A1 = 10*eye(10);
A2 = 3*eye(13);

W1 = 2*eye(10);
W2 = eye(13);

A = tensor2Matrix(A1,A2);
W = tensor2Matrix(W1,W2);

%Xtest(1:2,:) = reshape(X(:,1:3),2,6)
%Xtest(r1+1:2*r1,:) = reshape(X(:,(r2+1):2*r2),r1,k1*k2)
%Xtest(i:i*r1,:) = reshape(X(:,i:r2),r1,k1*k2)
for i=1:k2
Xtest(i*r1-1:i*r1,:) = reshape(X(:,i*r2-2:i*r2),r1,k1*k2)
end