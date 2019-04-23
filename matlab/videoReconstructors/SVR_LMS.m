function [ reconstructedVideo ] = SVR_LMS( reconstructedFrame, faultyVideo, selectionMatrix, lambda, mu )
% reconstruct a faulty video with the single value regularized least mean
% square algorithm. 

% INPUT
% reconstructedFrame    is the first frame. 
% faultyVideo           is the measured video, it has lost most of it data
% selectionMatrix       is the matrix describing which pixels are not lost
% lambda, mu            are the parameters to tweak the performance of the algorithm with

% OUTPUT
% reconstructedVideo    which is the reconstruction of the faultyVideo

% constants
%% setup
k_end = length(faultyVideo);         % k_end should be the number of frames in the video
[nRows,nColumns] = size(faultyVideo(1).frame); 
% nRows is number of rows, nColumns is number of Columns, used for
% initializing the structs below

reconstructedVideo = struct('frame', zeros(nRows, nColumns, 3, 'double'));   % Initializing the matrix reconstructedVideo,
reconstructedVideo(1).frame = im2double(reconstructedFrame); %reconstructedFrame is a uint8 data type
%reconstructedVideo(k).frame(:,:,rgb) --> k is framenumber, (:,:,rgb) is the matrix for red(rgb=1), green(2) or blue(3) 
%% iterative SVR-LMS algorithm
for k = 1:k_end % k goes through the frame, progressing through time
    
    %This makes the imported datatype uint8 to double so calculation can
    %be made using svd()
    faultyVideo(k).frame = im2double(faultyVideo(k).frame);
    
    for rgb = 1 : 3 %3 times because RGB has 3 colours
    % single value decomposition of reconstructedVideo
    [U,S,V] = svd(reconstructedVideo(k).frame(:, :, rgb),'econ'); % Singular value decomposition for every color (and frame)
    %'econ' produces an economy-size decomposition of m-by-n matrix A. Only the first m columns of V are computed, and S is m-by-m
    
    % update next frame of reconstructedVideo
    reconstructedVideo(k+1).frame(:, :, rgb) = reconstructedVideo(k).frame(:, :, rgb) + mu * selectionMatrix(:, :, k).*(faultyVideo(k).frame(:, :, rgb) - reconstructedVideo(k).frame(:, :, rgb)) - mu*lambda*U*V';
    end
    reconstructedVideo(k).frame = im2uint8(reconstructedVideo(k).frame); %convert the double datatype back to uint8
end
end





