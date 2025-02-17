function [pltImage] = drawLine(axes_im,selected_frame,x,y)
    %cla
    pltImage = image(selected_frame,'Parent',axes_im);
    set(axes_im,'Layer','top','XTick',zeros(1,0),'YTick',zeros(1,0));

    hold on       
    plot(x,y,'-+r',...
        'LineWidth',2,...
        'MarkerSize',10)

    if length(x)>2
         plot([x(end),x(1)],...
             [y(end),y(1)],'--g',...
        'LineWidth',2)
    end 
end