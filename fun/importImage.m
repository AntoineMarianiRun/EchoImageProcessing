function image_ = importImage(imagePath,imageName,fig)
if ischar(imagePath)
    imagePath = string(imagePath);
end

if length(imagePath)<=2
    if nargin == 2
        frames{1} = imread(imagePath); % get frame and video information
    elseif nargin == 3
        d = uiprogressdlg(fig, 'Title', 'Please Wait', 'Message', ['Loading image : ', imageName]);
        d.Value = 0;  % Update progress bar
        frames{1} = imread(imagePath); % get frame and video information
        pause(0.1)
        d.Value = 1;  % Update progress bar
    end

    [coef_x,coef_y] = scaleImage(frames);% video scaling
    time = 0; 
    
    image_.name = imageName;
    image_.path = imagePath;
    image_.videoObject = nan(1);
    image_.frame = frames;
    image_.coef.x = coef_x;
    image_.coef.y = coef_y;
    image_.time.Bmode = time;


    opts.Interpreter = 'tex'; opts.Default = 'Yes'; %option
    dlg = questdlg('is the images contains color map?',...
        'echo type',...
        "Yes","No",opts);
    if strcmpi(string(dlg),"Yes")
        tempfig = figure("Name","image","Color", [1 1 1]);
        image(image_.frame{1});
        xticks([])
        yticks([])

        [image_.colorScale.colorScaleRGBuint8,...
            image_.colorScale.colorScaleRGBdouble,...
            image_.colorScale.colorScaleValue] = setColorScale(frames{1});
        image_.time.SWE = image_.time.Bmode;
        image_.time.SWindex = 1;
        
        close(tempfig)
    elseif strcmpi(string(dlg),"No")
        image_.colorScale = "None"; 
    end
else
    error('the function "importVideo" must have a single path in imput')
end
end