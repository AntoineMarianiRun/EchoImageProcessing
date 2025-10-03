function [x,y,x_moyen,y_moyen] = uiFrameCorrelationClusterAnalysis(frame)
% cette fonction est sert a faire une analyse des clusters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Global Variables Initialization
heigthTemplate_ = 45;
widthTemplate_ = 35;
verticalDrift_ = 0.6;
epsilon = 10;
rateOfChange  = 15;

[r,c,~] = size(frame);

% output initialization
row_ = nan(1);
col_ = nan(1);
x = cell(1);
y = cell(1);
x_moyen = nan(1);
y_moyen = nan(1);

%% 2. Create UI Figure
fig = uifigure();
fig.Name = 'UI cluster determination';
fig.Position = [100 100 800 500];
fig.Color = [1 1 1];
fig.CloseRequestFcn = @(src, event) resumeFig(fig);

% Create GridLayout
GridLayout = uigridlayout(fig);
GridLayout.ColumnWidth = {220, '1x'};
GridLayout.RowHeight = {'1x'};
GridLayout.ColumnSpacing = 10;
GridLayout.RowSpacing = 10;
GridLayout.Padding = [10 10 10 10];
GridLayout.Scrollable = 'on';

% Create Left Panel
LeftPanel = uipanel(GridLayout);
LeftPanel.Layout.Row = 1;
LeftPanel.Layout.Column = 1;

% Create UI Components on Left Panel
% **About Template Section**
ForTemplateLabel = uilabel(LeftPanel);
ForTemplateLabel.HorizontalAlignment = 'center';
ForTemplateLabel.Position = [10 440 200 28];
ForTemplateLabel.Text = 'About Template';
ForTemplateLabel.FontAngle = 'italic';
ForTemplateLabel.FontSize = 16;

% Heigth Spinner
HeigthSpinnerLabel = uilabel(LeftPanel);
HeigthSpinnerLabel.HorizontalAlignment = 'left';
HeigthSpinnerLabel.Position = [10 390 60 22];
HeigthSpinnerLabel.Text = 'Height';
HeigthSpinnerLabel.FontWeight = 'bold';

HeigthSpinner = uispinner(LeftPanel);
HeigthSpinner.Position = [80 390 130 22];
HeigthSpinner.Limits = [1 501];
HeigthSpinner.Step = 2;
HeigthSpinner.Value = heigthTemplate_;

% Width Spinner
WidthSpinnerLabel = uilabel(LeftPanel);
WidthSpinnerLabel.HorizontalAlignment = 'left';
WidthSpinnerLabel.Position = [10 340 60 22];
WidthSpinnerLabel.Text = 'Width';
WidthSpinnerLabel.FontWeight = 'bold';

WidthSpinner = uispinner(LeftPanel);
WidthSpinner.Position = [80 340 130 22];
WidthSpinner.Limits = [1 501];
WidthSpinner.Step = 2;
WidthSpinner.Value = widthTemplate_;

% **About cluster analysis Section**
ForClusterLabel = uilabel(LeftPanel);
ForClusterLabel.HorizontalAlignment = 'center';
ForClusterLabel.Position = [10 280 200 28];
ForClusterLabel.Text = 'About cluster analysis';
ForClusterLabel.FontAngle = 'italic';
ForClusterLabel.FontSize = 16;

% Vertical Drift Spinner
minCorrelationSpinnerLabel = uilabel(LeftPanel);
minCorrelationSpinnerLabel.HorizontalAlignment = 'left';
minCorrelationSpinnerLabel.Position = [10 240 80 22];
minCorrelationSpinnerLabel.Text = 'min corr';
minCorrelationSpinnerLabel.FontWeight = 'bold';

minCorrelationSpinner = uispinner(LeftPanel);
minCorrelationSpinner.Position = [100 240 110 22];
minCorrelationSpinner.Limits = [0 100];
minCorrelationSpinner.Step = 0.01;
minCorrelationSpinner.Value = verticalDrift_;
minCorrelationSpinner.Limits = [-1 1];

% Horizontal Drift Spinner
maxDistSpinnerLabel = uilabel(LeftPanel);
maxDistSpinnerLabel.HorizontalAlignment = 'left';
maxDistSpinnerLabel.Position = [10 200 80 22];
maxDistSpinnerLabel.Text = 'max dist';
maxDistSpinnerLabel.FontWeight = 'bold';

maxDistSpinner = uispinner(LeftPanel);
maxDistSpinner.Position = [100 200 110 22];
maxDistSpinner.Limits = [0 200];
maxDistSpinner.Step = 1;
maxDistSpinner.Value = epsilon;

% error Spinner
minPointsSpinerLabel = uilabel(LeftPanel);
minPointsSpinerLabel.HorizontalAlignment = 'left';
minPointsSpinerLabel.Position = [10 160 80 22];
minPointsSpinerLabel.Text = 'n points min';
minPointsSpinerLabel.FontWeight = 'bold';

minPointsSpiner = uispinner(LeftPanel);
minPointsSpiner.Position = [100 160 110 22];
minPointsSpiner.Limits = [5 1000];
minPointsSpiner.Step = 1;
minPointsSpiner.Value = 100;

