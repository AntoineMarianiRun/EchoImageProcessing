function [coef] = pix2centimeter(nbPix)
fig = uifigure();
fig.Position(3:4) = [230 250];
fig.Color = [1 1 1];

% NumberofpixelEditFieldLabel
NumberofpixelEditFieldLabel = uilabel(fig);
NumberofpixelEditFieldLabel.HorizontalAlignment = 'right';
NumberofpixelEditFieldLabel.Position = [20 200 90 20];
NumberofpixelEditFieldLabel.Text = 'Number of pixel';
% NumberofpixelEditField
NumberofpixelEditField = uieditfield(fig, 'numeric');
NumberofpixelEditField.Position = [120 200 90 20];
NumberofpixelEditField.Value = nbPix;

% DistancecmEditFieldLabel
DistancecmEditFieldLabel = uilabel(fig);
DistancecmEditFieldLabel.HorizontalAlignment = 'right';
DistancecmEditFieldLabel.Position = [20 120 90 20];
DistancecmEditFieldLabel.Text = 'Distance (cm)';

% DistancecmEditField
DistancecmEditField = uieditfield(fig, 'numeric');
DistancecmEditField.Position = [120 120 90 20];
DistancecmEditField.Value = 1;

% ContinueButton
ContinueButton = uibutton(fig, 'push');
ContinueButton.Position = [50 50 130 25];
ContinueButton.Text = 'Ok';
ContinueButton.BackgroundColor=[.99 .99 .99];
ContinueButton.ButtonPushedFcn =  @(btn,event) ButtonPushed(fig);
%%
uiwait(fig);
coef = DistancecmEditField.Value / NumberofpixelEditField.Value;
delete (fig)
%% button pushed function
    function ButtonPushed(fig)
        uiresume(fig);
    end
end
