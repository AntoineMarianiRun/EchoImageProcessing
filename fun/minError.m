function [minValue,rowOffset,colOffset] = minError(errMatrix)
% error matrix information
[heigthMartix,widthMartix] = size(errMatrix);
heigthCenter = round(heigthMartix/2);
widthCenter = round(widthMartix/2);

% find minimal value
[minValue] = min(errMatrix,[],'all');
[row,col] = find(errMatrix==minValue);

%% 
if length(row)~=1 % multiple local min
    [idx] = minOpt(row,col,heigthCenter,widthCenter);
    rowOffset = row(idx) - heigthCenter;
    colOffset = col(idx) - widthCenter;
else
    rowOffset = row - heigthCenter;
    colOffset = col - widthCenter;
end
end

function [idx] = minOpt(row,col,heigthCenter,widthCenter) % find the nearest frome the center
offset = abs(row - heigthCenter)+abs(col - widthCenter);
[~,idx] = min(offset);
end