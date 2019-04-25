function [relativeError] = relativeError(originalVideo, reconstructedVideo)
%This function calculates the frobian relative error for each frame (R, G
%and B seperately, then the mean of these values).

%INPUT
%originalVideo          is the original video in struct uint-8 format
%reconstructedVideo     is the reconstructed video in struct uint-8 format

%initializing vectors for the error
relativeError = zeros(length(originalVideo),1);
relativeError_rgb = zeros(3,1);

for k = 1 : length(originalVideo) %loop through every time frame
    
    %convert uint-8 to double for calculation
    originalVideo(k).frame = im2double(originalVideo(k).frame);
    reconstructedVideo(k).frame = im2double(reconstructedVideo(k).frame);
    
    for rgb = 1:3 %loop throug all colours, and caclulate the relative error of the Frobinian norm
        relativeError_rgb(rgb,1) = norm((reconstructedVideo(k).frame(:,:,rgb) - originalVideo(k).frame(:,:,rgb)),'fro')/norm(originalVideo(k).frame(:,:,rgb),'fro');
    end
    relativeError(k,1) = mean(relativeError_rgb); %take the mean of the relative error of the colours
end
frames = linspace(1, length(originalVideo),length(originalVideo)); %setup the x-axis for the plot
plot(frames(1,:), relativeError(:,1)); %plot the relative error for each frame
end

