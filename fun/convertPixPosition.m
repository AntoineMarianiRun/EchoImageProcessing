function [xPosition,yPosition] = convertPixPosition(mkrTracked,coef)
%convertPixPosition from the position in the image in pix to the positon in
%centimeter
% mkrTracked is the marker 
% coef : coef of the video
xPosition = mkrTracked.col .* coef.x;
yPosition = mkrTracked.row .* coef.y;
end