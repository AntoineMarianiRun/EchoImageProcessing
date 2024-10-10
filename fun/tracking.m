function [row,col,minValue] = tracking(frames,template,currentTemplateRow,currentTemplateCol,nPixRow,nPixCol,rateOfChange,opts)
% defoaut options
defaultOpts.showHeatMap = "off";
defaultOpts.showTemplate = "off";
defaultOpts.progressBar = "off";


% check option 
if nargin > 7
    % do nothing
else
    opts = struct();  % Si aucune option n'est fournie
end
% option select 
opts = mergeOptions(defaultOpts, opts);

% progress bar
if opts.progressBar == "on"
    fig = uifigure('Name', 'Progress');
    fig.Color =  [1 1 1];
    fig.Position(3:4) =  [400 110]; %  w h
    fig.WindowStyle ="modal";
    d = uiprogressdlg(fig, 'Title', 'Please Wait', 'Message', 'Tracking progress');
end




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
        currentTemplateCol, ...                                            % previous position 
        currentTemplateRow, ...                                            % previous position 
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


    % change 
    if compt == rateOfChange
       compt = 0;
       currentTemplateRow = row(currentFrame);
       currentTemplateCol = col(currentFrame);
       
       template = corpImageAsRectangle(currentImage, ...
           currentTemplateCol, ...
           currentTemplateRow, ...
           nTemplateRow, ...
           nTemplateCol);

       % options
       if opts.showHeatMap == "on"
           plotErrorMartixAndImage(errMatrix,currentZoneOfInterest)
           title(['heat map frame : ', num2str(currentFrame)])
       end

       if opts.showTemplate == "on"
           figure('Name','template update', 'color',[1 1 1])
           image(template)
           title(['template frame : ', num2str(currentFrame)])
       end
    end
    compt = compt + 1;
    if opts.progressBar == "on" && mod(currentFrame,10)==1
        d.Value = currentFrame / nbFrames;  % Update progress bar
        pause(0.1)
    end
end


if opts.progressBar == "on"
    fig.WindowStyle ="normal";
    close(fig)
end

end



function opts = mergeOptions(defaultOpts, userOpts)
    opts = defaultOpts;
    fields = fieldnames(userOpts);
    for i = 1:length(fields)
        if isfield(defaultOpts, fields{i})
            opts.(fields{i}) = userOpts.(fields{i});
        else
            warning(['Option ', fields{i}, ' unknown.']);
        end
    end
end