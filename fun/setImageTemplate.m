function [X,Y,patternImage] = setImageTemplate(selected_frame,heigthBox,widthBox)

% to have a center for the template
if mod(heigthBox,2)~=1
    heigthBox = heigthBox+1;
end

if mod(widthBox,2)~=1
    widthBox = widthBox+1;
end




click_X = [];                                                              % global variable for click position
click_Y = [];                                                              % global variable for click position


fig = figure('Name', 'frame read','Color', [1 1 1]);%,'ToolBar','none','MenuBar','none'); % figure
axes_im = axes('Parent', fig ,'Position',[0 0 1 1]) ;                      % axis
pltImage = image(selected_frame,'Parent',axes_im);                         % image
set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));          % set axe

% interration function
pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event,selected_frame, axes_im,pltImage);
fig.WindowKeyPressFcn =@(fig,event) KeyPressFcn(fig,event);        % press "ok" to resume

% ui wait
uiwait(fig)
delete(fig)

% extract pattern
X = click_X;
Y = click_Y;
patternImage = corpImageAsRectangle(selected_frame,X,Y,heigthBox,widthBox); 

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
            click_X = round(click_position(1));
            click_Y = round(click_position(2));
        elseif event.Button ==3 % left click
            if length(click_X)<2
                click_X = [];
                click_Y = [];
            end
        end

        % function plot line

%         [pltImage] = drawBoxPattern(axes_im,selected_frame,click_X,click_Y, lengthBox);
        [pltImage] = drawBoxPattern(axes_im,selected_frame,click_X,click_Y,heigthBox,widthBox);
        pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event, selected_frame, axes_im,pltImage);
    end

end