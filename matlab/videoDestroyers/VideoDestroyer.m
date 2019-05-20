function [faultyVideo, faultyVector] = VideoDestroyer(frameHeight, frameWidth, originalVideo, selectionMatrix, numFrames, colours)
% creates a video in which certain pixels are set to 0 (black) depending
% on the selectionMatrix.

% INPUT
% todo

% OUTPUT
% todo

% determining the number of pixels
amountOfPixels = frameHeight*frameWidth;

%% creating the faulty video
faultyVideo = struct('frame',zeros(frameHeight,frameWidth,colours,'uint8')); %initializing a zero struct for faultyVideo

%loop through every time frame 
for k = 1:numFrames
    %initializing a zero's column vector to put the pixels of the video
    emptyFrame = uint8(zeros(amountOfPixels,1,colours));   
    
    % find the positions of the ones in the matrix
    JIndices = find(selectionMatrix(:,:,k));           %the ones will determine the pixels that will be saved
    %put the videoframes into the struct
    faultyVideo(k).frame = originalVideo(k).frame;
    for rgb = 1 : colours
        %create a matrix for R, G and B colours
        R(:,:,rgb) = faultyVideo(k).frame(:,:,rgb);
        %     G = faultyVideo(k).frame(:,:,2);
        %     B = faultyVideo(k).frame(:,:,3);
        
        %for every colour the column vector is filled with the pixels
        emptyFrame(JIndices,:,rgb) = R(JIndices);
        
        %     emptyFrame(JIndices,:,2) = G(JIndices);
        %     emptyFrame(JIndices,:,3) = B(JIndices);
         faultyVector(k).frame(:,:,rgb) = double(R(JIndices));
    end
    %     %initializing a zero's column vector to put the pixels of the video
    %     emptyFrame = uint8(zeros(amountOfPixels,1,3));
%     
%     % find the positions of the ones in the matrix
%     JIndices = find(selectionMatrix(:,:,k));           %the ones will determine the pixels that will be saved
%     
%     %for every colour the column vector is filled with the pixels
%     emptyFrame(JIndices,:,rgb) = R(JIndices, rgb);          
% %     emptyFrame(JIndices,:,2) = G(JIndices);
% %     emptyFrame(JIndices,:,3) = B(JIndices);
%     
    %reshape the column vectors to a frame of the original size
    faultyVideo(k).frame = reshape(emptyFrame,[frameHeight,frameWidth,colours]); 
end
%for k = numFrames : -1 : 1
    %faultyVector(k) = struct('frame', zeros(length(JIndices),1,colours,'double'));
    faultyVector(k).frame(:,:,rgb) = R(JIndices);
%end

end