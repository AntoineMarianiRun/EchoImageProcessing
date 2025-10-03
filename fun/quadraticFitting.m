function [anonyme] = quadraticFitting(memory_tracking,n)
% x : col
% y : row
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin <2
    n = 1;
end

nframe = length(memory_tracking.mkrTracked(1).row);
nmkr = size(memory_tracking.mkrTracked,2);
anonyme = [];

for i = 1 : nframe
    y = [];
    x = [];
    % en pixel
    for ii = 1 : nmkr % selectioner les markers de la frame
        y(ii) = memory_tracking.mkrTracked(ii).row(i);
        x(ii) = memory_tracking.mkrTracked(ii).col(i);
    end

    [p,stats] = polyfit(x,y,n);
    anonyme(i).parameters = p;
    anonyme(i).stats = stats;
    anonyme(i).frame = @(col) polyval(p, col);

    % en cm
    y = [];
    x = [];
    for ii = 1 : nmkr % selectioner les markers de la frame
        y(ii) = memory_tracking.mkrTracked(ii).y(i);
        x(ii) = memory_tracking.mkrTracked(ii).x(i);
    end

    [p,~] = polyfit(x,y,n);
    anonyme(i).parameterscm = p;
    anonyme(i).framecm = @(x) polyval(p, x);
end
end