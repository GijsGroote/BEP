function [comparedPerformance] = comparator(originalVideo, reconstructedVideoSVR, reconstructedVideoKF,colours)
% this function compares the performance of algorithm 2 with the SVR-LMS + Kalman filter
% algorithm

%the name 'filteredReconstructedVideo' is temporary and depends on the
%final name of the output of the reconstructed and filtered video

% INPUT
% todo

% OUTPUT
% todo

%%
%initializing zero vectors for the error
numFrames=length(reconstructedVideoKF);
comparedPerformance = zeros(numFrames,2); 
relativeErrorRGB = zeros(3,2); 
% the matrix will contain the errors per color and per reconstructed video (filtered and unfiltered);
% the first column corresponds to the unfiltered video, the second one to the filtered video  

%loop through every time frame
for k = 1 : numFrames
    
    %convert uint-8 to double for calculation
    originalVideo(k).frame = im2double(originalVideo(k).frame);
    reconstructedVideoSVR(k).frame = im2double(reconstructedVideoSVR(k).frame);
    reconstructedVideoKF(k).frame = im2double(reconstructedVideoKF(k).frame);
    
    %loop throug all colours, and calculate the relative error of the Frobenius norm
    for rgb = 1:colours 
        relativeErrorRGB(rgb,1) = norm((reconstructedVideoSVR(k).frame(:,:,rgb) - originalVideo(k).frame(:,:,rgb)),'fro')/norm(originalVideo(k).frame(:,:,rgb),'fro');
        relativeErrorRGB(rgb,2) = norm((reconstructedVideoKF(k).frame(:,:,rgb) - originalVideo(k).frame(:,:,rgb)),'fro')/norm(originalVideo(k).frame(:,:,rgb),'fro');
    end
    
 %take the mean of the relative error of the colours
 comparedPerformance(k,1) = mean(relativeErrorRGB(:,1)); 
 comparedPerformance(k,2) = mean(relativeErrorRGB(:,2)); 
 
end

%setup the x-axis for the plot
frames = linspace(1, numFrames, numFrames); 

%plot the relative error for each frame
figure
hold on
plot(frames(1,:), comparedPerformance(:,1),'b-')%,frames(1:numFrames/10:end,:), comparedPerformance(1:numFrames/10:end,1),'bo'); % We have to make sure that the same color is used for the same algorithm, so comparing graphs is easy
plot(frames(1,:), comparedPerformance(:,2),'r-')%,frames(1:numFrames/10:end,:), comparedPerformance(1:numFrames/10:end,2),'r+');
% plot(frames(1,1:10:end), comparedPerformance(1:10:end,1),'bo')
% plot(frames(1,1:10:end), comparedPerformance(1:10:end,2),'rx')
title('Relative error versus the time')
xlabel('Time')
ylabel('Relative error')
legend('SVR-LMS','Kalman estimate')

end