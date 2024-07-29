function [colorScaleRGBuint8,colorScaleRGBdouble,colorScaleValue] = setColorScale(img)
    [colorScaleRGBuint8,colorScaleRGBdouble] = getColorScale(img);     % get the scale color
    [colorScaleValue] = setColorscaleValue(colorScaleRGBuint8,...
        colorScaleRGBdouble);                                          % get the corresponding value
end