function [video] = autoScale(filesPathName)
% load video
%%%%%%%%%%%%
filesPathName = string(filesPathName);
[video.path ,video.name] = fileparts(filesPathName);

[frames, video_object] = loadVideo(filesPathName);
video.videoObject = video_object;
video.frame = frames;
frame = frames{1};

fs = video_object.FrameRate;
time = 1/fs : 1/fs : video_object.Duration;
if length(time) ~= video_object.NumFrames
    time = linspace(0,video_object.Duration,size(frames,2));
end
video.time.Bmode = time;

try
    [coef_x,coef_y] = autoScaleEcho(frame); % automatic 
    video.coef.x = coef_x;
    video.coef.y = coef_y;

    % % est-ce ok?
    % opts.Interpreter = 'tex'; opts.Default = 'Yes'; %option
    % dlg = questdlg('is the bmode scaling ok?',...
    %     'echo type',...
    %     "Yes","No",opts);
    % if strcmpi(string(dlg),"Yes")
    %     % do nothing
    % elseif strcmpi(string(dlg),"No")
    %     [coef_x,coef_y] = scaleImage(frames);
    %     video.coef.x = coef_x;
    %     video.coef.y = coef_y;
    % end
catch
    [coef_x,coef_y] = scaleImage(frames);
    video.coef.x = coef_x;
    video.coef.y = coef_y;
end


left_top_corner = frame(1 : size(frame,1)*.4,...
    size(frame,2)*.8 : size(frame,2),...
    :);

% check if there is a colormap
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mean(isColor(left_top_corner),"all")>0.001 % 1% of image is composed of color pix
    try
        [colorScaleRGBuint8,colorScaleRGBdouble] = getColorScale(frame);
    catch
        disp('Color scale not found, default coloscale set on')
        [colorScaleRGBuint8,colorScaleRGBdouble] = getDefaultColorScale();     % get the scale color
    end

    % auto ophelie 
    colorScaleValue = linspace(0,300,length(colorScaleRGBdouble));
    % ShowColorScale(colorScaleRGBuint8,colorScaleValue)

    video.colorScale.colorScaleRGBuint8 = colorScaleRGBuint8;
    video.colorScale.colorScaleRGBdouble = colorScaleRGBdouble;
    video.colorScale.colorScaleValue = colorScaleValue;


    % auto frame rate
    [video.time.SWE,video.time.SWindex,state] = autoSWEFrameRate(video.frame,video.colorScale,video.coef,video.time);
    % if state == "fail"
    %     [video.time.SWE,video.time.SWindex]= setSSIFrameRate(frames,time);
    % end
else
    video.colorScale = "None";
end 
end