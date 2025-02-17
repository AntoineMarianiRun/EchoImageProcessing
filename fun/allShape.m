function [Shape] = allShape(frame)
% this function automaticlly select swe zone and return a true false matrix Shape
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize Shape 
[nRowFrame,nColFrame,~] = size(frame);
Shape = zeros(nRowFrame,nColFrame);

% get the position of the color map 
[row_,col_] = getColorMap(frame); 

% set true on shape 
Shape(row_,col_) = 1;
end