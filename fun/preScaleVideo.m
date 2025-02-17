function preScale = preScaleVideo()
%% select video
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[f_,pathname] = uigetfile({'*.avi','Video (*.avi)';...
    '*.*'  ,'Tous les Fichiers (*.*)';},...
    'Select your video','MultiSelect', 'on');
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



%% pre scaling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nbFiles = length(f_);                                                      % number of file selected
if ~isnumeric(f_)
    for currentFile = 1 : nbFiles

        % display to user
        %%%%%%%%%%%%%%%%%
        disp(['Scaling process of video : ', num2str(currentFile), ' / ', ...
            num2str(nbFiles)])
        disp(['video name : ', f_{currentFile}])

        % import video
        %%%%%%%%%%%%%%
        [frames, video_object] = loadVideo(f{currentFile});                    % import frames and video information
        timeBmode = 1/video_object.FrameRate : ...
            1/video_object.FrameRate :...
            video_object.Duration;                                             % time vetor of the video

        if length(timeBmode) ~= video_object.NumFrames
            timeBmode = linspace(0,video_object.Duration,size(frames,2));      % correct potential error
        end

        % scaling
        %%%%%%%%%%%%%%
        stateScaling = false;
        while stateScaling == false
            preScale = [];

            % B-mode
            %%%%%%%%%%%%%%
            disp('     - Set scale the width and heigth of video ')
            [coef_x,coef_y] = scaleImage(frames);                          % video scaling

            % add to the structure preScale
            preScale.name = f_{currentFile};
            preScale.path = f{currentFile};
            preScale.time.Bmode = timeBmode;
            preScale.coef.x = coef_x; % col factor
            preScale.coef.y = coef_y; % row factor

            try
                % Swe
                %%%%%%%%%%%%%%
                % color scale
                disp('     - Set color scale ')
                frameRead(frames,1)
                [colorScaleRGBuint8,colorScaleRGBdouble,colorScaleValue] = setColorScale(frames{1}); % color scale
                close all

                % add to the structure preScale
                preScale.colorScale.colorScaleRGBuint8 = colorScaleRGBuint8;
                preScale.colorScale.colorScaleRGBdouble = colorScaleRGBdouble;
                preScale.colorScale.colorScaleValue = colorScaleValue;

                % frame rate
                disp('     - Set SWE frame rate ')
                [timeSWE,indexImgSWE]= setSSIFrameRate(frames,timeBmode);

                % add to the structure preScale
                preScale.time.SWE = timeSWE;
                preScale.time.SWindex = indexImgSWE;
            catch
                disp('this file did not contain SWE map')
                close all
            end

            % OK
            %%%%%%%%%%%%%%
            opts.Interpreter = 'tex'; opts.Default = 'Yes'; % options
            dlg = questdlg('is prescaling ok?','echo type',"Yes","No","Abort",opts);
            if strcmpi(string(dlg),"Yes")
                stateScaling = true;
                savePrescale(preScale)
            elseif strcmpi(string(dlg),"Abort")
                stateScaling = true;
            end
        end
    end
end
end


function savePrescale(preScale)
origin = cd;

saveName = [preScale.name(1:end-4),'.mat'];

% find the path 
savePath = preScale.path;
tf = savePath == '/'| savePath == '\';
idx = find(tf,1,"last");
savePath =savePath(1 : idx-1);

cd(savePath)
save(saveName,"preScale",'-mat')
cd(origin)

disp(['file : ', saveName, ' save in : ',savePath ])


end 