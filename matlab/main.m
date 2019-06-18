function [ reconstructedVideoSVR, reconstructedVideoKF, faultyVideo, selectionMatrixVar, relativeErrorVar, relativeErrorVarPSNR, originalVideo] = main( videoName, percentage, destructionType, lambda, mu )
%INPUT
%videoPath          is the location of the video that is to be destroyed and
%                   reconstructed, only takes the name+extenosion, has to be in the
%                   folder input. i.e. Test_Video.pm4
%percentage         is the percentage of pixels that is to be destroyed
%                   (number between 0 and 1)
%destructionType    is an string that ("1","2","3","4") that determines the
%                   shape of the selection matrix
%mu, lambda         are values to optimize the performance of the
%                   reconstructor, wrong values can break the algorithm
%                   (NaN or INF as pixel output)

%OUTPUT
%reconstructedVideo     is a struct of the reconstructed video (uint-8)
%faultyVideo            is a struct of the observed video
%selectionMatrixVar     is a 3D matrix of ones and zeros (height by widthch
%                       by frames)
%relativeError          is a vector with the releative error of the Frobian
%                       norm per frame

%% add paths to file
try 
    %The following code adds the folder where the video data is stored to
    %the path. The folder containing the video's is called 'BEP_DATA' and
    %has folders 'input','output' and 'observed'. This folder is in the 
    %same folder that stores the Bep folder. Store the video that is
    %to be destroyed and reconstructed in '\BEP_DATA\input\'.
    
    %This adds the folder 1 up from BEP
    myDir  = pwd; %current path (where this file is saved)
    idcs   = strfind(myDir,filesep); %find the "\" folder seperator
    newDir = myDir(1:idcs(end-1)-1); % go 2 folders up
    inputVideoPath = strcat(newDir,'\BEP_DATA\input\',videoName); %path to the video
    %addpath(strcat(newdir,'\BEP_DATA\observed')  
    %addpath(strcat(newdir,'\BEP_DATA\output')    
    
    %path where functions are saved
    addpath('./selectionMatrices');
    addpath('./videoDestroyers');
    addpath('./videoReconstructors');
    addpath('./Performance');
    addpath('./tensorTrain');
    
    %% import video
    videoObj = VideoReader(inputVideoPath);
    
    % video meta data
    frameHeight = videoObj.Height;
    frameWidth = videoObj.Width;
catch
    warning('problem loading the video')
end
%% put the video into a struct
try
    originalVideo = struct('frame',zeros(frameHeight,frameWidth,3,'uint8'));
    numFrames = 0;
    while hasFrame(videoObj)
        originalVideo(numFrames+1).frame = readFrame(videoObj);
        numFrames = numFrames + 1;
    end
    
    %% Define the first frame
    colours = size(originalVideo(1).frame,3);
    firstFrame = 128*ones(frameHeight, frameWidth, colours,'uint8');
catch
    warning('problem with putting the video into a struct')
end
%% create selection matrix
try
    selectionMatrixVar = selectionMatrix(frameHeight, frameWidth,  numFrames, percentage, destructionType);
catch
    warning('could not create a selectionMatrix')
end

%% Remove pixels from frames
% try
faultyVideo = VideoDestroyer(frameHeight, frameWidth, originalVideo, selectionMatrixVar, numFrames, colours);
% catch
%     warning('could not destroy the video')
%     faultyVideo = 0;
%
% end

%% Reconstruct Video frame SVR-LMS
try
    reconstructedVideoSVR = SVR_LMS(firstFrame, faultyVideo, selectionMatrixVar, lambda, mu, colours);
catch
    warning('could not reconstruct using SVR_LMS')
    reconstructedVideoSVR=0;
end
%% Kalman estimate
%try
    %initialisation for the kalman values
    sigmaP = 100;
    sigmaW = 5;
    Xrank = 50; 
    numFrames = 3; %manual way to say how many frames should be caclulated
    for k=numFrames:-1:1
        %X is the tensor network representation of the frame
        X(k).X1 = zeros(frameHeight, 1, Xrank,'double');
        X(k).X2 = zeros(frameWidth, 1, Xrank,'double');
        %P is the tensor network representation of the covariance matrix
        P(k).P1 = zeros(frameHeight, frameHeight, 'double');
        P(k).P2 = zeros(frameWidth, frameWidth, 'double');
        %XMatrix is the reconstructed frame
        XMatrix(k).frame = zeros(frameHeight, frameWidth, 'double');
        reconstructedVideoKF(k).frame = zeros(frameHeight, frameWidth, 'uint8');
        %Determining where the measured pixels are
        %R is the location of the measured pixels, loc is the corresponding
        %index. y is the measurement vectorized.
        R(k).frame = find(selectionMatrixVar(:,:,k));
        loc = ind2sub([frameHeight frameWidth colours],R(k).frame);
        C = faultyVideo(k).frame(loc);
        y(k).frame = double(C);
    end
    %Initialisation grey frame
    X(1).X1 = 128/Xrank*ones(frameHeight, 1, Xrank,'double');
    X(1).X2 = ones(frameWidth, 1, Xrank,'double');
    
    %Inititialisation original frame (tensor network)
    % [U1,S1,V1] = svd(double(originalVideo(1).frame(:,:,1)),'econ');
    % U1(:,(Xrank+1):end) = [];
    % S1 = S1(1:Xrank,1:Xrank);
    % V1(:,(Xrank+1):end) = [];
    %X(1).X1 = permute(U1*S1,[1 3 2]);
    %X(1).X2 = permute(V1,[1 3 2]);
    
    %Define the process noise covariance matrix
    W.W1 = sigmaW*eye(frameHeight, frameHeight, 'double');
    W.W2 = eye(frameWidth, frameWidth, 'double');
    
    % first value for P, very important for the result
    %P effects all the pixels nearby (best result)
    range = 15;
     for i=-range:1:range %the range of this i determines how many pixles around the measured pixels are affected
     P(1).P1 = P(1).P1 + diag((-abs(i)^1+range)*sigmaP*ones(frameHeight-abs(i),1),i);
     P(1).P2 = P(1).P2 + diag((-abs(i)^1+range)*0.5*ones(frameWidth-abs(i),1),i);
     end
     %pixels only influence themselves
%     P(1).P1 = sigmaP*eye(frameHeight, frameHeight, 'double');
%     P(1).P2 = eye(frameWidth, frameWidth, 'double');
    %every pixel influences every pixel
%     P(1).P1 = sigmaP*ones(frameHeight, frameHeight, 'double');
%     P(1).P2 = ones(frameWidth, frameWidth, 'double');

    for k = 1:numFrames-1 %the loop where xhat is calculated
        tic
        [X(k+1), P(k+1)] = KalmanFilterTensorScriptFast(X(k), P(k), W, y(k).frame, R(k).frame);
        %rank reduction for xhat
        XMatrix(k+1).frame = reshape(permute(X(k+1).X1,[1 3 2])*permute(X(k+1).X2,[3 1 2]),480,720);
        [U,S,V] = svd(XMatrix(k+1).frame,'econ');
        U(:,(Xrank+1):end) = [];
        S = S(1:Xrank,1:Xrank);
        V(:,(Xrank+1):end) = [];
        X(k+1).X1 = permute(U*S,[1 3 2]);
        X(k+1).X2 = permute(V,[1 3 2]);
        toc
    end
    for k = 1:numFrames
        %this the struct where the reconstructed video is stored
        reconstructedVideoKF(k).frame = uint8(permute(X(k).X1,[1 3 2])*permute(X(k).X2,[3 1 2]));
    end
% catch
     warning('could not reconstruct using Kalman')
     reconstructedVideoKF(k).frame = 0;
% end
%% Plot relative error for each frame
try
    relativeErrorVar = relativeError(originalVideo, reconstructedVideoSVR);
catch
    warning('could not compute the relative error using relative error, setting it to 0')
    relativeErrorVar = 0;
end
%% Plot relative error for each frame
try
    relativeErrorVarPSNR = comparePSNR(originalVideo, reconstructedVideoSVR);  
catch
    warning('could not compute the relative error using PSNR, setting it to 0')
    relativeErrorVarPSNR = 0;
end
end %function end