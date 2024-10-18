function [pltImage] = drawBoxPattern(axes_im,selected_frame,x,y,heigthBox,widthBox,pltImage)
if nargin <= 6
    pltImage = image(selected_frame,'Parent',axes_im);
    set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));
    hold on
end

if length(x)==1
    plot(axes_im,x,y,'.r',...
        'LineWidth',2,...
        'MarkerSize',10)                                     % plot th selected point

    cornerX = x-floor(widthBox/2);
    cornerY = y-floor(heigthBox/2);
    boxLengthX = widthBox-1;
    boxLengthY = heigthBox-1;

    rectangle(axes_im,'Position', [cornerX, cornerY, boxLengthX, boxLengthY],...
        'EdgeColor', 'r');
end
end
