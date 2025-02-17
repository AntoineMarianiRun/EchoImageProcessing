function [x_intersect, y_intersect] = intersectionLinear(a1, b1, a2, b2)
% intersection - finds the intersection of two linear functions
%
% Syntax: [x_intersect, y_intersect] = intersection(m1, b1, m2, b2)
%
% Inputs:
%    a1 - slope of the first linear function
%    b1 - y-intercept of the first linear function
%    a2 - slope of the second linear function
%    b2 - y-intercept of the second linear function
%
% Outputs:
%    x_intersect - x-coordinate of the intersection point (column in an image)
%    y_intersect - y-coordinate of the intersection point (row in an image)

% Check if the slopes are equal (the lines are parallel)
if a1 == a2
    warning('The lines are parallel and do not intersect.');
    x_intersect = nan(1); y_intersect = nan(1);
else
    % Calculate the x-coordinate of the intersection point
    x_intersect = (b2 - b1) ./ (a1 - a2);

    % Calculate the y-coordinate of the intersection point
    y_intersect = a1 .* x_intersect + b1;
end
end
