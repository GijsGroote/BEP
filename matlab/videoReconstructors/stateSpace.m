function [result] = stateSpace(reconstructedFrame, faultyVideo, selectionMatrix)
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
%% initializing structs
%pre-allocating space for these struct reduces computing time
%backward loop, so that the last of frame is made first --> faster computing
for k = k_end:-1:1 
    % The s struct is the struct in which the input/output of the kalman
    % filter is stored, more detailed information below( setting initial
    % conditions)
    s(k).x = zeros(vectorLength, 1, 3);             %state vector
    %s(k).P = zeros(vectorLength, vectorLength);    %covariance matrix
    
    %s(k).H = zeros(vectorLength, vectorLength);    %output gain matrix (C)
    % H is time invariant, so mb not needed as struct
    %s(k).Q = zeros(vectorLength, vectorLength); %process noise covariance
    %s(k).R = zeros(vectorLength, vectorLength); %measurement noise cov
    %s(k).A = zeros(vectorLength, vectorLength);    %state gain
    %s(k).B = zeros(vectorLength, 1);               %input gain
    %s(k).v = zeros(vectorLength, 1);               %measurement noise
    %s(k).w = zeros(vectorLength, 1);               %process  noise
    
    
    %result is the struct in which the returned value of the function will
    %be stored
    result(k) = struct('frame', zeros(nRows, nColumns, 3, 'uint8'));
    
    % faultyVideo is imported as uint-8 and needs to be double for
    % calculation purposes
    faultyVideo(k).frame = im2double(reshape(faultyVideo(k).frame, vectorLength, 1, 3));
end
%% defining the initial condition for the Kalman filter
%s.x is the video in vector form of the reconstructed/estimated video by
%the kalman filter. The kalman filter needs an initial frame, this is
%inputtet below. s(2-->k_end).x is calculated and inputted by the kalman
%filter output.
s(1).x = im2double(reshape(reconstructedFrame, vectorLength, 1, 3));

%s.P is the covariance matrix (always square), with size vectorLengh x
%vectorLength. This matrix changes for every frame and is calculated by the
%Kalman filter. It does need an initial value.
%s(1).P = ones(vectorLength, vectorLength);
s(1).P = 1;
%s.R is the measurement noise covariance, a square matrix with size
%vectorLength x vectorLength. This matrix can be time invariant and is not
%calculated by the Kalman filter.
%s(1).R = zeros(vectorLength, vectorLength);

%s.Q is the process noise covariance a square matrix with size
%vectorLength x vectorLength. This matrix can be time invariant and is not
%calculated by the Kalman filter.
%s(1).Q = zeros(vectorLength, vectorLength);

% H is a matrix that maps the state to the output. H (sometimes C in state
% space equations) is as square matrix with size vectorLength x
% vecorLength. H does not change with time
%H = zeros(vectorLength, vectorLength);
%% loop over every frame
for k = 2:k_end 
    %state(k).state =  reshape(faultyVideo(k).frame, vectorLength, 1, 3); % reshape faulty video to vector
    %loop over 3 basis colors
    s(k) = Kalman_filter_simplified(s(k-1), faultyVideo(k).frame, H, nColumns, nRows);
end
   for k=1:k_end
       result(k).frame = im2uint8(reshape(s(k).x, nRows, nColumns, 3));
   end
end