function [output_position] = setAxis(frames,scaled_axis,frame_number)
if nargin < 3
    frame_number = 1 ;
end

if ischar(scaled_axis)
    scaled_axis = string(scaled_axis);
end

if scaled_axis == "horizontal"
    selected_axis = 1;
elseif scaled_axis == "verical"
    selected_axis = 2;
else
    error('input must be "hoizontal" or "verical"')
end


selected_frame = frames{frame_number} ;

position = [];                                                      % global variable for click position

fig = figure('Name', 'frame read','Color', [1 1 1], ...
    'ToolBar','none','MenuBar','none');                            % figure
axes_im = axes('Parent', fig ,'Position',[0 0 1 1]) ;              % axis
pltImage = image(selected_frame,'Parent',axes_im);                 % image
set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));  % set axe


% interration function
pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event, selected_frame, axes_im,pltImage);
fig.WindowKeyPressFcn =@(fig,event) KeyPressFcn(fig,event);        % press "ok" to resume

% ui wait
uiwait(fig)
output_position = position;
delete(fig)

% callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% press ok to resume
    function KeyPressFcn(fig,event)
        if string(event.Key) ==  "return"
            uiresume(fig)
        end
    end

% mouth click to resume
    function axesClickCallback(~, event, selected_frame, axes_im,~)
        % Check if left mouse button was clicked (event.Button == 1)
        if event.Button ==1 % rigth click
            if length(position)<2
                click_position = axes_im.CurrentPoint(1,1:2); % mouse position in the axe
                position = [position,round(click_position(selected_axis))];
            end
        elseif event.Button ==3 % left click
            if length(position)<2
                position = [];
            else
                position = position(1:end-1);
            end
        end

        % function plot line
        if selected_axis == 1
            [pltImage] = drawVerticalLine(axes_im, selected_frame, position);
        else
            [pltImage] = drawHorizontalLine(axes_im, selected_frame, position);
        end
        pltImage.ButtonDownFcn = @(src, event) axesClickCallback(src, event, selected_frame, axes_im,pltImage);
    end
end