function [frameResults] = frameColorCalculation(img,colorScaleRGBdouble,colorScaleValue,coef,Shape)
compt = 0;
nPixCol_ = sum(sum(Shape)~=0);
nPixRow_ = sum(sum(Shape,2)~=0);

results = nan(1,sum(Shape,'all'));
for row = 1 : size(Shape,1)
    for col = 1 : size(Shape,2)
        if Shape(row,col) == 1                                             % if the pix is in the shape
            compt = compt + 1;                                             % current pix
            currentPix = img(row,col,:);                                   % RGB valeur of the pix
            [value,colorErr,greyErr] = pixColor2Numeric(currentPix,colorScaleRGBdouble,colorScaleValue); % comparason to the color scale
            if colorErr<greyErr                                            % closer to grey than the scale
                results(compt)=value;
            end
        end
    end
end
frameResults.pixValue = results;                                           % all pix
frameResults.meanValueShearModulus = mean(results(~isnan(results)));       % shear modulus (kPa) : mean
frameResults.stdValueShearModulus = std(results(~isnan(results)));         % shear modulus (kPa) : standard deviation
frameResults.meanValueYoungModulus = frameResults.meanValueShearModulus.*3;% young modulus (kPa) : mean
frameResults.stdValueYoungModulus = frameResults.stdValueShearModulus.*3;  % young modulus (kPa) : standard deviation
frameResults.meanValueShearVelocity = sqrt(frameResults.meanValueShearModulus);% shear velocity (m/s) : mean
frameResults.stdValueShearVelocity = sqrt(frameResults.stdValueShearModulus);          % shear velocity (m/s) : standard deviation


frameResults.voidPercent = (sum(isnan(results))/compt)*100;        % void
frameResults.saturationPercent = (sum((results==max(colorScaleValue)))/compt)*100; % saturation
frameResults.nbPixel = compt;                                      % number of pixel
frameResults.ROIsize = (nPixCol_ *coef.x)*(nPixRow_*coef.y);                                      % number of pixel
end