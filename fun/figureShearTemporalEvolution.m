function figureShearTemporalEvolution(results)
% Sample data
time = results.time; % Time vector
mean_SWE = results.meanValue; % Sample mean data
std_SWE = results.stdValue; % Sample standard deviation data
void = results.voidPercent; % Sample value data

% Create figure
figure("Name","Temporal evolution of SWE","Color",[1 1 1],"MenuBar","none","ToolBar","none");

% First subplot: Mean and Standard Deviation
subplot(3,1,[1 2]);
errorbar(time(results.frameIndex),mean_SWE(results.frameIndex),std_SWE(results.frameIndex),'-x','Color','r')
ylabel('Shear modulus (kPa)','FontWeight','bold');
title('Temporal Evolution of Shear modulus');
legend('Mean  +/- Std');
xlim([0 max(time)])
ylim([0 max(mean_SWE + 1.5 * std_SWE)+0.1])

% Second subplot: Value
subplot(3,1,3);
plot(time, void, 'k*', 'LineWidth', 2); % Plot value data
xlabel('Time (s)','FontWeight','bold');
ylabel('Void (%)','FontWeight','bold');
xlim([0 max(time)])
ylim([0 (max(void)*1.2)+0.1])
grid on;
end