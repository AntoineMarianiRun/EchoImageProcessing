function [frames, video_object] = loadVideo(videoPath, fig)
% load_video Load video frames from a specified path.
%   [frames, video_object] = load_video(path) loads the video specified by
%   the given path and returns the frames in a cell array and the VideoReader
%   object.
%   [frames, video_object] = load_video(path, fig) uses the specified figure
%   handle for displaying the progress dialog.
%
%   Input:
%   - path: String or character vector specifying the path to the video file.
%   - fig (optional): Figure handle for displaying the progress dialog.
%
%   Output:
%   - frames: Cell array containing video frames.
%   - video_object: VideoReader object with video properties.

% Input verification
if ischar(videoPath)
    videoPath = string(videoPath);
elseif isstring(videoPath)
    if numel(videoPath) ~= 1
        error('Input must be a single path.');
    end
else
    error('Path must be a string or character vector.');
end

% % Handle optional figure input
if nargin < 2
    fig = uifigure('Name', 'Video Import Tool', 'Color', [1 1 1]);
    fig.Position(3:4) = [400 100];  % Width and height
    fig.WindowStyle = 'modal';      % Modal mode
end

% Create VideoReader object
videObject = VideoReader(videoPath);
video_object.Name = videObject.Name;
video_object.Path = videObject.Path;
video_object.Duration = videObject.Duration;
video_object.Width = videObject.Width;
video_object.Height = videObject.Height;
video_object.FrameRate = videObject.FrameRate;
video_object.BitsPerPixel = videObject.BitsPerPixel;
video_object.VideoFormat = videObject.VideoFormat;
video_object.NumFrames = round(video_object.Duration*video_object.FrameRate);


% Progress dialog
d = uiprogressdlg(fig, 'Title', 'Please Wait', 'Message', ['Loading video : ', video_object.Name]);

% Number of frames
numFrames = video_object.NumFrames;
frames = cell(1, numFrames);  % Initialize the cell array for storing frames


for current_frame = 1 : video_object.NumFrames
    try
        frames{current_frame} = read(videObject, current_frame);
        d.Value = current_frame / video_object.NumFrames;  % Update progress bar
    catch
        video_object.NumFrames = current_frame-1 ; 
    end
end



% Update progress dialog message
% d.Message = 'Finishing';
pause(0.3);

% Close the figure if it was created within the function
if nargin < 2
    close(fig);
end
end