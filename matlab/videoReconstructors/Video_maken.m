function Video_maken(reconstructedVideo, videoName, outputfolder)
    %voorbeelden om deze functie te gebruiken:
    %fautly video maken:
    %Video_maken(faultyVideo, 'Human_Power_Team_480p_0.5_[1]_observed', 'observed')
    
    %ReconstructedVideo:
    %Video_maken(reconstructedVideo, 'Human_Power_Team_480p_0.5_[1]', 'output')
    
    %Ik denk dat dit een heel omslachtige manier is om een video file te maken
    %omdat je steeds per frame een figure moet openen
    
    mydir  = pwd; %current path (where this file is saved)
    idcs   = strfind(mydir,filesep); %find the "\" folder seperator
    newdir = mydir(1:idcs(end-1)-1); % go 2 folders up
    inputVideoPath = strcat(newdir,'\BEP_DATA\',outputfolder,'\',videoName); %path to the video
    
    %takes a struct 'faultyVideo' and writes it into 'testfileMPEG_faulty', which needs to be in you workspace 
    test =  VideoWriter(inputVideoPath,'MPEG-4'); %filename and extension
    open(test)    %open the videowriter so "writeVideo()" can be used
    for k = 1:length(reconstructedVideo)
        imshow(reconstructedVideo(k).frame) %put each frame in a figure
        F = getframe;   %read the figure into something "writevideo()" understands
        writeVideo(test, F) %make the video from the frames
    end
    close(test) %close the video writer
end