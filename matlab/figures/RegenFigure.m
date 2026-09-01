clearvars -except Type; 
clc; close all;

s = settings;
s.matlab.appearance.figure.GraphicsTheme.TemporaryValue = 'light';

% Get figure data from file
matFile = 'figures/' + Type + '/all_figures_data.mat';

% Output regenerated figure
outputFolder = 'figures/' + Type + '/regen_figs/';
FigName = 'SingleRun_One_Cycle';

data = load(matFile);
jsonText = jsonencode(data, 'PrettyPrint', true);
% disp(jsonText)
fields = fieldnames(data.extractedData);
disp(fields);

% replace data.extractedData.* with whatever graph from the available fields
figData = data.extractedData.SingleRun_One_CycleAbsoluteWaveforms;

% Create figure with publication-ready dimensions
% Typical column width for papers: ~3-3.5 inches (76-89 mm)
hFig = figure('Units', 'inches', 'Position', [1, 1, 4.5, 3.2]);
set(hFig, 'Color', 'white');

hAx = axes('Parent', hFig);
hold(hAx, 'on');

% Professional color scheme (distinguishable, print-friendly, no pure colors)
colors = [
    0.0000 0.4470 0.7410  % Blue
    0.6350 0.0780 0.1840  % Maroon/Dark Red
    0.2500 0.6000 0.2500  % Forest Green (not bright)
    0.8000 0.5000 0.0000  % Dark Orange
    0.4940 0.1840 0.5560  % Purple
    0.2000 0.5000 0.7000  % Teal
    0.7000 0.3000 0.4000  % Plum
];

% change specs accordingly with professional styling
specs = [
    struct('key', 'SimscapeV_p', 'label', 'Simscape $v_p$',    'axis', 'left',  'style', '-',  'lw', 2, 'color', colors(1, :))
    struct('key', 'IdealPaperV_p', 'label', 'Ideal paper $v_p$', 'axis', 'left',  'style', '--', 'lw', 2, 'color', colors(1, :))
    struct('key', 'v__p_F_',    'label', '$v_{p,Fundamental}$',         'axis', 'left',  'style', '--', 'lw', 2, 'color', colors(1, :))
    % struct('key', 'v__store_',  'label', '$v_{store}$',       'axis', 'left',  'style', '-', 'lw', 2, 'color', colors(3, :))
    struct('key', 'i__eq_',     'label', 'Simscape $i_{eq}$',          'axis', 'right', 'style', '-', 'lw', 2, 'color', colors(2, :))
    % struct('key', 'i__rect_',   'label', '$i_{rect}$',        'axis', 'right', 'style', '--', 'lw', 2, 'color', colors(4, :))
    % struct('key', 'i__piezo_',  'label', '$i_{piezo}$',       'axis', 'right', 'style', '-', 'lw', 2, 'color', colors(5, :))
];

H = gobjects(0);
labels = strings(0);

for i = 1:numel(specs)
    fieldName = specs(i).key;
    if ~isfield(figData, fieldName), continue; end

    trace = figData.(fieldName);
    yyaxis(hAx, specs(i).axis);

    h = plot(hAx, trace.XData, trace.YData, ...
            'LineStyle', specs(i).style, 'LineWidth', specs(i).lw, 'Color', specs(i).color, 'Marker', 'none');
    H(end + 1) = h;
    labels(end + 1) = specs(i).label;
end

yyaxis(hAx, 'left');
ylabel(hAx, 'Voltage (V)', 'Interpreter', 'tex');
set(hAx, 'YColor', 'k');

yyaxis(hAx, 'right');
ylabel(hAx, 'Current (A)', 'Interpreter', 'tex');
set(hAx, 'YColor', 'k');

% Set x-axis label
xlabel(hAx, 'Time within one cycle (s)', 'Interpreter', 'tex');

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
leg = legend(hAx, H, labels, 'Location', 'best', 'Interpreter', 'latex');
set(leg, 'Box', 'on', 'LineWidth', 0.75, 'FontSize', 11);

hold(hAx, 'off');

% Adjust layout to prevent label cutoff
set(hFig, 'PaperPositionMode', 'auto');

% Set global font size for the figure to match text font size
fontsize(hFig, 16, 'points');


% Export in publication quality (300 DPI is standard for journals)
exportgraphics(hFig, outputFolder + FigName + '.png', 'Resolution', 300);
% Also save as PDF for vector format (recommended for papers)
exportgraphics(hFig, outputFolder + FigName + '.pdf', 'Resolution', 300);
% Keep MATLAB figure format for future editing
savefig(hFig, outputFolder + FigName + '.fig');