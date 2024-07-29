    function pltImage = draw_vertical_line(axes_im, selected_frame, x)
        % draw_vertical_line Draw vertical lines on the image.
        %   pltImage = draw_vertical_line(axes_im, selected_frame, x) draws vertical
        %   lines at positions specified in 'x' on the 'selected_frame' image
        %   displayed on the axes 'axes_im'.
        %
        %   Input:
        %   - axes_im: Axes handle where the image is displayed.
        %   - selected_frame: Image data to be displayed.
        %   - x: Vector of x-coordinates where vertical lines will be drawn.
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

        % Draw vertical lines
        for i = 1:length(x)
            line(axes_im, [x(i) x(i)], [0 size(selected_frame, 1)], ...
                'Color', 'Red', 'LineWidth', 1);
        end

        % Release hold
        hold(axes_im, 'off');
    end