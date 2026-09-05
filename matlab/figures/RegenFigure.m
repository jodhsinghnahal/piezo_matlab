clearvars -except Type Graph;
clc; close all;

% "Vp" or "Load"
% Graph = "Load";

s = settings;
s.matlab.appearance.figure.GraphicsTheme.TemporaryValue = 'light';

% Get figure data from file
matFile = 'figures/' + Type + '/all_figures_data.mat';

if Graph == "Load"
    FigName = 'Sweep_HarvestedPowerVsRload';
    figDataName = 'Sweep_HarvestedPowerVsRload';
else
    FigName = 'Single_Run_One_Cycle';
    figDataName = 'SingleRun_One_CycleAbsoluteWaveforms';
end

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

% Which graph to recreate.
figData = data.extractedData.(figDataName);

% Create figure with publication-ready dimensions
hFig = figure( ...
    'Units', 'inches', ...
    'Position', [1, 1, 5, 3], ...
    'WindowState', 'normal'); % piexel size = (width,height) inch * 300 DPI

set(hFig, 'Color', 'white');

hAx = axes('Parent', hFig);
hold(hAx, 'on');

colors = struct( ...
    'Blue', [0.0000 0.4500 0.7400], ...
    'Red', [0.8500 0.1000 0.1000], ...
    'Green', [0.0000 0.9500 0.1000], ...
    'Purple', [0.4940 0.1840 0.5560], ...
    'Cyan', [0.3010 0.7450 0.9330], ...
    'Maroon', [0.6350 0.0780 0.1840], ...
    'Orange', [1.0000 0.5000 0.0000], ...
    'DarkGreen', [0.0000 0.4000 0.0500]);

loadColors = struct( ...
    'Blue', [0.0000 0.2500 0.7500], ...
    'Purple', [0.4500 0.1000 0.6500], ...
    'Red', [0.8500 0.1000 0.0500], ...
    'Cyan', [0.0000 0.6000 0.7500], ...
    'Green', [0.0000 0.5500 0.3000], ...
    'Orange', [0.9000 0.4500 0.0000]);

if Graph == "Load"
    specs = [
    struct('key', 'ExtractedTime_domain_Mean_v_pI__eq__', ...
         'label', 'Extracted Power', ...
         'style', '-', ...
         'marker', 's', ...
         'lw', 2.6, ...
         'color', loadColors.Red, ...
         'scale', 1)

    struct('key', 'PaperEq_43', ...
         'label', 'Paper Eq. 43', ...
         'style', '--', ...
         'marker', '.', ...
         'lw', 2.2, ...
         'color', loadColors.Cyan, ...
         'scale', 1)

     struct('key', 'Harvested_load_Vstore_2_Rload', ...
         'label', 'Harvested Power$', ...
         'style', '-', ...
         'marker', 's', ...
         'lw', 2.6, ...
         'color', loadColors.Blue, ...
         'scale', 1)

    struct('key', 'PaperEq_42', ...
         'label', 'Paper Eq. 42', ...
         'style', '--', ...
         'marker', '.', ...
         'lw', 2.2, ...
         'color', loadColors.Orange, ...
         'scale', 1)

    %  struct('key', 'ExtractedFundamental', ...
    %      'label', 'Extracted fundamental', ...
    %      'style', '--', ...
    %      'marker', 'd', ...
    %      'lw', 1.5, ...
    %      'color', loadColors.Green, ...
    %      'scale', 1)

    %  struct('key', 'UnderwaterEq_29', ...
    %      'label', 'Underwater Eq. 29', ...
    %      'style', '--', ...
    %      'marker', '^', ...
    %      'lw', 1.5, ...
    %      'color', loadColors.Orange, ...
    %      'scale', 1)
    ];
else
    specs = [
    struct('key', 'SimscapeV_p', ...
           'label', 'Simscape $V_p$', ...
           'axis', 'left', ...
           'style', '-', ...
           'lw', 2.6, ...
           'color', colors.Blue, ...
           'scale', 1)

    struct('key', 'IdealPaperV_p', ...
           'label', 'Ideal paper $V_p$', ...
           'axis', 'left', ...
           'style', '--', ...
           'lw', 1.8, ...
           'color', colors.Orange, ...
           'scale', 1)

    struct('key', 'v__p_F_', ...
           'label', 'Fundamental $V_{p,F}$', ...
           'axis', 'left', ...
           'style', '--', ...
           'lw', 1.8, ...
           'color', colors.Purple, ...
           'scale', 1)

    struct('key', 'i__eq_', ...
           'label', 'Simscape $I_{eq}$', ...
           'axis', 'right', ...
           'style', '-', ...
           'lw', 2.0, ...
           'color', colors.Red, ...
           'scale', 1e3)
    ];
