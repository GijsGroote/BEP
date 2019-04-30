function [selectionMatrix] = selectionMatrix(frameHeight,frameWidth,numFrames,percentage,type)
%   Generating a selection matrix

 % calculate the amount of pixels in a frame
 amount_of_pixels = frameHeight*frameWidth;

%% Create a random selection matrix that stays the same throughout all frames 
if type == "random_same" || type == "1"
    
    % create a 2D zero column matrix with the length of the total amount of pixels in the frame 
    selectionMatrixColumn = zeros(amount_of_pixels, 1);
    
    % (1-percentage)*amount_of_pixels positions are picked random, no position can be picked more than once
    unique_indices = randperm(amount_of_pixels,round((amount_of_pixels)*(1-percentage)));
    
    % create a 3D matrix consisting of a copy of the selectionMatrixColumn with the positions of unique_indices set to 1   
    for k = 1:numFrames
        selectionMatrixColumn(unique_indices,:,k) = 1; % set the value on the place of the unique_indices to 1
    end
    
    % reshape the column matrix to a matrix in the size of the video
    selectionMatrix = reshape(selectionMatrixColumn,[frameHeight,frameWidth,numFrames]);
    
end

%% Create a random selection matrix that changes every frame
% almost exactly the same as the "random_same" method only in this method the
% unique_indices variable is placed in the for loop to create new positions
% for every frame

if type == "random_different" || type == "2"
    
   % create a 2D zero column matrix with the length of the total amount of pixels in the frame 
    selectionMatrixColumn = zeros(amount_of_pixels, 1);
    
    % create a 3D matrix for which every frame, random (1-percentage)*amount_of_pixels positions are choosen and set to 1
    for k = 1:numFrames
       unique_indices = randperm(amount_of_pixels,round((amount_of_pixels)*(1-percentage)));
       selectionMatrixColumn(unique_indices,:,k) = 1; 
    end
    
    % reshape the column matrix to a matrix in the size of the video
    selectionMatrix = reshape(selectionMatrixColumn,[frameHeight,frameWidth,numFrames]);
    
end

%% Create a selecton matrix with horizontal stripes of ones and zeros e.g. [1 1 1; 0 0 0; 1 1 1; 0 0 0]
if type == "stripes_horizontal" || type == "3"
    
    % create a 3D matrix with uneven indices set to 1
    for k = 1:numFrames
        for p = 1:amount_of_pixels
            selectionMatrix(p,1,k) = mod(p,2);
        end
    end
    
    % reshape the matrix to the size of the frame
    selectionMatrix = reshape(selectionMatrix,[frameHeight,frameWidth,numFrames]);
    
end

%% Create a selection matrix with a checker pattern. 
% This is essentially a structured 50/50 selection matrix.
% The size of each square can be adjusted by changing the square_size
% variable.

if type == "checker_pattern" || type == "4"
    
    square_size = 1; 
    
    % create a standard matlab checkerboard matrix creates a 2*frameHeight
    % x 2*frameWidth matrix where half of the matrix contains 0.7 (gray)
    % and 0 (black) values and the other half contains 1 (white) and 0 (black) values.
    checker_matrix = checkerboard(square_size,frameHeight, frameWidth);
    
    % remove half of the rows and half of the columns to get a frameHeight x
    % frameWidth matrix with only 1 (white) and 0 (black) values.
    checker_matrix(:,(frameWidth+1:end)) = [];
    checker_matrix((frameHeight+1:end),:) = [];
    
    % copy the resulting checker matrix into a 3D matrix with the amount of
    % frames as the length.
    for k = 1:numFrames
        selectionMatrix(:,:,k) = checker_matrix;
    end
    
end

end

