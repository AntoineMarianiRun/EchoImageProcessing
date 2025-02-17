function [area_] = getArea(Shape,coef)
% this function getArea ...
% return a float value in cm²
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

singlePixelArea_ = coef.x * coef.y;                                        % get the area of one pixel

nPix_ = sum(Shape(:));

area_ = singlePixelArea_ * nPix_;
end