function [Shape] = setSquareShape(selected_frame)
    [X,Y] = setSquare(selected_frame);
    [lengthY,lengthX] = size(selected_frame,1:2);
    Shape = zeros(lengthY,lengthX);
    Shape(Y,X) = 1;
end