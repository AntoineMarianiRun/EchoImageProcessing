function ShowColorScale(colorScaleRGBuint8,colorScaleValue)
% create fig and display colorscale
fig = figure('Name','Color Scale','Color', [1 1 1], 'MenuBar','none','ToolBar','none');
fig.Position(3:4) = [200 400] ;
image(flip(colorScaleRGBuint8)) % showscale
xticks([ ])
try
    % ticks
    yyaxis left
    tck = round(linspace(1,length(colorScaleValue),6));
    yticks(tck)
    yticklabels(flip(round(colorScaleValue(tck),1)))
    ytickangle(45)
    ylabel('Shear modulus (kPa)','FontWeight','bold')

    yyaxis right
    tck2 = linspace(0,1,6);
    yticks(tck2)
    yticklabels(round(sqrt(colorScaleValue(tck)),1))
    ytickangle(-45)
    ylabel('Shear wave speed (m.s)','FontWeight','bold',Rotation=-90)

catch
    yticks([ ])
end
end