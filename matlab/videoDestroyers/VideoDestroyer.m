function [faultyVideo] = VideoDestroyer(frameHeight, frameWidth, originalVideo, selectionMatrix, numFrames)
% creates a video in which certain pixels are set to 0 (black) depending
% on the selectionMatrix.

%INPUT
%path               the path where the original video can be found
%selectionMatrix    a 1/0 matrix that determines what pixels are destroyed
%numframes          the number of frames the video has

% determining the number of pixels
amount_of_pixels = frameHeight*frameWidth;

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
    empty_frame = uint8(zeros(amount_of_pixels,1,3));   
    
    % find the positions of the ones in the matrix
    J_indices = find(selectionMatrix(:,:,k));           %the ones will determine the pixels that will be saved
    
    %for every colour the column vector is filled with the pixels
    empty_frame(J_indices,:,1) = R(J_indices);          
    empty_frame(J_indices,:,2) = G(J_indices);
    empty_frame(J_indices,:,3) = B(J_indices);
    
    %reshape the column vectors to a frame of the original size
    faultyVideo(k).frame = reshape(empty_frame,[frameHeight,frameWidth,3]); 
end

end

