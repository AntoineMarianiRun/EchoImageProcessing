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
    try
        max_value = findSWEValue(left_top_corner)./3;% module de mu
        colorScaleValue = linspace(0,max_value,length(colorScaleRGBdouble));

    catch
        colorScaleValue = linspace(0,200,length(colorScaleRGBdouble));
    end
    ShowColorScale(colorScaleRGBuint8,colorScaleValue)

    video.colorScale.colorScaleRGBuint8 = colorScaleRGBuint8;
    video.colorScale.colorScaleRGBdouble = colorScaleRGBdouble;
    video.colorScale.colorScaleValue = colorScaleValue;


    % auto frame rate
    try
        [video.time.SWE,video.time.SWindex,state] = autoSWEFrameRate(video.frame,video.colorScale,video.coef,video.time);
    catch
        close force
        video.time.SWE = video.time.Bmode;
        video.time.SWindex = 1 : length(video.time.Bmode);
        state = "fail";
    end
    % if state == "fail"
    %     [video.time.SWE,video.time.SWindex]= setSSIFrameRate(frames,time);
    % end
else
    video.colorScale = "None";
end
end

function max_value = findSWEValue(left_top_corner)

trashold = max(mean(isColor(left_top_corner),2));
tf = mean(isColor(left_top_corner),2)>trashold./2;
idx = find(tf == 1,1,"first")-1;

img = left_top_corner(idx-40 : idx, ...
    150:end, ...
    :);

img = rgb2gray(img);      % convert to grayscale
img = imadjust(img);                  % improve contrast
img = imbinarize(img);                % convert to binary
img = imresize(img,2);                % enlarge small text



r=ocr(img);
boxes = r.WordBoundingBoxes;    % coordonnées de chaque mot
words = r.Words;                 % texte de chaque mot
numbers = regexp(words,'\d+\.?\d*','match');   % extract integers or decimals
numbers = [numbers{:}];                        % flatten cell array
max_value = str2double(numbers);                  % convert to numeric

end