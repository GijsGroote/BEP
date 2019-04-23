function [faultyVideo] = VideoDestroyer(path, selectionMatrix, numFrames)

size(selectionMatrix)

v = VideoReader(path);

vidHeight = v.Height;
vidWidth = v.Width;
amount_of_pixels = vidHeight*vidWidth;

faultyVideo = struct('frame',zeros(vidHeight,vidWidth,3,'uint8'));

for k = 1:numFrames
    
    R = faultyVideo(k).frame(:,:,1);
    G = faultyVideo(k).frame(:,:,2);
    B = faultyVideo(k).frame(:,:,3);
    
    empty_frame = uint8(NaN(amount_of_pixels,1,3));
    
    % find the positions of the ones in the matrix
    J_indices = find(selectionMatrix(:,:,k));
    
    empty_frame(J_indices,:,1) = R(J_indices);
    empty_frame(J_indices,:,2) = G(J_indices);
    empty_frame(J_indices,:,3) = B(J_indices);
       
    modified_frame = reshape(empty_frame,[vidHeight,vidWidth,3]);
    faultyVideo(k).frame = modified_frame;

end

end

