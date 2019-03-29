% The main file manages all the function files
% By importing data from the input folder 
% By sending imported data to data removal functions which remove some
% pixels, this could also be done importing a video which is already faulty
% The faulty video is reconstructed with one of the algorithms
% The result is stored in the output folder

%clean up command window
clear
clc 

%% add path to file 
addpath('./frameReconstructors');
addpath('./selectionMatrices');
addpath('./videoDestroyers');
addpath('./videoReconstructors');

%% import video
videoObj = VideoReader('./input/DrDre.mp4');

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
%  faultyVideo = VideoDestroyer('./input/DrDre.mp4', selectionMatrix)
% has a error in videoDestroyer;

%% Reconstruct first frame
% reconstruct, for now use firstFrame

%% Reconstruct video

% [reconstructedVideo] = SVR_LMS(firstFrame, faultyVideo, J, 1, 2);


%% TODO see performance





% display first frame, old remove this later
 mov = struct('cdata',firstFrame, 'colormap',[]);
 hf = figure;
 set(hf,'position',[100 150 videoObj.Width videoObj.Height]);
 movie(hf,mov,1,videoObj.FrameRate);




