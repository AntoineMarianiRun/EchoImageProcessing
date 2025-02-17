function [axes_im,pltImage] = drawBoxCorner(axes_im,selected_frame,x,y)
    %cla
    pltImage = imshow(selected_frame, 'Parent',axes_im);
    
    set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));
    xlim(axes_im,[1 size(selected_frame,2)])
    ylim(axes_im,[1 size(selected_frame,1)])
    xticks([])
    yticks([])


    hold on
    if length(x)==1
        plot(axes_im,x,y,'-+r',...
            'LineWidth',2,...
            'MarkerSize',10)                                     % plot th selected point
    elseif length(x)>1
        % Calculate the bottom-left corner of the box
        cornerX = min(x);
        cornerY = min(y);
        boxLengthX = abs(diff(x));
        boxLengthY = abs(diff(y));
    
        rectangle(axes_im,'Position', [cornerX, cornerY, boxLengthX, boxLengthY],...
            'EdgeColor', 'r');
    end
end
