function [processNoise,covMatrix,mu] = processNoise(structVideo)

frame1 = double(structVideo(1).cdata);
frame2 = double(structVideo(2).cdata);

[r,c,d] = size(frame1);

covMatrix = zeros(c,c);
mu = [0, 0, 0];

processNoise = frame2 - frame1;

for k = 1:3
    covMatrix(:,:,k) = cov(processNoise(:,:,k));
    mu(k) = mean(processNoise(:,:,k),'all');
end
end

