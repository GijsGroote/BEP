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
% todo

%% Remove pixels from frames
% todo

%% Reconstruct first frame
% todo


%% Reconstruct video

% [reconstructedVideo] = SVR_LMS(firstFrame, faultyVideo, J, 1, 2);


%% TODO see performance

[faultyVideo, J] = removePixels('./input/DrDre.mp4', 0.5);



% display first frame
 mov = struct('cdata',firstFrame, 'colormap',[]);
 hf = figure;
 set(hf,'position',[100 150 videoObj.Width videoObj.Height]);
 movie(hf,mov,1,videoObj.FrameRate);




