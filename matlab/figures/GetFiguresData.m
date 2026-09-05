% Save open figures to file, Type is SEH, PSSHI or SSSHI from main.m

if CrossCircuitType == "BJT"
    Type = CrossCircuitType + '-' + 'PSSHI'
end

figureFolder = 'figures/' + Type + '/figs'; 
saveToFile = true;

% Save figure X,Y data to mat file
dataFolder = 'figures/' + Type + '/all_figures_data.mat';

% 1. Find all currently open figures
figHandles = findall(groot, 'Type', 'figure');

% 2. Fallback to saved .fig files if no open figures are found
if isempty(figHandles)
    fprintf('No open figures found. Searching for .fig files in %s...\n', figureFolder);
    
    figFiles = dir(fullfile(figureFolder, '*.fig'));
    if isempty(figFiles)
        error('No open figures or .fig files found in directory: %s', figureFolder);
    end
    
    % Open saved .fig files invisibly
    figHandles = gobjects(1, length(figFiles));
    for k = 1:length(figFiles)
        filePath = fullfile(figFiles(k).folder, figFiles(k).name);
        figHandles(k) = openfig(filePath, 'invisible');
    end
else
    fprintf('Extracting data from %d open figure(s)...\n', length(figHandles));
end

extractedData = struct();

for i = 1:length(figHandles)
    fig = figHandles(i);
    figName = matlab.lang.makeValidName(fig.Name);

    % Find graphics objects with X and Y data (lines, scatter, etc.)
    lines = findobj(fig, '-property', 'XData');

    for j = 1:length(lines)
        lineObj = lines(j);

        % Read series label/name if present
        displayName = lineObj.DisplayName;
        if isempty(displayName)
            displayName = sprintf('DataSeries_%d', j);
        else
            displayName = matlab.lang.makeValidName(displayName);
        end

        % Store X and Y vectors
        extractedData.(figName).(displayName).XData = get(lineObj, 'XData');
        extractedData.(figName).(displayName).YData = get(lineObj, 'YData');

        % Use the figure number as the filename
        if saveToFile
            FigName = num2str(get(fig, 'Number'));
            exportgraphics(fig, fullfile(figureFolder, strcat('Figure_', FigName, '.png')), 'Resolution', 300);
            savefig(fig, fullfile(figureFolder, strcat('Figure_', FigName, '.fig')));
        end

    end
    fprintf('Fig #%d, name: %s \n', i, figName);
end

% Save extracted plot data to a .mat file
save(dataFolder, 'extractedData');