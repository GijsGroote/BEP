function [estimatedOutput,R1,R2] = CtimesX(R,X1,X2)
    %INPUT
    % R is the index of the measured pixel
    % X1 is a part of tensor network of X size n x 1 x d
    % X2 is a part of tensor network of X size m x 1 x d
    %OUTPUT
    % estimatedOutput is C * X-
    % R1 is the index for the rows
    % R2 is the index for the colums
    n = size(X1,1);
    m = size(X2,1);
    d = size(X1,3);
    
    % map R to the corresponding rows of the tensor network
    [R1, R2] = ind2sub([n, m], R);
    
    % estimate the value of the pixel from the tensor network of X
    estimatedOutput = reshape(X1(R1,:,:),1,d)*reshape(X2(R2,:,:),d,1);
    % The reshaping is needed to get the right dimensions for multipling
    % (X1 and X2 need to be 2d, while they are 1x1xd)
end

