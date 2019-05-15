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

%% paths
    % als deze functie vaak wordt aangeroepen moet ie altijd hier doorheen
    % loopen, waarschijnlijk beter om dat in de file te doen die deze
    % functie aanroept
    myDir  = pwd; %current path (where this file is saved)
    idcs   = strfind(myDir,filesep); %find the "\" folder seperator
    newDir = myDir(1:idcs(end)-1); % go 1 folders up
    addpath(strcat(newDir,'\tensorTrain')) %path to tensorTrain
%% initialization (probably deleted when this turns into function file)
n=480; %the original video is size n x m 
m=720;
%Xrank should be high enough that the video is a good reconstruction, 
%the lower Xrank the larger the error between real X and its 
%representation X.X1, X,X2. A GOOD NUMBER STILL NEEDS TO BE FOUND 
Xrank = 10;
% the below is all input generated from other functions and/or videos
R = randi([0 (n*m)/100], 1, n*m); % location of measured pixels (random now)
y = randi([0 255], (n*m)/100, 1); % measurements (random now)
X.X1 = randi([0 4],n, 1, Xrank);
X.X2 = randi([0 4], m, 1, Xrank);
P.P1 = ones(n,n,1,'double');
P.P2 = ones(m,m,1,'double');
W.W1 = 40*ones(n,n,1,'double');
W.W2 = ones(m,m,1,'double');
%% Prediction of Kalman filter
%first kalman equation, but not needed in our case X[k+1] = X[k]
%X = X; 

%A priori estimate of the covariance matrix P
[P.P1, P.P2] = tensorSum(P.P1,P.P2,W.W1,W.W2,1);
%% Update step of Kalman filter
%CX is the estimation of what should be measured according to the
%prediction, R1 and R2 are the indexes of the pixel that is currently measured
[CX, R1, R2] = CtimesX(R(1),X.X1,X.X2);
% v = y - C*X
v = y(1) - CX;         %v is a temporary variable (scalar)

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