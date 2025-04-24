function [colorScaleRGBuint8,colorScaleRGBdouble,colorScaleValue] = setColorScale(img)
try
    [colorScaleRGBuint8,colorScaleRGBdouble] = getColorScale(img);     % get the scale color
catch Me
    disp('Color scale not found, default coloscale set on')
    [colorScaleRGBuint8,colorScaleRGBdouble] = getDefaultColorScale();     % get the scale color

end
    [colorScaleValue] = setColorscaleValue(colorScaleRGBuint8,...
        colorScaleRGBdouble);                                          % get the corresponding value
end