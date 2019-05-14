function [reducedRankA reducedRankB] = rankReduction(P1, P2, W1, W2)
% Reduce the rank of a matrix from 2 to 1
% INPUT
% --(P1)--  --(W1)--
%    |         | 
%    |         |
% --(P2)--  --(W2)--
% P1, P2 are tensor network representation of P (e.g. covariance)
% W1, W2 are tensor network representation of W (e.g. noise)
% P1 and W1 are of the same dimensions (n,n, x1)
% P2 and W2 are of the same dimensions (m,m, x2)
% x1 and x2 are numbers that can differ
% for covariance and noise x1=x2=1
%
% OUTPUT
% --(rdA)--
%     |
%     | 1
%     |
% --(rdB)--
% reducedRankA, reducedRankB are tensor network represenation of the sum 
%of input with the third rank reduced to 1 

% The size of the inputs is needed for reshaping
n = size(P1,1); 
m = size(P2,1);
%% Reshaping
P1a = reshape(P1, n^2, 1); %reshape P1 to column of length n^2
W1a = reshape(W1, n^2, 1); %reshape W1 to column of length n^2

P2a = reshape(P2, 1, m^2); %reshape P1 to row of length m^2
W2a = reshape(W2, 1, m^2); %reshape P1 to row of length m^2

columnMatrix = [P1a W1a];   %merge the columns --> (n^2 x 2)
RowMatrix = [P2a; W2a];     %merge the rows --> (2 x m^2)
%% SVD
% SVD is taken and then the largest value of S is saved
[U1, S1, V1] = svd(columnMatrix,'econ');
interMatrix1 = S1*V1'*RowMatrix;

[U2, S2, V2] = svd(interMatrix1, 'econ');
% deleting the 2nd to last row to lower the 3rd rank to 1
U2(:,2:end) = [];
S2 = S2(1,1);
V2(:,2:end) = [];
%computing the tensor representation of P-[k+1]
 reducedRankA= reshape(U1*U2*S2, n, n);
 reducedRankB = reshape(V2, m, m);
end