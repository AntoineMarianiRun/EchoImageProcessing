function angle_deg = angleBetweenLines(a1, a2)
    % angle_between_lines - calculates the angle between two linear functions
    %
    % Syntax: angle_deg = angle_between_lines(a1, a2)
    %
    % Inputs:
    %    a1 - slope of the first linear function
    %    a2 - slope of the second linear function
    %
    % Outputs:
    %    angle_deg - angle between the two lines in degrees

    % Calculate the tangent of the angle between the two linear functions
    tan_theta = abs((a2 - a1) ./ (1 + a1 .* a2));

    % Calculate the angle in radians
    theta_rad = atan(tan_theta);

    % Convert the angle from radians to degrees
    angle_deg = rad2deg(theta_rad);
end