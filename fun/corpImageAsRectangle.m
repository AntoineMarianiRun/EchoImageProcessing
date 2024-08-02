function patternImage = corpImageAsRectangle(selected_frame,X,Y,heigthBox,widthBox)
% set the box 
cornerX = min(X)-floor(widthBox/2);
cornerY = min(Y)-floor(heigthBox/2);
boxLengthX = widthBox-1;
boxLengthY = heigthBox-1;

try
    [patternImage] = selected_frame(cornerY:cornerY+boxLengthY,...
        cornerX:cornerX+boxLengthX, ...
        :);
catch
    patternImage = nan(heigthBox,widthBox);
end
end