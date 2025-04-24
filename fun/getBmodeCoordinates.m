function [box] = getBmodeCoordinates(frame)
frame2D = im2gray(frame);

trashold = median(frame2D,'all') ;
trueFalse = frame2D>trashold;

% avoid border
trueFalse(1:200,:) = 0;
trueFalse(end-200:end,:) = 0;
trueFalse(:,end-100:end) = 0;

x = mean(trueFalse,1) >.2;
y = mean(trueFalse,2)' >.2;

%% n box
%%%%%%%%%
box = {};
if any(x == 1)
    % get x start and x end
    boxOn = false;
    nboxX = 0;

    % add y
    %%%%%%%
    for i = 1 : length(y)-5
        if sum(y(i:i+4) == [0 0 1 1 1]) == 5 && boxOn == false
            boxOn = true;
            box(1).y(1) = i;
        end
        if sum(y(i:i+4) == [1 1 0 0 0]) == 5 && boxOn == true
            boxOn = false;
            box(1).y(2) = i+1;
            continue
        end
    end
    % add x
    %%%%%%%
    for i = 1 : length(x)-5
        if sum(x(i:i+4) == [0 0 1 1 1]) == 5 && boxOn == false
            boxOn = true;
            nboxX = nboxX + 1;
            box(nboxX).x(1) = i;
        end
        if sum(x(i:i+4) == [1 1 0 0 0]) == 5 && boxOn == true
            boxOn = false;
            box(nboxX).x(2) = i+1;
            box(nboxX).y = box(1).y;
        end
    end

    % draw box
    %%%%%%%%%%%
    figure("Name","show box")
    image(frame)
    hold on
    for i = 1 : nboxX
        rectangle('Position',[box(i).x(1),box(i).y(1), abs(diff([box(i).x])), abs(diff([box(i).y]))],'LineWidth',2,'LineStyle','--','EdgeColor','r')
    end
end
end