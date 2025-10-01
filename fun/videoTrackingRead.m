function videoTrackingRead(frames, video_object,mkrTracked,funTracked)
% video_read Play video frames in a figure window.
%   video_read(frames, video_object) plays the video frames stored in the
%   cell array 'frames' using the properties of 'video_object'.
%
%   Input:
%   - frames: Cell array containing video frames.
%   - video_object: VideoReader object with video properties.
%   - mkrTracked: VideoReader object with video properties.

if nargin <3
    nMkr = 0;
    nFun = 0 ; 
elseif nargin<4
    nMkr = size(mkrTracked,2);
    nFun = 0 ; 
else 
    nMkr = size(mkrTracked,2);
    nFun = size(funTracked,2) ; 
end

% Create a figure window for video playback
fig = figure('Name', 'Video Playback', 'Color', [1 1 1],...
    'ToolBar', 'none', 'MenuBar', 'none');

% Calculate frame rate
frameRate = 1 / video_object.FrameRate;

% Loop through frames and display them
for current_frame = 1 : 2 : video_object.NumFrames
    tic;
    % Display the current frame
    im = axes('Parent', fig, 'Position', [0 0 1 1]);
    % Clear the axes for the next frame
    cla(im);
    image(frames{current_frame}, 'Parent', im);
    set(im, 'Layer', 'top', 'XTick', [], 'YTick', []);
    hold on 
    for mkr = 1 : nMkr
        plot(mkrTracked(mkr).col(current_frame), ...
            mkrTracked(mkr).row(current_frame), ...
            "Color",mkrTracked(mkr).color, ...
            "Marker",mkrTracked(mkr).marker, ...
            "MarkerSize",mkrTracked(mkr).markerSize)
    end 
    
    for fun = 1 : nFun
        plot( [funTracked(fun).limInf(current_frame), funTracked(fun).limSup(current_frame)],...            ...
            [funTracked(fun).fun(current_frame).frame(funTracked(fun).limInf(current_frame)), ...
            funTracked(fun).fun(current_frame).frame(funTracked(fun).limSup(current_frame))],...
            "Color",funTracked(fun).color, ...
            "LineStyle",funTracked(fun).lineStyle, ...
            "LineWidth",funTracked(fun).lineWidth)
    end

    % Calculate wait time to maintain frame rate
    elapsedTime = toc;
    waitTime = frameRate - elapsedTime;
    if waitTime > 0.01
        pause(waitTime);
    end
end

% Close the figure window after playback
% close(fig);
end
