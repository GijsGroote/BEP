function [comparedPerformance] = comparator(originalVideo, reconstructedVideo, reconstructedFilteredVideo)
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
comparedPerformance = zeros(numFrames,2); % Can 'length(originalVideo)' be replaced by 'numFrames' as well?
relativeErrorRGB = zeros(3,2); % this matrix will contain the errors per color and per reconstructed video (filtered and unfiltered)
% the first column corresponds to the unfiltered video, the second one to the filtered video  

numFrames=length(originalVideo);

%loop through every time frame
for k = 1 : numFrames
    
    %convert uint-8 to double for calculation
    reconstructedVideo(k).frame = im2double(reconstructedVideo(k).frame);
    reconstructedFilteredVideo(k).frame = im2double(reconstructedFilteredVideo(k).frame);
    
    %loop throug all colours, and caclulate the relative error of the Frobinian norm
    for rgb = 1:3 
        relativeErrorRGB(rgb,1) = norm((reconstructedVideo(k).frame(:,:,rgb) - originalVideo(k).frame(:,:,rgb)),'fro')/norm(originalVideo(k).frame(:,:,rgb),'fro');
        relativeErrorRGB(rgb,2) = norm((reconstructedFilteredVideo(k).frame(:,:,rgb) - originalVideo(k).frame(:,:,rgb)),'fro')/norm(originalVideo(k).frame(:,:,rgb),'fro');
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
plot(frames(1,:), comparedPerformance(:,1),'bx'); % We have to make sure that the same color is used for the same algorithm, so comparing graphs is easy
plot(frames(1,:), comparedPerformance(:,2),'gx');
title('Performance of the algorithms')
xlabel('Timestep')
ylabel('Relative Frobenius error')
legend('Reconstructed','Reconstructed & filtered')

end