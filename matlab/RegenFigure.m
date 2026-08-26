% recreate_figure_exact_match.m
% Reconstruct saved Fig.mat data so the plot matches the original
% MATLAB dark-theme Plot 3 as closely as possible.

clear; clc; close all;

%% ============================================================
% 1. Load exported data
% ============================================================

matFileName = 'Fig.mat';

if ~exist(matFileName, 'file')
    error('File %s not found. Check current MATLAB directory.', matFileName);
end

data = load(matFileName);

%% ============================================================
% 2. Extract Figure 3 structure
% ============================================================

if isfield(data, 'Figure_3_SingleRun_One_CycleAbsoluteWaveforms')

    figData = data.Figure_3_SingleRun_One_CycleAbsoluteWaveforms;

elseif isfield(data, 'extractedData') && ...
       isfield(data.extractedData, ...
       'Figure_3_SingleRun_One_CycleAbsoluteWaveforms')

    figData = ...
        data.extractedData.Figure_3_SingleRun_One_CycleAbsoluteWaveforms;

else
    fields = fieldnames(data);
    figData = data.(fields{1});
end


%% ============================================================
% 3. Figure
%
% IMPORTANT:
% Do NOT manually force [0.1 0.1 0.1].
%
% The original graph is MATLAB's real dark graphics theme.
% This also gives the correct:
%   - figure background
%   - axes background
%   - grid coloring
%   - tick coloring
%   - text coloring
%   - legend coloring
%   - yyaxis colors
% ============================================================

hFig = figure( ...
    'Name', 'Single Run: One-Cycle Absolute Waveforms', ...
    'InvertHardcopy', 'off');

% MATLAB R2025a+
theme(hFig, 'dark');

hAx = axes('Parent', hFig);

% Explicitly use MATLAB's native dark-theme palette.
colororder(hAx, 'glow');

hold(hAx, 'on');


%% ============================================================
% 4. Find the individual saved traces
% ============================================================

[simVP,     hasSimVP]     = getSavedSeries(figData, "simscape_vp");
[simVcap,   hasSimVcap]   = getSavedSeries(figData, "simscape_vcap");
[vpF,       hasVpF]       = getSavedSeries(figData, "vpf");
[paperVP,   hasPaperVP]   = getSavedSeries(figData, "paper_vp");
[vstore,    hasVstore]    = getSavedSeries(figData, "vstore");

[ieq,       hasIeq]       = getSavedSeries(figData, "ieq");
[irect,     hasIrect]     = getSavedSeries(figData, "irect");
[ipiezo,    hasIpiezo]    = getSavedSeries(figData, "ipiezo");
[flipTrace, hasFlip]      = getSavedSeries(figData, "flip");


%% ============================================================
% 5. Get native dark-theme blue
%
% yyaxis-left curves in the original plot use the first color
% of MATLAB's dark-theme ("glow") palette.
% ============================================================

glowColors = colororder(hAx);
leftBlue = glowColors(1,:);


%% ============================================================
% 6. Plot LEFT axis
%
% EXACT ORIGINAL ORDER:
%
%   1. Simscape v_p
%   2. Simscape v_cap          [if present]
%   3. v_{p,F}
%   4. Ideal paper v_p
%   5. v_store
%
% This ordering matters because later traces are drawn on top.
% ============================================================

H = gobjects(0);
labels = strings(0);

yyaxis(hAx, 'left');


% ------------------------------------------------------------
% Simscape v_p
% Original:
% plot(..., "LineWidth", 1.4)
% ------------------------------------------------------------
if hasSimVP

    h = plotSavedSeries( ...
        hAx, simVP, ...
        '-', ...
        1.4, ...
        leftBlue);

    H(end+1) = h;
    labels(end+1) = "Simscape v_p";
end


% ------------------------------------------------------------
% Simscape v_cap
% Original:
% plot(..., "--", "LineWidth", 1.4)
% ------------------------------------------------------------
if hasSimVcap

    h = plotSavedSeries( ...
        hAx, simVcap, ...
        '--', ...
        1.4, ...
        leftBlue);

    H(end+1) = h;
    labels(end+1) = "Simscape v_{cap}";
end


% ------------------------------------------------------------
% Fundamental v_p,F
%
% IMPORTANT:
% NO MARKERS.
%
% Your previous code used:
% Marker = '^'
%
% That caused the thick/jagged appearance in the first graph.
%
% Original:
% plot(..., ":", "LineWidth", 2.0)
% ------------------------------------------------------------
if hasVpF

    h = plotSavedSeries( ...
        hAx, vpF, ...
        ':', ...
        2.0, ...
        leftBlue);

    H(end+1) = h;
    labels(end+1) = "v_{p,F}";
