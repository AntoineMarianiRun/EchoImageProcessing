function preScale = preScaleVideo()
%% select video
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[f_,pathname] = uigetfile({'*.avi','Video (*.avi)';...
    '*.*'  ,'Tous les Fichiers (*.*)';},...
    'Select your video','MultiSelect', 'off');
f = {};% le ou les fichiers

if iscell(f_)
    for i= 1:size(f_,2)
        f{i} =char(strcat(pathname,f_(i)));
    end
elseif ischar(f_)
    f{1} = char(strcat(pathname,f_));
end

if ischar(f_)
    f_ = string(f_);
end

disp(['Pre scaling of : ',  f_{1}])
%% about Bmode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get frame and video information
[frames, video_object] = loadVideo(f{1});

% time of video
timeBmode = 1/video_object.FrameRate : 1/video_object.FrameRate : video_object.Duration;
if length(timeBmode) ~= video_object.NumFrames
    timeBmode = linspace(0,video_object.Duration,size(frames,2));
end
%% scale process
stateScaling = false;

while stateScaling == false
    % scale image
    disp('     - Scale image ')

    [coef_x,coef_y] = scaleImage(frames);% video scaling

    % add tu the structure preScale
    preScale.name = f_{1};
    preScale.path = f{1};
    preScale.time.Bmode = timeBmode;
    preScale.coef.x = coef_x; % col factor
    preScale.coef.y = coef_y; % row factor

    %% Grey mapping
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    opts.Interpreter = 'tex'; opts.Default = 'Yes'; %option
    dlg = questdlg('Do you want to perform grey level analysis?','echo type',"Yes","No",opts);
    if strcmpi(string(dlg),"Yes")
        disp('     - Select zone to perform grey level analysis ')
        greyShape = setSquareShape(frames{1});
        preScale.greyShape = greyShape;
    end


    %% color map
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    opts.Interpreter = 'tex'; opts.Default = 'Yes'; %option
    dlg = questdlg('Do you want to perform shear extraction?','echo type',"Yes","No",opts);
    if strcmpi(string(dlg),"Yes")
        % about color scale
        disp('     - Set color scale ')
        frameRead(frames,1)
        [colorScaleRGBuint8,colorScaleRGBdouble,colorScaleValue] = setColorScale(frames{1});
        close all

        % about Zone of interest
        disp('     - Select zone to perform color analysis ')
        dlg1 = questdlg('what type of zone you want?','echo type',"Auto","Square","Custum",opts);
        if strcmpi(string(dlg1),"Auto")
            sweShape = autoShape(frames{1},preScale.coef);
        elseif strcmpi(string(dlg1),"Square")
            sweShape = setSquareShape(frames{1});
        elseif strcmpi(string(dlg1),"Custum")
            sweShape = setCustumShape(frames{1});
        end

        disp('     - Set SWE frame Rate ')
        [timeSWE,indexImgSWE]= setSSIFrameRate(frames,timeBmode);
        preScale.time.SWE = timeSWE;
        preScale.time.SWindex = indexImgSWE;

        preScale.colorScale.colorScaleRGBuint8 = colorScaleRGBuint8;
        preScale.colorScale.colorScaleRGBdouble = colorScaleRGBdouble;
        preScale.colorScale.colorScaleValue = colorScaleValue;
        preScale.sweShape = sweShape;

        dlg = questdlg('is prescaling ok?','echo type',"Yes","No","Abort",opts);
        if strcmpi(string(dlg),"Yes")
            stateScaling = true;
            saveName = [preScale.name(1:end-4),'_preScaleFiles.mat'];
            save(saveName,"preScale")
        elseif strcmpi(string(dlg),"Abort")
            stateScaling = true;
        end

    end

end