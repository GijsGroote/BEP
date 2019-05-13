function [unfilteredPSNR, filteredPSNR] = comparePSNR(originalVideo, reconstructedVideo, reconstructedFilteredVideo)
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
numFrames=length(originalVideo);
maxPixelValue=255; % max. pixel value for 8-bit numbers 
MSE=zeros(1,2,numFrames); % the PSNR value is determined for every timestep; the first column is for the unfiltered video, the second one for the filtered video

unfilteredPSNR=zeros(1,numFrames); 
filteredPSNR=zeros(1,numFrames); 

[m,n] = size(originalVideo(1).frame);
%% Calculate Mean Squared Error (MSE)
for k=1:numFrames
   
    originalVideo(k).frame = im2double(originalVideo(k).frame);
    reconstructedVideo(k).frame = im2double(reconstructedVideo(k).frame);
    reconstructedFilteredVideo(k).frame = im2double(reconstructedFilteredVideo(k).frame);
   
    dif1=(reconstructedVideo(k).frame - originalVideo(k).frame).^2; %elementwise squared difference between the pixels of reconstructedVideo and originalVideo
    MSE(:,1,k)=sum(dif1,'all'); % MSE for the reconstructedVideo
            
    dif2=(reconstructedFilteredVideo(k).frame - originalVideo(k).frame).^2; %elementwise squared difference between the pixels of reconstructedFilteredVideo and originalVideo
    MSE(:,2,k)=sum(dif2,'all'); % MSE for the reconstructedFilteredVideo
    
    MSE=MSE/(n*m); % divide by number of pixels in a frame
    
%% Calculcate PSNR
    unfilteredPSNR(k)=20*log10(maxPixelValue)-10*log10(MSE(1,1,k)); % the formula for the PSNR can be found on wikipedia
    filteredPSNR(k)=20*log10(maxPixelValue)-10*log10(MSE(1,2,k));
end
%% Plotting the results
figure
hold on

%setup the x-axis for the plot
frames = linspace(1, numFrames, numFrames); 

%plot the relative error for each frame 
plot(frames, unfilteredPSNR);
plot(frames, filteredPSNR);

title('Peak signal-to-noise ratio (PSNR) of reconstructed video data')
xlabel('Frame number')
ylabel('PSNR [dB]')
legend('Unfiltered video','Filtered video')
end