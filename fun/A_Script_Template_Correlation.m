                        %% Template matching correlation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% select echo video
video =  uiGetVideo();                                                     % get video and video information
videoIndex = 1;                                                            % first video selected 
selected_frame = video(videoIndex).frame{1};                               % first frame of the video 

%% set a template
    % set the template (heigth, width, position)
heigthBox = 57;                                                            % heigth of the template 
widthBox = 71;                                                             % width of the template 
[X,Y,templateImage] = setImageTemplate(selected_frame,heigthBox,widthBox); % set the template (set position: rigth mouse clic, clear mouse position : left clic, validate : enter) 
showTemplate(templateImage)                                                % show the template

%% 1/ template matching correlation on an image 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% warning on image selected ( n : heigthImage, m: widthImage ) this
% algorithm performence is O(n x m).

heigthImage = 501;
widthImage = 501;

Image_ = corpImageAsRectangle(selected_frame,X,Y,heigthImage,widthImage);  % image that you want to search on 

method = "Crop";                                                           % method for image border 
[errMatrix] = compareImage2Pattern(Image_,templateImage,method);           % template matching correlation 

[rowOffset,colOffset,~] = minError(errMatrix);                             % position and error 

% illustration 
plotErrorMartixAndImage(errMatrix,Image_)
plotHeatMapErrorMatrix(errMatrix)
plot3DErrorMatrix(errMatrix)

%% 2/ tracking process (template matching correlation on a video) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% warning on template drift set up ( n : nPixCol, m: nPixRow ) this
% algorithm performence is O(n x m).

frames = video(videoIndex).frame;                                          % images on which we perform the tracking
tempate = templateImage;                                                   % our template we search
row = Y;                                                                   % first position of the template 
col = X;                                                                   % first position of the template 
nPixCol = 31;                                                              % possible deplacement beatween each frame 
nPixRow = 21;                                                              % possible deplacement beatween each frame 
rateOfChange = 10;                                                         % Rate update of the template in number of frame (deformation of the medium) 

% options tracking 
opts.showHeatMap = "off";
opts.showTemplate = "off";
opts.progressBar = "on";

[row,col,minValue] = tracking(frames, ...
    tempate, ...
    row, ...
    col, ...
    nPixRow, ...
    nPixCol, ...
    rateOfChange, ...
    opts);                                                                 % tracking process

% exemple of tracking point and option
exTracked(1).row=row;
exTracked(1).col=col;
exTracked(1).color='r';
exTracked(1).marker='s';
exTracked(1).markerSize=6;

videoTrackingRead(frames, video.videoObject,exTracked)                     % show the tracking 


%% 3/  Muscle architecture exemple
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 3.1. set two markers for deep apponevroses, surface apponevroses and
    % muscle fiber
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.1.1 Deep apponevroses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deepApponevroses_1.X = 980;
deepApponevroses_1.Y = 594;
deepApponevroses_1.template = corpImageAsRectangle(selected_frame, ...
    deepApponevroses_1.X, ...
    deepApponevroses_1.Y, ...
    nPixRow, ...
    nPixCol);

deepApponevroses_2.X = 636;
deepApponevroses_2.Y = 659;
deepApponevroses_2.template = corpImageAsRectangle(selected_frame, ...
    deepApponevroses_2.X, ...
    deepApponevroses_2.Y, ...
    nPixRow, ...
    nPixCol);

% 3.1.2 Surface apponevroses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
surfaceApponevroses_1.X = 475;
surfaceApponevroses_1.Y = 285;
surfaceApponevroses_1.template = corpImageAsRectangle(selected_frame, ...
    surfaceApponevroses_1.X, ...
    surfaceApponevroses_1.Y, ...
    nPixRow, ...
    nPixCol);

surfaceApponevroses_2.X = 908;
surfaceApponevroses_2.Y = 270;
surfaceApponevroses_2.template = corpImageAsRectangle(selected_frame, ...
    surfaceApponevroses_2.X, ...
    surfaceApponevroses_2.Y, ...
    nPixRow, ...
    nPixCol);

% 3.1.3 Muscle fiber 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
muscleFibers_1.X = 551;
muscleFibers_1.Y = 390;
muscleFibers_1.template = corpImageAsRectangle(selected_frame, ...
    muscleFibers_1.X, ...
    muscleFibers_1.Y, ...
    51, ...
    51);

