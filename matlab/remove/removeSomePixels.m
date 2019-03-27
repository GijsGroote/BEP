

v = VideoReader('../doc/DrDre.mp4');
% v = VideoReader(uigetfile('*'));

vidHeight = v.Height;
vidWidth = v.Width;
total_pixels = vidHeight*vidWidth;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
j_data = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);


p = 0.95;

tic;
k = 0;
while hasFrame(v)  %hasFrame(v) %the amount of frames. Use hasFrame(v) to get all of the frames in the video
    mov(k+1).cdata = readFrame(v);
    k = k+1;
end
toc

first_unmodified_frame = mov(1).cdata;

% fv = VideoWriter('drDreFaulty.avi', 'Uncompressed AVI'); %create a VideoWriter object with the desired name

[file,path] = uiputfile('.avi');
fv = VideoWriter([path,file], 'Uncompressed AVI'); %create a VideoWriter object with the desired name

open(fv)

tic;
% rand_unique_pixels = randperm(total_pixels,round((total_pixels)*(1-p)));
for i = 1:k
    
    R = mov(i).cdata(:,:,1);
    G = mov(i).cdata(:,:,2);
    B = mov(i).cdata(:,:,3);
    
    empty_frame = uint8(NaN(total_pixels,1,3));
    rand_unique_pixels = randperm(total_pixels,round((total_pixels)*(1-p)));

    empty_frame(rand_unique_pixels,:,1) = R(rand_unique_pixels);
    empty_frame(rand_unique_pixels,:,2) = G(rand_unique_pixels);
    empty_frame(rand_unique_pixels,:,3) = B(rand_unique_pixels);

    modified_frame = reshape(empty_frame,[vidHeight,vidWidth,3]);
    mov(i).cdata = modified_frame;
    
    j_data(i).cdata(rand_unique_pixels,:,:) = 1;
    
    writeVideo(fv,mov(i).cdata);
    i
end
toc

close(fv)
%% show the faulty video in a figure
tic;
hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);

movie(hf,mov,1,v.FrameRate);
toc
