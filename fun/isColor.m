function [colorPixels] = isColor(img,Err)
if nargin == 1
    Err = 10;
end
grayScale = repmat((0 : 255)',[1,3]);
colorPixels = nan(size(img,1),size(img,2));
% comar
for X  = 1 : size(img,1)
    for Y = 1 : size(img,2)
        currentPix = double([img(X,Y,1),img(X,Y,2),img(X,Y,3)]) ;  % current pixel [R,G,B]
        ErrPix = sum(abs(currentPix- grayScale),2);                % abs error
        colorPixels(X,Y) = sum(ErrPix<Err)<1;
    end
end
end