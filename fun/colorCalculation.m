function [results] = colorCalculation(frame,frameindex,colorScaleRGBdouble,colorScaleValue,coef,Shape)
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
results.frameIndex = frameindex;
results.meanValue = nan(1, n);
results.stdValue = nan(1, n);
results.voidPercent = nan(1, n);
results.saturationPercent = nan(1, n);
results.nbPixel = nan(1, n);
results.ROIsize = nan(1, n);

for currentFrame = frameindex
    [resultsFrame] = frameColorCalculation(frame{currentFrame},colorScaleRGBdouble,colorScaleValue,coef,Shape);
    results.pixValue{currentFrame} = resultsFrame.pixValue;
    results.meanValue(currentFrame) = resultsFrame.meanValue;
    results.stdValue(currentFrame) = resultsFrame.stdValue;
    results.voidPercent(currentFrame) = resultsFrame.voidPercent;
    results.saturationPercent(currentFrame) = resultsFrame.saturationPercent;
    results.nbPixel(currentFrame) = resultsFrame.nbPixel;
    results.ROIsize(currentFrame) = resultsFrame.ROIsize;

    % progress
    compt = compt+1;
    d.Value = compt / length(frameindex);
    pause(.1)
end
close(fig)
end