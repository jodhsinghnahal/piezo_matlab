%% compare_piezo_circuits.m
% Runs all four piezo harvesting interface circuits and compares
% steady-state output power:  SEH | SSHI | SECE | SSHC
%
% Each model is built via its dedicated build_*.m script.
% This script then re-simulates each with shared parameters and
% collects the average output power over the last 20% of simulation.
%
% Usage:  Run this script from the folder containing build_SEH.m etc.

close all;

%% ---- Shared parameters (edit here to tune all circuits) ----
f_res    = 100;          % vibration / resonance frequency (Hz)
T_sim    = 0.5;          % simulation duration (s)
C_rect   = 100e-6;       % output capacitor (F)
R_load   = 1e3;          % load resistance (Ohm)
F_amp    = 0.5;          % force amplitude (N)

models = {'SEH_Piezo','SSHI_Piezo','SECE_Piezo','SSHC_Piezo'};
labels = {'SEH','SSHI','SECE','SSHC'};
colors = {'#0072BD','#D95319','#77AC30','#7E2F8E'};

P_avg = zeros(1,4);
t_all = cell(1,4);
V_all = cell(1,4);

%% ---- Build all models ----
scripts = {'build_SEH','build_SSHI','build_SECE','build_SSHC'};
for k = 1:4
    fprintf('\n=== Building %s ===\n', labels{k});
    run(scripts{k});   % builds and does one simulation
end

%% ---- (Re-)simulate with shared parameters & collect data ----
for k = 1:4
    mdl = models{k};
    if ~bdIsLoaded(mdl), load_system(mdl); end
    
    % Apply shared parameters
    set_param(mdl,'StopTime',num2str(T_sim));
    
    % Patch capacitor and resistor values
    try
        set_param([mdl '/C_rect'], 'Capacitance', num2str(C_rect));
    catch; end
    try
        set_param([mdl '/C_store'],'Capacitance', num2str(C_rect));
    catch; end
    try
        set_param([mdl '/R_load'], 'Resistance',  num2str(R_load));
    catch; end
    try
        set_param([mdl '/SineWave'], ...
            'Frequency', num2str(2*pi*f_res), ...
            'Amplitude',  num2str(F_amp));
    catch; end
    
    fprintf('Simulating %s ...\n', labels{k});
    simOut = sim(mdl, 'CaptureErrors','on');
    
    % Extract logged voltage signal from Simscape (or logsout)
    try
        slog  = simOut.simlog;
        vnode = slog.V_out.Voltage.series;
        t_all{k} = vnode.time;
        V_all{k} = vnode.values;
    catch
        % Fallback: look in logsout
        try
            ls = simOut.logsout;
            sig = ls.getElement('V_out');
            t_all{k} = sig.Values.Time;
            V_all{k} = sig.Values.Data;
        catch
            warning('Could not extract voltage for %s', labels{k});
            t_all{k} = [];
            V_all{k} = [];
            continue;
        end
    end
    
    % Average output power over last 20% of simulation
    t = t_all{k};  V = V_all{k};
    idx = t >= 0.8 * T_sim;
    if any(idx)
        V_rms2 = mean(V(idx).^2);
        P_avg(k) = V_rms2 / R_load * 1e3;  % mW
        fprintf('  %s  avg output power = %.2f mW\n', labels{k}, P_avg(k));
    end
end

%% ---- Plot: Output voltage time series ----
figure('Name','Piezo Interface Circuit Comparison','Color','w','Position',[100 100 1100 600]);

for k = 1:4
    if isempty(t_all{k}), continue; end
    subplot(2,2,k);
    plot(t_all{k}*1e3, V_all{k}, 'Color', colors{k}, 'LineWidth', 1.4);
    xlabel('Time (ms)');
    ylabel('V_{load} (V)');
    title(labels{k},'FontWeight','bold');
    grid on; box on;
    xlim([0 T_sim*1e3]);
end
sgtitle('Piezo Bender Output Voltage — Interface Circuit Comparison','FontSize',13);

%% ---- Bar chart: average output power ----
figure('Name','Output Power Comparison','Color','w','Position',[100 750 500 380]);
b = bar(P_avg, 0.55, 'FaceColor','flat');
for k = 1:4
    b.CData(k,:) = sscanf(colors{k}(2:end),'%2x%2x%2x')'/255;
end
set(gca,'XTickLabel',labels,'FontSize',11);
ylabel('Average Output Power (mW)');
title('Harvested Power by Interface Circuit');
grid on; box on;
for k = 1:4
    text(k, P_avg(k)+0.5, sprintf('%.1f mW', P_avg(k)), ...
        'HorizontalAlignment','center','FontSize',10);
end

fprintf('\n=== Simulation complete. Check figure windows for results. ===\n');
