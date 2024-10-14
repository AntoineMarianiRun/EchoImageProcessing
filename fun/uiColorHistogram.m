    function uiColorHistogram(video,videoidx,results)
        %% UIinterface
        %%%%%%%%%%%%%%%
        % fig
        fig_Hist = uifigure;
        fig_Hist.Name = "plot Histogram of shear modulus";
        fig_Hist.Position(3:4) = [500, 250] ;
        fig_Hist.Color = [1 1 1] ;
        fig_Hist.MenuBar = "none";
        fig_Hist.WindowStyle = "modal";

        % slider
        Slider = uislider(fig_Hist);
        Slider.MajorTicks = 1 : 1 : length(video(videoidx).time.SWE);
        Slider.Limits = [1 length(video(videoidx).time.SWE)] ;
        Slider.Value = 1 ;
        Slider.Position = [50, 150, 400, 20] ;

        % text
        Text = uitextarea(fig_Hist);
        Text.Position =  [50, 200, 400, 30] ;
        Text.Enable = 'off' ;
        Text.Value = ['Current SWE frame :', num2str(Slider.Value)] ;
        Text.FontSize = 20 ;

        % button plot
        Button_plot = uibutton(fig_Hist);
        Button_plot.Text = 'Plot' ;
        Button_plot.Position =  [50, 50, 150, 40] ;

        % button quit
        Button_quit = uibutton(fig_Hist);
        Button_quit.Text = 'Quit' ;
        Button_quit.Position =  [300, 50, 150, 40] ;

        %callbacks
        Slider.ValueChangedFcn = @(Slider,event) slider_callback(Slider,Text);
        Button_plot.ButtonPushedFcn = @(btn,event) button_callback_plot(video, videoidx, Slider,results);
        Button_quit.ButtonPushedFcn = @(btn,event) button_callback_quit(fig_Hist, btn);

        uiwait(fig_Hist)
        close(fig_Hist)

        % Callback function
        %%%%%%%%%%%%%%%%%%%%
        % select frame
        function slider_callback(Slider,Text)
            val = round(Slider.Value);
            Slider.Value = val;
            Text.Value = ['Current SWE frame : ', num2str(val)] ;
        end
        % quit
        function button_callback_quit(fig_Hist, ~)
            uiresume(fig_Hist)
        end
        % plot
        function button_callback_plot(video, videoidx, Slider,results)
            figureFrameColorHistogram(video,...               % video
                videoidx,...                       % video selected
                round(Slider.Value),...            % image
                results);                          % results matrix
        end

    end

