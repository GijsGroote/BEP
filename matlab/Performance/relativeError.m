function [relativeError] = relativeError(originalVideo, reconstructedVideo)
%This function calculates the frobian relative error for each frame (R, G
%and B seperately, then the mean of these values).

%INPUT
%originalVideo          the original video in struct uint-8 format
%reconstructedVideo     the reconstructed video in struct uint-8 format

%initializing zero vectors for the error
relativeError = zeros(length(originalVideo),1);
relativeError_rgb = zeros(3,1);

%loop through every time frame
for k = 1 : length(originalVideo) 
    
    %convert uint-8 to double for calculation
    originalVideo(k).frame = im2double(originalVideo(k).frame);
    reconstructedVideo(k).frame = im2double(reconstructedVideo(k).frame);
    
    %loop throug all colours, and caclulate the relative error of the Frobinian norm
    for rgb = 1:3 
        relativeError_rgb(rgb,1) = norm((reconstructedVideo(k).frame(:,:,rgb) - originalVideo(k).frame(:,:,rgb)),'fro')/norm(originalVideo(k).frame(:,:,rgb),'fro');
    end
    
 %take the mean of the relative error of the colours
 relativeError(k,1) = mean(relativeError_rgb); 
 
end

%setup the x-axis for the plot
frames = linspace(1, length(originalVideo),length(originalVideo)); 

%plot the relative error for each frame
plot(frames(1,:), relativeError(:,1));

end

