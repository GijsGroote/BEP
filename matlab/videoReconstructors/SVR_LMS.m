function [ reconstructedVideo ] = SVR_LMS( reconstructedFrame, faultyVideo, selectionMatrix, lambda, mu, colours)
% reconstruct a faulty video with the single value regularized least mean
% square algorithm. 

% INPUT
% reconstructedFrame    the first frame
% faultyVideo           the measured video with most data lost
% selectionMatrix       the matrix describing which pixels are not lost
% lambda, mu            the parameters to tweak the performance of the algorithm with

% OUTPUT
% reconstructedVideo    the reconstruction of the faultyVideo

%% setup
% k_end is the number of frames in the video
numFrames = length(faultyVideo);

% nRows is number of rows
% nColumns is number of Columns
[numRows,numColumns,~] = size(faultyVideo(1).frame); 

% Initializing a zero struct reconstructedVideo using nRows and nColumns
reconstructedVideo = struct('frame', zeros(numRows, numColumns, colours, 'double'));   

%reconstructedVideo(k).frame(:,:,rgb) --> k is framenumber, (:,:,rgb) is the matrix for red(rgb=1), green(2) or blue(3)
%for the first frame, convert the reconstructedFrame uint8 to double
reconstructedVideo(1).frame = im2double(reconstructedFrame);

%% iterative SVR-LMS algorithm
%loop through every time frame
for k = 1:numFrames -1
    
    % convert the imported datatype uint8 to double so calculation can
    %be made using svd()
    faultyVideo(k).frame = im2double(faultyVideo(k).frame);
    
    for rgb = 1 : colours %3 times because RGB has 3 colours or 1 if greyscale
        % single value decomposition of reconstructedVideo for every
        % colour (and frame)
        [U,~,V] = svd(reconstructedVideo(k).frame(:, :, rgb),'econ'); 
        %'econ' produces an economy-size decomposition of m-by-n matrix A. Only the first m columns of V are computed, and S is m-by-m
    
        % update next frame of reconstructedVideo
        reconstructedVideo(k+1).frame(:, :, rgb) = reconstructedVideo(k).frame(:, :, rgb) + mu * selectionMatrix(:, :, k).*(faultyVideo(k).frame(:, :, rgb) - reconstructedVideo(k).frame(:, :, rgb)) - mu*lambda*U*V';
    end
    
    %convert the double datatype back to uint8
    reconstructedVideo(k).frame = im2uint8(reconstructedVideo(k).frame); 
end

end