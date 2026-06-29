function [box] = getBmodeCoordinates(frame)
frame2D = im2gray(frame);% image(frame2D)

% avoid video inforamtion 
frame2D(1:160,:) = 0; % header 
frame2D(end-50:end,:) = 0; % buttum information 

trueFalse = frame2D>3;% image(trueFalse.*255)

x = mean(trueFalse,1) >.3; % represente at least 30% of the image 
y = mean(trueFalse,2)' >.1; % represente at least 30% of the image 

%% n box
%%%%%%%%%
box = {};
if any(x == 1)
    % x 
    %%%%%%%%%%%
    box.y(1) = find(y,1,"first");
    box.y(2) = find(y,1,"last");

       %%%%%%%%%%%
    box.x(1) = find(x,1,"first");
    box.x(2) = find(x,1,"last");

   
    % draw box
    %%%%%%%%%%%
    figure("Name","show box")
    image(frame)
    hold on
    rectangle('Position',[box.x(1),box.y(1), abs(diff([box.x])), abs(diff([box.y]))],'LineWidth',2,'LineStyle','--','EdgeColor','r')
end
end