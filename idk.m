%% SEH Simscape Waveform + Paper-Style Waveform Comparison
clear; clc; close all;

%% ============================================================
% USER SETTINGS
% =============================================================

model = "seh_simscape_model";

vpName     = "vp_sim";
vstoreName = "vstore_sim";
ieqName    = "ieq_sim";

% Paper / circuit parameters

L = 31e3;              % H
R = 1e6;               % ohm
C = 448e-12;            % F
Cp = 34.69e-9;         % F
Crect = 1e-6
Rload = 1e6

VF = 0.5;              % total bridge forward voltage drop, V
% alpha_e = 4.75e-4;     % N/V

% Excitation
f = 42;                % Hz
w = 2*pi*f;
T = 1/f;

% Simulation time
stopTime = 5.0;
t_start_ss = 3.0;

%% ============================================================
% SEND VARIABLES TO BASE WORKSPACE
% =============================================================

load_system(model);

assignin("base", "L", L);
assignin("base", "R", R);
assignin("base", "C", C);
assignin("base", "Cp", Cp);
assignin("base", "Rload", Rload);
assignin("base", "Crect", Crect);
% assignin("base", "alpha_e", alpha_e);
assignin("base", "VF", VF);
% assignin("base", "f", f);
assignin("base", "w", w);

simIn = Simulink.SimulationInput(model);
simIn = simIn.setModelParameter("StopTime", num2str(stopTime));
simIn = simIn.setModelParameter("ReturnWorkspaceOutputs", "on");

simIn = simIn.setVariable("L", L);
simIn = simIn.setVariable("R", R);
simIn = simIn.setVariable("C", C);
simIn = simIn.setVariable("Cp", Cp);
simIn = simIn.setVariable("Rload", Rload);
simIn = simIn.setVariable("Crect", Crect);
% simIn = simIn.setVariable("alpha_e", alpha_e);
simIn = simIn.setVariable("VF", VF);
% simIn = simIn.setVariable("f", f);
simIn = simIn.setVariable("w", w);

%% ============================================================
% RUN SIMULATION
% =============================================================

fprintf("Running Simscape model: %s\n", model);
simOut = sim(simIn);
fprintf("Simulation complete.\n");

disp("Available simOut variables:");
disp(simOut.who);

%% ============================================================
% READ SIGNALS
% =============================================================

[t_vp, vp] = readSignalDirect(simOut, vpName);
[t_vs, vstore] = readSignalDirect(simOut, vstoreName);
[t_i, ieq] = readSignalDirect(simOut, ieqName);

[t_vp, vp] = cleanTimeSignal(t_vp, vp);
[t_vs, vstore] = cleanTimeSignal(t_vs, vstore);
[t_i, ieq] = cleanTimeSignal(t_i, ieq);

% Use vp time as common time base
t = t_vp;
vp = vp(:);

vstore = interp1(t_vs, vstore, t, "linear", "extrap");
ieq = interp1(t_i, ieq, t, "linear", "extrap");

%% ============================================================
% STEADY-STATE REGION
% =============================================================

idx_ss = t >= t_start_ss;

if sum(idx_ss) < 10
    error("Not enough steady-state data. Lower t_start_ss or increase stopTime.");
end

t_ss = t(idx_ss);
vp_ss = vp(idx_ss);
vstore_ss = vstore(idx_ss);
ieq_ss = ieq(idx_ss);

Pload_inst = vstore_ss.^2 ./ Rload;
Pload_avg = mean(Pload_inst, "omitnan");

fprintf("\n===== Simscape SEH Results =====\n");
fprintf("Average harvested/load power = %.6f mW\n", Pload_avg * 1000);
fprintf("Average Vstore = %.6f V\n", mean(vstore_ss, "omitnan"));
fprintf("Peak-to-peak vp = %.6f V\n", max(vp_ss) - min(vp_ss));
fprintf("Peak-to-peak ieq = %.6e A\n", max(ieq_ss) - min(ieq_ss));

%% ============================================================
% EXTRACT ONE STEADY-STATE CYCLE
% =============================================================

t2 = t_ss(end);
t1 = t2 - T;

idx_cycle = t >= t1 & t <= t2;

if sum(idx_cycle) < 20
    error("Not enough points in one cycle. Reduce max step size in Simulink.");
end

t_c = t(idx_cycle);
vp_c = vp(idx_cycle);
vstore_c = vstore(idx_cycle);
ieq_c = ieq(idx_cycle);

tau = t_c - t_c(1);

%% ============================================================
% FUNDAMENTAL COMPONENTS
% =============================================================

