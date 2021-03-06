function [X,P] = KalmanFilterTensorScriptFast(X,P,W,y,R)
%INPUT
%X is a struct with a the tensor network representation of the state vector
%P is a struct with a tensor network representation of the covariance matrix
%W is a struct with a tensor network representation of the process noise
%covariance matrix
%y is a vector with the value of the measured pixels
%R is a vector with the index of the measured pixels
%% Prediction of Kalman filter
%first kalman equation, but not needed in our case X[k+1] = X[k]
%X = X; 

%A priori estimate of the covariance matrix P
[P.P1, P.P2] = tensorSum(P.P1, P.P2, W.W1, W.W2, 1);
%% Update step of Kalman filter

for n = 1: length(R)
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
% X = X+ceK*v - The new state FUNCTION OUTPUT
[X.X1, X.X2] = tensorSum(X.X1, X.X2, K.K1*v, K.K2); 
end
% -K*S*K'
KSKT.KSKT1 = -1*K.K1*S*(K.K1'); %KSK is a tensor network of two 2d matrixes
KSKT.KSKT2 = K.K2*(K.K2');

%P = P - K*S*K' - The new covariance matA=rix FUNCTION OUTPUT
[P.P1, P.P2] = tensorSum(P.P1, P.P2, KSKT.KSKT1, KSKT.KSKT2);
end