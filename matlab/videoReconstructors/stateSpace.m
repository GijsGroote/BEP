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

state = struct('state', zeros(vectorLength, 1, 3, 'double')); % initializing the state vector

% Kalman Filter Fields
% System has p inputs, n state variables and m outputs

% x_j = state [n, 1]: reconstructed video, output from kalman filter
% u_j = input [p, 1]: live input, is 0. We do not have live input
% z_j = output [m, 1]: measured data, faulty video
% A = stateGain [n, n]: pixels indepentent of other pixels at other position, unity matrix
                    % only depends on pixel at the same position at
                    % previous time step
% B = inputGain [n,p]: Measurement error, for input which is 0
% H_j = outputGain[m,n]: 
% w_j = precessNoice[n, 1]:
% Q = processNoiceCov[n, n]:
% v_j = measurementNoice[m, 1]:
% R = measurementNoiceCov[m, m]:
% (P_j)^- = aPrioriCov[n, n]:
% P_j = aPosterioriCov[n, n]:
% K_j = kalmanFilterGain[n, m]:
s(1).x = reconstructedFrame;
s(1).P = ones(360,450);
s(1).Q = 1;
s(1).R = 2;
state(1).vector = reshape(reconstructedFrame, vectorLength, 1, 3); % reshape first frame to a vector
%% loop over every frame
for k = 2:k_end 
    state(k).state =  reshape(faultyVideo(k).frame, vectorLength, 1, 3); % reshape faulty video to vector
    % loop over 3 basis colors
    s(k) = Kalman_filter_simplified(s(k-1), im2double(faultyVideo(k).frame), nColumns, nRows);
    
%     for rgb = 1 : 3         
%         kalman_filter (state(k),frameWidth, frameHeight)
%     end
end
end