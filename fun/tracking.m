function [row,col,minValue] = tracking(frames,template,currentTemplateRow,currentTemplateCol,nPixRow,nPixCol,rateOfChange)
compt = 1;
nbFrames = numel(frames);
method = "Crop";
    % size of the zone of interest
nTemplateRow = size(template,1);
nTemplateCol = size(template,2);
heigthBox = 2*nPixRow + nTemplateRow;
widthBox = 2*nPixCol + nTemplateCol;

if mod(length(heigthBox),2)~=1 && mod(length(widthBox),2)~=1
    error('error in function tracking')
end

    % intitialize 
row = nan(1,nbFrames);
col = nan(1,nbFrames);
minValue = nan(1,nbFrames);


for currentFrame = 1 : nbFrames
    currentImage = frames{currentFrame};
    currentZoneOfInterest = corpImageAsRectangle(currentImage, ...         % curent image to analyse 
        currentTemplateCol, ...                                           % previous position 
        currentTemplateRow, ...                                           % previous position 
        heigthBox,widthBox);                                               % zone of intest size

    errMatrix = compareImage2Pattern(currentZoneOfInterest,template,method);        % pattern matching 
    [currentError,rowOffset,colOffset] = minError(errMatrix);    
    
    
    if ~isnan(currentError)
        minValue(currentFrame) = currentError;
        col(currentFrame) = currentTemplateCol + colOffset;
        row(currentFrame) = currentTemplateRow + rowOffset;
    else
        minValue(currentFrame) = 1;
        col(currentFrame) = col(currentFrame-1);
        row(currentFrame) = row(currentFrame-1);
    end



    if compt == rateOfChange
       compt = 0;
       currentTemplateRow = row(currentFrame);
       currentTemplateCol = col(currentFrame);
       
       template = corpImageAsRectangle(currentImage, ...
           currentTemplateCol, ...
           currentTemplateRow, ...
           nTemplateRow, ...
           nTemplateCol);
    
%        plotErrorMartixAndImage(errMatrix,currentZoneOfInterest)
%        pause(.2)
%        close(gcf)
    end
    compt = compt + 1;
    
end
end