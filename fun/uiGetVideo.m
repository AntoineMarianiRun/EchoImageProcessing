function videoExported = uiGetVideo()
%UIGETVIDEO  Select and import one or more .avi videos through a modal UI.
%
%   videoExported = UIGETVIDEO() opens a modal dialog that lets the user
%   browse for video files, queue them in a list, clear the queue, and
%   import the queued files. The call blocks (uiwait) until the user either
%   imports the files or closes the window.
%
%   Output
%   ------
%   videoExported : struct array returned by importVideo(), one element per
%                   imported file. Returns [] if the user imports nothing.
%
%   Dependency
%   ----------
%   importVideo(path, name, parentFig) must be on the MATLAB path and must
%   return a struct (the .path field is used for the console summary).
%
%   Example
%   -------
%       vids = uiGetVideo();
%       if ~isempty(vids)
%           disp(vids(1).path);
%       end

    % ------------------------------------------------------------------ %
    %  Shared state (nested functions can read/write these variables)     %
    % ------------------------------------------------------------------ %
    video         = struct('path', {}, 'name', {});  % queued files (0x0)
    videoExported = [];                              % return value

    % ------------------------------------------------------------------ %
    %  Build the UI                                                        %
    % ------------------------------------------------------------------ %
    fig = uifigure('Name', 'Video import tool', ...
                   'Color', [1 1 1], ...
                   'WindowStyle', 'modal');
    fig.Position(3:4)   = [450 300];                 % [width height]
    fig.CloseRequestFcn = @onClose;

    bxl = uilistbox(fig, ...
        'Items',    {'Select your video files'}, ...
        'Position', [50 100 250 180]);

    btnSearch = uibutton(fig, 'push', ...
        'Text',            'Search video files', ...
        'Position',        [350 200 70 80], ...
        'ButtonPushedFcn', @onSearch);

    btnClear = uibutton(fig, 'push', ...
        'Text',            'Clear video files', ...
        'Enable',          'off', ...
        'Position',        [350 100 70 80], ...
        'ButtonPushedFcn', @onClear);

    btnLoad = uibutton(fig, 'push', ...
        'Text',            'Import video files', ...
        'Enable',          'off', ...
        'Position',        [125 50 200 22], ...
        'ButtonPushedFcn', @onLoad);

    % ------------------------------------------------------------------ %
    %  Block until the user is done, then report and clean up             %
    % ------------------------------------------------------------------ %
    uiwait(fig);

    if isempty(videoExported)
        disp('No video imported.');
    else
        for ii = 1:numel(videoExported)
            fprintf('Video "%s" imported to the workspace.\n', ...
                    videoExported(ii).path);
        end
    end

    if isvalid(fig)
        delete(fig);
    end

    % ================================================================== %
    %  Nested callbacks                                                   %
    % ================================================================== %

    function onSearch(~, ~)
        [files, pathname] = uigetfile( ...
            {'*.avi', 'Video (*.avi)'; '*.*', 'All files (*.*)'}, ...
            'Select your video(s)', 'MultiSelect', 'on');

        if isequal(files, 0)            % user cancelled the file dialog
            return
        end
        if ~iscell(files)               % single file -> normalise to cell
            files = {files};
        end

        base = numel(video);
        for k = 1:numel(files)
            video(base + k).path = fullfile(pathname, files{k}); %#ok<AGROW>
            video(base + k).name = files{k};
        end

        bxl.Items       = {video.path};
        btnClear.Enable = 'on';
        btnLoad.Enable  = 'on';
    end

    function onClear(~, ~)
        video           = struct('path', {}, 'name', {});
        bxl.Items       = {'Select your video files'};
        btnLoad.Enable  = 'off';
        btnClear.Enable = 'off';
    end

    function onLoad(~, ~)
        btnLoad.Enable   = 'off';
        btnClear.Enable  = 'off';
        btnSearch.Enable = 'off';

        nVideos = numel(video);
        for k = 1:nVideos
            v = importVideo(video(k).path, video(k).name, fig);
            if k == 1
                videoExported = repmat(v, 1, nVideos);  % preallocate
            end
            videoExported(k) = v;
        end

        uiresume(fig);
    end

    function onClose(~, ~)
        if ~isempty(video)
            sel = uiconfirm(fig, ...
                ['Some selected files have not been imported yet. ' ...
                 'Close anyway?'], 'Confirmation', ...
                'Options', {'Close', 'Cancel'}, ...
                'DefaultOption', 2, 'CancelOption', 2);
            if strcmp(sel, 'Cancel')
                return
            end
        end
        videoExported = [];     % nothing was imported
        uiresume(fig);          % let uiwait return; main body deletes fig
    end
end