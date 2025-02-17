function [value,colorErr,greyErr] = pixColor2Numeric(pix,colorScaleRGBdouble,colorScaleValue)
    grayScale = repmat((0 : 255)',[1,3]);
    pix = [double(pix(1,1,1)),double(pix(1,1,2)),double(pix(1,1,3))];  % pix as a double variable (RGB)
    
    colorErrFun = sum(abs((pix-colorScaleRGBdouble)),2);                    % cost fun
    greyErrFun = sum(abs((pix-grayScale)),2);                               % cost fun
    
    [colorErr,idx] = min(colorErrFun);                                 % minimale error
    [greyErr,~] = min(greyErrFun);                                     % minimale error
    
    value = colorScaleValue(idx);                                      % associeted value
end