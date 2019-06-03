function [PSNR] = comparePSNR(originalVideo, reconstructedVideo)
%This function calculates the peak signal-to-noise ratio (PSNR) for the unfiltered
%and filtered version compared to the original video

%INPUT
% originalVideo                 the original video in struct uint-8 format
% reconstructedVideo            the reconstructed video in struct uint-8 format
% reconstructedFilteredVideo    the reconstructed and filtered video in struct uint-8 format

%OUTPUT
% unfilteredPSNR                the PSNR value for the reconstructedVideo
% filteredPSNR                  the PSNR value for the reconstructedFilteredVideo

%%
numFrames=length(reconstructedVideo);
maxPixelValue=255; % max. pixel value for 8-bit numbers 
MSE=zeros(1,numFrames); % the PSNR value is determined for every timestep; the first column is for the unfiltered video, the second one for the filtered video

PSNR=zeros(1,numFrames); 

[m,n] = size(originalVideo(1).frame);
%% Calculate Mean Squared Error (MSE)
for k=1:numFrames
   
    originalVideo(k).frame = im2double(originalVideo(k).frame);
    reconstructedVideo(k).frame = im2double(reconstructedVideo(k).frame);
    
    dif1=(reconstructedVideo(k).frame - originalVideo(k).frame).^2; %elementwise squared difference between the pixels of reconstructedVideo and originalVideo
    
    MSE(:,k)=sum(dif1(:)); % MSE for the reconstructedVideo
    
    % Calculcate PSNR    
    PSNR(k) = 20 * log10(maxPixelValue) - 10 * log10(MSE(1,k));% / (m * n) binnen mse % the formula for the PSNR can be found on wikipedia

end
    MSE=MSE/(n*m); % divide by number of pixels in a frame
    

%% Plotting the results
figure(1)

hold on
%setup the x-axis for the plot
frames = linspace(1, numFrames, numFrames); 

%plot the relative error for each frame 
plot(frames, PSNR,'r-');
%plot(frames(1,1:10:end),PSNR(1,1:10:end),'rx');

title('Peak signal-to-noise ratio (PSNR) of reconstructed video data');
xlabel('Frame');
ylabel('PSNR [dB]');
% [~,objects] = legend('MyLegend');

% %objects(2).LineStyle = '-';
% objects(2).Marker = 'x';
legend('SVR-LMS','Kalman estimate');
end