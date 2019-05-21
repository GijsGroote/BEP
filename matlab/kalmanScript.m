 sigmaP = 100;
 sigmaW = 10;
    Xrank = 30; %to be determined by a function
     for k=numFrames:-1:1
         
         X2(k).X1 = zeros(frameHeight, 1, Xrank,'double');
         X2(k).X2 = zeros(frameWidth, 1, Xrank,'double');
         
         P(k).P1 = zeros(frameHeight, frameHeight, 'double');
         P(k).P2 = zeros(frameWidth, frameWidth, 'double');
     end
     X2(1).X1 = 128/Xrank*ones(frameHeight, 1, Xrank,'double');
     X2(1).X2 = ones(frameWidth, 1, Xrank,'double');
     W.W1 = sigmaW*eye(frameHeight, frameHeight, 'double');
     W.W2 = eye(frameWidth, frameWidth, 'double');
     P(1).P1 = sigmaP*eye(frameHeight, frameHeight, 'double');
     P(1).P2 = eye(frameWidth, frameWidth, 'double');
     for k = 1:30
         [X2(k+1), P(k+1)] = KalmanFilterTensorScript(X2(k), P(k), W, faultyVector(k).frame(:,:,1), R);
         k
     end
     