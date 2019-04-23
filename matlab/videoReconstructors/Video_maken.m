%Ik denk dat dit een heel omslachtige manier is om een video file te maken
%omdat je steeds per frame een figure moet openen

%takes a struct 'faultyVideo' and writes it into 'testfileMPEG_faulty', which needs to be in you workspace 
test =  VideoWriter('testfileMPEG_faulty','MPEG-4'); %filename and extension
open(test)    %open the videowriter so "writeVideo()" can be used
for k = 1:length(faultyVideo)
    imshow(faultyVideo(k).frame) %put each frame in a figure
    F = getframe;   %read the figure into something "writevideo()" understands
    writeVideo(test, F) %make the video from the frames
end
close(test) %close the video writer