function [faultyVideo] = VideoDestroyer(frameHeight, frameWidth, originalVideo, selectionMatrix, numFrames)
% creates a video in which certain pixels are set to 0 (black) depending
% on the selectionMatrix.

% INPUT
% todo

% OUTPUT
% todo

% determining the number of pixels
amountOfPixels = frameHeight*frameWidth;

%% creating the faulty video
faultyVideo = struct('frame',zeros(frameHeight,frameWidth,3,'uint8')); %initializing a zero struct for faultyVideo

%loop through every time frame 
for k = 1:numFrames
    %put the videoframes into the struct
    faultyVideo(k).frame = originalVideo(k).frame;
    
    %create a matrix for R, G and B colours
    R = faultyVideo(k).frame(:,:,1);                  
    G = faultyVideo(k).frame(:,:,2);
    B = faultyVideo(k).frame(:,:,3);
   
    %initializing a zero's column vector to put the pixels of the video
    emptyFrame = uint8(zeros(amountOfPixels,1,3));   
    
    % find the positions of the ones in the matrix
    JIndices = find(selectionMatrix(:,:,k));           %the ones will determine the pixels that will be saved
    
    %for every colour the column vector is filled with the pixels
    emptyFrame(JIndices,:,1) = R(JIndices);          
    emptyFrame(JIndices,:,2) = G(JIndices);
    emptyFrame(JIndices,:,3) = B(JIndices);
    
    %reshape the column vectors to a frame of the original size
    faultyVideo(k).frame = reshape(emptyFrame,[frameHeight,frameWidth,3]); 
end

end