muscleFibers_2.X = 851;
muscleFibers_2.Y = 453;
muscleFibers_2.template = corpImageAsRectangle(selected_frame, ...
    muscleFibers_2.X, ...
    muscleFibers_2.Y, ...
    51, ...
    51);

% 3.1.4 Show selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure("Name","marker set","Color",[1 1 1])
image(selected_frame)
hold on 

plot(deepApponevroses_1.X,deepApponevroses_1.Y,'+g')
plot(deepApponevroses_2.X,deepApponevroses_2.Y,'+g')

plot(surfaceApponevroses_1.X,surfaceApponevroses_1.Y,'+y')
plot(surfaceApponevroses_2.X,surfaceApponevroses_2.Y,'+y')

plot(muscleFibers_1.X,muscleFibers_1.Y,'+r')
plot(muscleFibers_2.X,muscleFibers_2.Y,'+r')

    % 3.2. track each marker 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.2.1. set tracking options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opts.showHeatMap = "off";
opts.showTemplate = "off";
opts.progressBar = "on";

% Apponevroses
nPixRowApponevroses = 10;                                                  % possible deplacement beatween each frame 
nPixColApponevroses = 0;                                                   % possible deplacement beatween each frame 
rateOfChangeApponevroses = 10;                                             % Rate update of the template in number of frame (deformation of the medium) 

% Muscles
nPixRowMuscles = 20;                                                       % possible deplacement beatween each frame 
nPixColMuscles = 20;                                                       % possible deplacement beatween each frame 
rateOfChangeMuscles = 15;                                                  % Rate update of the template in number of frame (deformation of the medium) 

% 3.2.2. tracking 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[deepApponevroses_1.row,deepApponevroses_1.col,deepApponevroses_1.minValue] = tracking(frames, ...
    deepApponevroses_1.template, ...
    deepApponevroses_1.Y, ...
    deepApponevroses_1.X, ...
    nPixRowApponevroses,nPixColApponevroses,rateOfChangeApponevroses,...
    opts);

[deepApponevroses_2.row,deepApponevroses_2.col,deepApponevroses_2.minValue] = tracking(frames, ...
    deepApponevroses_2.template, ...
    deepApponevroses_2.Y, ...
    deepApponevroses_2.X, ...
    nPixRowApponevroses,nPixColApponevroses,rateOfChangeApponevroses,...
    opts);

[surfaceApponevroses_1.row,surfaceApponevroses_1.col,surfaceApponevroses_1.minValue] = tracking(frames, ...
    surfaceApponevroses_1.template, ...
    surfaceApponevroses_1.Y, ...
    surfaceApponevroses_1.X, ...
    nPixRowApponevroses,nPixColApponevroses,rateOfChangeApponevroses,...
    opts);

[surfaceApponevroses_2.row,surfaceApponevroses_2.col,surfaceApponevroses_2.minValue] = tracking(frames, ...
    surfaceApponevroses_2.template, ...
    surfaceApponevroses_2.Y, ...
    surfaceApponevroses_2.X, ...
    nPixRowApponevroses,nPixColApponevroses,rateOfChangeApponevroses,...
    opts);

[muscleFibers_1.row,muscleFibers_1.col,muscleFibers_1.minValue] = tracking(frames, ...
    muscleFibers_1.template, ...
    muscleFibers_1.Y, ...
    muscleFibers_1.X, ...
    nPixRowMuscles,nPixColMuscles,rateOfChangeMuscles,...
    opts);

[muscleFibers_2.row,muscleFibers_2.col,muscleFibers_2.minValue] = tracking(frames, ...
    muscleFibers_2.template, ...
    muscleFibers_2.Y, ...
    muscleFibers_2.X, ...
    nPixRowMuscles,nPixColMuscles,rateOfChangeMuscles,...
    opts);


    % 3.3. show tracking 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.3.1. marker and marker options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkrTracked(1).row=deepApponevroses_1.row;
mkrTracked(1).col=deepApponevroses_1.col;
mkrTracked(1).color='w';
mkrTracked(1).marker='+';
mkrTracked(1).markerSize=6;

mkrTracked(2).row=deepApponevroses_2.row;
mkrTracked(2).col=deepApponevroses_2.col;
mkrTracked(2).color='w';
mkrTracked(2).marker='+';
mkrTracked(2).markerSize=6;

