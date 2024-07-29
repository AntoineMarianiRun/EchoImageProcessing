function [colorScaleRGBuint8,colorScaleRGBdouble] = getColorScale(selected_frame)
    % get scale position
    selected_frame = selected_frame(:,end-80:end,:);                       % aproximative localisation of the scale
    imgColor = isColor(selected_frame,75);                                 % get the color pix position
    idxX = floor(mean(find(sum(imgColor,1)>mean(sum(imgColor,1)))));       % x postion of the scale
    idxY = sum(imgColor,2)>mean(sum(imgColor,2));                    % y position of the scale
    
    % color scale output
    colorScaleRGBuint8 = flip(selected_frame(idxY,idxX,:));                       % scale in uint8 great to display
    colorScaleRGBdouble = [double(colorScaleRGBuint8(:,1,1)),double(colorScaleRGBuint8(:,1,2)),double(colorScaleRGBuint8(:,1,3))]; % scale in double better to pix compare
end