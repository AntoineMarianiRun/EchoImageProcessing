function [results] = colorCalculation(frame,frameindex,colorScaleRGBdouble,colorScaleValue,coef,Shape,timeBmode)
compt = 0 ;
fig =  uifigure("Name","SWE colormap process","Color",[1 1 1]);
fig.Position(3:4) =  [400,130];

d = uiprogressdlg(fig,'Title','Please Wait',...
    'Message','Process');
pause(.5)

% initialisation
%%%%%%%%%%%%%%%%%%%
n = size(frame,2); % Taille des vecteurs

results.pixValue = cell(1, n);
results.time = timeBmode;
results.frameIndex = frameindex;
results.meanValueYoungModulus = nan(1, n);
results.stdValueYoungModulus = nan(1, n);
results.meanValueShearVelocity = nan(1, n);
results.stdValueShearVelocity = nan(1, n);
results.meanValue = nan(1, n);
results.stdValue = nan(1, n);
results.voidPercent = nan(1, n);
results.saturationPercent = nan(1, n);
results.nbPixel = nan(1, n);
results.ROIsize = nan(1, n);


for currentFrame = frameindex
    [resultsFrame] = frameColorCalculation(frame{currentFrame},colorScaleRGBdouble,colorScaleValue,coef,Shape);
    results.pixValue{currentFrame} = resultsFrame.pixValue;
    results.meanValueShearModulus(currentFrame) = resultsFrame.meanValueShearModulus;
    results.stdValueShearModulus(currentFrame) = resultsFrame.stdValueShearModulus;
    results.voidPercent(currentFrame) = resultsFrame.voidPercent;
    results.saturationPercent(currentFrame) = resultsFrame.saturationPercent;
    results.nbPixel(currentFrame) = resultsFrame.nbPixel;
    results.ROIsize(currentFrame) = resultsFrame.ROIsize;
    results.meanValueYoungModulus(currentFrame) = resultsFrame.meanValueYoungModulus;
    results.stdValueYoungModulus(currentFrame) = resultsFrame.stdValueYoungModulus;
    results.meanValueShearVelocity(currentFrame) = resultsFrame.meanValueShearVelocity;
    results.stdValueShearVelocity(currentFrame) = resultsFrame.stdValueShearVelocity;

    % progress
    compt = compt+1;
    d.Value = compt / length(frameindex);
    pause(.1)
end
close(fig)
end