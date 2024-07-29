function [X,Y] = set_square(selected_frame)

click_X = [];                                                      % global variable for click position
click_Y = [];                                                      % global variable for click position

fig = figure('Name', 'frame read','Color', [1 1 1],'ToolBar','none','MenuBar','none'); % figure
axes_im = axes('Parent', fig ,'Position',[0 0 1 1]) ;              % axis
pltImage = image(selected_frame,'Parent',axes_im);           % image
set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));  % set axe

% interration function
pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event, frames_, frameindex_, axes_im,pltImage);
fig.WindowKeyPressFcn =@(fig,event) KeyPressFcn(fig,event);        % press "ok" to resume

uiwait(fig)
delete(fig)
if length(click_X)<2
    X = [];
    Y = [];
else
    X = min(click_X) : max(click_X);
    Y = min(click_Y) : max(click_Y);
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
    function axesClickCallback(~, event, frames_, frameindex_, axes_im,~)
        % Check if left mouse button was clicked (event.Button == 1)
        if event.Button ==1 % rigth click
            click_position = axes_im.CurrentPoint(1,1:2); % mouse position in the axe
            if length(click_X)<2
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

        % plot line
        [pltImage] = drawBoxCorner(axes_im,frames_,frameindex_,click_X,click_Y);
        pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event, frames_, frameindex_, axes_im,pltImage);
    end
end