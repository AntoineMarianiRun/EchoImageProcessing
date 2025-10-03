function [new_frame] = cropVideo(frames,coord)
% select only a part of a video
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_frame = size(frames,2);

new_frame = cell(1,n_frame);

row = coord.y(1) : coord.y(2);
col = coord.x(1) : coord.x(2);

for i = 1 : n_frame %crop each frame 
new_frame{i} = frames{i}(row,...
    col, ...
    :);
end

end