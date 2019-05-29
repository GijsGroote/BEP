sigmaP = 100;
sigmaW = 5;
Xrank = 50; %to be determined by a function
[frameHeight, frameWidth, colours] = size(originalVideo(1).frame);
numFrames = 5;
for k=numFrames:-1:1
    
    X(k).X1 = zeros(frameHeight, 1, Xrank,'double');
    X(k).X2 = zeros(frameWidth, 1, Xrank,'double');
    
    P(k).P1 = zeros(frameHeight, frameHeight, 'double');
    P(k).P2 = zeros(frameWidth, frameWidth, 'double');
    
    XMatrix(k).frame = zeros(frameHeight, frameWidth, 'double');
    XMatrixRR3(k).frame = zeros(frameHeight, frameWidth, 'uint8');
    R(k).frame = find(selectionMatrixVar(:,:,k));
    %[~,~,C] = find(faultyVideo(k).frame(:,:,1));
    loc = ind2sub([frameHeight frameWidth colours],R(k).frame);
    C = faultyVideo(k).frame(loc);
    y(k).frame = double(C);
end
%R = sub2ind([frameHeight frameWidth],A,B);
      X(1).X1 = 128/Xrank*ones(frameHeight, 1, Xrank,'double');
      X(1).X2 = ones(frameWidth, 1, Xrank,'double');
[U1,S1,V1] = svd(double(originalVideo(1).frame(:,:,1)),'econ');
U1(:,(Xrank+1):end) = [];
S1 = S1(1:Xrank,1:Xrank);
V1(:,(Xrank+1):end) = [];
%X(1).X1 = permute(U1*S1,[1 3 2]);
%X(1).X2 = permute(V1,[1 3 2]);
W.W1 = sigmaW*eye(frameHeight, frameHeight, 'double');
W.W2 = eye(frameWidth, frameWidth, 'double');
% for i=-15:1:15
% P(1).P1 = P(1).P1 + diag((-abs(i)^1+15)*sigmaP*ones(frameHeight-abs(i),1),i);
% P(1).P2 = P(1).P2 + diag((-abs(i)^1+15)*0.5*ones(frameWidth-abs(i),1),i);
% end
P(1).P1 = sigmaP*eye(frameHeight, frameHeight, 'double');
P(1).P2 = eye(frameWidth, frameWidth, 'double');
for k = 1:numFrames-1
    tic
    [X(k+1), P(k+1)] = KalmanFilterTensorScriptFast(X(k), P(k), W, y(k).frame, R(k).frame); %faultyVector(k).frame(:,:,1)
    XMatrix(k+1).frame = reshape(permute(X(k+1).X1,[1 3 2])*permute(X(k+1).X2,[3 1 2]),480,720);
    [U,S,V] = svd(XMatrix(k+1).frame,'econ');
    U(:,(Xrank+1):end) = [];
    S = S(1:Xrank,1:Xrank);
    V(:,(Xrank+1):end) = [];
    X(k+1).X1 = permute(U*S,[1 3 2]);
    X(k+1).X2 = permute(V,[1 3 2]);
    toc
end
 for k = 1:numFrames - 1
     XMatrixRR3(k).frame = uint8(permute(X(k).X1,[1 3 2])*permute(X(k).X2,[3 1 2]));
%     [U3,S3,V3] = svd(XMatrix(i).frame,'econ');
%     U3(:,(Xrank+1):end) = [];
%     S3 = S3(1:Xrank,1:Xrank);
%     V3(:,(Xrank+1):end) = [];
%     XMatrixRR(i).frame = uint8(U3*S3*V3');
 end
%save('C:\Users\Thijs\Documents\School\BEP_DATA\workspace\veranderingen_2')
sigmaP = 100;
sigmaW = 5;
Xrank = 50; %to be determined by a function
[frameHeight, frameWidth, colours] = size(originalVideo(1).frame);
numFrames = 10;
for k=numFrames:-1:1
    
    X(k).X1 = zeros(frameHeight, 1, Xrank,'double');
    X(k).X2 = zeros(frameWidth, 1, Xrank,'double');
    
    P(k).P1 = zeros(frameHeight, frameHeight, 'double');
    P(k).P2 = zeros(frameWidth, frameWidth, 'double');
    
    XMatrix(k).frame = zeros(frameHeight, frameWidth, 'double');
    XMatrixRR4(k).frame = zeros(frameHeight, frameWidth, 'uint8');
    R(k).frame = find(selectionMatrixVar(:,:,k));
    %[~,~,C] = find(faultyVideo(k).frame(:,:,1));
    loc = ind2sub([frameHeight frameWidth colours],R(k).frame);
    C = faultyVideo(k).frame(loc);
    y(k).frame = double(C);
end
%R = sub2ind([frameHeight frameWidth],A,B);
      X(1).X1 = 128/Xrank*ones(frameHeight, 1, Xrank,'double');
      X(1).X2 = ones(frameWidth, 1, Xrank,'double');
[U1,S1,V1] = svd(double(originalVideo(1).frame(:,:,1)),'econ');
U1(:,(Xrank+1):end) = [];
S1 = S1(1:Xrank,1:Xrank);
V1(:,(Xrank+1):end) = [];
%X(1).X1 = permute(U1*S1,[1 3 2]);
%X(1).X2 = permute(V1,[1 3 2]);
W.W1 = sigmaW*eye(frameHeight, frameHeight, 'double');
W.W2 = eye(frameWidth, frameWidth, 'double');
% for i=-15:1:15
% P(1).P1 = P(1).P1 + diag((-abs(i)^1+15)*sigmaP*ones(frameHeight-abs(i),1),i);
% P(1).P2 = P(1).P2 + diag((-abs(i)^1+15)*0.5*ones(frameWidth-abs(i),1),i);
% end
P(1).P1 = sigmaP*ones(frameHeight, frameHeight, 'double');
P(1).P2 = ones(frameWidth, frameWidth, 'double');
for k = 1:numFrames-1
    tic
    [X(k+1), P(k+1)] = KalmanFilterTensorScriptFast(X(k), P(k), W, y(k).frame, R(k).frame); %faultyVector(k).frame(:,:,1)
    XMatrix(k+1).frame = reshape(permute(X(k+1).X1,[1 3 2])*permute(X(k+1).X2,[3 1 2]),480,720);
    [U,S,V] = svd(XMatrix(k+1).frame,'econ');
    U(:,(Xrank+1):end) = [];
    S = S(1:Xrank,1:Xrank);
    V(:,(Xrank+1):end) = [];
    X(k+1).X1 = permute(U*S,[1 3 2]);
    X(k+1).X2 = permute(V,[1 3 2]);
    toc
end
 for k = 1:numFrames - 1
     XMatrixRR4(k).frame = uint8(permute(X(k).X1,[1 3 2])*permute(X(k).X2,[3 1 2]));
%     [U3,S3,V3] = svd(XMatrix(i).frame,'econ');
%     U3(:,(Xrank+1):end) = [];
%     S3 = S3(1:Xrank,1:Xrank);
%     V3(:,(Xrank+1):end) = [];
%     XMatrixRR(i).frame = uint8(U3*S3*V3');
 end
