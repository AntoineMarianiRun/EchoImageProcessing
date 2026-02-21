function [coef_x,coef_y] = autoScaleEcho(frame)
frame2D = im2gray(frame);% image(frame2D)

% avoid video inforamtion 
frame2D(1:100,:) = 0; % header 
frame2D(end-50:end,:) = 0; % buttum information 
trueFalse = frame2D>1;% image(trueFalse.*255)

% find box in Y
trueFalse_y = trueFalse(:, ...
    floor(size(trueFalse,2)*.3): floor(size(trueFalse,2)*.7));
y = mean(trueFalse_y,2)' >.7; % represente at least 30% of the image 
y_idx_beg = find(y>0,1,"first");
y_idx_end = find(y>0,1,"last");
y(y_idx_beg:y_idx_end) = true;

% find box in X
trueFalse_x = trueFalse(size(trueFalse,1)*.3 : size(trueFalse,1)*.7, ...
    y_idx_beg:floor((y_idx_end - y_idx_beg)*.3));

x = mean(trueFalse,1) >.35; % represente at least 30% of the image 
x_idx_beg = find(x>0,1,"first");
x_idx_end = find(x>0,1,"last");
x(x_idx_beg:x_idx_end) = true;

R_O_x = x_idx_end;
R_O_y = y_idx_beg;

figure("Name","show box")
image(frame)
hold on
plot(R_O_x,R_O_y,'sr')

% find graduation x
grad_ = mean(frame2D(R_O_y-6 :R_O_y-1 , x_idx_beg+50 : R_O_x));
grad_(end-20 :end) = min(grad_);
grad_ = grad_>20;

idx = find(islocalmax(grad_,'FlatSelection','center')==1);
delta_ = diff(idx);
delta_ = delta_(~(delta_ > mean(delta_)+20 | delta_ < mean(delta_)-20));
delta_= mean(delta_)*2;

coef_x = 1/delta_;
coef_y = 1/delta_;

plot([R_O_x-delta_, R_O_x],[R_O_y, R_O_y],'b','LineWidth',2)
text(R_O_x-(delta_/2),R_O_y-40,'x','Color','b','FontSize',15)
plot([R_O_x, R_O_x],[R_O_y, R_O_y+delta_],'g','LineWidth',2)
text(R_O_x + 20,R_O_y+(delta_/2),'y','Color','g','FontSize',15)

end