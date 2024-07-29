function [frameResults] = frameColorCalculation(img,colorScaleRGBdouble,colorScaleValue,coef,Shape)
compt = 0;
results = nan(1,sum(Shape,'all'));
for row = 1 : size(Shape,1)
    for col = 1 : size(Shape,2)
        if Shape(row,col) == 1                               % if the pix is in the shape
            compt = compt + 1;                                 % current pix
            currentPix = img(row,col,:);                       % RGB valeur of the pix
            [value,colorErr,greyErr] = pixColor2Numeric(currentPix,colorScaleRGBdouble,colorScaleValue); % comparason to the color scale
            if colorErr<greyErr                                % closer to grey than the scale
                results(compt)=value;
            end
        end
    end
end
frameResults.pixValue = results;                                   % all pix
frameResults.meanValue = mean(results(~isnan(results)));           % mean value
frameResults.stdValue = std(results(~isnan(results)));             % standard deviation
frameResults.voidPercent = (sum(isnan(results))/compt)*100;        % void
frameResults.saturationPercent = (sum((results==max(colorScaleValue)))/compt)*100; % saturation
frameResults.nbPixel = compt;                                      % number of pixel
frameResults.ROIsize = compt *coef.x*coef.y;                                      % number of pixel
end