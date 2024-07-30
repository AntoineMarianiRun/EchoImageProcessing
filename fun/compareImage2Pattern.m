function [errMatrix] = compareImage2Pattern(Img,patternImage)

lengthBox = size(patternImage,1);
errMatrix = ones(size(Img,1),size(Img,2));

for row = 1 : size(Img,1)
    for col = 1 : size(Img,2)
        temp = extractPattern(Img,row,col,lengthBox);
        if ~isnan(temp)
            errMatrix(row,col) =  comparaisonImage(temp,patternImage);
        end

    end
end
end