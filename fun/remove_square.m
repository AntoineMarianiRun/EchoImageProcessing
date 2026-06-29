function [output_frame] = remove_square(frame,coord)
% remove the yellow square in the center of the bmode image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[heigth_,width_, dim_] = size(frame); % image information

in = zeros(heigth_,width_,dim_); % out matrix

if nargin == 2
    % remove the border 
    %%%%%%%%%%%%%%%%%%%
    in(coord.y(1):coord.y(2), ...
        coord.x(1):coord.x(2), ...
        1:dim_) = 1; % top border
else
    in = ones(heigth_,width_,dim_); % out matrix
end 

M = frame;
M(in==0) = 0; % matrix to work with

%% detect color square
%%%%%%%%%%%%%%%%%%%%%%%%
% [is_color] = isColor(M,
% 10);
[is_color] = isColor(M,20);
M = mean(M,3);
M(is_color==1) = NaN(1);

%% fit missing value
%%%%%%%%%%%%%%%%%%%%%%%%%%
[x, y] = meshgrid(1:size(M,2), 1:size(M,1)); % linear problem

mask = ~isnan(M); % masque datas

% création des points valides
xv = x(mask);
yv = y(mask);
vv = M(mask);

% interpolation bilinéaire
% F = scatteredInterpolant(xv, yv, vv, 'linear', 'none');
F = scatteredInterpolant(x(mask), y(mask), M(mask), 'natural', 'none');

%% output image
%%%%%%%%%%%%%%%%%%%%%%%%%%
output_frame = M;
output_frame(~mask) = F(x(~mask), y(~mask));
output_frame = repmat(output_frame,[1,1,3]);

output_frame(in==0) = frame(in==0);
output_frame = uint8(output_frame);

% figure
% subplot(1,2,1)
% image(frame)
% 
% subplot(1,2,2)
% image(output_frame)
end 