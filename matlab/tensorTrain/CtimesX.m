function [estimatedOutput,R1,R2] = CtimesX(R,X1,X2)
    %INPUT
    % R is the index of the measured pixel
    % X1 is a part of tensor network of X size n x d
    % X2 is a part of tensor network of X size d x m
    %OUTPUT
    % estimatedOutput is C * X-
    % R1 is the index for the rows
    % R2 is the index for the colums
    n = size(X1,1);
    m = size(X2,2);
    
    [R1, R2] = ind2sub([n, m], R);
    estimatedOutput = X1(2,:)*X2(:,3);
end

