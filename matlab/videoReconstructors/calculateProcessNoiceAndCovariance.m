function [processNoise, covMatrix, mu] = calculateProcessNoiceAndCovariance(structVideo)
% this function calculates the process noice and covariance matrix.

% FUTURE TODO: mu is there to check, it should approach 0. It is here to check if it actually goes to 0
% addtional expension: loop over all the frames for more accuracyyyyy

% INPUT
% structVideo   Struct of the original video

% OUTPUT
% processNoise  Frame 2 = frame 1 + process noice
% covMatrix     The covariance matrix of the process noice
% mu            Validate if code does what is supposed to do, approach 0


%% setup
frame1 = double(structVideo(1).cdata);
frame2 = double(structVideo(2).cdata);

% get number of columns from the video matrix
numColumns = size(frame1, 2);

% create start covariance matrix with zeros
covMatrix = zeros(numColumns, numColumns);
% mu = [red, green, blue] <- average color from difference between frame k and k+1, initially set to 0.
mu = [0, 0, 0];

% create process noise matrix 
processNoise = frame2 - frame1;

%% create covariance matrix. And calculate average of every color frame for 3 colors
for k = 1:3
    covMatrix(:,:,k) = cov(processNoise(:,:,k));
    mu(k) = mean(processNoise(:,:,k),'all');
end
end

