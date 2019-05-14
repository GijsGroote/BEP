function [ reconstructedVideo, faultyVideo, selectionMatrixVar, relativeErrorVar] = main( videoName, percentage, destructionType, lambda, mu )
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
%selectionMatrixVar     is a 3D matrix of ones and zeros (height by width
%                       by frames)
%relativeError          is a vector with the releative error of the Frobian
%                       norm per frame


%% add paths to file
try
    %this adds the folder 1 up from BEP
    myDir  = pwd; %current path (where this file is saved)
    idcs   = strfind(myDir,filesep); %find the "\" folder seperator
    newDir = myDir(1:idcs(end-1)-1); % go 2 folders up
    inputVideoPath = strcat(newDir,'\BEP_DATA\input\',videoName); %path to the video
    %addpath(strcat(newdir,'\BEP_DATA\observed')  %not needed (yet)
    %addpath(strcat(newdir,'\BEP_DATA\output')    %not needed (yet)


%path where functions are saved
addpath('./selectionMatrices');
addpath('./videoDestroyers');
addpath('./videoReconstructors');
addpath('./Performance');


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
    firstFrame = originalVideo(1).frame;
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
try
    faultyVideo = VideoDestroyer(frameHeight, frameWidth, originalVideo, selectionMatrixVar, numFrames);
catch
    warning('could not destroy the video')
    faultyVideo = 0;
end
%% Reconstruct Video frame
% choose to uncomment the SVR_LMS or stateSpace algorithm

% reconstructedVideo = SVR_LMS(firstFrame, faultyVideo, selectionMatrixVar, lambda, mu); 
% reconstructedVideo = stateSpace(firstFrame, faultyVideo, selectionMatrixVar);
%% Plot relative error for each frame
try
    reconstructedVideo = SVR_LMS(firstFrame, faultyVideo, selectionMatrixVar, lambda, mu); 
catch
    warning('could not destroy the video')
    reconstructedVideo = 0;
end
%% Plot relative error for each frame
try
    relativeErrorVar = relativeError(originalVideo, reconstructedVideo);
catch
    warning('could not compute the relative error, setting it to 0')
    relativeErrorVar = 0;
end
end %function end