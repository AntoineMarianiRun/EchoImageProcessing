function ShowColorScale(colorScaleRGBuint8,colorScaleValue)
% create fig and display colorscale
fig = figure('Name','Color Scale','Color', [1 1 1], 'MenuBar','none','ToolBar','none');
fig.Position(3:4) = [100, 400] ;
image(flip(colorScaleRGBuint8)) % showscale
xticks([ ])
try
    % ticks
    tck = round(linspace(1,length(colorScaleValue),10));
    yticks(tck)
    yticklabels(flip(round(colorScaleValue(tck))))
    ytickangle(45)
    ylabel('Shear modulus (kPa)','FontWeight','bold')
catch
    yticks([ ])
end
end