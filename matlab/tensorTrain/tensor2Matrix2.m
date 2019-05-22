function [A] = tensor2Matrix2(A1,A2)
[r1,k1,R] = size(A1);
[r2,k2,~] = size(A2);

A1 = reshape(A1, r1*k1, R);
A2 = reshape(A2, r2*k2, R)';
Ainter = A1*A2;

for i=1:k2
    i
A(i*r1-(r1-1):i*r1,:) = reshape(Ainter(:,i*r2-(r2-1):i*r2),r1,k1*k2)
end
end

