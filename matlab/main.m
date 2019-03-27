% The main file manages all the function files
% By importing data from the input folder 
% By sending imported data to data removal functions which remove some
% pixels, this could also be done importing a video which is already faulty
% The faulty video is reconstructed with one of the algorithms
% The result is stored in the output folder

clear
clc %clean up command window

% create faulty video and selective matrix
[faultyVideo, J] = removePixels('./input/DrDre.mp4', 0.5);






% import video
videoPathAndFileName = fullfile('../doc', 'DrDre.mp4');
videoObj = VideoReader(videoPathAndFileName);

% take first frame
firstFrame = readFrame(videoObj);

%display first frame

% mov = struct('cdata',firstFrame, 'colormap',[]);
% hf = figure;
% set(hf,'position',[100 150 videoObj.Width videoObj.Height]);
% movie(hf,mov,1,videoObj.FrameRate);

% make video faulty
% todo remove some percentage of pixels out of every frame from videoObj in
% external function file, also create selective matrix J which are the
% pixel positions of the remaining pixels which have not been removed

% TODO: make videoObj -> faultyVideo matrix, make selective matrix J which
% has a 1 for pixels which are not removed, and a 0 for all the faulty
% pixels for every time step

% reconstruct
[result] = SVRLMS(firstFrame, faultyVideo, J, 1, 2);

% save reconstructed video