function video = importVideo(videoPath,videoName,fig)
if ischar(videoPath)
    videoPath = string(videoPath);
end

if length(videoPath)<=2

    if nargin == 2
        [frames, video_object] = loadVideo(videoPath); % get frame and video information
    elseif nargin == 3
        [frames, video_object] = loadVideo(videoPath,fig); % get frame and video information
    end

    [coef_x,coef_y] = scaleImage(frames);% video scaling
    fs = 1 / video_object.FrameRate; % sampling rate
    time = (fs:fs:video_object.NumFrames * fs) - fs; % time vetor

    video.name = videoName;
    video.path = videoPath;
    video.videoObject = video_object;
    video.frame = frames;
    video.coef.x = coef_x;
    video.coef.y = coef_y;
    video.time.Bmode = time;


    opts.Interpreter = 'tex'; opts.Default = 'Yes'; %option
    dlg = questdlg('is the images contains color map?',...
        'echo type',...
        "Yes","No",opts);
    if strcmpi(string(dlg),"Yes")
        [video.colorScale.colorScaleRGBuint8,...
            video.colorScale.colorScaleRGBdouble,...
            video.colorScale.colorScaleValue] = setColorScale(frames{1});
        [video.time.SWE,video.time.SWindex]= setSSIFrameRate(frames,time);
    elseif strcmpi(string(dlg),"No")
        video.colorScale = "None"; 
    end
else
    error('the function "importVideo" must have a single path in imput')
end
end