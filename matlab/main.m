function [ reconstructedVideo, faultyVideo, selectionMatrixVar, relativeErrorVar] = main( videoName, percentage, destructionType, lambda, mu )
%INPUT
%videoPath          is the location of the video that is to be destroyed and
%                   reconstructed, only takes the name, has to be in the
%                   folder input
%percentage         is the percentage of pixels that is to be destroyed
%                   (number between 0 and 1)
%destructionType   is an string that ("1","2","3","4") that determins the
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
%this adds the folder 1 up from BEP
mydir  = pwd; %current path (where this file is saved)
idcs   = strfind(mydir,filesep); %find the "\" folder seperator
newdir = mydir(1:idcs(end-1)-1); % go 2 folders up
inputVideoPath = strcat(newdir,'\BEP_DATA\input\',videoName); %path to the video
%addpath(strcat(newdir,'\BEP_DATA\observed')  %not needed (yet)
%addpath(strcat(newdir,'\BEP_DATA\output')    %not needed (yet)

%path where functions are saved
addpath('./selectionMatrices');
addpath('./videoDestroyers');
addpath('./videoReconstructors');
addpath('./Performance');


%% import video
% if the video cannot be found create a folder in the same folder as 'BEP'
% called 'BEP_DATA'in 'BEP_DATA' create a folder 'input' (and also
% 'output') input must contain DrDre.mp4, or the video which is the test video. 
videoObj = VideoReader(inputVideoPath);    % test video 

% video meta data
frameHeight = videoObj.Height;
frameWidth = videoObj.Width;

%% put the video into a struct
originalVideo = struct('frame',zeros(frameHeight,frameWidth,3,'uint8'));
numFrames = 0;
while hasFrame(videoObj)
     originalVideo(numFrames+1).frame = readFrame(videoObj);
     numFrames = numFrames + 1;
end

 %% Define the first frame
firstFrame = originalVideo(1).frame;

%% create selection matrix
selectionMatrixVar = selectionMatrix(frameHeight, frameWidth,  numFrames, percentage, destructionType);
%% Remove pixels from frames
faultyVideo = VideoDestroyer(frameHeight, frameWidth, originalVideo, selectionMatrixVar, numFrames);

%% Reconstruct Video frame
% reconstructedVideo = SVR_LMS(firstFrame, faultyVideo, selectionMatrixVar, lambda, mu); 
reconstructedVideo = stateSpace(firstFrame, faultyVideo, selectionMatrixVar);
%% Plot relative error for each frame
relativeErrorVar = 1;
% relativeErrorVar = relativeError(originalVideo, reconstructedVideo);
end %function end
