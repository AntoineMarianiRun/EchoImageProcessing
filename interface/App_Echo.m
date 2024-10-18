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
                app.component.TrackinPointgmenu.Text = 'Tracking point';
                app.component.TrackinPointgmenu.MenuSelectedFcn =createCallbackFcn(app, @Tracking_point, true);

            % Pipline 
            app.component.Piplinemenu = uimenu(app.component.Bmodemenu);
            app.component.Piplinemenu.Text = 'Pipline';
                % set SWE Frame rate  (SWEFramerate
                app.component.SWEFrameratemenu = uimenu(app.component.Piplinemenu);
                app.component.SWEFrameratemenu.Text = 'Angle';
                app.component.SWEFrameratemenu.MenuSelectedFcn =createCallbackFcn(app, @Pipline, true);
                % calculation SWE (SWEcalculation)
                app.component.SWEcalculationmenu = uimenu(app.component.Piplinemenu);
                app.component.SWEcalculationmenu.Text = 'Structure';
                app.component.SWEcalculationmenu.MenuSelectedFcn =createCallbackFcn(app, @Pipline, true);

            % Tracking filter 
            app.component.TrackingFiltermenu = uimenu(app.component.Bmodemenu);
            app.component.TrackingFiltermenu.Text = 'Filter';
%            app.component.TrackingFiltermenu =createCallbackFcn(app, @Filter, true);

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
                    end
                catch
                end

                % linear function 

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
                swe = []; tracking = [];
                if ~isempty(app.video(i).memory_SWE)
                    swe = app.video(i).memory_SWE;
                end
                if ~isempty(app.video(i).memory_tracking)
                    tracking = app.video(i).memory_tracking;
                end
                save(saveName,"swe","tracking",'-mat')
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
        
        %% SetUpBMode (OK)
        function SetUpBMode(app,~)
            if isempty (app.video) % no video import / impossible 
                errordlg('You have to import video before','unavailable process')                
            else 
                temp = app.general.fun.scalevideo(app.video,app.variables.videoindex) ; 
                app.video(app.variables.videoindex).coef = temp.coef; 
                app.video(app.variables.videoindex).memory_tracking = []; 
                app.video(app.variables.videoindex).memory_SWE = []; 
                app.video(app.variables.videoindex).memory_processing = [] ;
            end 
        end

        %% Tracking_point (ok)
        function Tracking_point(app,~)
            %% point name
            nbmkr = length(app.video(app.variables.videoindex).memory_tracking) ;
            nbmkr = nbmkr+1;
            [row_,col_] = app.general.fun.uiTracking(app.video(app.variables.videoindex).frame);
            if ~any(isnan(row_)) || ~any(isnan(col_))
                %% add to memory
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).row=row_;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).col=col_;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).y=row_ .* app.video(app.variables.videoindex).coef.y;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).x=col_ .* app.video(app.variables.videoindex).coef.x;
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).color='y';
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).marker='s';
                app.video(app.variables.videoindex).memory_tracking.mkrTracked(nbmkr).markerSize=8;
            end
        end

        %% function Pipline
        function Pipline(app,event)
            if isempty(app.video) % is there a r a video selected
                errordlg('You have to import a video before', 'Error')
            else
                if string(event.Source.Text)  == "Structure"
                    disp('L 478')
                    
                    app.general.fun.structure(app.video,app.variables.videoindex)
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