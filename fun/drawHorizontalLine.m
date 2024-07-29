function pltImage = draw_horizontal_line(axes_im, selected_frame, y)
% draw_horizontal_line Draw horizontal lines on the image.
%   pltImage = draw_horizontal_line(axes_im, selected_frame, y) draws
%   horizontal lines at positions specified in 'y' on the 'selected_frame'
%   image displayed on the axes 'axes_im'.
%
%   Input:
%   - axes_im: Axes handle where the image is displayed.
%   - selected_frame: Image data to be displayed.
%   - y: Vector of y-coordinates where horizontal lines will be drawn.
%
%   Output:
%   - pltImage: Handle to the image object.

% Clear axes
cla(axes_im);

% Display the image
pltImage = image(selected_frame, 'Parent', axes_im);
set(axes_im, 'Layer', 'top', 'XTick', [], 'YTick', []);

% Hold on to the current plot
hold(axes_im, 'on');

% Draw horizontal lines
for i = 1:length(y)
    line(axes_im, [0 size(selected_frame, 2)], [y(i) y(i)], ...
        'Color', 'Red', 'LineWidth', 1);
end

% Release hold
hold(axes_im, 'off');
end
