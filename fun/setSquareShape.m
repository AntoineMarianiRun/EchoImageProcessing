function [Shape] = set_square_shape(frames,frameindex_)
    [X,Y] = SetSquare(frames,frameindex_);
    [lengthY,lengthX] = size(frames{frameindex_});
    Shape = zeros(lengthY,lengthX);
    Shape(Y,X) = 1;
end