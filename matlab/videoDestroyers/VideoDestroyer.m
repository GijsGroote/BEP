function [faultyVideo] = VideoDestroyer(frameHeight, frameWidth, originalVideo, selectionMatrix, numFrames)
% creates a video in which certain pixels are set to 0 (black), depending
% on de selectionMatrix.

%INPUT
%path               is the path where the original video can be found
%selectionMatrix    is a 1/0 matrix that determines what pixels are
%destroyed. (one's are distroyed)

%nuframes           is the number of frames the video has
size(selectionMatrix); %is this of any use?
%% determining size of the frames and number of frames
%v = VideoReader(path);

%vidHeight = v.Height;
%vidWidth = v.Width;
amount_of_pixels = frameHeight*frameWidth;

%% creating the faulty video
faultyVideo = struct('frame',zeros(frameHeight,frameWidth,3,'uint8')); %initializing the struct for faultyVideo
for k = 1:numFrames
    faultyVideo(k).frame = originalVideo(k).frame;    %putting the videoframes into the struct
    R = faultyVideo(k).frame(:,:,1);        %creating a matrix for R, G and B colours
    G = faultyVideo(k).frame(:,:,2);
    B = faultyVideo(k).frame(:,:,3);
    
    empty_frame = uint8(zeros(amount_of_pixels,1,3));   %initializing a zero's column vector to put the new pixels
    
    % find the positions of the ones in the matrix
    J_indices = find(selectionMatrix(:,:,k));           %the ones will determine the pixels that will be saved
    
    empty_frame(J_indices,:,1) = R(J_indices);          %for every colour the column vector is filled
    empty_frame(J_indices,:,2) = G(J_indices);
    empty_frame(J_indices,:,3) = B(J_indices);
       
    faultyVideo(k).frame = reshape(empty_frame,[frameHeight,frameWidth,3]); %reshape the column vector to a frame of the original size
end

end