end


% ------------------------------------------------------------
% Ideal paper v_p
% Original:
% plot(..., "-.", "LineWidth", 1.4)
% ------------------------------------------------------------
if hasPaperVP

    h = plotSavedSeries( ...
        hAx, paperVP, ...
        '-.', ...
        1.4, ...
        leftBlue);

    H(end+1) = h;
    labels(end+1) = "Ideal paper v_p";
end


% ------------------------------------------------------------
% v_store
%
% Original:
% plot(..., "-.g", "LineWidth", 1.4)
%
% NOTE:
% Your old reconstruction used "--".
% ------------------------------------------------------------
if hasVstore

    h = plotSavedSeries( ...
        hAx, vstore, ...
        '-.', ...
        1.4, ...
        [0 1 0]);

    H(end+1) = h;
    labels(end+1) = "v_{store}";
end


ylabel(hAx, 'Voltage (V)');


%% ============================================================
% 7. Plot RIGHT axis
%
% EXACT ORIGINAL ORDER:
%
%   6. i_eq
%   7. i_rect
%   8. i_piezo
%   9. flip                  [if present]
% ============================================================

yyaxis(hAx, 'right');


% ------------------------------------------------------------
% i_eq
%
% Original:
% plot(..., "-.r", "LineWidth", 1.4)
%
% Your old reconstruction incorrectly used ":".
% ------------------------------------------------------------
if hasIeq

    h = plotSavedSeries( ...
        hAx, ieq, ...
        '-.', ...
        1.4, ...
        [1 0 0]);

    H(end+1) = h;
    labels(end+1) = "i_{eq}";
end


% ------------------------------------------------------------
% i_rect
%
% Original:
% plot(..., "-y", "LineWidth", 1.4)
%
% Your old reconstruction incorrectly used "--".
% ------------------------------------------------------------
if hasIrect

    h = plotSavedSeries( ...
        hAx, irect, ...
        '-', ...
        1.4, ...
        [1 1 0]);

    H(end+1) = h;
    labels(end+1) = "i_{rect}";
end


% ------------------------------------------------------------
% i_piezo
%
% Original:
% plot(..., "-.m", "LineWidth", 1.4)
% ------------------------------------------------------------
if hasIpiezo

    h = plotSavedSeries( ...
        hAx, ipiezo, ...
        '-.', ...
        1.4, ...
        [1 0 1]);

    H(end+1) = h;
    labels(end+1) = "i_{piezo}";
end


% ------------------------------------------------------------
% flip trace
%
% Original:
% stairs(..., "-.w", "LineWidth", 1.5)
% ------------------------------------------------------------
if hasFlip

    if isfield(flipTrace, 'XData') && ...
       isfield(flipTrace, 'YData')

        h = stairs( ...
            hAx, ...
            flipTrace.XData, ...
            flipTrace.YData, ...
            '-.', ...
            'Color', [1 1 1], ...
            'LineWidth', 1.5);

        H(end+1) = h;
        labels(end+1) = "flip";
    end
end


ylabel(hAx, 'Current (A)');


%% ============================================================
% 8. Formatting
%
% Do NOT manually recolor axes, grid, legend, etc.
% Let MATLAB's dark theme do it exactly as the original.
% ============================================================

grid(hAx, 'on');
box(hAx, 'on');

xlabel(hAx, 'Time within one cycle (s)');

% Change this if the MAT file is for PSSHI/SSSHI/etc.
plotType = "SEH";

title( ...
    hAx, ...
    "One-Cycle Simscape vs Fundamental vs Paper " + plotType);


%% ============================================================
% 9. Legend
%
% Passing handles explicitly guarantees the SAME ordering
% regardless of how fieldnames() returns the MAT fields.
% ============================================================

legend( ...
    hAx, ...
    H, ...
    labels, ...
    'Location', 'best', ...
    'Interpreter', 'tex');


hold(hAx, 'off');



%% ============================================================
% LOCAL FUNCTIONS
% ============================================================

