function [errMatrix] = compareImage2Pattern(Img,patternImage,method)

if nargin < 3
    method = "Include"; % default method
end

heigthBox = size(patternImage,1);
widthBox = size(patternImage,2);

errMatrix = nan(size(Img,1),size(Img,2));

% method
if method == "Include"
    lengthBorderHeigth = 0;
    lengthBorderwidth = 0;
elseif method == "Crop"
    lengthBorderHeigth = floor(heigthBox/2);
    lengthBorderwidth = floor(widthBox/2);
else 
    error('method enable: %s', method);
end

% compare 
for col = 1+lengthBorderwidth : size(Img,2)-lengthBorderwidth 
    for row = 1+lengthBorderHeigth : size(Img,1)-lengthBorderHeigth
        temp = corpImageAsRectangle(Img,col,row,heigthBox,widthBox);
        if ~isnan(temp)
            errMatrix(row,col) = comparaisonImage(temp,patternImage);
        end
    end
end

end