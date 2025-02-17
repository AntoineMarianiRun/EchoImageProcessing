function fun = loadFunctions(dirPath)
    % loadFunctions: Loads all MATLAB function files (.m) from a given directory
    % into a structure where field names are the function names and values are
    % the function handles.
    %
    % Input:
    %   dirPath - The path to the directory containing MATLAB function files (.m)
    %
    % Output:
    %   fun - Structure with function handles for each .m file in the directory.
    
    % Check if the directory exists
    if nargin < 1 || isempty(dirPath)
        dirPath = pwd; % Use current directory if no path is provided
    elseif ~isfolder(dirPath)
        error('The specified directory does not exist.');
    end

    % Get all .m files in the directory
    files = dir(fullfile(dirPath, '*.m'));
    
    % Initialize the output structure
    fun = struct();

    % Loop through each file
    for i = 1:length(files)
        % Get the full path of the file
        filePath = fullfile(files(i).folder, files(i).name);
        
        % Open the file and read the first few lines to check if it's a function
        fid = fopen(filePath, 'r');
        if fid == -1
            warning('Could not open file: %s', files(i).name);
            continue;
        end
        
        % Read the first line to check for 'function' keyword
        firstLine = fgetl(fid);
        fclose(fid);
        
        % Check if the file contains a function definition
        if contains(strtrim(firstLine), 'function')
            [~, functionName] = fileparts(files(i).name); % Get the function name without extension
            try
                fun.(functionName) = str2func(functionName); % Create function handle and store in structure
            catch ME
                warning('Could not load function: %s\nError: %s', functionName, ME.message);
            end
        end
    end
end