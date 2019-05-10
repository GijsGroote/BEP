% Reduce the rank of a matrix from 2 to 1
sigmax_sq = 10;

n=20;   %rows
m=30;   %columns

N = n*m; %pixels
% the initial matrices for P[k] and W
P1 = eye(n);
P2 = eye(m);

W1 = sigmax_sq*eye(n);
W2 = eye(m);

P1a = reshape(P1, n^2, 1);
W1a = reshape(W1, n^2, 1);

P2a = reshape(P2, 1, m^2);
W2a = reshape(W2, 1, m^2);

columnMatrix = [P1a W1a];
RowMatrix = [P2a; W2a];

[U1, S1, V1] = svd(columnMatrix,'econ');
interMatrix1 = S1*V1'*RowMatrix;

[U2, S2, V2] = svd(interMatrix1, 'econ');
% deleting the 2nd row to lower the rank
U2(:,2) = [];
S2 = S2(1,1);
V2(:,2) = [];
%computing the tensor representation of P-[k+1]
 Pnew1vector= U1*U2*S2;
 Pnew1= reshape(U1*U2*S2, n, n);
 Pnew2 = reshape(V2, m, m);