function videoExported = uiGetVideo()
video = [] ; % intitialized
%% UI configuration
%%%%%%%%%%%%%%%%%%%%
fig = uifigure('Name', 'Video import tool');
fig.Color =  [1 1 1];
fig.Position(3:4) =  [450 300]; %  w h
fig.CloseRequestFcn = @(src,event)closereq(src);
fig.WindowStyle ="modal";

% files list
bxl = uilistbox('Parent', fig) ;
bxl.Items = {'Select your video files'};
bxl.Position = [50 100 250 180] ;

% search files btn
btn_search = uibutton('push','Parent',fig);
btn_search.Text = {'Search', 'video' , 'files'} ;
btnX1 = 350;
btnY1 = 200;
btnWidth1 = 70;
btnHeight1 = 80;
btn_search.Position = [btnX1 btnY1 btnWidth1 btnHeight1];

% clear files btn
btn_clear = uibutton('push','Parent',fig);
btn_clear.Text = 'clear video files' ;
btn_clear.Enable = "off" ;
btnX2 = 350;
btnY2 = 100;
btnWidth2 = 70;
btnHeight2 = 80;
btn_clear.Position = [btnX2 btnY2 btnWidth2 btnHeight2];

% load files btn
btn_load = uibutton('push','Parent',fig);
btn_load.Text = 'Import video files' ;
btn_load.Enable = "off" ;
btnX3 = 125;
btnY3 = 50;
btnWidth3 = 200;
btnHeight3 = 22;
btn_load.Position = [btnX3 btnY3 btnWidth3 btnHeight3];

% interation fnctions
btn_search.ButtonPushedFcn = @(btn,event) search(bxl,btn_load,btn_clear,fig);
btn_clear.ButtonPushedFcn = @(btn,event) files_clear(bxl,btn_load,btn_clear);
btn_load.ButtonPushedFcn =  @(btn,event) files_import(fig,btn_load,btn_clear,btn_search);


%% UI end
%%%%%%%%%%%%%%%%%%%%
uiwait(fig);
for ii = 1 : length(videoExported)
    formatSpec = 'video :" %s " is import to the workspace\n';
    fprintf(formatSpec,videoExported(ii).path);
end
delete(fig)


%% UI callbacks
%%%%%%%%%%%%%%%%%%%%
% search
    function search(bxl,btn_load,btn_clear,fig)
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

        if length(f) == 1
            f_ = string(f_);
        end


        if isempty(video) == 1
            for i = 1 : length(f_)
                video(i).path = f{i};
                video(i).name = f_{i};
                items(i) = string(f{i}) ;
            end

        else
            lbeg = length(video);
            for i = 1 : length(f_)
                video(i + lbeg).path = f{i};
                video(i + lbeg).name = f_{i};
            end
        end

        for i = 1 : length(video)
            items(i) = string(video(i).path) ;
        end


        bxl.Items = items;
        btn_clear.Enable = "on" ;
        btn_load.Enable = "on" ;
        fig.WindowStyle = 'modal';
    end

% clear
    function files_clear(bxl,btn_load,btn_clear)
        video = [] ;
        bxl.Items = {'select your video files'};
        btn_load.Enable = "off" ;
        btn_clear.Enable = "off" ;
    end

% files_import
    function files_import(fig,btn_load,btn_clear,btn_search)
        btn_load.Enable ="off";
        btn_clear.Enable ="off";
        btn_search.Enable ="off";
        for videoidx = 1 : length(video)
%             videoExported(videoidx) = importVideo(video(videoidx).path,video(videoidx).name);
            videoExported(videoidx) = importVideo(video(videoidx).path,video(videoidx).name,fig);

        end
        uiresume(fig);
    end

% close request
    function closereq(fig)
        selection = uiconfirm(fig,'Close the window?',...
            'Confirmation');
        if isempty(video)
            switch selection
                case 'OK'
                    uiresume(fig)
                    delete(fig)
                case 'Cancel'
                    return
            end
        else
            % do nothing
            delete(fig)
        end
    end
end