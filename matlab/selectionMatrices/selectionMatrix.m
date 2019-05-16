function [selectionMatrix,R] = selectionMatrix(frameHeight,frameWidth,numFrames,percentage,type)
    %   Generate a selection matrix

    % INPUT
    % frameHeight           Number of rows in the matrix 
    % frameWidth            Number of columns in the matrix
    % numFrames             Amount of frames in the video
    % percentage            The percentage that will be 'destroyed'
    % type                  The 'destroy' method

    % OUTPUT
    % selectionMatrix       A 3D-matrix of ones and zeros in the size of the video
                            % with the numFrames as a third dimension 
    % R                     A column vector with all the indices of the known
                            % pixels

    % calculate the amount of pixels in a frame
     amountOfPixels = frameHeight*frameWidth;

    %% Create a random selection matrix that stays the same throughout all frames 
    if type == "randomSame" || type == "1"

        % create a 2D zero column matrix with the length of the total amount of pixels in the frame 
        selectionMatrixColumn = zeros(amountOfPixels, 1);

        % (1-percentage)*amount_of_pixels positions are picked random, no position can be picked more than once
        uniqueIndices = randperm(amountOfPixels,round((amountOfPixels)*(1-percentage)));

        % create a 1 x m vector
        R = sort(uniqueIndices);

        % create a 3D matrix consisting of a copy of the selectionMatrixColumn with the positions of unique_indices set to 1   
        for k = 1:numFrames
            selectionMatrixColumn(uniqueIndices,:,k) = 1; % set the value on the place of the unique_indices to 1
        end

        % reshape the column matrix to a matrix in the size of the video
        selectionMatrix = reshape(selectionMatrixColumn,[frameHeight,frameWidth,numFrames]);

    end

    %% Create a random selection matrix that changes every frame
    % almost exactly the same as the "random_same" method only in this method the
    % unique_indices variable is placed in the for loop to create new positions
    % for every frame

    if type == "randomDifferent" || type == "2"

       % create a 2D zero column matrix with the length of the total amount of pixels in the frame 
        selectionMatrixColumn = zeros(amountOfPixels, 1);

        % create a 3D matrix for which every frame, random (1-percentage)*amount_of_pixels positions are choosen and set to 1
        for k = 1:numFrames
           uniqueIndices = randperm(amountOfPixels,round((amountOfPixels)*(1-percentage)));
           selectionMatrixColumn(uniqueIndices,:,k) = 1;

           % find the positions of the ones in the selectionMatrix for every frame and create a
           % 1 x m x numFrames matrix
           R(:,:,k) = sort(uniqueIndices);
        end

        % reshape the column matrix to a matrix in the size of the video
        selectionMatrix = reshape(selectionMatrixColumn,[frameHeight,frameWidth,numFrames]);

    end

    %% Create a selecton matrix with horizontal stripes of ones and zeros e.g. [1 1 1; 0 0 0; 1 1 1; 0 0 0]
    if type == "stripesHorizontal" || type == "3"

        % create a 3D matrix with uneven indices set to 1
        for k = 1:numFrames
            for p = 1:amountOfPixels
                selectionMatrix(p,1,k) = mod(p,2);
            end
        end

        % reshape the matrix to the size of the frame
        selectionMatrix = reshape(selectionMatrix,[frameHeight,frameWidth,numFrames]);

        % find the positions of the ones in the selectionMatrix and transpose
        % it to a 1 x m vector
        R = find(selectionMatrix(:,:,1))';
    end

    %% Create a selection matrix with a checker pattern. 
    % This is essentially a structured 50/50 selection matrix.
    % The size of each square can be adjusted by changing the square_size
    % variable.

    if type == "checkerPattern" || type == "4"

        squareSize = 1; 

        % create a standard matlab checkerboard matrix creates a 2*frameHeight
        % x 2*frameWidth matrix where half of the matrix contains 0.7 (gray)
        % and 0 (black) values and the other half contains 1 (white) and 0 (black) values.
        checkerMatrix = checkerboard(squareSize,frameHeight, frameWidth);

        % remove half of the rows and half of the columns to get a frameHeight x
        % frameWidth matrix with only 1 (white) and 0 (black) values.
        checkerMatrix(:,(frameWidth+1:end)) = [];
        checkerMatrix((frameHeight+1:end),:) = [];

        % copy the resulting checker matrix into a 3D matrix with the amount of
        % frames as the length.
        for k = 1:numFrames
            selectionMatrix(:,:,k) = checkerMatrix;
        end

        % find the positions of the ones in the selectionMatrix and transpose
        % it to a 1 x m vector
        R = find(selectionMatrix(:,:,1))';
    end
end