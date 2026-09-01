clearvars -except Type; 
clc; close all;

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

hFig = figure();
theme(hFig, 'dark');

hAx = axes('Parent', hFig);
colororder(hAx, 'glow');
hold(hAx, 'on');

leftBlue = colororder(hAx);
leftBlue = leftBlue(1, :);

% change specs accordingly
specs = [
    struct('key', 'SimscapeV_p', 'label', 'Simscape v_p',    'axis', 'left',  'style', '-',  'lw', 1.4, 'color', leftBlue)
    struct('key', 'v__p_F_',    'label', 'v_{p,F}',         'axis', 'left',  'style', ':',  'lw', 2.0, 'color', leftBlue)
    struct('key', 'IdealPaperV_p', 'label', 'Ideal paper v_p', 'axis', 'left',  'style', '-.', 'lw', 1.4, 'color', leftBlue)
    struct('key', 'v__store_',  'label', 'v_{store}',       'axis', 'left',  'style', '-.', 'lw', 1.4, 'color', [0 1 0])
    struct('key', 'i__eq_',     'label', 'i_{eq}',          'axis', 'right', 'style', '-.', 'lw', 1.4, 'color', [1 0 0])
    struct('key', 'i__rect_',   'label', 'i_{rect}',        'axis', 'right', 'style', '-',  'lw', 1.4, 'color', [1 1 0])
    struct('key', 'i__piezo_',  'label', 'i_{piezo}',       'axis', 'right', 'style', '-.', 'lw', 1.4, 'color', [1 0 1])
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
ylabel(hAx, 'Voltage (V)');
yyaxis(hAx, 'right');
ylabel(hAx, 'Current (A)');

grid(hAx, 'on');
box(hAx, 'on');
xlabel(hAx, 'Time within one cycle (s)');
legend(hAx, H, labels, 'Location', 'best', 'Interpreter', 'tex');
hold(hAx, 'off');

exportgraphics(hFig, outputFolder + FigName + '.png', 'Resolution', 300);
savefig(hFig, outputFolder + FigName + '.fig');