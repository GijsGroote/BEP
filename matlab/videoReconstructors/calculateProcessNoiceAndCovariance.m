function [processNoise, covMatrix, mu, muTotal] = calculateProcessNoiceAndCovariance(structVideo)
% this function calculates the process noice and covariance matrix.

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

muSum = [0,0,0];

% Uncomment to view plot of the average of the processNoise 
% figure;
% hold on;

for i=1:length(structVideo)-1
    processNoise = double(structVideo(i+1).cdata)-double(structVideo(i).cdata);
    muSum = muSum + mean(processNoise, 'all');
    
% This is also needed for the plot of the average of the ProcessNoise
%     gem = muSum/i;
%     plot(i,gem(1),'-s')
end

% muTotal should approach zero
muTotal = muSum/i;

end

