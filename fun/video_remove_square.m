function [frames] = video_remove_square(frames)
% remove yellow box of the bmode during capture with swe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig = uifigure('Name', 'remove square from b-mode', 'Color', [1 1 1]);
fig.Position(3:4) = [400 100];  % Width and height
fig.WindowStyle = 'modal';      % Modal mode
d = uiprogressdlg(fig, 'Title', 'Please Wait', 'Message', 'remove process');

nbFrames = length(frames);                                                 % number pf frames in the video

coord = getBmodeCoordinates(frames{1});                                    % get coord of b-mode

for currentFrame= 1 : length(frames)                                       % for each frame
    frames{currentFrame} = remove_square(frames{currentFrame},coord(1));   % remove yellow box 
    if mod(currentFrame,5)==1
        d.Value = currentFrame / nbFrames;                                 % Update progress bar
    end
end
close(fig);
end