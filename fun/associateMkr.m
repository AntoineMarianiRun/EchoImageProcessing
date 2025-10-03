function [funTracked] = associateMkr(frame,memory_tracking)
%% setup
frameIndex = 1;
[~,nframe] = size(frame);
[r,c,~] = size(frame{frameIndex});

funTracked = [];

% verification
if ~isfield(memory_tracking, 'mkrTracked') || isempty(memory_tracking.mkrTracked)
    error('La structure memory_tracking.mkrTracked est vide ou inexistante.');
end

% Création de la liste des noms (ou indice si pas de nom)
nMarkers = numel(memory_tracking.mkrTracked);
names = cell(1, nMarkers);
for k = 1:nMarkers
    if isfield(memory_tracking.mkrTracked, 'mkrName') && ~isempty(memory_tracking.mkrTracked(k).mkrName)
        names{k} = sprintf('%d : %s', k, memory_tracking.mkrTracked(k).mkrName);
    else
        names{k} = sprintf('%d : (sans nom)', k);
    end
end

%% figure component
% Create fig and hide until all components are created


fig = uifigure('Visible', 'off');
fig.AutoResizeChildren = 'off';
fig.Position = [100 100 640 480];
fig.Name = 'associate mkr';

% Create GridLayout
GridLayout = uigridlayout(fig);
GridLayout.ColumnWidth = {220, '1x'};
GridLayout.RowHeight = {'1x'};
GridLayout.ColumnSpacing = 0;
GridLayout.RowSpacing = 0;
GridLayout.Padding = [0 0 0 0];
GridLayout.Scrollable = 'on';

% Create LeftPanel
LeftPanel = uipanel(GridLayout);
LeftPanel.Title = 'settings';
LeftPanel.Layout.Row = 1;
LeftPanel.Layout.Column = 1;

% Create ListBox
ListBox = uilistbox(LeftPanel);
ListBox.Position = [7 317 207 108];
ListBox.Items = names;
ListBox.Multiselect = "on";


% Create quadraticfunction
quadraticfunction = uiswitch(LeftPanel, 'slider');
quadraticfunction.Position = [29 256 23 10];

% Create custumfunction
custumfunction = uiswitch(LeftPanel, 'slider');
custumfunction.Position = [29 179 23 10];

% Create polynomiaorderSpinnerLabel
polynomiaorderSpinnerLabel = uilabel(LeftPanel);
polynomiaorderSpinnerLabel.Position = [7 216 96 22];
polynomiaorderSpinnerLabel.Text = 'polynomia order';

% Create polynomiaorderSpinner
polynomiaorderSpinner = uispinner(LeftPanel);
polynomiaorderSpinner.Position = [148 216 66 22];
polynomiaorderSpinner.Value = 2;
polynomiaorderSpinner.Limits = [1 10];

% Create functionEditFieldLabel
functionEditFieldLabel = uilabel(LeftPanel);
functionEditFieldLabel.HorizontalAlignment = 'right';
functionEditFieldLabel.Position = [7 136 47 22];
functionEditFieldLabel.Text = 'function';

% Create functionEditField
functionEditField = uieditfield(LeftPanel, 'text');
functionEditField.Position = [63 135 151 24];
functionEditField.Value = '@(x) e^ax +b';

% Create setButton
setButton = uibutton(LeftPanel, 'push');
setButton.Position = [7 13 207 32];
setButton.Text = 'set';

% Create nameEditFieldLabel
nameEditFieldLabel = uilabel(LeftPanel);
nameEditFieldLabel.HorizontalAlignment = 'right';
nameEditFieldLabel.Position = [7 61 35 22];
nameEditFieldLabel.Text = 'name';

% Create nameEditField
nameEditField = uieditfield(LeftPanel, 'text');
nameEditField.Position = [77 60 137 24];
nameEditField.Value = 'apponevrose_1';

% Create RightPanel
RightPanel = uipanel(GridLayout);
RightPanel.Layout.Row = 1;
RightPanel.Layout.Column = 2;

% Create OkButton
OkButton = uibutton(RightPanel, 'push');
OkButton.Position = [204 13 206 32];
OkButton.Text = 'Ok';

%% Create UIAxes
UIAxes = uiaxes(RightPanel);
UIAxes.Position = [20 120 500 282];
UIAxes.XTick = [];
UIAxes.YTick = [];
UIAxes.XLim = [1 c];
UIAxes.YLim = [1 r];
UIAxes.Box = 'on';