% Horizontal Drift Spinner
ChangeRateLabel = uilabel(LeftPanel);
ChangeRateLabel.HorizontalAlignment = 'left';
ChangeRateLabel.Position = [10 120 80 22];
ChangeRateLabel.Text = 'Update template';
ChangeRateLabel.FontWeight = 'bold';

ChangeRateSpinner = uispinner(LeftPanel);
ChangeRateSpinner.Position = [100 120 110 22];
ChangeRateSpinner.Limits = [1 inf];
ChangeRateSpinner.Step = 1;
ChangeRateSpinner.Value = rateOfChange;


HeigthSpinner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);
WidthSpinner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);
minCorrelationSpinner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);
maxDistSpinner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);
minPointsSpiner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);

% **Interaction Buttons**
% Perform Tracking Button
setParametersButton = uibutton(LeftPanel, 'push');
setParametersButton.Position = [10 60 200 30];
setParametersButton.Text = 'test parameters';
setParametersButton.BackgroundColor = [0.9 0.9 0.9];
setParametersButton.ButtonPushedFcn = @(src, event) testParameters();

% Ok Button
OkButton = uibutton(LeftPanel, 'push');
OkButton.Position = [10 20 200 30];
OkButton.Text = 'Ok';
OkButton.BackgroundColor = [0.9 0.9 0.9];
OkButton.ButtonPushedFcn = @(src, event) resumeFig(fig);



% Create Right Panel
RightPanel = uipanel(GridLayout);
RightPanel.Layout.Row = 1;
RightPanel.Layout.Column = 2;


% Create UIAxes
UIAxes = uiaxes(RightPanel);
UIAxes.Position = [20 120 500 282];
UIAxes.XTick = [];
UIAxes.YTick = [];
UIAxes.XLim = [1 c];
UIAxes.YLim = [1 r];
UIAxes.Box = 'on';

% Ensure UIAxes can detect clicks
UIAxes.HitTest = 'on';
UIAxes.PickableParts = 'all';

% Initial Display
displayImage();

%% 3. function end
uiwait(fig)
delete(fig)


%% Nested Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% **Display Image Function**
    function displayImage()
        cla(UIAxes);  % Clear current axes
        pltImage = image(frame,'Parent',UIAxes);
        UIAxes.Layer = 'top';
        UIAxes.XTick = [];
        UIAxes.YTick = [];
        UIAxes.XLim = [1 c];
        UIAxes.YLim = [1 r];
        hold(UIAxes, 'on');

        if ~isnan(row_) && ~isnan(col_)
            [pltImage] = drawBoxPattern(UIAxes,...
                1, ...
                col_, ...
                row_, ...
                double(HeigthSpinner.Value), ...
                double(WidthSpinner.Value), ...
                pltImage);
        end

        if ~isnan(x_moyen) && ~isnan(y_moyen)
            plot(UIAxes,x_moyen,y_moyen,'sb','MarkerSize',12)
            plot(UIAxes,x,y,'r','LineWidth',3)
        end

        hold(UIAxes, 'off');
        pltImage.ButtonDownFcn = @(src, event) axesClickCallback(event);
    end

    % **Axes Click Callback**
    function axesClickCallback(event)
        % Check which mouse button was clicked
        switch event.Button
            case 1  % Left click
                % Get click position
                click_position = UIAxes.CurrentPoint(1, 1:2);  % [x, y]
                colClicked = round(click_position(1));
                rowClicked = round(click_position(2));

                % Validate click within image bounds
                if colClicked >= 1 && colClicked <= c && rowClicked >=1 && rowClicked <= r
                    % Store the clicked position for the first frame
                    row_ = rowClicked;
                    col_ = colClicked;
                    displayImage();  % Update display with the new point
                else
                    disp('Click is outside the image bounds.');
                end

            case 3  % Right click
                % Reset tracking points
                row_ = nan(1);
                col_ = nan(1);
                displayImage();  % Update display to remove points
        end
    end

    % test parameters
    function testParameters()
        if ~isnan(col_) && ~isnan(row_)
            % get template 
            template = corpImageAsRectangle(frame, ...
                col_, ...
                row_, ...
                double(HeigthSpinner.Value), ...
                double(WidthSpinner.Value));

            % correlation matrix
            disp('   - correlation map processing')
            tic
            ncc_map = NCC_matching(frame,template);
            toc

            % cluster analysis
            disp('   - cluster analysis processing')
            tic
            [x,y,x_moyen,y_moyen] = getStuctureCluster(col_, ...
                row_, ...
                ncc_map, ...
                double(minCorrelationSpinner.Value), ...
                double(maxDistSpinner.Value), ...
                double(minPointsSpiner.Value));
            toc

            disp('process ok')

            % display results
            displayImage();
        end

    end

    % **update globale Function**
    function updateGlobale(HeigthSpinner,WidthSpinner)
        if mod(double(HeigthSpinner.Value),2) ~= 1
            HeigthSpinner.Value = double(HeigthSpinner.Value)+1;
        end

        if mod(double(WidthSpinner.Value),2) ~= 1
            WidthSpinner.Value = double(WidthSpinner.Value)+1;
        end
        displayImage()
    end 

    % **update globale Function**
    function resumeFig(fig)
        uiresume(fig)
    end 

end