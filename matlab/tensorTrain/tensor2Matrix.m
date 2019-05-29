function [X] = tensor2Matrix(X1,X2)
%X1 size (r1,k1,R)
%X2 size (r2,k2,R)

%X size (r1*r2, k1*k2)
[r1,k1,R] = size(X1);
[r2,k2,~] = size(X2);

X1 = reshape(X1, r1*k1, R);
X2 = reshape(X2, r2*k2, R)';
X = X1*X2;
X = permute(X, [1 3 2 4]);
X = reshape(X, r1*r2, k1*k2);
end