function [s, found] = getSavedSeries(figData, requestedType)
% Robust search using:
%   1) field name
%   2) DisplayName
%   3) fallback heuristics

    names = fieldnames(figData);
    s = struct();
    found = false;

    candidates = struct([]);
    cidx = 0;

    for k = 1:numel(names)
        rawName = names{k};
        candidate = figData.(rawName);

        if ~isstruct(candidate) || ...
           ~isfield(candidate, 'XData') || ...
           ~isfield(candidate, 'YData') || ...
           isempty(candidate.XData) || isempty(candidate.YData)
            continue;
        end

        displayName = "";
        if isfield(candidate, 'DisplayName') && ~isempty(candidate.DisplayName)
            displayName = string(candidate.DisplayName);
        end

        token = lower(string(rawName) + "_" + displayName);
        token = regexprep(token, '[^a-zA-Z0-9]+', '_');
        token = regexprep(token, '_+', '_');
        token = strip(token, '_');

        cidx = cidx + 1;
        candidates(cidx).rawName = rawName;
        candidates(cidx).token = token;
        candidates(cidx).data = candidate;
    end

    % -------- First pass: direct name matching --------
    for k = 1:numel(candidates)
        token = candidates(k).token;

        switch requestedType
            case "simscape_vp"
                tf = contains(token, "simscape") && ...
                    (contains(token, "v_p") || contains(token, "vp")) && ...
                    ~contains(token, "cap");

            case "simscape_vcap"
                tf = contains(token, "simscape") && ...
                    (contains(token, "v_cap") || contains(token, "vcap"));

            case "vpf"
                tf = contains(token, "v_p_f") || ...
                     contains(token, "vp_f") || ...
                     contains(token, "fundamental");

            case "paper_vp"
                tf = contains(token, "ideal") || ...
                    (contains(token, "paper") && ...
                    (contains(token, "v_p") || contains(token, "vp")));

            case "vstore"
                tf = contains(token, "v_store") || contains(token, "vstore");

            case "ieq"
                tf = contains(token, "i_eq") || contains(token, "ieq");

            case "irect"
                tf = contains(token, "i_rect") || contains(token, "irect");

            case "ipiezo"
                tf = contains(token, "i_piezo") || contains(token, "ipiezo");

            case "flip"
                tf = contains(token, "flip");

            otherwise
                tf = false;
        end

        if tf
            s = candidates(k).data;
            found = true;
            return;
        end
    end

    % -------- Second pass: fallback heuristics --------
    switch requestedType

        case "simscape_vp"
            % Look for a voltage-like waveform:
            % - big swing around zero
            % - not flat like vstore
            % - not dotted/dash-dot reference curves if possible
            bestScore = -inf;
            bestIdx = [];

            for k = 1:numel(candidates)
                y = candidates(k).data.YData(:);
                if isempty(y), continue; end

                yrange = max(y, [], "omitnan") - min(y, [], "omitnan");
                ymean  = mean(y, "omitnan");

                ls = "";
                if isfield(candidates(k).data, 'LineStyle') && ~isempty(candidates(k).data.LineStyle)
                    ls = string(candidates(k).data.LineStyle);
                end

                token = candidates(k).token;

                % Reject obvious non-Simscape candidates
                if contains(token, "store") || contains(token, "eq") || ...
                   contains(token, "rect") || contains(token, "piezo") || ...
                   contains(token, "paper") || contains(token, "fundamental") || ...
                   contains(token, "flip") || contains(token, "cap")
                    continue;
                end

                score = 0;

                % Big symmetric-ish voltage swing
                if yrange > 20
                    score = score + 5;
                end
                if abs(ymean) < 5
                    score = score + 3;
                end

                % Prefer solid line
                if ls == "-" || ls == ""
                    score = score + 4;
                elseif ls == ":"
                    score = score - 2;
                elseif ls == "-."
                    score = score - 1;
                end

                if score > bestScore
                    bestScore = score;
                    bestIdx = k;
                end
            end

            if ~isempty(bestIdx)
                s = candidates(bestIdx).data;
                found = true;
                return;
            end
    end
end


function h = plotSavedSeries(hAx, s, lineStyle, lineWidth, lineColor)
% Plot saved XData/YData while preserving optional ZData.

    if isfield(s, 'ZData') && ~isempty(s.ZData)

        h = plot3( ...
            hAx, ...
            s.XData, ...
            s.YData, ...
            s.ZData, ...
            'LineStyle', lineStyle, ...
            'LineWidth', lineWidth, ...
            'Color', lineColor, ...
            'Marker', 'none');

    else

        h = plot( ...
            hAx, ...
            s.XData, ...
            s.YData, ...
            'LineStyle', lineStyle, ...
            'LineWidth', lineWidth, ...
            'Color', lineColor, ...
            'Marker', 'none');
    end
end