[vp_F, VpF_amp, VpF_phase] = fundamentalComponent(t_c, vp_c, f);
[ieq_F, I0, ieq_phase] = fundamentalComponent(t_c, ieq_c, f);

fprintf("\n===== Fundamental Components =====\n");
fprintf("Fundamental ieq amplitude I0 = %.6e A\n", I0);
fprintf("Fundamental vp amplitude = %.6f V\n", VpF_amp);

%% ============================================================
% IDEAL PAPER-STYLE SEH WAVEFORM
% =============================================================

Voc_sim = I0 / (w * Cp);
Vrect_sim = mean(vstore_ss, "omitnan") + VF*2;
Vtilde_sim = Vrect_sim / Voc_sim;

fprintf("\n===== Paper-Style SEH Estimates =====\n");
fprintf("Estimated Voc = %.6f V\n", Voc_sim);
fprintf("Estimated Vrect = Vstore + VF = %.6f V\n", Vrect_sim);
fprintf("Estimated Vtilde_rect = %.6f\n", Vtilde_sim);

vp_paper = nan(size(t_c));

if Vtilde_sim > 0 && Vtilde_sim < 1

    theta = acos(1 - 2*Vtilde_sim);

    % Align ideal waveform with simulated ieq fundamental
    phi = mod(w*t_c + ieq_phase, 2*pi);

    for k = 1:length(phi)
        p = phi(k);

        if p >= 0 && p < theta
            vp_paper(k) = Voc_sim * (1 - cos(p)) - Vrect_sim;

        elseif p >= theta && p < pi
            vp_paper(k) = Vrect_sim;

        elseif p >= pi && p < pi + theta
            vp_paper(k) = Vrect_sim - Voc_sim * (1 + cos(p));

        else
            vp_paper(k) = -Vrect_sim;
        end
    end

    % Flip if polarity is opposite
    if simpleCorr(vp_paper(:), vp_c(:)) < 0
        vp_paper = -vp_paper;
    end

else
    warning("Vtilde_rect is outside (0,1). Ideal SEH paper waveform cannot be reconstructed.");
end

%% ============================================================
% PLOT 1: STEADY-STATE SIGNALS
% =============================================================

figure("Name", "Steady-State Simscape Signals");
tiledlayout(4,1);

nexttile;
plot(t_ss, vp_ss, "LineWidth", 1.2);
grid on;
ylabel("v_p (V)");
title("Steady-State Simscape SEH Signals");

nexttile;
plot(t_ss, ieq_ss, "LineWidth", 1.2);
grid on;
ylabel("i_{eq} (A)");

nexttile;
plot(t_ss, vstore_ss, "LineWidth", 1.2);
grid on;
ylabel("V_{store} (V)");

nexttile;
plot(t_ss, Pload_inst*1000, "LineWidth", 1.2);
grid on;
ylabel("P_{load} (mW)");
xlabel("Time (s)");

%% ============================================================
% PLOT 2: PAPER-STYLE NORMALIZED WAVEFORM
% =============================================================

figure("Name", "Paper-Style SEH Waveform from Simscape");

plot(tau, normalizeShape(ieq_F), "--", "LineWidth", 1.5); hold on;
plot(tau, normalizeShape(vp_c), "LineWidth", 1.5);
plot(tau, normalizeShape(vp_F), ":", "LineWidth", 2.0);

if all(~isnan(vp_paper))
    plot(tau, normalizeShape(vp_paper), "-.", "LineWidth", 1.5);
    legend("i_{eq} fundamental", ...
           "Simscape v_p", ...
           "v_{p,F} fundamental", ...
           "Ideal SEH paper waveform", ...
           "Location", "best");
else
    legend("i_{eq} fundamental", ...
           "Simscape v_p", ...
           "v_{p,F} fundamental", ...
           "Location", "best");
end

grid on;
xlabel("Time within one cycle (s)");
ylabel("Normalized amplitude");
title("Paper-Style SEH Waveform from Simscape");
xlim([0 T]);

%% ============================================================
% PLOT 3: ONE-CYCLE ABSOLUTE WAVEFORMS
% =============================================================

figure("Name", "One-Cycle Absolute Waveforms");

yyaxis left;
plot(tau, vp_c, "LineWidth", 1.4); hold on;
plot(tau, vp_F, ":", "LineWidth", 2.0);

if all(~isnan(vp_paper))
    plot(tau, vp_paper, "-.", "LineWidth", 1.4);
end

ylabel("Voltage (V)");

yyaxis right;
plot(tau, ieq_F, "--", "LineWidth", 1.4);
ylabel("Current (A)");

grid on;
xlabel("Time within one cycle (s)");
title("One-Cycle Simscape vs Fundamental vs Paper SEH");

