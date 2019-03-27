function [ X ] = SVRLMS( firstFrame, M, J, lambda, mu )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


% this file was created on 14-03-2019 by Gijs Groote

% INPUT
% firstFrame is the first frame. This needs some reconstruction in a
% different function. Thus are those 2 algorithms in seperate files
% The code takes as input 2 matrices. Matrix M which is a low rank matrix
% and a subset of omega (which is the complete picture which we need to
% reconstruct). The other matrix is J a matix containing 1 and 0. 1 if a
% pixel value is equal as the pixel value of omega and 0 if it is not.
% more info needed, see [1] and [2] from the paper Adaptive Low Rank Matrix
% Completion

% OUTPUT
% Matrix X which is an reconstruction of omega using the 
%(Single Value Regularize - Least Mean Square) SVR-LMS algorithm. 


% constants
k_end = hasFrame(M);      % k_end should be the number of frames the video has

[nRows,nColums] = size(M);          % nRows is number of rows, nColumns is number of Columns
X = zeros(nRows,nColums,k_end);     % Initializing the matrix X, whith the same dimensions as M
X(:,:,1) = firstFrame;              % Setting the first frame of X to M

% iterative SVR-LMS algorithm
for k = 1:k_end
    % single value decomposition of X
    [U,S,V] = svd(X(:,:,k));
    
    % delete last row
    V(nColums,:) = [];
    
    % update next frame of X
    % .* is the hadmard product
    X(:,:,k+1) = X(:,:,k) + mu*J.*(M - X(:,:,k)) - mu*lambda*U*V;
end

end








