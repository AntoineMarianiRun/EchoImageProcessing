function [coef_x,coef_y] = scale_image(frames)

% X axis
[X] = set_axis(frames,"horizontal");
nbPixX = abs(diff(X));
[coef_x] = pix2centimeter(nbPixX);

% Y axis
[Y] = set_axis(frames,"verical");
nbPixY = abs(diff(Y));
[coef_y] = pix2centimeter(nbPixY);

end