mkrTracked(3).row=surfaceApponevroses_1.row;
mkrTracked(3).col=surfaceApponevroses_1.col;
mkrTracked(3).color='w';
mkrTracked(3).marker='+';
mkrTracked(3).markerSize=6;

mkrTracked(4).row=surfaceApponevroses_2.row;
mkrTracked(4).col=surfaceApponevroses_2.col;
mkrTracked(4).color='w';
mkrTracked(4).marker='+';
mkrTracked(4).markerSize=6;

mkrTracked(5).row=muscleFibers_1.row;
mkrTracked(5).col=muscleFibers_1.col;
mkrTracked(5).color='r';
mkrTracked(5).marker='+';
mkrTracked(5).markerSize=6;

mkrTracked(6).row=muscleFibers_2.row;
mkrTracked(6).col=muscleFibers_2.col;
mkrTracked(6).color='r';
mkrTracked(6).marker='+';
mkrTracked(6).markerSize=6;

% 3.3.2. display tracking 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
videoTrackingRead(frames, video.videoObject,mkrTracked)

% 3.3.3. consider stucture as line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[deepApponevroses_fun] = linearInteroplation(deepApponevroses_1,deepApponevroses_2);
[surfaceApponevroses_fun] = linearInteroplation(surfaceApponevroses_1,surfaceApponevroses_2);
[muscleFibers_fun] = linearInteroplation(muscleFibers_1,muscleFibers_2);


% 3.3.4. find intersection between fiber and apponevroses 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1 : length([deepApponevroses_fun.a])
    [intersect_1.col(i), intersect_1.row(i)] = intersectionLinear(deepApponevroses_fun(i).a, ...
        deepApponevroses_fun(i).b, ...
        muscleFibers_fun(i).a, ...
        muscleFibers_fun(i).b);
    [intersect_2.col(i), intersect_2.row(i)] = intersectionLinear(surfaceApponevroses_fun(i).a, ...
        surfaceApponevroses_fun(i).b, ...
        muscleFibers_fun(i).a, ...
        muscleFibers_fun(i).b);
end

mkrTracked(7).row=intersect_1.row;
mkrTracked(7).col=intersect_1.col;
mkrTracked(7).color='y';
mkrTracked(7).marker='s';
mkrTracked(7).markerSize=8;

mkrTracked(8).row=intersect_2.row;
mkrTracked(8).col=intersect_2.col;
mkrTracked(8).color='y';
mkrTracked(8).marker='s';
mkrTracked(8).markerSize=8;

videoTrackingRead(frames, video.videoObject,mkrTracked)

% 3.3.4.  plot results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
funTracked(1).fun = deepApponevroses_fun;
funTracked(1).limInf = min([intersect_1.col;intersect_2.col]);
funTracked(1).limSup = max([intersect_1.col;intersect_2.col]);
funTracked(1).color='w';
funTracked(1).lineStyle='-.';
funTracked(1).lineWidth=2;

funTracked(2).fun = surfaceApponevroses_fun;
funTracked(2).limInf = min([intersect_1.col;intersect_2.col]);
funTracked(2).limSup = max([intersect_1.col;intersect_2.col]);
funTracked(2).color='w';
funTracked(2).lineStyle='-.';
funTracked(2).lineWidth=2;

funTracked(3).fun = muscleFibers_fun;
funTracked(3).limInf = min([intersect_1.col;intersect_2.col]);
funTracked(3).limSup = max([intersect_1.col;intersect_2.col]);
funTracked(3).color='r';
funTracked(3).lineStyle='-';
funTracked(3).lineWidth=2;

videoTrackingRead(frames, video.videoObject,mkrTracked,funTracked)


% 3.3.5. caluculate fiber length 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[intersect_1.xPosition,intersect_1.yPosition] = convertPixPosition(intersect_1,video(videoIndex).coef);
[intersect_2.xPosition,intersect_2.yPosition] = convertPixPosition(intersect_2,video(videoIndex).coef);

[fiberLength] = distanceBetween(intersect_1.xPosition,...
    intersect_1.yPosition,...
    intersect_2.xPosition,...
    intersect_2.yPosition);

figure 
plot(video(videoIndex).time.Bmode,fiberLength)
xlabel('Time (s)')
ylabel('Fiber length (cm)')