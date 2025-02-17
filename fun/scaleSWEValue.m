function [Maxvalue] = scaleSWEValue(colorScale,txt)
if txt == "m/s"
    Maxvalue = 14.1;
else
    Maxvalue = 600;
end

fig = uifigure();
fig.Position(3:4) = [230 250];
fig.Color = [1 1 1];

% EditFieldLabel
EditFieldLabel = uilabel(fig);
EditFieldLabel.HorizontalAlignment = 'right';
EditFieldLabel.Position = [20 220 90 20];
EditFieldLabel.Text = "Max Scale Value" ;
% Number
Number = uieditfield(fig, 'numeric');
Number.Position = [120 220 90 20];
Number.Value = Maxvalue;
% plot
ax= uiaxes(fig) ;
ax.Position = [40 60 160 125];
ax.XTick = [] ;
ax.YTick = [] ;
ax.Toolbar.Visible = 'off';
image(ax,flip(colorScale)) ;

% ContinueButton
ContinueButton = uibutton(fig, 'push');
ContinueButton.Position = [50 30 130 25];
ContinueButton.Text = 'Ok';
ContinueButton.BackgroundColor=[.99 .99 .99];
ContinueButton.ButtonPushedFcn =  @(btn,event) ButtonPushed(fig);
%%
uiwait(fig);
Maxvalue = Number.Value ;
close (fig)
%% button pushed function
    function ButtonPushed(fig)
        uiresume(fig);
    end
end