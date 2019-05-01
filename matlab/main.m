% The main file manages all the function files
% By importing data from the input folder 
% By sending imported data to data removal functions which remove some
% pixels, this could also be done importing a video which is already faulty
% The faulty video is reconstructed with one of the algorithms
% The result is stored in the output folder

%clean up command window
clear
clc 

%% add paths to file 
addpath('./selectionMatrices');
addpath('./videoDestroyers');
addpath('./videoReconstructors');
addpath('./Performance');


%% import video
videoObj = VideoReader('../../BEP_DATA/input/DrDre.mp4');

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
selectionMatrix = selectionMatrix(frameHeight, frameWidth,  numFrames, 0.9, "random_different");

%% Remove pixels from frames
faultyVideo = VideoDestroyer(frameHeight, frameWidth, originalVideo, selectionMatrix, numFrames);

%% Reconstruct Video frame
reconstructedVideo = SVR_LMS(firstFrame, faultyVideo, selectionMatrix, 2, 1); 
%% Plot relative error for each frame
relativeError = relativeError(originalVideo, reconstructedVideo);

