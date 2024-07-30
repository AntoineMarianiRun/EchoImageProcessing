function patternImage = extractPattern(selected_frame,X,Y,lengthBox)
% set the box 
cornerX = min(X)-floor(lengthBox/2);
cornerY = min(Y)-floor(lengthBox/2);
boxLengthX = lengthBox-1;
boxLengthY = lengthBox-1;

try
    [patternImage] = selected_frame(cornerY:cornerY+boxLengthY,...
        cornerX:cornerX+boxLengthX, ...
        :);
catch
    patternImage = nan(lengthBox);
end
end