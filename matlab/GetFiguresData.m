% Find all open figures
figHandles = findall(groot, 'Type', 'figure');

extractedData = struct();

for i = 1:length(figHandles)
    fig = figHandles(i);
    figName = sprintf('Figure_%d_%s', fig.Number, matlab.lang.makeValidName(fig.Name));

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

        % Store ZData if 3D
        if isprop(lineObj, 'ZData') && ~isempty(get(lineObj, 'ZData'))
            extractedData.(figName).(displayName).ZData = get(lineObj, 'ZData');
        end
    end
end

% Save extracted plot data to a .mat file
% save('all_figures_data.mat', 'extractedData');
save('Fig.mat', '-struct', 'extractedData', 'Figure_3_SingleRun_One_CycleAbsoluteWaveforms');