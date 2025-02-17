function [Shape] = setSquareShapeCm(frame,coef,cm)
% this function automaticlly select a square shape in the midlle of the swe
% zone of on cm^2 and return a true false matrix Shape
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize Shape 
[nRowFrame,nColFrame,~] = size(frame);
Shape = zeros(nRowFrame,nColFrame);

% size of zone of interest in pix 
nPixCol_ = round(round(1/coef.x) * cm);
nPixRow_ = round(round(1/coef.y)* cm);

% get the position of the color map 
[col_,row_] = setOneCmBox(frame,nPixCol_,nPixRow_);

% get the ceter of colormap
rowCenter_ = floor(mean(row_));
colCenter_ = floor(mean(col_));

% get the index of the top left corner of the shape 
startCol_ = floor(colCenter_ - (nPixCol_/2));
startRow_ = floor(rowCenter_ - (nPixRow_/2));

% get the index of the bottom rigth corner of the shape 
endCol_ = startCol_ + nPixCol_-1;
endRow_ = startRow_ + nPixRow_-1;

% index of the zone of interest 
indexCol_ = startCol_ : endCol_;
indexRow_ = startRow_ : endRow_;

% set true on shape 
Shape(indexRow_,indexCol_) = 1; % displayShape(frame,Shape)
end