end

H = gobjects(0);
labels = strings(0);

for i = 1:numel(specs)
    fieldName = specs(i).key;
    if ~isfield(figData, fieldName), continue; end

    trace = figData.(fieldName);
    yData = trace.YData * specs(i).scale;
    

    if Graph == "Load"
        if specs(i).marker == '.'
            markersize = 15;
        else
            markersize = 5;
        end
        h = semilogx(hAx, trace.XData, yData, ...
            'LineStyle', specs(i).style, ...
            'LineWidth', specs(i).lw, ...
            'Color', specs(i).color, ...
            'Marker', specs(i).marker, ...
            'MarkerSize', markersize, ...
            'MarkerFaceColor', 'none', ...
            'MarkerEdgeColor', specs(i).color);
    else
        yyaxis(hAx, specs(i).axis);
        h = plot(hAx, trace.XData, yData, ...
            'LineStyle', specs(i).style, ...
            'LineWidth', specs(i).lw, ...
            'Color', specs(i).color, ...
            'Marker', 'none');
    end

    H(end + 1) = h;
    labels(end + 1) = specs(i).label;
end

% ----- Axis tick font size -----
tickFontSize  = 10;
labelFontSize = 11;

% Set tick-number font sizes
hAx.XAxis.FontSize = tickFontSize;
if Graph == "Load"
    hAx.YAxis.FontSize = tickFontSize;
else
    hAx.YAxis(1).FontSize = tickFontSize;
    hAx.YAxis(2).FontSize = tickFontSize;
end

% ----- Axis labels -----
if Graph == "Load"
    xLabelText = 'R_{load} (\Omega)';
else
    xLabelText = 'Time within one cycle (s)';
end

if Graph == "Load"
    ylLeft = ylabel(hAx, 'Power (mW)', 'Interpreter', 'tex');
    set(hAx, 'YColor', 'k');
else
    yyaxis(hAx, 'left');
    ylLeft = ylabel(hAx, 'Voltage (V)', 'Interpreter', 'tex');
    set(hAx, 'YColor', 'k');

    yyaxis(hAx, 'right');
    ylRight = ylabel(hAx, 'Current (mA)', 'Interpreter', 'tex');
    set(hAx, 'YColor', 'k');
end

xl = xlabel(hAx, xLabelText, ...
    'Interpreter', 'tex');

xData = figData.(specs(1).key).XData;
xlim(hAx, [min(xData) max(xData)]);
if Graph == "Load"
    hAx.XScale = 'log';
end

% IMPORTANT: set label font sizes AFTER tick font sizes
xl.FontSize      = labelFontSize;
ylLeft.FontSize  = labelFontSize;
if Graph ~= "Load"
    ylRight.FontSize = labelFontSize;
end

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
if Graph == "Load"
    legendFontSize = 9.5;
else
    legendFontSize = 10.5;
end
set(leg, 'Box', 'on', 'LineWidth', 0.5, 'FontSize', legendFontSize);

% Give load-plot line samples enough length to show dash patterns.
if Graph == "Load"
    leg.ItemTokenSize = [28, 6];
else
    leg.ItemTokenSize = [12, 6];
end

drawnow;

% Position legend exactly against top-right axes border
leg.Units = 'normalized';
hAx.Units = 'normalized';

axPos  = hAx.Position;
legPos = leg.Position;

if Type == "SEH"
    rightflush = 0.003;
    topflush = 0.001;
elseif Type == "PSSHI" || Type == "BJT-PSSHI"
    rightflush = 0.05;
    topflush = 0.05;
    if Graph == "Load"
        rightflush = 0.4;
        topflush = 0.05;
    end
elseif Type == "SSSHI"
    rightflush = 0.05;
    topflush = 0.02;
end

leg.Position = [ ...
    axPos(1) + axPos(3) - legPos(3) - rightflush, ... % flush right
    axPos(2) + axPos(4) - legPos(4) - topflush, ... % flush top
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