if all(~isnan(vp_paper))
    legend("Simscape v_p", "v_{p,F}", "Ideal paper v_p", "i_{eq,F}", ...
           "Location", "best");
else
    legend("Simscape v_p", "v_{p,F}", "i_{eq,F}", ...
           "Location", "best");
end

%% ============================================================
% SAVE RESULTS
% =============================================================

results.t = t;
results.vp = vp;
results.vstore = vstore;
results.ieq = ieq;
results.t_ss = t_ss;
results.vp_ss = vp_ss;
results.vstore_ss = vstore_ss;
results.ieq_ss = ieq_ss;
results.Pload_inst = Pload_inst;
results.Pload_avg = Pload_avg;
results.t_cycle = tau;
results.vp_cycle = vp_c;
results.ieq_cycle = ieq_c;
results.vp_F = vp_F;
results.ieq_F = ieq_F;
results.vp_paper = vp_paper;
results.Voc_sim = Voc_sim;
results.Vrect_sim = Vrect_sim;
results.Vtilde_sim = Vtilde_sim;

assignin("base", "seh_results", results);

fprintf("\nSaved results to base workspace as seh_results.\n");

%% ============================================================
% LOCAL FUNCTIONS
% =============================================================

function [t, y] = readSignalDirect(simOut, name)

    name = char(name);

    try
        sig = simOut.get(name);
    catch
        try
            sig = evalin("base", name);
        catch
            error("Could not find signal '%s'. Available simOut variables are listed above.", name);
        end
    end

    [t, y] = signalToTimeData(sig, simOut);
end

function [t, y] = signalToTimeData(sig, simOut)

    if isa(sig, "timeseries")
        t = sig.Time;
        y = sig.Data;

    elseif isa(sig, "Simulink.SimulationData.Signal")
        [t, y] = signalToTimeData(sig.Values, simOut);

    elseif isa(sig, "Simulink.SimulationData.Dataset")
        elem = sig.get(1);
        [t, y] = signalToTimeData(elem.Values, simOut);

    elseif istimetable(sig)
        t = seconds(sig.Properties.RowTimes - sig.Properties.RowTimes(1));
        y = sig{:,1};

    elseif isstruct(sig)

        if isfield(sig, "time") && isfield(sig, "signals")
            t = sig.time;
            y = sig.signals.values;

        elseif isfield(sig, "Time") && isfield(sig, "Data")
            t = sig.Time;
            y = sig.Data;

        else
            error("Unsupported struct signal format.");
        end

    elseif isnumeric(sig)

        if size(sig,2) >= 2 && all(diff(sig(:,1)) >= 0)
            t = sig(:,1);
            y = sig(:,2);
        else
            try
                t = simOut.tout;
            catch
                t = simOut.get("tout");
            end

            y = sig;
        end

    else
        error("Unsupported signal type: %s", class(sig));
    end

    t = t(:);
    y = squeeze(y);

    if size(y,1) ~= length(t)
        y = y(:);
    end
end

function [t, y] = cleanTimeSignal(t, y)

    t = t(:);
    y = squeeze(y);

    if size(y,1) ~= length(t)
        y = y(:);
    end

    valid = isfinite(t) & isfinite(y);
    t = t(valid);
    y = y(valid);

    [t, sortIdx] = sort(t);
    y = y(sortIdx);

    [t, uniqueIdx] = unique(t, "stable");
    y = y(uniqueIdx);
end

function [yF, amp, phase] = fundamentalComponent(t, y, f)

    t = t(:);
    y = y(:);

    valid = isfinite(t) & isfinite(y);
    t = t(valid);
    y = y(valid);

    y = y - mean(y, "omitnan");

    w = 2*pi*f;

    A = [sin(w*t), cos(w*t)];
    
    coeff = A \ y;

    a = coeff(1);
    b = coeff(2);
    % disp(a);
    % disp(b);

    amp = hypot(a, b);
    phase = atan2(b, a);

    yF = amp * sin(w*t + phase);
end

function yn = normalizeShape(y)

    y = y(:);
    m = max(abs(y), [], "omitnan");

    if m == 0 || isnan(m)
        yn = y;
    else
        yn = y ./ m;
    end
end

function r = simpleCorr(a, b)

    a = a(:);
    b = b(:);

    valid = isfinite(a) & isfinite(b);
    a = a(valid);
    b = b(valid);

    if numel(a) < 2
        r = 0;
        return;
    end

    a = a - mean(a);
    b = b - mean(b);

    denom = sqrt(sum(a.^2) * sum(b.^2));

    if denom == 0
        r = 0;
    else
        r = sum(a .* b) / denom;
    end
end