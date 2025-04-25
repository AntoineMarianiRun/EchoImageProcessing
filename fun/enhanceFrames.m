function global_frames = enhanceFrames(frames, ROI)
% This function applies Contrast-Limited Adaptive Histogram Equalization (CLAHE)
% to a specific ROI within each frame, boosting contrast only in that area while
% keeping the rest of the image unchanged.
%
% Inputs:
%   - frames : 3D matrix of image frames (height x width x number of frames)
%   - ROI    : structure with fields 'x' (columns) and 'y' (rows) defining the area to enhance
%
% Output:
%   - global_frames : full image frames with enhanced contrast in the ROI only
%
% Author: Ophelie LARIVIERE, Last review: 24/04/2025

numFrames = numel(frames);
filteredFrames = cell(1, numFrames);
originalType = class(frames{1});

% Parallel loop si disponible
parfor i = 1:numFrames
    frame = frames{i}(ROI.y,ROI.x,:);
    frame_dbl = im2double(frame);  % Convertir une fois

    if ndims(frame_dbl) == 3  % RGB
        frame_eq = zeros(size(frame_dbl));
        for c = 1:3
            frame_eq(:,:,c) = adapthisteq(frame_dbl(:,:,c), 'NumTiles', [4 4], 'ClipLimit', 0.01);
            % Ou histeq(frame_dbl(:,:,c)) si tolérable
        end
    else  % Grayscale
        frame_eq = adapthisteq(frame_dbl, 'NumTiles', [4 4], 'ClipLimit', 0.01);
    end

    frame_sharp = imsharpen(frame_eq);

    filteredFrames = im2uint8(frame_sharp);
    global_frames{i} = frames{i};
    global_frames{i}(ROI.y,ROI.x,:)=filteredFrames;
end