function [selectionMatrix] = selectionMatrix(frameHeight,frameWidth,frames,percentage,type)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

amount_of_pixels = frameHeight*frameWidth; %calculate the amount of pixels in a frame

%% Create a random selection matrix that stays the same throughout all frames 
if type == "random_same" || type == "1"
    
    % create a 2D zero column matrix with the length of the total amount of pixels in the frame 
    selectionMatrixColumn = zeros(amount_of_pixels, 1);
    
    % Pick (1-percentage)*amount_of_pixels random but unique pixels indices from a list of all avaible pixels in the frame 
    unique_indices = randperm(amount_of_pixels,round((amount_of_pixels)*(1-percentage)));
    
    % create a 3D matrix consisting of copies from the selectionMatrixColumn   
    for k = 1:frames
        % set the value on the place of the unique_indices to 1
        selectionMatrixColumn(unique_indices,:,k) = 1; 
    end
    
    % reshape the column matrix to the size of the video
    selectionMatrix = reshape(selectionMatrixColumn,[frameHeight,frameWidth,frames]);
    
end

%% Create a random selection matrix that changes every frame
% almost exactly the same as the "random_same" method only in this one the
% unique_indices variable is placed in the for loop to create a new one for
% every frame

if type == "random_different" || type == "2"
    
    selectionMatrixColumn = zeros(amount_of_pixels, 1);
    
    for k = 1:frames
       unique_indices = randperm(amount_of_pixels,round((amount_of_pixels)*(1-percentage)));
       selectionMatrixColumn(unique_indices,:,k) = 1; 
    end
    
    selectionMatrix = reshape(selectionMatrixColumn,[frameHeight,frameWidth,frames]);
    
end

%% Create a selecton matrix with horizontal stripes of ones and zeros e.g. [1 1 1; 0 0 0; 1 1 1; 0 0 0]
if type == "stripes_horizontal" || type == "3"
    
    for k = 1:frames
        % create a matrix with uneven indices set to 1 
        for p = 1:amount_of_pixels
            selectionMatrix(p,1,k) = mod(p,2);
        end
    end
    
    % reshape the matrix to the size of the frame.
    selectionMatrix = reshape(selectionMatrix,[frameHeight,frameWidth,frames]);
    
end

%% Create a selection matrix with a checker pattern. 
% This is essentially a structured 50/50 selection matrix.
% The size of each square can be adjusted by changing the square_size
% variable.

if type == "checker_pattern" || type == "4"
    
    square_size = 1; 
    
    % create a standard matlab checkerboard matrix creates a 2*frameHeight
    % x 2*frameWidth matrix where half of the matrix contains 0.7 (gray)
    % and 0 (black) values. this parts needs to be removed.
    checker_matrix = checkerboard(square_size,frameHeight, frameWidth);
    
    % remove the last half of the rows and columns to get a frameHeight x
    % frameWidth matrix with only 1 (white) and 0 (black) values.
    checker_matrix(:,(frameWidth+1:end)) = [];
    checker_matrix((frameHeight+1:end),:) = [];
    
    %copy the resulting checker matrix into a 3D matrix with the amount of
    %frames as the length.
    for k = 1:frames
        selectionMatrix(:,:,k) = checker_matrix;
    end
    
end

end

