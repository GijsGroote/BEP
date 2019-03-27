%%clear the Workspace
clear;
clc;

%% Import video and assign required information to variables
v = VideoReader('../../doc/drDre.mp4');

%get video Width and Height in amount of pixels
vidWidth = v.Width; %Video Width
vidHeight = v.Height; %video Height

%Create a empty 'video' structure object called mov which is going to contain all the frames of the imported video. all the frames are
%Zero-Matrices of size vidHeight x vidWidth
mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

%% Fill the mov structure with the imported frames
k = 0;
while k < hasFrame(v) %the amount of frames. Use hasFrame(v) to get all of the frames in the video
    mov(k+1).cdata = readFrame(v);
    k = k+1;
end

p = 0.95; %The percentage of the pixels that will be removed for every frame 

%% create the faulty frames

for i = 1:k
    frame_column_vector = reshape(mov(i).cdata,[vidHeight*vidWidth,1,3]); %reshape the frame to a column vector 
    unique_random_pixels = randperm(vidHeight*vidWidth,round(vidHeight*vidWidth*p)); %pick an x amount of unique 'pixels' from all the available pixels
    
    for n = 1 : length(unique_random_pixels)
        frame_column_vector(unique_random_pixels(n),1,:) = nan; %set pixel value to nan (not a number)
    end
    
    faulty_frame = reshape(frame_column_vector,[vidHeight,vidWidth,3]); %reshapes the processed frame column vector to a vidHeight x vidWidth vector
    mov(i).cdata = faulty_frame; %assign the faulty frame to the mov structure
    i %shows the current processed frame in the command window
end

%% Save the video
fv = VideoWriter('DrDreFaulty.avi', 'Uncompressed AVI'); %create a VideoWriter object with the desired name
open(fv)
writeVideo(fv,mov) %write the video the the newly created file
close(fv)

%% show the faulty video in a figure

hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);

movie(hf,mov,1,v.FrameRate);

