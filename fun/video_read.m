function video_read(frames, video_object)
% video_read Play video frames in a figure window.
%   video_read(frames, video_object) plays the video frames stored in the
%   cell array 'frames' using the properties of 'video_object'.
%
%   Input:
%   - frames: Cell array containing video frames.
%   - video_object: VideoReader object with video properties.

% Create a figure window for video playback
fig = figure('Name', 'Video Playback', 'Color', [1 1 1], ...
    'ToolBar', 'none', 'MenuBar', 'none');

% Calculate frame rate
frameRate = 1 / video_object.FrameRate;

% Loop through frames and display them
for current_frame = 1 : 2 : video_object.NumFrames
    tic;

    % Display the current frame
    im = axes('Parent', fig, 'Position', [0 0 1 1]);
    image(frames{current_frame}, 'Parent', im);
    set(im, 'Layer', 'top', 'XTick', [], 'YTick', []);

    % Calculate wait time to maintain frame rate
    waitTime = frameRate - elapsedTime;
    if waitTime > 0.01
        pause(waitTime);
    end

    % Clear the axes for the next frame
    cla(im);
end

% Close the figure window after playback
close(fig);
end
