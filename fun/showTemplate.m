function showTemplate(template)
% template metrics 
[heigth_,width_,~] = size(template);

figure('Name','Template','Color',[1 1 1])                                  % figure for the tempate 
image(template)                                                            % show the tempate 
hold on
plot(round(width_/2),round(heigth_/2), 'sr')                                             % center of the template
legend('center of template', 'Location','southoutside')
xticks([])
yticks([])
end 