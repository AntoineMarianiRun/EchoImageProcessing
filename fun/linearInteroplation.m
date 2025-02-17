function [anonyme] = linearInteroplation(mkr1,mkr2)
% x : col
% y : row
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = (mkr2.row - mkr1.row) ./ (mkr2.col - mkr1.col);                        % function slope
b = mkr1.row - a .* mkr1.col;                                              % y y_intersect 

anonyme = struct();
% fun = @(col) a * col + b; %function 
for i = 1 : length(a)
    anonyme(i).a = a(i); % Capture la valeur de a(i)
    anonyme(i).b = b(i); % Capture la valeur de b(i)
    anonyme(i).frame = @(col) a(i) * col + b(i);         % Fonction anonyme pour chaque i
end
end