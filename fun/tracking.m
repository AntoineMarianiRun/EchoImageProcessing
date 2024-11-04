function [row,col,minValue] = tracking(frames,template,currentTemplateRow,currentTemplateCol,nPixRow,nPixCol,rateOfChange,opts)
% defoaut options
defaultOpts.showHeatMap = "off";
defaultOpts.showTemplate = "off";
defaultOpts.progressBar = "off";
defaultOpts.maxError = 1;
defaultOpts.rateOfDisplay = 5;

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

figTracking = figure('Name','Show tracking','Color',[1 1 1]);




compt = 1;
nbFrames = numel(frames);
method = "Crop";
    % size of the zone of interest
nTemplateRow = size(template,1);
nTemplateCol = size(template,2);
heigthBox = 2*nPixRow + nTemplateRow;
widthBox = 2*nPixCol + nTemplateCol;

if mod(nTemplateRow,2)~=1 && mod(nTemplateCol,2)~=1
    error('error in function tracking template size must have a odd heigth and odd width')
end

    % intitialize 
row = nan(1,nbFrames);
col = nan(1,nbFrames);
minValue = nan(1,nbFrames);
col(1) = currentTemplateCol;
row(1) = currentTemplateRow;




for currentFrame = 1 : nbFrames
    currentImage = frames{currentFrame};


    if currentFrame == 1
        currentZoneOfInterest = corpImageAsRectangle(currentImage, ...         % curent image to analyse
            currentTemplateCol, ...                                            % previous position
            currentTemplateRow, ...                                             % previous position
            heigthBox,widthBox);                                               % zone of intest size
    else
        currentZoneOfInterest = corpImageAsRectangle(currentImage, ...         % curent image to analyse
            col(currentFrame-1) , ...                                            % previous position
            row(currentFrame-1), ...                                             % previous position
            heigthBox,widthBox);                                               % zone of intest size
    end
    errMatrix = compareImage2Pattern(currentZoneOfInterest,template,method);        % pattern matching 
    [currentError,rowOffset,colOffset] = minError(errMatrix);  

    if currentError >  opts.maxError
        [col(currentFrame),row(currentFrame),template] = setImageTemplate(frames{currentFrame},nTemplateRow,nTemplateCol); % set the template (set position: rigth mouse clic, clear mouse position : left clic, validate : enter)
    else 
        if currentFrame == 1
            if ~isnan(currentError)
                minValue(currentFrame) = currentError;
                col(currentFrame) = col(currentFrame) + colOffset;
                row(currentFrame) = row(currentFrame) + rowOffset;
            else
                minValue(currentFrame) = 1;
                col(currentFrame) = col(currentFrame);
                row(currentFrame) = row(currentFrame);
            end
        else
            if ~isnan(currentError)
                minValue(currentFrame) = currentError;
                col(currentFrame) = col(currentFrame-1) + colOffset;
                row(currentFrame) = row(currentFrame-1) + rowOffset;
            else
                minValue(currentFrame) = 1;
                col(currentFrame) = col(currentFrame-1);
                row(currentFrame) = row(currentFrame-1);
            end                                       % zone of intest size
        end
    end


    if mod(currentFrame,opts.rateOfDisplay) == 1
        [figTracking] = upDateAxes(figTracking,frames{currentFrame},row,col,nTemplateRow/2,nTemplateCol/2,currentFrame,nbFrames);
    end



    % change 
    if compt == rateOfChange
       compt = 0;
       
       template = corpImageAsRectangle(currentImage, ...
           col(currentFrame), ...
           row(currentFrame), ...
           nTemplateRow, ...
           nTemplateCol);

       % options
       if opts.showHeatMap == "on"
           plotErrorMartixAndImage(errMatrix,currentZoneOfInterest)
           title(['heat map frame : ', num2str(currentFrame)])
       end

       if opts.showTemplate == "on"
           showTemplate(template)
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


function [fig] = upDateAxes(fig,current_frame,currentTemplateRow,currentTemplateCol,nPixRow,nPixCol,numFrames,numFramesMax)
    clf(fig)
    
    im = axes('Parent', fig, 'Position', [0 0 1 .95]);
    hold (im,'on')

    im = drawBoxCorner(im,current_frame, ...
        [currentTemplateCol(numFrames)-nPixCol , currentTemplateCol(numFrames)+nPixCol ], ...
        [currentTemplateRow(numFrames)-nPixRow , currentTemplateRow(numFrames)+nPixRow ]);

    plot(im,currentTemplateCol(numFrames),currentTemplateRow(numFrames),'+r');

    plot (im, currentTemplateCol,currentTemplateRow, '-g','LineWidth',1.5)
    title(im,['Frame n°', num2str(numFrames),'/',num2str(numFramesMax)])
    fig.WindowStyle = 'modal';
    fig.WindowStyle = 'normal';
end 