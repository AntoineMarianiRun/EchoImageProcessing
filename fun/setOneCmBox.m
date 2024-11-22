function [X,Y] = setOneCmBox(selected_frame,nPixCol_,nPixRow_,fig)
    click_X = [];                                                      % global variable for click position 
    click_Y = [];                                                      % global variable for click position 

    if nargin <4
        fig = figure('Name', 'frame QQCH','Color', [1 1 1]);%,'ToolBar','none','MenuBar','none'); % figure
    end

    axes_im = axes('Parent', fig ,'Position',[0 0 1 1]) ;              % axis
    pltImage = image(selected_frame,'Parent',axes_im);           % image
    set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));  % set axe

    % interration function 
    pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event,selected_frame, axes_im,pltImage);
    fig.WindowKeyPressFcn =@(fig,event) KeyPressFcn(fig,event);        % press "ok" to resume
    
    % ui wait 
    uiwait(fig)
    
    if nargin <2
        close(fig)
    end

    if length(click_X) == 1
        X = click_X;
        Y = click_Y;
    else
        X = nan(1);
        Y = nan(1);
    end 

        % callback
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % press ok to resume 
    function KeyPressFcn(fig,event)
        if string(event.Key) ==  "return"
            uiresume(fig)
        end
    end

            % mouth click to resume 
    function axesClickCallback(~, event,selected_frame, axes_im,~)
        % Check if left mouse button was clicked (event.Button == 1)
        if event.Button ==1 % rigth click
            click_position = axes_im.CurrentPoint(1,1:2); % mouse position in the axe
            click_X = []; click_Y = [];
            click_X = round(click_position(1));
            click_Y = round(click_position(2));
        elseif event.Button ==3 % left click
            click_X = [];
            click_Y = [];
        end

        % function plot line
        [pltImage] = drawLine(axes_im,selected_frame,click_X,click_Y);
        [pltImage] = drawBoxPattern(axes_im, ...
            selected_frame, ...
            click_X,click_Y, ...
            nPixRow_,nPixCol_, ...
            pltImage);
        
        pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event, selected_frame, axes_im,pltImage);
    end
end