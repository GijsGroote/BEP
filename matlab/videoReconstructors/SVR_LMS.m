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

% TODO: uint-8 to doubles for faultyVideo and reconstructedframe

k_end = length(faultyVideo);         % k_end should be the number of frames in the video
[nRows,nColumns] = size(faultyVideo); 

% nRows is number of rows, nColumns is number of Columns
reconstructedVideo = struct('frame', zeros(nRows, nColumns, 3), 'double');   % Initializing the matrix reconstructedVideo,
reconstructedVideo(1) = reconstructedFrame; 

X(:,:,1) = firstFrame;              % Setting the first frame of X to M

% iterative SVR-LMS algorithm
for k = 1:k_end
    for rgb = 1 : 3 
    % single value decomposition of reconstructedVideo
    [U,S,V] = svd(reconstructedVideo(k).frame(:, :, rgb));
    
    % delete last row       TODO: this does not workkkk
    V = V';
    V((nColumns+1):end,:) = [];
    
    % update next frame of reconstructedVideo
    reconstructedVideo(k+1).frame(:, :, rgb) = reconstructedVideo(k).frame(:, :, rgb) + mu * selectionMatrix(:, :, k).*(faultyVideo(k).frame(:, :, rgb) - reconstructedVideo(k).frame(:, :, rgb)) - mu*lambda*U*V;
    
    end
end

% doubles to uint-8 pleasze

end








