function [Product1, Product2] = tensorVectorMultiplication(A1,A2,s,B1,B2)
%     nA1 = size(A1);
%     nA2 = size(A2);
    %computing A*s*B
    %% A*s
    A1 = A1*s;
    %% A*s*B
    Product1 = A1*B1;
    Product2 = A2*B2
end

