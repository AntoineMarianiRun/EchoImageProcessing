function [coef_x,coef_y] = scaleImage(frames)

% X axis
[X] = setAxis(frames,"horizontal");
nbPixX = abs(diff(X));
[coef_x] = pix2centimeter(nbPixX);

% Y axis
[Y] = setAxis(frames,"verical");
nbPixY = abs(diff(Y));
[coef_y] = pix2centimeter(nbPixY);

end