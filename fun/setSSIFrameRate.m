function [timeSWE,indexImgSWE]= setSSIFrameRate(frames,timeBmode)
% set up
frSWE = 1;
currentFrame = 1;

% fig
fig = uifigure('Name', 'Set SWE frame rate', 'NumberTitle', 'off', 'Position', [100, 100, 1000, 500], 'Color',[1 1 1]);

% axis
ax = uiaxes(fig);
ax.XTick = [];
ax.YTick = [];
ax.Position = [0 .2 .7 .8].*[fig.Position(3) fig.Position(4) fig.Position(3) fig.Position(4)];
ax.Color = [0 0 0] ;

axesUpdate(ax,frames,currentFrame)

% Create edit boxes for numerical input
textBox1 = uilabel(fig);
textBox1.Text = "SWE's first changing frame";
textBox1.Position = [.72, .8, .26, 30].*[fig.Position(3) fig.Position(4) fig.Position(3) 1];
textBox1.HorizontalAlignment = "center";
textBox1.FontWeight = "bold";

editBox1 = uieditfield(fig, 'numeric');
editBox1.Position = [.72, .7, .26, 30].*[fig.Position(3) fig.Position(4) fig.Position(3) 1];
editBox1.FontSize = 12;
editBox1.Enable = "off";
editBox1.Value = currentFrame;

textBox2 = uilabel(fig);
textBox2.Text = "SWE's frame rate";
textBox2.Position = [.72, .5, .26, 30].*[fig.Position(3) fig.Position(4) fig.Position(3) 1];
textBox2.HorizontalAlignment = "center";
textBox2.FontWeight = "bold";

editBox2 = uieditfield(fig, 'numeric');
editBox2.Position = [.72, .4, .26, 30].*[fig.Position(3) fig.Position(4) fig.Position(3) 1];
editBox2.FontSize = 12;
editBox2.Value = frSWE;
editBox2.Limits = [0.0001 Inf];


% Create a button and set its callback function
btnResume = uibutton(fig);
btnResume.Position =[.72, .1, .26, 30].*[fig.Position(3) fig.Position(4) fig.Position(3) 1];
btnResume.BackgroundColor = [1 1 1];
btnResume.Text = "Set";
btnResume.FontWeight = "bold";
btnResume.ButtonPushedFcn = @(btn,event) resumeButton_callback(fig);


% Create a button and set its callback function
forwardButton = uibutton(fig);
forwardButton.Position =[.4, .05, .2, .1].*[fig.Position(3) fig.Position(4) fig.Position(3) fig.Position(4)];
forwardButton.BackgroundColor = [1 1 1];
forwardButton.Text = "forward";
forwardButton.ButtonPushedFcn = @(btn,event) forwardButton_callback(ax,frames,editBox1,timeBmode);


backwardButton = uibutton(fig);
backwardButton.Position =[.1, .05, .2, .1].*[fig.Position(3) fig.Position(4) fig.Position(3) fig.Position(4)];
backwardButton.BackgroundColor = [1 1 1];
backwardButton.Text = "backward";
backwardButton.ButtonPushedFcn = @(btn,event) backwardButton_callback(ax,frames,editBox1,timeBmode);

% wait
uiwait(fig)

currentFrame = editBox1.Value;
frSWE = editBox2.Value;

% output
timeFirstFrameSWE = timeBmode(currentFrame);
timeSWE = (timeFirstFrameSWE : 1/frSWE : max(timeBmode));
indexImgSWE = nan(1);
for i = 1 : length(timeSWE)
    indexImgSWE(i) = find(timeBmode >= timeSWE(i),1,'first');
end

close(fig)

% callback function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% forward
    function forwardButton_callback(ax,frames_,editBox1,timeBmode)
        if editBox1.Value == length(timeBmode)
            editBox1.Value = 1;
        else
            editBox1.Value = editBox1.Value+1;
        end
        axesUpdate(ax,frames_,editBox1.Value)
    end

%backward
    function backwardButton_callback(ax,frames_,editBox1,timeBmode)
        if editBox1.Value == 1
            editBox1.Value = length(timeBmode);
        else
            editBox1.Value = editBox1.Value-1;
        end
        axesUpdate(ax,frames_,editBox1.Value)
    end

%resume
    function resumeButton_callback(fig)
        uiresume(fig)
    end


    function axesUpdate(ax,frames_,framesIndex)
        cla(ax)
        ax.XTick = [];
        ax.YTick = [];
        image(ax,frames_{framesIndex})
    end
end