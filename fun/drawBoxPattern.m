function [pltImage] = drawBoxPattern(axes_im,selected_frame,x,y, lengthBox)
pltImage = image(selected_frame,'Parent',axes_im);
set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));

hold on
if length(x)==1
    plot(x,y,'.r',...
        'LineWidth',2,...
        'MarkerSize',10)                                     % plot th selected point

    cornerX = min(x)-floor(lengthBox/2);
    cornerY = min(y)-floor(lengthBox/2);
    boxLengthX = lengthBox-1;
    boxLengthY = lengthBox-1;

    rectangle('Position', [cornerX, cornerY, boxLengthX, boxLengthY],...
        'EdgeColor', 'r');
end
end
