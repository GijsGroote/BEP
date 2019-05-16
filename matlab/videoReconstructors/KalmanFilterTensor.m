function [X,P] = kalmanFilterTensor(X,P,W,y,R)
%% TO DO
    % make a function of the file
    % INPUT: X.X1, X.X2 | P.P1, P.P2 | W.W1, W.W2 | y (measurement vector |
    % R ('location of measurement'-vector |
    % OUTPUT: X.X1, X.X2 | P.P1, P.P2
    %
    % make a loop for that loops through all pixels (Vector R in this case)
    % for now only R(1) is done (R(1) --> R(i))
    %
    % probably more comment should be added

%% Prediction of Kalman filter
%first kalman equation, but not needed in our case X[k+1] = X[k]
%X = X; 
%A priori estimate of the covariance matrix P
[P.P1, P.P2] = tensorSum(P.P1,P.P2,W.W1,W.W2,1);

Xrank = size(X,2);
%% Update step of Kalman filter
for n = 1:1
%CX is the estimation of what should be measured according to the
%prediction, R1 and R2 are the indexes of the pixel that is currently measured
[CX, R1, R2] = CtimesX(R(n),X.X1,X.X2);
% v = y - C*X
v = y(n) - CX;         %v is a temporary variable (scalar)

% S = C*P*C'
S = P.P1(R1,R1)*P.P2(R2,R2);   %S is temporary variable (scalar)

%K = P*C'*1/S
K.K1 = P.P1(:,R1)*1/S; %K is a tensor network of two vectors
K.K2 = P.P2(:,R2);     %K is the Kalman Gain 

% X = X+K*v - The new state FUNCTION OUTPUT
[X.X1, X.X2] = tensorSum(X.X1, X.X2, K.K1*v, K.K2,Xrank); 

% -K*S*K'
KSKT.KSKT1 = -1*K.K1*S*(K.K1'); %KSK is a tensor network of two 2d matrixes
KSKT.KSKT2 = K.K2*(K.K2');

%P = P - K*S*K' - The new covariance matrix FUNCTION OUTPUT
[P.P1, P.P2] = tensorSum(P.P1, P.P2, KSKT.KSKT1, KSKT.KSKT2, 1);
n
end
end

