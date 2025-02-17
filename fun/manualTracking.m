function [row,col]= manualTracking(frames,rateOfChange)

fig =figure('Name','Manual Tracking','Color',[1 1 1]);
axes_im = axes('Parent',fig);

nFrames = size(frames,2);

row = nan(1,nFrames);
col = nan(1,nFrames);


for currentFrames = 1 : rateOfChange : nFrames
    [col(currentFrames),row(currentFrames)] = setPoint(frames{currentFrames},fig);
       
    disp(['frames number :', num2str(currentFrames), ' out of ', num2str(nFrames)])
end

close(fig); 

end 