function [Shape] = isInShape(X,Y,Xsize,Ysize)
    % Define the range of x and y based on the polygon coordinates
    xRange = 1:Xsize;
    yRange = 1:Ysize;
    
    % Create a meshgrid for the coordinates
    [xGrid, yGrid] = meshgrid(xRange, yRange);
    
    %Check which points are inside the polygon
    Shape = inpolygon(xGrid, yGrid, X, Y);
end