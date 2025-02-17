function [coef_x,coef_y] = scaleImage(frames)

% X axis
[X,fig] = setAxis(frames,"horizontal");
nbPixX = abs(diff(X));
[coef_x] = pix2centimeter(nbPixX);
delete(fig)

% Y axis
[Y,fig] = setAxis(frames,"verical");
nbPixY = abs(diff(Y));
[coef_y] = pix2centimeter(nbPixY);
delete(fig)

end