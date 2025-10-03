classdef App_Echo < matlab.apps.AppBase
    %% App Echo
    %% Component initalisation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = public)
        video
        variables
        component
        general
    end

    methods (Access = public)
        function SetFigure(app)
            %% figure
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            app.component.figure = uifigure();
            app.component.figure.Color = [1 1 1] ;
            app.component.figure.Position = [0 0 1400 800];
            app.component.figure.MenuBar = 'none' ;
            app.component.figure.ToolBar = 'none' ;
            app.component.figure.Name = 'Echographique image processing' ;
            app.component.figure.Units= 'pixel';

            %% MenuBar
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% MenuBar --> Home
            app.component.Homemenu = uimenu(app.component.figure);
            app.component.Homemenu.Text = 'Home';

            % loadfiles
            app.component.loadfilesmenu = uimenu(app.component.Homemenu);
            app.component.loadfilesmenu.Text = 'Load Video';
            app.component.loadfilesmenu.MenuSelectedFcn =createCallbackFcn(app, @loadfiles, true);

            % exportprescale
            app.component.exportscalingmenu = uimenu(app.component.Homemenu);
            app.component.exportscalingmenu.Text = 'Export scaling';
            app.component.exportscalingmenu.MenuSelectedFcn =createCallbackFcn(app, @exportscaling, true);

            % exportresults
            app.component.exportresultsmenu = uimenu(app.component.Homemenu);
            app.component.exportresultsmenu.Text = 'Export results';
            app.component.exportresultsmenu.MenuSelectedFcn =createCallbackFcn(app, @export, true);

            %%  MenuBar --> Tools
            app.component.Bmodemenu = uimenu(app.component.figure);
            app.component.Bmodemenu.Text = 'B-Mode';
            % Setup B-mode
            app.component.SetUpBModemenu = uimenu(app.component.Bmodemenu);
            app.component.SetUpBModemenu.Text = 'Setup';

            % Calibration of B-mode
            app.component.CalibrationBModemenu = uimenu(app.component.SetUpBModemenu);
            app.component.CalibrationBModemenu.Text = 'Calibration of B-mode';
            app.component.CalibrationBModemenu.MenuSelectedFcn =createCallbackFcn(app, @SetUpBMode, true);

            % Tracking tools
            app.component.TrackinPointgmenu = uimenu(app.component.Bmodemenu);
            app.component.TrackinPointgmenu.Text = 'Tracking';

            % Tracking tools
            app.component.TrackinManualgmenu = uimenu(app.component.TrackinPointgmenu);
            app.component.TrackinManualgmenu.Text = 'Manual';
            app.component.TrackinManualgmenu.MenuSelectedFcn =createCallbackFcn(app, @Tracking_point, true);

            % Tracking tools
            app.component.TrackinSemiAutomaticgmenu = uimenu(app.component.TrackinPointgmenu);
            app.component.TrackinSemiAutomaticgmenu.Text = 'Semi automatic';
            app.component.TrackinSemiAutomaticgmenu.MenuSelectedFcn =createCallbackFcn(app, @Tracking_point, true);

            % set mkrOptions
            app.component.mkrOptionsmenu = uimenu(app.component.TrackinPointgmenu);
            app.component.mkrOptionsmenu.Text = 'Options';
            app.component.mkrOptionsmenu.MenuSelectedFcn =createCallbackFcn(app, @mkrOptions, true);

            % delete markers
            app.component.mkrDeletemenu = uimenu(app.component.TrackinPointgmenu);
            app.component.mkrDeletemenu.Text = 'Delete';
            app.component.mkrDeletemenu.MenuSelectedFcn =createCallbackFcn(app, @mkrDelete, true);

            % Tracking filter
            app.component.TrackingFiltermenu = uimenu(app.component.Bmodemenu);
            app.component.TrackingFiltermenu.Text = 'Filter';
            %            app.component.TrackingFiltermenu =createCallbackFcn(app, @Filter, true);

            % Associate markers
            app.component.associateMkrmenu = uimenu(app.component.Bmodemenu);
            app.component.associateMkrmenu.Text = 'Associate markers';

            % set
            app.component.associateMkrSetmenu = uimenu(app.component.associateMkrmenu);
            app.component.associateMkrSetmenu.Text = 'Set';
            app.component.associateMkrSetmenu.MenuSelectedFcn =createCallbackFcn(app, @associateMkr, true);

            % delete
            app.component.associateMkrDeletemenu = uimenu(app.component.associateMkrmenu);
            app.component.associateMkrDeletemenu.Text = 'Delete';
            % app.component.associateMkrDeletemenu.MenuSelectedFcn =createCallbackFcn(app, @associateMkr, true);

            app.component.associateMkrOptionsmenu = uimenu(app.component.associateMkrmenu);
            app.component.associateMkrOptionsmenu.Text = 'Options';
            % app.component.associateMkrDeletemenu.MenuSelectedFcn =createCallbackFcn(app, @associateMkr, true);

            % advenced tools
            app.component.advencedToolsmenu = uimenu(app.component.Bmodemenu);
            app.component.advencedToolsmenu.Text = 'Advenced tools';

            % find intersect
            app.component.findIntersectmenu = uimenu(app.component.advencedToolsmenu);
            app.component.findIntersectmenu.Text = 'Find intersect';

            % angle between
            app.component.angleBetweenmenu = uimenu(app.component.advencedToolsmenu);
            app.component.angleBetweenmenu.Text = 'Angle between';

            % distance between
            app.component.distanceBetweenmenu = uimenu(app.component.advencedToolsmenu);
            app.component.distanceBetweenmenu.Text = 'Distance between';

            %%  MenuBar --> greylevel
            app.component.greyLevelmenu = uimenu(app.component.figure);
            app.component.greyLevelmenu.Text = 'Grey Level';

            % Set Up greylevel
            app.component.SetUpZoneOfInterestBModemenu = uimenu(app.component.greyLevelmenu);
            app.component.SetUpZoneOfInterestBModemenu.Text = 'Set zone of interest';

            % Set Up Square
            app.component.SetUpZoneOfInterestBModeSquaremenu = uimenu(app.component.SetUpZoneOfInterestBModemenu);
            app.component.SetUpZoneOfInterestBModeSquaremenu.Text = 'Square zone of interest';
            app.component.SetUpZoneOfInterestBModeSquaremenu.MenuSelectedFcn =createCallbackFcn(app, @setZoneOfInterestBmode, true);

            % Set Up Square
            app.component.SetUpZoneOfInterestBModeSquare1cmmenu = uimenu(app.component.SetUpZoneOfInterestBModemenu);
            app.component.SetUpZoneOfInterestBModeSquare1cmmenu.Text = 'Square 1cm^2 zone of interest';
            app.component.SetUpZoneOfInterestBModeSquare1cmmenu.MenuSelectedFcn =createCallbackFcn(app, @setZoneOfInterestBmode, true);

            % Set Up Square
            app.component.SetUpZoneOfInterestBModeCustummenu = uimenu(app.component.SetUpZoneOfInterestBModemenu);
            app.component.SetUpZoneOfInterestBModeCustummenu.Text = 'Custum zone of interest';
            app.component.SetUpZoneOfInterestBModeCustummenu.MenuSelectedFcn =createCallbackFcn(app, @setZoneOfInterestBmode, true);

            % Calcualtion Pipline
            app.component.greyLevelCaluculationmenu = uimenu(app.component.greyLevelmenu);
            app.component.greyLevelCaluculationmenu.Text = 'Start grey level calculation';
            app.component.greyLevelCaluculationmenu.MenuSelectedFcn =createCallbackFcn(app, @Grey_Level_Calculation, true);

            % grey level illustration
            app.component.greyLevelIllustractionmenu = uimenu(app.component.greyLevelmenu);
            app.component.greyLevelIllustractionmenu.Text = 'grey level illustration';

            % Histogram
            app.component.greyLevelHistogrammenu = uimenu(app.component.greyLevelIllustractionmenu);
            app.component.greyLevelHistogrammenu.Text = 'Histogram';
            app.component.greyLevelHistogrammenu.MenuSelectedFcn =createCallbackFcn(app, @greyLevelillustration, true);

            % Temporal evolution
            app.component.greyLevelTemporalevolutionmenu = uimenu(app.component.greyLevelIllustractionmenu);
            app.component.greyLevelTemporalevolutionmenu.Text = 'Temporal evolution';
            app.component.greyLevelTemporalevolutionmenu.MenuSelectedFcn =createCallbackFcn(app, @greyLevelillustration, true);


            %%  MenuBar --> SWE
            app.component.SWEmenu = uimenu(app.component.figure);
            app.component.SWEmenu.Text = 'SWE';

            % Set Up SWE
            app.component.SetUpSWEmenu = uimenu(app.component.SWEmenu);
            app.component.SetUpSWEmenu.Text = 'Set SWE';

            % Set Up SWE Color Scale Value
            app.component.CalibrationSWEmenu = uimenu(app.component.SetUpSWEmenu);
            app.component.CalibrationSWEmenu.Text = 'Set color scale';
            app.component.CalibrationSWEmenu.MenuSelectedFcn =createCallbackFcn(app, @SWESetUp, true);

            % Set Up SWE Color Scale
            app.component.CalibrationSWEmenu1 = uimenu(app.component.SetUpSWEmenu);
            app.component.CalibrationSWEmenu1.Text = 'Set color scale value';
            app.component.CalibrationSWEmenu1.MenuSelectedFcn =createCallbackFcn(app, @SWESetUp, true);

            % Set Up SWE framerate
            app.component.FramerateSWEmenu= uimenu(app.component.SetUpSWEmenu);
            app.component.FramerateSWEmenu.Text = 'Set framerate';
            app.component.FramerateSWEmenu.MenuSelectedFcn =createCallbackFcn(app, @SWESetUp, true);

            % ShowSolorScale
            app.component.ShowSolorScalemenu = uimenu(app.component.SetUpSWEmenu);
            app.component.ShowSolorScalemenu.Text = 'Show color scale';
            app.component.ShowSolorScalemenu.MenuSelectedFcn =createCallbackFcn(app, @SWESetUp, true);

            % Set Up SWE
            app.component.SetUpShapemenu = uimenu(app.component.SWEmenu);
            app.component.SetUpShapemenu.Text = 'Set Shape';

            % Set Up Square
            app.component.ShapeSquaremenu = uimenu(app.component.SetUpShapemenu);
            app.component.ShapeSquaremenu.Text = 'Square shape';
            app.component.ShapeSquaremenu.MenuSelectedFcn =createCallbackFcn(app, @setShape, true);

            % Set Up Custum
            app.component.ShapeCustummenu = uimenu(app.component.SetUpShapemenu);
            app.component.ShapeCustummenu.Text = 'Custum shape';
            app.component.ShapeCustummenu.MenuSelectedFcn =createCallbackFcn(app, @setShape, true);

            % Set Up auto 1cm2
            app.component.ShapeAutomenu = uimenu(app.component.SetUpShapemenu);
            app.component.ShapeAutomenu.Text = 'Auto shape';
            app.component.ShapeAutomenu.MenuSelectedFcn =createCallbackFcn(app, @setShape, true);

            % Set Up 1cm2 square
            app.component.ShapeSquare1cm2menu = uimenu(app.component.SetUpShapemenu);
            app.component.ShapeSquare1cm2menu.Text = 'Square 1cm^2 shape';
            app.component.ShapeSquare1cm2menu.MenuSelectedFcn =createCallbackFcn(app, @setShape, true);

            % Set Up all
            app.component.ShapeAllmenu = uimenu(app.component.SetUpShapemenu);
            app.component.ShapeAllmenu.Text = 'All color map';
            app.component.ShapeAllmenu.MenuSelectedFcn =createCallbackFcn(app, @setShape, true);

            % Calcualtion Pipline
            app.component.SWECaluculationmenu = uimenu(app.component.SWEmenu);
            app.component.SWECaluculationmenu.Text = 'Start SWE calculation';
            app.component.SWECaluculationmenu.MenuSelectedFcn =createCallbackFcn(app, @SWE_Calculation, true);

            % SWE illustration
            app.component.SWEIllustractionmenu = uimenu(app.component.SWEmenu);
            app.component.SWEIllustractionmenu.Text = 'SWE illustration';

            % Histogram
            app.component.Histogrammenu = uimenu(app.component.SWEIllustractionmenu);
            app.component.Histogrammenu.Text = 'Histogram';
            app.component.Histogrammenu.MenuSelectedFcn =createCallbackFcn(app, @SWEillustration, true);

            % Temporal evolution
            app.component.Temporalevolutionmenu = uimenu(app.component.SWEIllustractionmenu);
            app.component.Temporalevolutionmenu.Text = 'Temporal evolution';
            app.component.Temporalevolutionmenu.MenuSelectedFcn =createCallbackFcn(app, @SWEillustration, true);


            %% MenuBar --> Help
            app.component.Helpmenu = uimenu(app.component.figure);
            app.component.Helpmenu.Text = 'Help';
            % Set
            app.component.Documentation = uimenu(app.component.Helpmenu);
            app.component.Documentation.Text = 'Documentation';

            %% Image IRISSE
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            app.component.Image = uiimage(app.component.figure);
            app.component.Image.Position = [10 5 200 70];
            app.component.Image.HorizontalAlignment = 'center';
            app.component.Image.ImageSource = [app.general.path.Icons, '\IRISSE_Lab.jpg'];
            app.component.Image.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.component.Image.ScaleMethod = 'fit';

            %% Video_label
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            app.component.Vlabel = uilabel(app.component.figure);
            app.component.Vlabel.BackgroundColor = [0.94,0.94,0.94];
            app.component.Vlabel.HorizontalAlignment = 'center';
            app.component.Vlabel.VerticalAlignment = 'center';
            app.component.Vlabel.FontName = 'Times New Roman';
            app.component.Vlabel.FontSize = 15;
            app.component.Vlabel.FontWeight = 'bold';
            app.component.Vlabel.Position(1:2) = [10 700];
            app.component.Vlabel.Position(3:4) = [200 30];
            app.component.Vlabel.Text = 'Video name';

            %% Video ListBox
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            app.component.Vlist = uilistbox(app.component.figure);
            app.component.Vlist.Items = {'none'};
            app.component.Vlist.Position(1:2) = [10 300];
            app.component.Vlist.Position(3:4) = [200 400];
            app.component.Vlist.Value = 'none';
            app.component.Vlist.Enable = 'off';
            app.component.Vlist.ValueChangedFcn = createCallbackFcn(app, @VideoChange, true);

            %% Axes
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            app.component.Axes = uiaxes(app.component.figure);
            app.component.Axes.XTick = [];
            app.component.Axes.YTick = [];
            app.component.Axes.Color = 'none';
            app.component.Axes.Box = 'on';
            app.component.Axes.Position(1:2) = [320 100];
            app.component.Axes.Position(3:4) = [1280 720] .*0.7;
            app.component.Axes.Toolbar.Visible = 'off';

            %% Slider
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            app.component.Slider = uislider(app.component.figure);
            app.component.Slider.MajorTicks = [];
            app.component.Slider.MinorTicks = [];
            app.component.Slider.Enable = 'off';
            app.component.Slider.Position(1:2) = [320 90];
            app.component.Slider.Position(3:4) = [1280 720] .*0.7;

            %% Button player
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Backward
            app.component.Backward =  uibutton(app.component.figure);
            app.component.Backward.Position = [550 30 120 40];
            app.component.Backward.Text = '';
            app.component.Backward.Icon = [app.general.path.Icons , '\backward_btn.jpg'];
            app.component.Backward.IconAlignment = 'center';
            app.component.Backward.BackgroundColor = [1 1 1];
            app.component.Backward.ButtonPushedFcn = createCallbackFcn(app, @BackwardButton, true);
            app.component.Backward.Enable = 'off';

            % Play
            app.component.Play = uibutton(app.component.figure);
            app.component.Play.Position = [750 30 120 40];
            app.component.Play.Text = '';
            app.component.Play.Icon = [app.general.path.Icons , '\play_btn.jpg'];
            app.component.Play.IconAlignment = 'center';
            app.component.Play.BackgroundColor = [1 1 1];
            app.component.Play.Enable = 'off';
            app.component.Play.ButtonPushedFcn = createCallbackFcn(app, @PlayButton, true);

            % Forward
            app.component.Forward = uibutton(app.component.figure);
            app.component.Forward.Position = [950 30 120 40];
            app.component.Forward.Text = '';
            app.component.Forward.Icon = [app.general.path.Icons, '\forward_btn.jpg'];
            app.component.Forward.IconAlignment = 'center';
            app.component.Forward.BackgroundColor = [1 1 1];
            app.component.Forward.ButtonPushedFcn = createCallbackFcn(app, @ForwardButton, true);
            app.component.Forward.Enable = 'off';

            %% table
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            app.component.Table = uitable(app.component.figure);
            app.component.Table.ColumnName = {'frame'; 'time'; 'none'; 'none'};
            app.component.Table.RowName = {};
            app.component.Table.Position = [1000 150 300 500];
            app.component.Table.Enable = 'off';
            app.component.Table.Visible = "off";
            %% show figure
            app.component.figure.WindowState = 'maximize' ;
            app.component.Figure.Visible = "on" ;


        end

        %% SetApp (ok)
        function SetApp(app)
            %% Axes
            Set_Axes(app)
            %% Slider
            Set_Slider(app)
        end

        %% Set_Axes (ok)
        function Set_Axes(app)
            displayFrame(app)
            app.component.Axes.XLim = [0 app.video(app.variables.videoindex).videoObject.Width];
            app.component.Axes.YLim = [0 app.video(app.variables.videoindex).videoObject.Height];
        end

        %% Set_Slider (ok)
        function Set_Slider(app)
            app.component.Slider.Limits = [0 app.video(app.variables.videoindex).videoObject.Duration];
            app.component.Slider.MinorTicks = 0 : 0.5 : app.video(app.variables.videoindex).videoObject.Duration;
            app.component.Slider.MajorTicks = 0  : app.video(app.variables.videoindex).videoObject.Duration : app.video(app.variables.videoindex).videoObject.Duration;
        end
    end

    %% Callbacks
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        %% ImageClicked (ok)
        function ImageClicked(~,~)
            url = 'https://irisse.univ-reunion.fr/';
            web(url);
            url2 ='https://www.researchgate.net/profile/Antoine-Mariani';
            web(url2);
        end

        %% PlayButton (ok)
        function PlayButton(app,~)
            displayFrame(app)
            for i = app.variables.frameindex : 2 : app.video(app.variables.videoindex).videoObject.NumFrames
                displayFrame(app)
                app.component.Slider.Value = (i / app.video(app.variables.videoindex).videoObject.NumFrames) * app.video(app.variables.videoindex).videoObject.Duration ;
                pause(1/app.video(app.variables.videoindex).videoObject.FrameRate)
                app.variables.frameindex = app.variables.frameindex+1;
            end
            app.variables.frameindex =1;
            app.component.Slider.Value = 0 ;
            displayFrame(app)
        end

        %% ForwardButton (ok)
        function ForwardButton(app,~)
            if app.variables.frameindex  == app.video(app.variables.videoindex).videoObject.NumFrames
                app.variables.frameindex = 1;
            elseif app.variables.frameindex >= app.video(app.variables.videoindex).videoObject.NumFrames
                app.CurrentImg = 1;
            else
                app.variables.frameindex = app.variables.frameindex +1 ;
            end
            displayFrame(app)
            app.component.Slider.Value = (app.variables.frameindex/ app.video(app.variables.videoindex).videoObject.NumFrames) * app.video(app.variables.videoindex).videoObject.Duration ;
        end

        %% BackwardButton (ok)
        function BackwardButton(app,~)
            if app.variables.frameindex  == 1
                app.variables.frameindex = app.video(app.variables.videoindex).videoObject.NumFrames;
            elseif app.variables.frameindex >= app.video(app.variables.videoindex).videoObject.NumFrames
                app.variables.frameindex = app.variables.frameindex - 1 ;
            else
                app.variables.frameindex = app.variables.frameindex - 1 ;
            end
            displayFrame(app)
            app.component.Slider.Value = (app.variables.frameindex/ app.video(app.variables.videoindex).videoObject.NumFrames) * app.video(app.variables.videoindex).videoObject.Duration ;
        end

        %% displayFrame (ok)
        function displayFrame(app)
            currentFrame = app.variables.frameindex;
            cla(app.component.Axes)
            image(app.component.Axes,app.video(app.variables.videoindex).frame{currentFrame});
            hold(app.component.Axes,'on')


            if ~isempty(app.video(app.variables.videoindex).memory_tracking)
                % tracking point
                try
                    for ii = 1 : size(app.video(app.variables.videoindex).memory_tracking.mkrTracked,2)
                        plot(app.component.Axes, ...
                            app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).col(currentFrame), ...
                            app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).row(currentFrame), ...
                            'Color',app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).color, ...
                            'Marker',app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).marker,...
                            'MarkerSize',app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).markerSize)
                        text(app.component.Axes,...
                            app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).col(currentFrame), ...
                            app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).row(currentFrame)-30, ...
                            app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).mkrName,...
                            'Color',app.video(app.variables.videoindex).memory_tracking.mkrTracked(ii).color,...
                            'FontSize',16,...
                            'HorizontalAlignment','left',...
                            'FontWeight','bold')
                    end
                catch
                end
            end


            if ~isempty(app.video(app.variables.videoindex).memory_fitting)
                % tracking point
                try
                    for ii = 1 : size(app.video(app.variables.videoindex).memory_fitting.funTracked,2)
                        lineQuality = 5;
                        linePlot = app.video(app.variables.videoindex).memory_fitting.funTracked(ii).limInf : lineQuality : app.video(app.variables.videoindex).memory_fitting.funTracked(ii).limSup ;

                        plot(app.component.Axes, ...
                            linePlot, ...
                            app.video(app.variables.videoindex).memory_fitting.funTracked(ii).fun(currentFrame).frame(linePlot), ...
                            'Color',app.video(app.variables.videoindex).memory_fitting.funTracked(ii).color, ...
                            'lineStyle',app.video(app.variables.videoindex).memory_fitting.funTracked(ii).lineStyle,...
                            'lineWidth',app.video(app.variables.videoindex).memory_fitting.funTracked(ii).lineWidth)

                        text(app.component.Axes,...
                            mean(linePlot), ...
                            mean(app.video(app.variables.videoindex).memory_fitting.funTracked(ii).fun(currentFrame).frame(linePlot))+ 30, ...
                            app.video(app.variables.videoindex).memory_fitting.funTracked(ii).name,...
                            'Color',app.video(app.variables.videoindex).memory_fitting.funTracked(ii).color,...
                            'FontSize',16,...
                            'HorizontalAlignment','left',...
                            'FontWeight','bold')
                    end
                catch
                end
            end
        end

        %% VideoChange (OK)
        function VideoChange(app,event)
            app.variables.videoindex = find(string(event.Value) == string(app.component.Vlist.Items)) ;
            SetApp(app);
        end

        %% Menu bar callbacks
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% loadfiles (ok)
        function loadfiles(app,~)
            app.video = [] ;
            try
                app.video = app.general.fun.uiGetVideo();
            catch M
                disp(M)
                app.video = [];
            end
            if ~isempty(app.video)
                for i = 1 : length(app.video)
                    app.video(i).memory_tracking = [];
                    app.video(i).memory_SWE = [];
                    app.video(i).memory_grey_level = [];
                    app.video(i).memory_fitting = [];
                    app.video(i).memory_processing = [];
                end

                app.variables.videoindex = 1;
                app.variables.frameindex = 1;
                SetApp(app)

                if isempty(app.video)
                    app.component.Backward.Enable = "off";
                    app.component.Forward.Enable = "off";
                    app.component.Play.Enable = "off";
                    app.component.Table.Enable = "off";
                    app.component.View.Enable = "off";
                    app.component.Vlist.Enable = "off";
                    app.component.Vlist.Items = {'none'};
                else
                    app.component.Backward.Enable = "on";
                    app.component.Forward.Enable = "on";
                    app.component.Play.Enable = "on";
                    app.component.Table.Enable = "on";
                    app.component.View.Enable = "on";
                    app.component.Vlist.Enable = "on";
                    app.component.Vlist.Items = {app.video.name};
                end
            end
        end

        %% export (ok)
        function export(app,~)
            nVideo = size(app.video,2);
            %% export for SWE
            %%%%%%%%%%%%%%%%%%
            cd(app.general.path.General)
            for i= 1 : nVideo
                saveName  = string([app.video(i).name(1:end-4),'_results.mat']) ;
                swe = []; tracking = []; grey_level = []; fitting = [];
                if ~isempty(app.video(i).memory_SWE)
                    swe = app.video(i).memory_SWE;
                end
                if ~isempty(app.video(i).memory_tracking)
                    tracking = app.video(i).memory_tracking;
                end
                if ~isempty(app.video(i).memory_fitting)
                    fitting = app.video(i).memory_fitting;
                end
                if ~isempty(app.video(i).memory_grey_level)
                    grey_level = app.video(i).memory_grey_level;
                end

                save(saveName,"swe","tracking","grey_level","fitting",'-mat')
            end
            cd(app.general.path.App)
        end

        %% export scaling
        function exportscaling(app,~)
            nVideo = size(app.video,2);
            %% export prescale
            %%%%%%%%%%%%%%%%%%
            cd(app.general.path.General)
            for i = 1 : nVideo
                preScale = [];
                saveName  = string([app.video(i).name(1:end-4),'.mat']) ;

                preScale.name = app.video(i).name;
                preScale.path = app.video(i).path;

                preScale.time.Bmode = app.video(i).time.Bmode;
                preScale.coef.x = app.video(i).coef.x; % col factor
                preScale.coef.y = app.video(i).coef.y; % row factor

                try
                    preScale.time.SWE = app.video(i).time.SWE;
                    preScale.time.SWindex = app.video(i).time.SWindex;
                    preScale.colorScale.colorScaleRGBuint8 = app.video(i).colorScale.colorScaleRGBuint8;
                    preScale.colorScale.colorScaleRGBdouble = app.video(i).colorScale.colorScaleRGBdouble;
                    preScale.colorScale.colorScaleValue = app.video(i).colorScale.colorScaleValue;

                catch M
                    preScale.colorScale = "None";
                end

                % about zone of interest Bmode
                try
                    preScale.zoneOfInterestBMode = app.video(i).ZoneOfInterestBmode;
                catch M
                    preScale.zoneOfInterestBMode = "None";
                end

                % about zone of interest swe
                try
                    preScale.zoneOfInterestSWE = app.video(i).Shape;
                catch M
                    preScale.zoneOfInterestSWE = "None";
                end
                % save
                save(saveName,"preScale",'-mat')
            end
            cd(app.general.path.App)
        end

        %% setShape
        function setShape(app,event)
            if isempty (app.video(app.variables.videoindex).colorScale) % no video import / impossible
                errordlg('You have to import video before','unavailable process')
            else
                if string(event.Source.Text)  == "Custum shape"
                    Shape = app.general.fun.setCustumShape(app.video(app.variables.videoindex).frame{1});
                    app.video(app.variables.videoindex).Shape = Shape;
                elseif string(event.Source.Text)  == "Square shape"
                    Shape = app.general.fun.setSquareShape(app.video(app.variables.videoindex).frame{1});
                    app.video(app.variables.videoindex).Shape = Shape;
                elseif string(event.Source.Text)  == "Auto shape"
                    Shape = app.general.fun.autoShape(app.video(app.variables.videoindex).frame{1},app.video(app.variables.videoindex).coef);
                    app.video(app.variables.videoindex).Shape = Shape;
                    app.general.fun.displayShape(app.video(app.variables.videoindex).frame{1},Shape)
                elseif string(event.Source.Text)  == "Square 1cm^2 shape"
                    Shape = app.general.fun.setSquareShapeCm(app.video(app.variables.videoindex).frame{1},app.video(app.variables.videoindex).coef,1);
                    app.video(app.variables.videoindex).Shape = Shape;
                    app.general.fun.displayShape(app.video(app.variables.videoindex).frame{1},Shape)
                elseif string(event.Source.Text)  == "All color map"
                    Shape = app.general.fun.allShape(app.video(app.variables.videoindex).frame{1});
                    app.video(app.variables.videoindex).Shape = Shape;
                    app.general.fun.displayShape(app.video(app.variables.videoindex).frame{1},Shape)
                end
            end
        end

        %% setZoneOfInterestBmode
        function setZoneOfInterestBmode(app,event)
            if isempty(app.video) % no video import / impossible
                errordlg('You have to import video before','unavailable process')
            else
                if string(event.Source.Text)  == "Custum zone of interest"
                    Shape = app.general.fun.setCustumShape(app.video(app.variables.videoindex).frame{1});
                    app.video(app.variables.videoindex).ZoneOfInterestBmode = Shape;
                elseif string(event.Source.Text)  == "Square zone of interest"
                    Shape = app.general.fun.setSquareShape(app.video(app.variables.videoindex).frame{1});
                    app.video(app.variables.videoindex).ZoneOfInterestBmode = Shape;
                elseif string(event.Source.Text)  == "Square 1cm^2 zone of interest"
                    Shape = app.general.fun.setSquareShapeCm(app.video(app.variables.videoindex).frame{1},app.video(app.variables.videoindex).coef,1);
                    app.video(app.variables.videoindex).ZoneOfInterestBmode = Shape;
                    app.general.fun.displayShape(app.video(app.variables.videoindex).frame{1},Shape)
                end
            end
        end

        %% SetUpBMode (OK)
        function SetUpBMode(app,~)
            if isempty (app.video) % no video import / impossible
                errordlg('You have to import video before','unavailable process')
            else
                [coef_x,coef_y] = app.general.fun.scaleImage(app.video(app.variables.videoindex).frame);
                app.video(app.variables.videoindex).coef.x = coef_x;
                app.video(app.variables.videoindex).coef.y = coef_y;
                app.video(app.variables.videoindex).memory_tracking = [];
                app.video(app.variables.videoindex).memory_SWE = [];
                app.video(app.variables.videoindex).memory_grey_level = [];
                app.video(app.variables.videoindex).memory_processing = [] ;
            end
        end

        %% Tracking_point (ok)
        function Tracking_point(app,event)
            try
                nbmkr = size(app.video(app.variables.videoindex).memory_tracking.mkrTracked,2) ;
                nbmkr = nbmkr+1;
            catch
                nbmkr = 1;
            end

            try
                if string(event.Source.Text)  == "Manual"
                    [rateOfChange] =  setRateOfChange(app.video(app.variables.videoindex).videoObject.NumFrames);
                    [row_,col_] = app.general.fun.manualTracking(app.video(app.variables.videoindex).frame,rateOfChange);
                elseif string(event.Source.Text)  == "Semi automatic"
                    [row_,col_] = app.general.fun.uiTracking(app.video(app.variables.videoindex).frame);
                end

                %% add to memory
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).row=row_;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).col=col_;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).y=row_ .* app.video(app.variables.videoindex).coef.y;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).x=col_ .* app.video(app.variables.videoindex).coef.x;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).color='y';
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).marker='s';
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).markerSize=8;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).mkrName=['no name ',num2str(nbmkr)];
            catch
                errordlg('You have to import video first','error')
            end
        end

        %% mkrOptions
        function mkrOptions(app,~)
            if isempty(app.video)
                errordlg('You have to import a video before', 'Error')
            else
                if isempty(app.video(app.variables.videoindex).memory_tracking) % is there a r a video selected
                    errordlg('You have to track markers before a video before', 'Error')
                else
                    app.video(app.variables.videoindex).memory_tracking = app.general.fun.editMarker(app.video(app.variables.videoindex).memory_tracking);
                end
            end
        end

                %% mkrOptions
        function mkrDelete(app,~)
            if isempty(app.video)
                errordlg('You have to import a video before', 'Error')
            else
                if isempty(app.video(app.variables.videoindex).memory_tracking) % is there a r a video selected
                    errordlg('You have to track markers before a video before', 'Error')
                else
                    app.video(app.variables.videoindex).memory_tracking = app.general.fun.deleteMarker(app.video(app.variables.videoindex).memory_tracking);
                end
            end
        end

        %% associateMkr
        function associateMkr(app,~)
            if isempty(app.video)
                errordlg('You have to import a video before', 'Error')
            else
                if size(app.video(app.variables.videoindex).memory_tracking,2)>2 % is there a r a video selected
                    errordlg('You have to track at list two markers before', 'Error')
                else
                    if isempty(app.video(app.variables.videoindex).memory_fitting)
                        nbfitting = 1;
                    else
                        nbfitting = size(app.video(app.variables.videoindex).memory_fitting.funTracked,2) + 1;
                    end

                    funTracked = app.general.fun.associateMkr(app.video(app.variables.videoindex).frame,app.video(app.variables.videoindex).memory_tracking);
                    if ~isempty(funTracked)
                        app.video(app.variables.videoindex).memory_fitting.funTracked(nbfitting) = funTracked;
                    end
                end
            end
        end

        %% function Pipline
        function Pipline(app,event)
            if isempty(app.video(app.variables.videoindex).memory_tracking) % is there a r a video selected
                errordlg('You have to import a video before', 'Error')
            else
                if string(event.Source.Text)  == "Structure"
                    disp('L 478')

                    app.general.fun.structure(app.video,app.variables.videoindex)

                elseif string(event.Source.Text)  == "Angle"
                    app.video(app.variables.videoindex).memory_tracking
                end
            end
        end

        %% SWESetUp
        function SWESetUp(app,event)
            try

                if isempty(app.video(app.variables.videoindex).colorScale)
                    errordlg('Video selected must contain SWE')
                else
                    if string(event.Source.Text)  == "Set color scale"
                        disp(' Tu dois le refaire - ligne 510 function "pipline"')
                        %                         temp = app.general.fun.SetManualColorScale(app.video, app.variables.videoindex);
                        %                         app.video(app.variables.videoindex) =temp(app.variables.videoindex);

                    elseif string(event.Source.Text)  == "Set color scale value"
                        [colorScaleValue] = app.general.fun.setColorscaleValue(app.video(app.variables.videoindex).colorScale.colorScaleRGBuint8,...
                            app.video(app.variables.videoindex).colorScale.colorScaleRGBdouble);
                        app.video(app.variables.videoindex).colorScale.colorScaleValue = colorScaleValue;

                    elseif string(event.Source.Text)  == "Set framerate" % set SWE frame rate
                        [timeSWE,indexImgSWE] = app.general.fun.setSSIFrameRate(app.video(app.variables.videoindex).frame,...
                            app.video(app.variables.videoindex).time.Bmode);
                        app.video(app.variables.videoindex).time.SWE = timeSWE;
                        app.video(app.variables.videoindex).time.SWindex = indexImgSWE;

                    elseif string(event.Source.Text)  == "Show color scale"
                        app.general.fun.ShowColorScale(app.video(app.variables.videoindex).colorScale.colorScaleRGBuint8,...
                            app.video(app.variables.videoindex).colorScale.colorScaleValue);
                    end
                end
            catch
                errordlg('Import Video first')
            end
        end

        %% SWE_Calculation
        function SWE_Calculation(app,~)
            try
                results = app.general.fun.colorCalculation(app.video(app.variables.videoindex).frame, ...
                    app.video(app.variables.videoindex).time.SWindex, ...
                    app.video(app.variables.videoindex).colorScale.colorScaleRGBdouble, ...
                    app.video(app.variables.videoindex).colorScale.colorScaleValue, ...
                    app.video(app.variables.videoindex).coef, ...
                    app.video(app.variables.videoindex).Shape,...
                    app.video(app.variables.videoindex).time.Bmode);

                results.time = app.video(app.variables.videoindex).time.Bmode;
                app.video(app.variables.videoindex).memory_SWE = results;
            catch
                errordlg('Video selected must contain SWE and shape must be set')
            end
        end

        %% SWEillustration
        function SWEillustration(app,event)
            try
                isempty(app.video(app.variables.videoindex).memory_SWE); % SWE?
                % action Set frame rate

                if string(event.Source.Text)  == "Histogram"
                    app.general.fun.uiColorHistogram(app.video,...
                        app.variables.videoindex,...
                        app.video(app.variables.videoindex).memory_SWE)
                elseif string(event.Source.Text)  == "Temporal evolution"
                    app.general.fun.figureShearTemporalEvolution(app.video(app.variables.videoindex).memory_SWE)

                end
            catch
                errordlg('Caluclaton process of SWE is not done yet')
            end
        end


        %% Grey_Level_Calculation
        function Grey_Level_Calculation(app,~)
            try
                results = app.general.fun.greyCalculation(app.video(app.variables.videoindex).frame, ...
                    1 : app.video(app.variables.videoindex).videoObject.NumFrames, ...
                    app.video(app.variables.videoindex).coef, ...
                    app.video(app.variables.videoindex).ZoneOfInterestBmode,...
                    app.video(app.variables.videoindex).time.Bmode);

                results.time = app.video(app.variables.videoindex).time.Bmode;
                app.video(app.variables.videoindex).memory_grey_level = results;
            catch
                errordlg('Video selected must contain SWE and shape must be set')
            end
        end

        %% greyLevelillustration
        function greyLevelillustration(app,event)
            try
                isempty(app.video(app.variables.videoindex).memory_grey_level); % SWE?
                % action Set frame rate

                if string(event.Source.Text)  == "Histogram"
                    app.general.fun.figureFrameGreyHistogram(1,app.video(app.variables.videoindex).memory_grey_level)
                elseif string(event.Source.Text)  == "Temporal evolution"
                    app.general.fun.figureGreyTemporalEvolution(app.video(app.variables.videoindex).memory_grey_level)

                end
            catch
                errordlg('Caluclaton process of SWE is not done yet')
            end
        end

    end




    %% App creation and deletion (ok)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = public)
        % Construct app
        function app = App_Echo

            %% Path set up
            app.general.path.App = cd;
            app.general.path.General = app.general.path.App (1 : end-10);
            app.general.path.Icons =  [app.general.path.General, '\icons'];
            app.general.path.Fun =  [app.general.path.General, '\fun'];

            cd(app.general.path.Fun)
            app.general.fun = loadFunctions(app.general.path.Fun);
            cd(app.general.path.App)

            % Create UIFigure and components
            addpath(app.general.path.Fun)

            SetFigure(app)

            if nargout == 0
                clear app
            end
        end
        %% delete app
        function delete(app)
            path = app.general.path.General ;
            delete(app)
            cd(path)
        end
    end

end