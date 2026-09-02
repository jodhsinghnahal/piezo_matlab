clearvars -except Type; 
clc; close all;

s = settings;
s.matlab.appearance.figure.GraphicsTheme.TemporaryValue = 'light';

% Get figure data from file
matFile = 'figures/' + Type + '/all_figures_data.mat';

FigName = 'Single_Run_One_Cycle';

% Output regenerated figure
outputFolder = 'figures/' + Type + '/regen_figs/' + FigName;

% Output same regenerated figure to latex folder
outputFolder2 = '../../latex/figures/' + Type + '_' + FigName ;
scriptDir = fileparts(mfilename('fullpath'));
outputPath = fullfile(scriptDir, outputFolder2);

data = load(matFile);
jsonText = jsonencode(data, 'PrettyPrint', true);
% disp(jsonText)
fields = fieldnames(data.extractedData);
disp(fields);

% replace data.extractedData.* with whatever graph from the available fields
figData = data.extractedData.SingleRun_One_CycleAbsoluteWaveforms;

% Create figure with publication-ready dimensions
hFig = figure( ...
    'Units', 'inches', ...
    'Position', [1, 1, 5, 3], ...
    'WindowState', 'normal'); % piexel size = (width,height) inch * 300 DPI

set(hFig, 'Color', 'white');

hAx = axes('Parent', hFig);
hold(hAx, 'on');

colors = [
    0.0000 0.4500 0.7400  % Blue        (Simscape V_p)
    0.8500 0.1000 0.1000  % Red       (Simscape i_eq - Right Axis)
    0.0000 0.9500 0.1000  % Green 
    0.4940 0.1840 0.5560  % Purple       (V_p Fundamental)
    0.3010 0.7450 0.9330  % Cyan
    0.6350 0.0780 0.1840  % Maroon
    1.0000, 0.5000, 0.0000 % Orange     (Ideal Paper V_p)
    0.0000, 0.4000, 0.0500 % Dark Green
];

specs = [
    struct('key', 'SimscapeV_p', ...
           'label', 'Simscape $V_p$', ...
           'axis', 'left', ...
           'style', '-', ...
           'lw', 2.6, ...
           'color', colors(1,:), ...
           'scale', 1)

    struct('key', 'IdealPaperV_p', ...
           'label', 'Ideal paper $V_p$', ...
           'axis', 'left', ...
           'style', '--', ...
           'lw', 1.8, ...
           'color', colors(7,:), ...
           'scale', 1)

    struct('key', 'v__p_F_', ...
           'label', 'Fundamental $V_p$', ...
           'axis', 'left', ...
           'style', '--', ...
           'lw', 1.8, ...
           'color', colors(4,:), ...
           'scale', 1)

    struct('key', 'i__eq_', ...
           'label', 'Simscape $I_{eq}$', ...
           'axis', 'right', ...
           'style', '-', ...
           'lw', 2.0, ...
           'color', colors(2,:), ...
           'scale', 1e3)
];

H = gobjects(0);
labels = strings(0);

for i = 1:numel(specs)
    fieldName = specs(i).key;
    if ~isfield(figData, fieldName), continue; end

    trace = figData.(fieldName);
    yyaxis(hAx, specs(i).axis);

    % Apply unit scaling (e.g., convert A to mA for i_eq)
    yData = trace.YData * specs(i).scale;

    h = plot(hAx, trace.XData, yData, ...
    'LineStyle', specs(i).style, ...
    'LineWidth', specs(i).lw, ...
    'Color', specs(i).color, ...
    'Marker', 'none');

    % h = plot(hAx, trace.XData, yData, ...
    %         'LineStyle', specs(i).style, 'LineWidth', specs(i).lw, 'Color', specs(i).color, 'Marker', 'none');
    H(end + 1) = h;
    labels(end + 1) = specs(i).label;
end

% ----- Axis tick font size -----
tickFontSize  = 10;
labelFontSize = 12;

% Set tick-number font sizes
hAx.XAxis.FontSize = tickFontSize;
hAx.YAxis(1).FontSize = tickFontSize;
hAx.YAxis(2).FontSize = tickFontSize;

% ----- Axis labels -----
yyaxis(hAx, 'left');
ylLeft = ylabel(hAx, 'Voltage (V)', ...
    'Interpreter', 'tex');
set(hAx, 'YColor', 'k');

yyaxis(hAx, 'right');
ylRight = ylabel(hAx, 'Current (mA)', ...
    'Interpreter', 'tex');
set(hAx, 'YColor', 'k');

xl = xlabel(hAx, 'Time within one cycle (s)', ...
    'Interpreter', 'tex');

xEnd = max(figData.SimscapeV_p.XData);
disp(xEnd);

xlim(hAx, [0 xEnd]);

% IMPORTANT: set label font sizes AFTER tick font sizes
xl.FontSize      = labelFontSize;
ylLeft.FontSize  = labelFontSize;
ylRight.FontSize = labelFontSize;

% Configure grid
grid(hAx, 'on');
hAx.GridLineStyle = '--';
hAx.GridAlpha = 0.3;

% Configure box and spine visibility
box(hAx, 'on');
hAx.LineWidth = 0.75;

% Configure tick labels
set(hAx, 'TickLabelInterpreter', 'tex');

% Configure legend with professional styling
leg = legend(hAx, H, labels, 'Location', 'northeast', 'Interpreter', 'latex');
set(leg, 'Box', 'on', 'LineWidth', 0.5, 'FontSize', 10.5);

% Make legend line samples shorter
leg.ItemTokenSize = [12, 6];

drawnow;

% Position legend exactly against top-right axes border
leg.Units = 'normalized';
hAx.Units = 'normalized';

axPos  = hAx.Position;
legPos = leg.Position;

leg.Position = [ ...
    axPos(1) + axPos(3) - legPos(3) - 0.015, ... % flush right
    axPos(2) + axPos(4) - legPos(4) - 0.01, ... % flush top
    legPos(3), ...
    legPos(4)];

hold(hAx, 'off');

% Adjust layout to prevent label cutoff
set(hFig, 'PaperPositionMode', 'auto');

exportgraphics(hFig, outputFolder + '.png', ...
    'Resolution', 300);
exportgraphics(hFig, outputPath + '.png', ...
    'Resolution', 300);

% MATLAB figure
savefig(hFig, outputFolder + '.fig');

close all;