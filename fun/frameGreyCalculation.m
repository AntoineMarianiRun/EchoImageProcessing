function [frameResults] = frameGreyCalculation(img,greyScaleRGBdouble,greyScaleValue,coef,Shape)
if isempty(greyScaleRGBdouble) && isempty(greyScaleValue)
    % do nothing 
else 
   disp('greyScale not done yet') 
end

compt = 0;
nPixCol_ = sum(sum(Shape)~=0);
nPixRow_ = sum(sum(Shape,2)~=0);

results = nan(1,sum(Shape,'all'));
for row = 1 : size(Shape,1)
    for col = 1 : size(Shape,2)
        if Shape(row,col) == 1                                             % if the pix is in the shape
            compt = compt + 1;                                             % current pix
            currentPix = img(row,col,:);                                   % RGB valeur of the pix
            [trueFalse] = isColor(currentPix,10);
            if trueFalse == 0
                results(compt) = mean(currentPix,'all')/255;
            end
        end
    end
end
frameResults.pixValue = results;                                           % all pix
frameResults.meanValue = mean(results(~isnan(results)));                   % mean value
frameResults.stdValue = std(results(~isnan(results)));                     % standard deviation
frameResults.voidPercent = (sum(isnan(results))/compt)*100;                % void
frameResults.saturationPercent = (sum((results==1))/compt)*100;            % saturation
frameResults.nbPixel = compt;                                              % number of pixel
frameResults.ROIsize = (nPixCol_ *coef.x)*(nPixRow_*coef.y);               % number of pixel
end