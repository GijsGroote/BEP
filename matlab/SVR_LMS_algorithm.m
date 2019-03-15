% this file was created on 14-03-2019 by Gijs Groote

% INPUT
% The code takes as input 2 matrices. Matrix M which is a low rank matrix
% and a subset of omega (which is the complete picture which we need to
% reconstruct). The other matrix is J a matix containing 1 and 0. 1 if a
% pixel value is equal as the pixel value of omega and 0 if it is not.
% more info needed, see [1] and [2] from the paper Adaptive Low Rank Matrix
% Completion

% DELETE LATER AND MAKE FUNCTION FILE OF THIS FILE
M = [1 2 3 ; 3 4 5 ; 4 5 6];
J = [0 1 0 ; 1 0 0 ; 0 0 0];
X = M*J; % TODO check if this is the cross product


% OUTPUT
% Matrix X which is an reconstruction of omega using the 
%(Single Value Regularize - Least Mean Square) SVR-LMS algorithm. 


% constants 
lambda = 1;     % TODO explain what the constants do
mu = 2;
t_end = 1;

% for now the algorithm should do 1 iteration and store X_t+1 in a separete
% value Xt1
% iterative SVR-LMS algorithm
for t = 1:t_end
    
    % single value decomposition of X
    [U,S,V] = svd(X); % TODO: is V transposed?
    
    % update X
    % 0. is the hadmard product
    Xt1 = X + mu*J.*(M - X) - mu*lambda*U*V; % TODO dubble check if hadamard product is working correctly
   
end



