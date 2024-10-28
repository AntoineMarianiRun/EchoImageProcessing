function [rateOfChange] =  setRateOfChange(nFrame)

if nargin <1
    nFrame = 100;
end

fig = uifigure(); 
fig.Name = "Set rate of change";
fig.Color = [1 1 1]; 
fig.Position(3:4) = [400 150];


RateOfChangeLabel = uilabel(fig);
RateOfChangeLabel.HorizontalAlignment = 'left';
RateOfChangeLabel.Position = [10 100 250 22];
RateOfChangeLabel.Text = 'Set position each : (in frame)';
RateOfChangeLabel.FontWeight = 'bold';

RateOfChangeSpinner = uispinner(fig);
RateOfChangeSpinner.Position = [270 100 120 22];
RateOfChangeSpinner.Limits = [1 nFrame];
RateOfChangeSpinner.Step = 1;
RateOfChangeSpinner.Value = 24;

% Ok Button
OkButton = uibutton(fig, 'push');
OkButton.Position = [150 20 100 30];
OkButton.Text = 'set';
OkButton.BackgroundColor = [0.9 0.9 0.9];
OkButton.ButtonPushedFcn = @(src, event) resumeFig(fig);


% resume 
uiwait(fig)
rateOfChange = double(RateOfChangeSpinner.Value); 
close(fig)


%% callback
    % set 
    function resumeFig(fig)
        uiresume(fig)
    end 
end