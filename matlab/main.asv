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
addpath('./frameReconstructors');
addpath('./selectionMatrices');
addpath('./videoDestroyers');
addpath('./videoReconstructors');


%% import video
videoObj = VideoReader('./input/DrDre.mp4');    % test video


% video meta data
firstFrame = readFrame(videoObj);
frameHeight = videoObj.Height;
frameWidth = videoObj.Width;

%% create selection matrix

% delete later
    numFrames = 0;
    while hasFrame(videoObj)
        readFrame(videoObj);
        numFrames = numFrames + 1;
    end
    
selectionMatrix = selectionMatrix(frameHeight, frameWidth,  numFrames, 0.9, "1");


%% Remove pixels from frames
faultyVideo = VideoDestroyer('./input/DrDre.mp4', selectionMatrix, numFrames);

%% Reconstruct first frame
reconstructedVideo = SVR_LMS(firstFrame, faultyVideo, selectionMatrix, 1, 6); 


%% Remove pixels from frames
% todo

%% Reconstruct first frame
% todo

