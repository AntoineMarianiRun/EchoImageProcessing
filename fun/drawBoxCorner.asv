function [pltImage] = drawBoxCorner(axes_im,selected_frame,x,y)
    %cla
    pltImage = image(selected_frame,'Parent',axes_im);
    
    set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));
    
    hold on
    if length(x)==1
        plot(x,y,'-+r',...
            'LineWidth',2,...
            'MarkerSize',10)                                     % plot th selected point
    elseif length(x)>1
        % Calculate the bottom-left corner of the box
        cornerX = min(x);
        cornerY = min(y);
        boxLengthX = abs(diff(x));
        boxLengthY = abs(diff(y));
    
        rectangle('Position', [cornerX, cornerY, boxLengthX, boxLengthY],...
            'EdgeColor', 'r');
    end
end
