function [structVideo] = video2Struct(videoPath)
v = VideoReader(videoPath);

%get video Width and Height in amount of pixels
vidWidth = v.Width; %Video Width
vidHeight = v.Height; %video Height

%Create a empty 'video' structure object called mov which is going to contain all the frames of the imported video. all the frames are
%Zero-Matrices of size vidHeight x vidWidth
structVideo = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

%% Fill the mov structure with the imported frames

k = 0;
while hasFrame(v) %the amount of frames. Use hasFrame(v) to get all of the frames in the video
    structVideo(k+1).cdata = readFrame(v);
    k = k+1;
end
end

