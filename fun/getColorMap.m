function [row,col] = getColorMap(img)
% getColorMap to get the row and th column for color map

tf = isColor(img,70);

X = mean(tf)./max(mean(tf));
X = X>0.5;
[col] = getIndex(X);

Y = mean(tf,2)./max(mean(tf,2));
Y = Y>0.5;
[row] = getIndex(Y);
end

function [index] = getIndex(X)
nShape = 0;
for i = 1: length(X)-1
    if X(i) == 0 && X(i+1) ==1
        nShape = nShape+1;
        beginingShape(nShape) = i+1;
    end
    if X(i) == 1 && X(i+1) ==0 && nShape>0
        endShape(nShape) = i;
    end
end

if length(beginingShape)~=length(endShape)
    endShape = [endShape, length(X)];
end

lengthShape = endShape - beginingShape;

[~,i] = max(lengthShape);
if ~isnan(i)
    index = beginingShape(i):endShape(i);
else
    index = nan(1);
end
end
