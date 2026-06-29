                        %% Script test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get the the video and scale it
video =  uiGetVideo(); 

% video selected 
videoIndex = 1; % first video import
frameIndex = 1; % first frame to set the shape 

%% read the video
videoRead(video(videoIndex).frame,video(videoIndex).videoObject)           % read the video 

frameRead(video(videoIndex).frame,frameIndex)                              % show a sigle frame

%% show colorscale 
ShowColorScale(video(videoIndex).colorScale.colorScaleRGBuint8, ...
    video(videoIndex).colorScale.colorScaleValue)                          % show the color scale 

%% set a shape (in the shape is the pixels selected to perform the color
% comparaison)
% Shape = setCustumShape(video(videoIndex).frame{frameIndex});             % custum
% Shape = setSquareShape(video(videoIndex).frame{frameIndex});             % as a square 
% Shape = allShape(video(videoIndex).frame{frameIndex});                   % select all 
% Shape = setSquareShapeCm(video(videoIndex).frame{frameIndex}, ...
%     video(videoIndex).coef, ...
%     1);                                                                  % 1 cm square shape 
% [Shape] = setSquareShapeFixedCm(frame,coef,cmwidth,cmhight)

[Shape] = autoShape(video(videoIndex).frame{frameIndex}, ...
    video(videoIndex).coef);                                               % 1cm^2 on the middle of swe zone 

%% compare each pixel contains in the shape (for each SWE image) to the
results = colorCalculation(video(videoIndex).frame,...                     % frames 
    video(videoIndex).time.SWindex,...                                     % index of the swe images
    video(videoIndex).colorScale.colorScaleRGBdouble,...                   % colors of the scale 
    video(videoIndex).colorScale.colorScaleValue,...                       % values of the scale 
    video(videoIndex).coef,...                                             % scale value of the video dimension
    Shape,...                                                              % shape
    video(videoIndex).time.Bmode);                                         % time vecteur of the b mode

%% plots 
% time evolution 
figureShearTemporalEvolution(results)

% interestion value of an image
sweFrameIndex = 2;
figureFrameColorHistogram(video,videoIndex,sweFrameIndex,results)

%% save 
currentForder = cd;                                                        % current forlder 
cd(video(videoIndex).videoObject.Path)                                     % save in the video folder 
saveName = [video(videoIndex).name(1:end-4),'.mat'];                       % save name you can cahnge it 
save(saveName,"results",'-mat')                                            % save
cd(currentForder)                                                          % go backto the function folder 
disp(['results : ' , saveName,' is save in ', video(videoIndex).videoObject.Path])


%% compare each pixel contains in the shape (for each Bmode image) to a grey scale
% video(videoIndex).frame = video(videoIndex).frame(1:30);
% video(videoIndex).frame = video_remove_square(video(videoIndex).frame); % take time 
% video(videoIndex).videoObject.NumFrames = size(video(videoIndex).frame ,2);


Shape = setSquareShape(video(videoIndex).frame{frameIndex});               % as a square 
% displayShape(video(videoIndex).frame{1},Shape,0.4)

% video(videoIndex).time.SWindex = 1 : size(video(videoIndex).frame ,2);

frameindex = video(videoIndex).time.SWindex;                               % frameindex = 1 : video(videoIndex).videoObject.NumFrames;

[results] = greyCalculation(video(videoIndex).frame, ...
    frameindex, ...
    video(videoIndex).coef, ...
    Shape, ...
    video(videoIndex).time.Bmode);

results.pixValue{20}(results.pixValue{20}<=0) = NaN(1);

figureFrameGreyHistogram(20,results)

figureGreyTemporalEvolution(results)