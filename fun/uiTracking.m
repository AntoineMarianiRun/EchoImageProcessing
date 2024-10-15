function [row_,col_] = uiTracking(frame)
    %% Global Variables Initialization
    %about tracking
    heigthTemplate_ = 25;
    widthTemplate_ = 25;
    verticalDrift_ = 10;
    horizontalDrift_ = 10;
    rateOfChange  = 15;

    % about video
    frameIndex = 1;
    [~,nframe] = size(frame);
    [r,c,~] = size(frame{frameIndex});
    frameIndex = 1;
    [r, c, ~] = size(frame{frameIndex});

    % Tracking points initialization
    row_ = nan(1, nframe);
    col_ = nan(1, nframe);

    %% Create UI Figure
    fig = uifigure();
    fig.Name = 'UI Tracking Setup';
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

    %% Create Left Panel
    LeftPanel = uipanel(GridLayout);
    LeftPanel.Layout.Row = 1;
    LeftPanel.Layout.Column = 1;

    %% Create UI Components on Left Panel

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

    %% **About Tracking Section**
    ForTrackingLabel = uilabel(LeftPanel);
    ForTrackingLabel.HorizontalAlignment = 'center';
    ForTrackingLabel.Position = [10 260 200 28];
    ForTrackingLabel.Text = 'About Tracking';
    ForTrackingLabel.FontAngle = 'italic';
    ForTrackingLabel.FontSize = 16;

    % Vertical Drift Spinner
    VerticalSpinnerLabel = uilabel(LeftPanel);
    VerticalSpinnerLabel.HorizontalAlignment = 'left';
    VerticalSpinnerLabel.Position = [10 210 80 22];
    VerticalSpinnerLabel.Text = 'Vertical';
    VerticalSpinnerLabel.FontWeight = 'bold';

    VerticalSpinner = uispinner(LeftPanel);
    VerticalSpinner.Position = [100 210 110 22];
    VerticalSpinner.Limits = [0 100];
    VerticalSpinner.Step = 1;
    VerticalSpinner.Value = verticalDrift_;

    % Horizontal Drift Spinner
    HorizontalSpinnerLabel = uilabel(LeftPanel);
    HorizontalSpinnerLabel.HorizontalAlignment = 'left';
    HorizontalSpinnerLabel.Position = [10 170 80 22];
    HorizontalSpinnerLabel.Text = 'Horizontal';
    HorizontalSpinnerLabel.FontWeight = 'bold';

    HorizontalSpinner = uispinner(LeftPanel);
    HorizontalSpinner.Position = [100 170 110 22];
    HorizontalSpinner.Limits = [0 1000];
    HorizontalSpinner.Step = 1;
    HorizontalSpinner.Value = horizontalDrift_;

        % Horizontal Drift Spinner
    ChangeRateLabel = uilabel(LeftPanel);
    ChangeRateLabel.HorizontalAlignment = 'left';
    ChangeRateLabel.Position = [10 130 80 22];
    ChangeRateLabel.Text = 'Update template';
    ChangeRateLabel.FontWeight = 'bold';

    ChangeRateSpinner = uispinner(LeftPanel);
    ChangeRateSpinner.Position = [100 130 110 22];
    ChangeRateSpinner.Limits = [1 1000];
    ChangeRateSpinner.Step = 1;
    ChangeRateSpinner.Value = rateOfChange;

    HeigthSpinner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);
    WidthSpinner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);
    VerticalSpinner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);
    HorizontalSpinner.ValueChangingFcn =  @(src, event) updateGlobale(HeigthSpinner,WidthSpinner);


    %% **Interaction Buttons**
    % Perform Tracking Button
    PerformTrackingButton = uibutton(LeftPanel, 'push');
    PerformTrackingButton.Position = [10 60 200 30];
    PerformTrackingButton.Text = 'Perform Tracking';
    PerformTrackingButton.BackgroundColor = [0.9 0.9 0.9];
    PerformTrackingButton.ButtonPushedFcn = @(src, event) performTracking();

    % Ok Button
    OkButton = uibutton(LeftPanel, 'push');
    OkButton.Position = [10 20 200 30];
    OkButton.Text = 'Ok';
    OkButton.BackgroundColor = [0.9 0.9 0.9];
    OkButton.ButtonPushedFcn = @(src, event) resumeFig(fig);

    %% Create Right Panel
    RightPanel = uipanel(GridLayout);
    RightPanel.Layout.Row = 1;
    RightPanel.Layout.Column = 2;

    %% Create UIAxes
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



    %% Create Play Button
    playButton = uibutton(RightPanel, 'push');
    playButton.Position = [25 41 114 26];
    playButton.Text = 'Play';
    playButton.BackgroundColor = [1 1 1];
    playButton.ButtonPushedFcn = @(src,event) playVideo();

    %% Initial Display
    displayImage();

    %% function end 
    uiwait(fig)
    delete(fig)
    if any(isnan(col_)) || any(isnan(row_))
        col_ = nan(1, nframe);
        row_ = nan(1, nframe);
    end


    %% Nested Callback Functions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % **Display Image Function**
    function displayImage()
        cla(UIAxes);  % Clear current axes
        pltImage = image(frame{frameIndex},'Parent',UIAxes);
        UIAxes.Layer = 'top';
        UIAxes.XTick = [];
        UIAxes.YTick = [];
        UIAxes.XLim = [1 c];
        UIAxes.YLim = [1 r];        
        hold(UIAxes, 'on');
        if ~isnan(row_(frameIndex)) && ~isnan(col_(frameIndex))
            plot(UIAxes, col_(frameIndex), row_(frameIndex), '+r', 'MarkerSize', 10, 'LineWidth', 2);
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
                    row_(frameIndex) = rowClicked;
                    col_(frameIndex) = colClicked;
                    displayImage();  % Update display with the new point
                else
                    disp('Click is outside the image bounds.');
                end

            case 3  % Right click
                % Reset tracking points
                row_ = nan(1, nframe);
                col_ = nan(1, nframe);
                displayImage();  % Update display to remove points
        end
    end

    % **Play Video Function**
    function playVideo()
        for k = 1:nframe
            frameIndex = k;
            displayImage();
            pause(1/24);  
        end
        frameIndex = 1;
        displayImage();
    end

    % **Perform Tracking Function**
    function performTracking()
        if ~isnan(col_(1)) && ~isnan(row_(1))
            template = corpImageAsRectangle(frame{frameIndex}, ...
                col_(frameIndex), ...
                row_(frameIndex), ...
                double(HeigthSpinner.Value), ...
                double(WidthSpinner.Value));
            opts.progressBar = "on";
            [row_,col_,~] = tracking(frame,template,row_(frameIndex),col_(frameIndex), ...
                double(VerticalSpinner.Value), ...
                double(HorizontalSpinner.Value), ...
                double(ChangeRateSpinner.Value), ...
                opts);
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
    end 

    % **update globale Function**
    function resumeFig(fig)
        uiresume(fig)
    end 
end
