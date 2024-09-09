function [X,Y] = setLine(selected_frame)
    click_X = [];                                                      % global variable for click position 
    click_Y = [];                                                      % global variable for click position 
    
    fig = figure('Name', 'frame read','Color', [1 1 1]);%,'ToolBar','none','MenuBar','none'); % figure
    axes_im = axes('Parent', fig ,'Position',[0 0 1 1]) ;              % axis
    pltImage = image(selected_frame,'Parent',axes_im);           % image
    set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));  % set axe

    % interration function 
    pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event,selected_frame, axes_im,pltImage);
    fig.WindowKeyPressFcn =@(fig,event) KeyPressFcn(fig,event);        % press "ok" to resume
    
    % ui wait 
    uiwait(fig)
    close(fig)

    if length(click_X) == 2
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
            if length(click_X) ~= 2 % did not permit more the 2 point 
                click_X = [click_X,round(click_position(1))];
                click_Y = [click_Y,round(click_position(2))];
            end
        elseif event.Button ==3 % left click
            if length(click_X)<2
                click_X = [];
                click_Y = [];
            else
                click_X = click_X(1:end-1);
                click_Y = click_Y(1:end-1);
            end
        end

        % function plot line
        [pltImage] = drawLine(axes_im,selected_frame,click_X,click_Y);
        pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event, selected_frame, axes_im,pltImage);
    end
end