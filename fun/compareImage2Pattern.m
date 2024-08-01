function [errMatrix] = compareImage2Pattern(Img,patternImage,method)

if nargin < 3
    method = "Include"; % default method
end

lengthBox = size(patternImage,1);
errMatrix = nan(size(Img,2),size(Img,1));

if method == "Include"
    lengthBorder = 0;
elseif method == "Crop"
    lengthBorder = floor(lengthBox/2);
else 
    error('method enable: %s', method);
end





for row = 1+lengthBorder : size(Img,2)
    for col = 1+lengthBorder : size(Img,1)
        temp = extractPattern(Img,row,col,lengthBox);
        if ~isnan(temp)
            errMatrix(row,col) =  comparaisonImage(temp,patternImage);
        end
    end
end

errMatrix = errMatrix'; % transpose for representation 

end