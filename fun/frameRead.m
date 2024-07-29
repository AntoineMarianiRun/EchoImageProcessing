%% frame_read (AM : 24/01/2023)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function frameRead(frames, frame_number)
% frame_read Display a specific frame from the video.
%   frame_read(frames, frame_number) displays the specified frame from
%   the cell array 'frames'.
%
%   Input:
%   - frames: Cell array containing video frames.
%   - frame_number: Integer specifying the frame to display.

% Validate input
if ~iscell(frames)
    error('The first input must be a cell array of frames.');
end

if ~isscalar(frame_number) || frame_number <= 0 || frame_number > numel(frames)
    error('Frame number must be a valid integer within the range of the frames array.');
end

% Create a figure window for displaying the frame
fig = figure('Name', 'Frame Playback', 'Color', [1 1 1], ...
    'ToolBar', 'none', 'MenuBar', 'none');

% Display the specified frame
im = axes('Parent', fig, 'Position', [0 0 1 1]);
image(frames{frame_number}, 'Parent', im);
set(im, 'Layer', 'top', 'XTick', [], 'YTick', []);
end