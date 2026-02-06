function [row,col,n_mkr_out]= manualLineTracking(frames,rateOfChange)

fig =figure('Name','Manual Line Tracking','Color',[1 1 1]);

nFrames = size(frames,2);

n_mkr_max = 100 ; 
row = nan(n_mkr_max,nFrames);
col = nan(n_mkr_max,nFrames);


for currentFrames = 1 : rateOfChange : nFrames

    % set line
    [col_temp, row_temp] = setLine(frames{currentFrames},fig);

    % add to the matrix
    n_mkr = length(col_temp);
    col(1:n_mkr,currentFrames) = col_temp;
    row(1:n_mkr,currentFrames) = row_temp;
      
    disp(['frames number :', num2str(currentFrames), ' out of ', num2str(nFrames)])
end
close(fig); 

% output
keep = false(1,n_mkr_max);
for i = 1 : n_mkr_max
    keep(i) = any(~isnan(col(i,:)));
end

col = col(keep,:);
row = row(keep,:);
n_mkr_out = sum(keep);

end 