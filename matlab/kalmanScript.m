 sigmaP = 100;
 sigmaW = 0.01;
    Xrank = 50; %to be determined by a function
     for k=numFrames:-1:1
         
         X3(k).X1 = zeros(frameHeight, 1, Xrank,'double');
         X3(k).X2 = zeros(frameWidth, 1, Xrank,'double');
         
         P(k).P1 = zeros(frameHeight, frameHeight, 'double');
         P(k).P2 = zeros(frameWidth, frameWidth, 'double');
         
         X3Matrix(k).frame = zeros(frameHeight, frameWidth, 'double');
     end
     X3(1).X1 = 128/Xrank*ones(frameHeight, 1, Xrank,'double');
     X3(1).X2 = ones(frameWidth, 1, Xrank,'double');
     W.W1 = sigmaW*eye(frameHeight, frameHeight, 'double');
     W.W2 = eye(frameWidth, frameWidth, 'double');
     P(1).P1 = sigmaP*eye(frameHeight, frameHeight, 'double');
     P(1).P2 = eye(frameWidth, frameWidth, 'double');
     for k = 1:210
         tic
         [X3(k+1), P(k+1)] = KalmanFilterTensorScript(X3(k), P(k), W, faultyVector(k).frame(:,:,1), R);
         X3Matrix(k+1).frame = reshape(tensor2Matrix(X3(k+1).X1,X3(k+1).X2),480,720);
         [U,S,V] = svd(X3Matrix(k+1).frame,'econ');
         U(:,(Xrank+1):end) = [];
         S = S(1:Xrank,1:Xrank);
         V(:,(Xrank+1):end) = [];
         X3(k+1).X1 = permute(U*S,[1 3 2]);
         X3(k+1).X2 = permute(V,[1 3 2]);
         toc
     end
     save('C:\Users\Thijs\Documents\School\BEP_DATA\workspace\210frames_rank50_v2')
     