% Show the figure after all components are created
fig.Visible = 'on';
%% function assocaiated ton the figure
quadraticfunction.ValueChangedFcn =  @(src, event) updateSwitch(src, event,quadraticfunction,custumfunction);
custumfunction.ValueChangedFcn =  @(src, event) updateSwitch(src, event,quadraticfunction,custumfunction);
OkButton.ButtonPushedFcn = @(src, event) resumeFig(fig);
setButton.ButtonPushedFcn = @(src, event) setButtonFunction(src,quadraticfunction,custumfunction,ListBox,memory_tracking);



displayImage(UIAxes,frame,frameIndex,r,c,[],[])

%% function end
uiwait(fig)
delete(fig)


%% callback function
% resume figure **
    function resumeFig(fig)
        uiresume(fig)
    end

% **Display Image Function**
    function displayImage(UIAxes,frame,frameIndex,r,c,currentMrk,funTracked)
        cla(UIAxes);  % Clear current axes
        pltImage = image(frame{frameIndex},'Parent',UIAxes);
        UIAxes.Layer = 'top';
        UIAxes.XTick = [];
        UIAxes.YTick = [];
        UIAxes.XLim = [1 c];
        UIAxes.YLim = [1 r];
        hold(UIAxes, 'on');
        if ~isempty(currentMrk)
            for ii = 1 : size(currentMrk.mkrTracked,2)
                plot(UIAxes, ...
                    currentMrk.mkrTracked(ii).col(frameIndex), ...
                    currentMrk.mkrTracked(ii).row(frameIndex), ...
                    'Color',currentMrk.mkrTracked(ii).color, ...
                    'Marker',currentMrk.mkrTracked(ii).marker,...
                    'MarkerSize',currentMrk.mkrTracked(ii).markerSize)
                text(UIAxes,...
                    currentMrk.mkrTracked(ii).col(frameIndex), ...
                    currentMrk.mkrTracked(ii).row(frameIndex)-30, ...
                    currentMrk.mkrTracked(ii).mkrName,...
                    'Color',currentMrk.mkrTracked(ii).color,...
                    'FontSize',16,...
                    'HorizontalAlignment','left',...
                    'FontWeight','bold')
            end
        end
        if ~isempty(funTracked)
            lineQuality = 2;
            linePlot = funTracked.limInf : lineQuality : funTracked.limSup ;
            plot(UIAxes, ...
                linePlot, ...
                funTracked.fun(frameIndex).frame(linePlot), ...
                'Color',funTracked.color, ...
                'lineStyle',funTracked.lineStyle,...
                'lineWidth',funTracked.lineWidth)
            text(UIAxes,...
                mean(linePlot), ...
                mean(funTracked.fun(frameIndex).frame(linePlot)) + 30, ...
                funTracked.name,...
                'Color',funTracked.color, ...
                'FontSize',16,...
                'HorizontalAlignment','left',...
                'FontWeight','bold')

        end
        hold(UIAxes, 'off');
        pltImage.ButtonDownFcn = @(src, event) axesClickCallback(event);
    end


%update switch
    function updateSwitch(src, ~,quadraticfunction,custumfunction)
        % Quand un switch change d'état
        if strcmp(src.Value, 'On')
            if src ~= quadraticfunction
                quadraticfunction.Value = 'Off';
            end
            if src ~= custumfunction
                custumfunction.Value = 'Off';
            end
        end
    end

% set
    function setButtonFunction(src,quadraticfunction,custumfunction,ListBox,memory_tracking)
        % selected mkr
        [idx] = find(ismember(ListBox.Items, ListBox.Value) == 1);

        currentMrk.mkrTracked = memory_tracking.mkrTracked(idx);

        if string(quadraticfunction.Value) == "On"
            [funTracked.fun] = quadraticFitting(currentMrk,polynomiaorderSpinner.Value);
            funTracked.name = nameEditField.Value ;
            funTracked.limInf = 0;
            funTracked.limSup = c;
            funTracked.color='w';
            funTracked.lineStyle='-.';
            funTracked.lineWidth=2;

            displayImage(UIAxes,frame,frameIndex,r,c,currentMrk,funTracked)

        elseif string(custumfunction.Value) == "On"

        end

    end

end