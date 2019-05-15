function [sumA, sumB] = tensorSum(P1, P2, W1, W2,desiredRank)
% Take the sum of 2 matrices, and reduce rank of the sum to the desired. If
% desiredRank is not specified, no rank reduction will be performed.
% rank.
% INPUT
% --(P1)--  --(W1)--
%    |         |
%    |PR       |PW
%    |         |
% --(P2)--  --(W2)--
% P1, P2 are tensor network representation of P (e.g. covariance)
% W1, W2 are tensor network representation of W (e.g. noise)
% P1 and W1 are of the same dimensions (n,n, ...)
% P2 and W2 are of the same dimensions (m,m, ...)
% x1 and x2 are numbers that can differ from eachother
% for covariance and noise PR=WR=1

% PR and WR (in drawing) are defined in the function, not in the input
% arguments.

% desiredRank is the rank of the outputted tensor network
% OUTPUT
% --(rdA)--
%     |
%     | desiredRank
%     |
% --(rdB)--
% reducedRankA, reducedRankB are tensor network represenation of the sum
%of input with the third rank reduced to desiredRank

% The size of the inputs is needed for reshaping
n = size(P1,1);     %number of colums and rows of P1 (and W1)
m = size(P2,1);     %number of colums and rows of P2 (and W2)
PR = size(P1,3);    %lenght of 3rd dimension of P1 (and P2)
WR = size(W1,3);    %lenght of 3rd dimension of W1 (and W2)
%% Reshaping 3d to 2d
P1a = reshape(P1, n^2, PR); %reshape P1 to column of length n^2 (PR colums side by side)
W1a = reshape(W1, n^2, WR); %reshape W1 to column of length n^2 (WR colums side by side)

P2a = reshape(P2, PR, m^2); %reshape P1 to row of length m^2 (PR rows side by side)
W2a = reshape(W2, WR, m^2); %reshape P1 to row of length m^2 (WR rows side by side)

columnMatrix = [P1a W1a];   %merge the columns --> (n^2 x 2)
rowMatrix = [P2a; W2a];     %merge the rows --> (2 x m^2)
%% Sum of the tensor networks
% nargin is the number of inputs, so if desiredRank (nargin = 4) is not specified, this
% function just sums, without reducing rank
if nargin == 4 
    %% Reshape into desired tensors
    sumA = reshape(columnMatrix, n, n, PR+WR);  %reshape into desired form
    sumB = reshape(rowMatrix, m, m, PR+WR);     %reshape into desired form
else % If rankReduced is specified (nargin = 5 =/= 4). 
    %% Rank reduction using SVD
    % SVD is taken and then the largest value of S is saved
    [U1, S1, V1] = svd(columnMatrix,'econ');
    interMatrix1 = S1*V1'*rowMatrix;
    
    [U2, S2, V2] = svd(interMatrix1, 'econ');
    % deleting all but the first 'desiredRank' rows (and colums) of U2,S2 and V2
    U2(:,(desiredRank+1):end) = [];
    S2 = S2(1:desiredRank,1:desiredRank);
    V2(:,(desiredRank+1):end) = [];
    %computing the tensor representation of the sum
    sumA= reshape(U1*U2*S2, n, n, desiredRank);
    sumB = reshape(V2, m, m, desiredRank);
end
end