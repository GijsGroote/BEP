function [reconstructedVideo] = stateSpace(reconstructedFrame, faultyVideo, selectionMatrix)
% this function file creates a reconstruction of the faulty video. Using
% the kalman filter which is based on normal distributions. 

% INPUT
% reconstructedFrame    The first frame reconstructed
% faultyVideo           The destroyed video which needs to be reconstructed
% selectionMatrix       The matrix which indicates which pixels in
%                       faultyVideo are 'turned off'

% OUTPUT
% reconstructedVideo    The reconstruction of faultyvideo using the kalman
%                                                                filter

%% Setup
k_end = length(faultyVideo);         % k_end should be the number of frames in the video
[nRows,nColumns, dim] = size(faultyVideo(1).frame);

reconstructedVideo = struct('frame', zeros(nRows, nColumns, 3, 'double'));   % Initializing the matrix reconstructedVideo,
reconstructedVideo(1).frame = im2double(reconstructedFrame); %reconstructedFrame is a uint8 data type
%% loop over every frame
for k = 1:k_end 
    
    
    % TODO GIJS!
    
 % kalman_filter (s,frameWidth, frameHeight)




end
end