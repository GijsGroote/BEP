function [state] = stateSpace(reconstructedFrame, faultyVideo, selectionMatrix)
% this function file creates a reconstruction of the faulty video. Using
% the kalman filter which is based on normal distributions. 

% INPUT
% reconstructedFrame    The first frame reconstructed
% faultyVideo           The destroyed video which needs to be reconstructed
% selectionMatrix       The matrix which indicates which pixels in
%                       faultyVideo are destroyed (black)

% OUTPUT
% reconstructedVideo    The reconstruction of faultyvideo using the kalman
%                                                                filter

%% Setup
k_end = length(faultyVideo);         % k_end should be the number of frames in the video
[nRows, nColumns, dim] = size(faultyVideo(1).frame);

vectorLength = nRows * nColumns; % vectorlength when there is only one column

state = struct('vector', zeros(vectorLength, 1, 3, 'double')); % initializing the state vector

% todo: the s.fields

state(1).vector = reshape(reconstructedFrame, vectorLength, 1, 3); % reshape first frame to a vector
%% loop over every frame
for k = 2:k_end 
    state(k).vector =  reshape(faultyVideo(k).frame, vectorLength, 1, 3); % reshape faulty video to vector
    % loop over 3 basis colors
    for rgb = 1 : 3         
    
        
% if ~isfield(s,'x'); error('State matrix missing (x)'); end
s.x = state(k).vector;
% if ~isfield(s,'P'); error('Proces covariance matrix missing (P)'); 
s.P = zeros(vectorLength, vectorLenght);
% if ~isfield(s,'z'); error('Observation vector missing (z)'); end 
s.z = 
% if ~isfield(s,'u'); error('Control variable matrix (u)'); end
% if ~isfield(s,'A'); error('Adaptation matrix (A) is missing'); end
% if ~isfield(s,'B'); error('Adaptation matrix (B) is missing'); end
% if ~isfield(s,'Q'); error('Process noise covariance matrix (Q)'); end
% if ~isfield(s,'R'); error('Sensor noise covariance matrix (R)'); end
% if ~isfield(s,'H'); error('Conversion matrix (H)'); end

        
        
        kalman_filter (s,frameWidth, frameHeight)
    end
end
end