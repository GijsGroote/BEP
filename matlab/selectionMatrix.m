function [selectionMatrix] = selectionMatrix(frameHeight,frameWidth,frames,percentage,type)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

amount_of_pixels = frameHeight*frameWidth;

if type == "random_same" || type == "1"
    
    selectionMatrixColumn = zeros(amount_of_pixels, 1);
    
    unique_indices = randperm(amount_of_pixels,round((amount_of_pixels)*(1-percentage)));
    
    for k = 1:frames
       selectionMatrixColumn(unique_indices,:,k) = 1; 
    end
    
    selectionMatrix = reshape(selectionMatrixColumn,[frameHeight,frameWidth,frames]);
    
end


if type == "random_different" || type == "2"
    
    selectionMatrixColumn = zeros(amount_of_pixels, 1);
    
    for k = 1:frames
       unique_indices = randperm(amount_of_pixels,round((amount_of_pixels)*(1-percentage)));
       selectionMatrixColumn(unique_indices,:,k) = 1; 
    end
    
    selectionMatrix = reshape(selectionMatrixColumn,[frameHeight,frameWidth,frames]);
    
end


if type == "stripes_horizontal" || type == "3"
    
    for k = 1:frames
        for p = 1:amount_of_pixels
            selectionMatrix(p,:,k) = mod(p,2);
        end
    end
    
    selectionMatrix = reshape(selectionMatrix,[frameHeight,frameWidth,frames]);
    
end

if type == "checker_pattern" || type == "4"

    checker_matrix = checkerboard(1,frameHeight, frameWidth);
    checker_matrix(:,(frameWidth+1:end)) = [];
    checker_matrix((frameHeight+1:end),:) = [];
    
    for k = 1:frames
        selectionMatrix(:,:,k) = checker_matrix;
    end
    
end

end

