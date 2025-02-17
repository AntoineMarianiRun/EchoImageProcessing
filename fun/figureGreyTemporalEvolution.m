function figureGreyTemporalEvolution(results)
% Sample data
time = results.time; % Time vector
mean_Grey = results.meanValue; % Sample mean data
std_Grey = results.stdValue; % Sample standard deviation data
void = results.voidPercent; % Sample value data

% Create figure
figure("Name","Temporal evolution of SWE","Color",[1 1 1],"MenuBar","none","ToolBar","none");

% First subplot: Mean and Standard Deviation
subplot(3,1,[1 2]);
errorbar(time(results.frameIndex),mean_Grey(results.frameIndex),std_Grey(results.frameIndex),'-x','Color','r')
ylabel('grey level (u.a.)','FontWeight','bold');
title('Temporal Evolution of Grey');
legend('Mean  +/- Std');
xlim([0 max(time)])
ylim([0 max(mean_Grey + 1.5 * std_Grey)+0.05])

% Second subplot: Value
subplot(3,1,3);
plot(time, void, 'k*', 'LineWidth', 2); % Plot value data
xlabel('Time (s)','FontWeight','bold');
ylabel('Void (%)','FontWeight','bold');
xlim([0 max(time)])
ylim([0 (max(void)*1.2)+0.1])
grid on;
end