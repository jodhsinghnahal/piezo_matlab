%% ============================================================
% FULL SEH / P-SSHI / S-SSHI SIMSCAPE + PAPER-STYLE IMPEDANCE ANALYSIS
%
% This script:
% 1) Runs one detailed SEH simulation (first get piezo open circuit voltage)
% 2) Extracts steady-state vp, ieq, Vstore
% 3) Computes fundamental components
% 4) Computes Zelec_sim = Vp,F / Ieq,F
% 5) Computes paper SEH, P-SSHI, or S-SSHI Zelec formula
% 6) Decomposes Zelec into Rd, Rh, XE
% 7) Computes harvested power vs extracted power
% 8) Runs an Rload sweep
% 9) Finds optimum harvested power
% 10) Plots impedance plane and power curves
%
% ============================================================

tic; % Starts the stopwatch timer
% clear; clc; close all;
Simulink.sdi.clear;

%% ============================================================
% USER SETTINGS
% ============================================================

model = "simscape_model";

% Variant subsystem type: "SEH", "PSSHI", or "SSSHI"
% For S-SSHI, your Simscape variant must place the switch+Li+Rsw in SERIES
% between the piezo termienal and the bridge rectifier AC terminal.
Type = Type_test;
CrossCircuitType = CrossCircuitTest; % "Switch" (PS Zero Cross Switch) or "BJT" (Zero Cross Circ 1), or "NoSwitch"
WindingRatio = WindingRatio_test;

vpName      = "vp_sim";
vcapName    = "vcap_sim";
vstoreName  = "vstore_sim";
ieqName    = "ieq_sim";
irectName = "irect_sim";
ipName = "ip_sim";
flipName = "flip_sim";

% For BJT ESP-PSSHI: Current Sensor blocks in series with each SSHI inductor.
iL1Name = "iL1_sim";
iL2Name = "iL2_sim";

% Excitation
% f = 42;                         % Hz
f = f_test;
w = 2*pi*f;
T = 1/f;

% Single-run load
if strcmpi(string(Type), "SSSHI")
    Rload_single = 1e5;
else
    Rload_single = 1e6;
    % Rload_single = 4.64E+03;
end
% Rload_single = 5.994843e+04;

% Rectifier / storage / load
Crect = 1e-6;     % F

%% Equivalent electrical-domain transducer model
% Set true to use the underwater-acoustic equivalent circuit paper:
%   Zeq = Req + 1/(j*w*Ceq) + j*w*Leq, in parallel with Cp
%   Req/Ceq/Leq from Underwater Energy Harvesting Eq. (9)-(11)
%   VSrc_eq_amp = |Veq| from Eq. (6), driven by acoustic pressure amplitude.
%
% Set false to keep the old Liang/Liao beam example values.
useUnderwaterPaperModel = false;

if useUnderwaterPaperModel
    uwMaterial = "PZT";          % "PZT" or "PVDF"
    uwArea_m2 = 2e-3;            % use 2e-3 or 20e-3 m^2 for PZT
    SPL_dB = 230;  p_ref = 1e-6;            % dB re 1 uPa for underwater
    pw_rms = p_ref * 10^(SPL_dB/20);
    uwPressureAmp_Pa = sqrt(2) * pw_rms;      % peak acoustic pressure amplitude, Pa

    useNewModel = false;
    uw = MyUtils.underwaterPaperEquivalent(uwMaterial, ...
        uwArea_m2, uwPressureAmp_Pa, f, useNewModel);

    L  = uw.Leq;                 % H
    R  = uw.Req;                 % ohm
    C  = uw.Ceq;                 % F
    Cp = uw.Cp;                  % F
    VSrc_eq_amp = abs(uw.Veq_phasor);  % peak electrical source amplitude, V

    fprintf("\n===== UNDERWATER PAPER EQUIVALENT CIRCUIT (%.1e dB) =====\n", SPL_dB);
    fprintf("Material = %s, A = %.4e m^2, p_w,pk = %.4g Pa\n", ...
        uw.material, uw.A, uw.pw_amp);
    fprintf("Req = %.6e ohm\n", R);
    fprintf("Ceq = %.6e F\n", C);
    fprintf("Leq = %.6e H\n", L);
    fprintf("Cp  = %.6e F\n", Cp);
    fprintf("|Veq| = %.6e V\n", VSrc_eq_amp);
    fprintf("Calculated |Voc,piezo| = %.6e V\n", uw.Voc_piezo_amp);
    fprintf("Approx factor |Veq|/p_w = %.6e V/Pa\n", abs(uw.Veq_phasor)/uw.pw_amp);
    opts = {'old', 'new'};
    fprintf('*Use %s model\n', opts{useNewModel + 1});
else
    % Original Liang/Liao experimental setup / equivalent model
    L  = 31e3;        % H
    R  = 1e6;         % ohm
    C  = 448e-12;     % F
    Cp = 34.69e-9;    % F
    % Cp = Cp*10;
    % Cp = 34.69e-15;    % F

    ae = 4.75*10^-4;
    Y_rms_accel = 10;
    y_peak_accel = sqrt(2) * Y_rms_accel;
    VSrc_eq_amp = L * ae * y_peak_accel;
    uw = [];
    Zseries_oc = R + 1j*w*L + 1/(1j*w*C);
    ZCp_oc = 1/(1j*w*Cp);

    openCircuitVoltage = abs( ...
        VSrc_eq_amp * ZCp_oc / (Zseries_oc + ZCp_oc) ...
        );

    fprintf("\n===== LIANG/LIAO EXPERIMENTAL EQUIVALENT CIRCUIT =====\n");
    fprintf("Acceleration (rms) = %.2f m/s^2, Peak = %.4f m/s^2\n", Y_rms_accel, y_peak_accel);
    fprintf("Req = %.6e ohm\n", R);
    fprintf("Ceq = %.6e F\n", C);
    fprintf("Leq = %.6e H\n", L);
    fprintf("Cp  = %.6e F\n", Cp);
    fprintf("|Veq| = %.6e V\n", VSrc_eq_amp);
    fprintf("Calculated |Voc,piezo| = %.6e V\n", openCircuitVoltage);
end

% Print in SPICE .param format
% fprintf('.param Leq = %.6e\n', L);
% fprintf('.param Req = %.6e\n', R);
% fprintf('.param Ceq = %.6e\n', C);
% fprintf('.param Veq = %.6e\n', VSrc_eq_amp);
% fprintf('.param f = %d\n', f);
% fprintf('.param Cp = %.6e\n', Cp);

% return;

% If each diode is about 0.5 V, total bridge drop is about 1.0 V.
% Vd_single = 0.25;
Vd_single = 0.5;
VF_bridge = 2 * Vd_single;  % total conducting bridge drop, V
r_single = 0.03; % the on resistance

C1 = 2.2e-9;
% C1 = C1Test*Cp;

% Cp_ref = 34.69e-9;
% C1_ref = 2.2e-9;
% 
% C1_ratio = C1_ref / Cp_ref;   % 0.06342
% C1 = C1_ratio * Cp;

Vbe = 0.55;
curGain = 25;
Vd_BJT = 0.25;

% Single-run timing
stopTime_single = 5.0;
t_start_ss_single = 3.0;

% Load sweep settings
doSweep = true;

%fast mode
fast_mode = false;

% Avoid going too high unless you allow very long simulations.
% With Crect = 1e-6, Rload = 10 MOhm gives tau = 10 s.
% Rload_list = logspace(3, 7, 10);
Rload_list = logspace(4, 7, 20);    % 20 logarithmically spaced points from 10 kOhm to 10 MOhm
% Rload_list = logspace(4, 6.7, 20);
% Rload_list = logspace(7, 8, 5);

if fast_mode
    % fast simulations
    minStopTime = 2.0;
    tauMultiplier = 1.5;
    maxStopTime = 20.0;
    ssStartFraction = 0.60;
else
    minStopTime = 5.0;
    tauMultiplier = 5.0;                 % simulate about 5 RC time constants
    maxStopTime = 90.0;                  % safety cap
    ssStartFraction = 0.75;              % use last 25% as steady-state
end

%% SSHI settings
if CrossCircuitType == "NoSwitch"
    Li = 1 / (w^2 * Cp);
else
    % switchFraction = switchFracTest;
    % Li = (switchFraction * 0.5 * T/pi)^2/Cp;
    Li = 47e-3;                 % SSHI inductor, H
    % Li = Li_test;
    % Li = 1 / (pi^2 * f^2 * Cp) * 1/1000;
end
L1 = 1 / (w^2 * Cp); % = 414 H inductor value at freq=42 Hz (not practical)
L2 = L1 * (1/WindingRatio)^2;

R_closed = 0.54;            %IRL510 on resistance
Tsw = pi * sqrt(Li * Cp);   % switch closed time for half LC cycle
Threshold = 0.5;

% not used:
G_open   = 1e-8;
blankingTime = 0.25 / f;    % prevents repeated triggering near zero
tEnable = 3 / f;            % delay switching until startup settles
Ieps = 1e-7;                % current deadband for zero-cross detection
Sres = 1e-2;                % zero cross circ 3 params:
Pcond = 1e-6;

% Paper SSHI inversion factor, Eq. 22: gamma = -exp(-pi/(2Q))
% IMPORTANT: Rsw should be the TOTAL resistance in the Cp-Li switching loop
%            (switch Ron + inductor ESR + wiring/other series resistance).
paper_gamma = -0.7;          % table 1
Q_needed = -1 * pi / (2 * log(-1 * paper_gamma));
Rloop_total = sqrt(Li/Cp) / Q_needed;
Rsw = Rloop_total - R_closed;   % calculated from quality factor
% Rsw = 84; % directly specified value
% Rloop_total = Rsw + R_closed;
% Li = (Q_needed^2) * (Rloop_total^2) * Cp;

Qsshi = sqrt(Li/Cp) / Rloop_total;
gamma_sshi = -exp(-pi/(2*Qsshi));

% omega0 = 1/sqrt(Li*Cp);
% omega_d = omega0 * sqrt(1 - 1/(4*Qsshi^2));
% Tsw = pi / omega_d;

% Use gamma = 1 for SEH. SEH is the gamma = 1 special case of the
% P-SSHI formulas in the Liang/Liao impedance paper.
% P-SSHI and S-SSHI both use the SSHI inversion factor gamma.
if strcmpi(string(Type), "SEH")
    gamma = 1;
elseif any(strcmpi(string(Type), ["PSSHI","P-SSHI","SSSHI","S-SSHI"]))
    gamma = gamma_sshi;
else
    error("Unsupported Type '%s'. Use SEH, PSSHI, or SSSHI.", char(string(Type)));
end

% Safe tag for workspace variable names, e.g., "PSSHI" -> "psshi".
TypeTag = matlab.lang.makeValidName(char(lower(erase(string(Type), "-"))));

if useUnderwaterPaperModel
    assignin("base", "uw_paper_equivalent", uw);
end

% Solver max step for cleaner waveform/fundamental extraction
if strcmpi(string(Type), "SEH")
    maxStep = T/400;
elseif any(strcmpi(string(Type), ["PSSHI","P-SSHI","SSSHI","S-SSHI"]))
    if fast_mode
        maxStep = min(T/400, Tsw/5.5); % fast
    else
        maxStep = min(T/400, Tsw/10);
    end
end

%% ============================================================
% LOAD MODEL
% ============================================================

load_system(model);
set_param(model, 'SimulationMode', 'normal'); % fast
set_param(model, "FastRestart", "off");

%% ============================================================
% MEASURE ACTUAL OPEN-CIRCUIT VOC
% ============================================================
measureOC = true;

if measureOC
    fprintf("\n============================================================\n");
    fprintf("MEASURING ACTUAL OPEN-CIRCUIT TRANSDUCER VOLTAGE\n");
    fprintf("============================================================\n");
    
    Voc_oc = MyUtils.measureOpenCircuitVoc(model, vpName, ...
        L, R, C, Cp, Crect, Rload_single, VF_bridge, VSrc_eq_amp, ...
        f, stopTime_single, t_start_ss_single, maxStep, ...
        Type, Li, Rsw, R_closed, G_open, Threshold, Tsw, blankingTime, ...
        tEnable, Ieps, gamma, Qsshi);
    
    openCircuitVoltage = Voc_oc.Voc_amp;
    
    fprintf("\n===== ACTUAL OPEN-CIRCUIT MEASUREMENT =====\n");
    fprintf("Measured open-circuit Voc fundamental amplitude = %.6f V\n", openCircuitVoltage);
    fprintf("Measured open-circuit Voc peak-to-peak = %.6f V\n", Voc_oc.Voc_pp);
    fprintf("Measured open-circuit Voc half peak-to-peak = %.6f V\n", Voc_oc.Voc_half_pp);

    plotOpenCircuitVoc(Voc_oc);
else
    if useUnderwaterPaperModel
        Zseries_old = R + 1j*w*L + 1/(1j*w*C);
        ZCp_old = 1/(1j*w*Cp);
    
        openCircuitVoltage = abs(VSrc_eq_amp * ZCp_old / (Zseries_old + ZCp_old));
    else
        % openCircuitVoltage = 19.956714;
        Zseries_oc = R + 1j*w*L + 1/(1j*w*C);
        ZCp_oc = 1/(1j*w*Cp);

        openCircuitVoltage = abs( ...
            VSrc_eq_amp * ZCp_oc / (Zseries_oc + ZCp_oc) ...
            );
    end
    fprintf("Calculated open-circuit Voc fundamental amplitude = %.6f V\n", openCircuitVoltage);
end

%% ============================================================
% SINGLE DETAILED RUN
% ============================================================

fprintf("\n============================================================\n");
fprintf("SINGLE DETAILED %s RUN\n", char(string(Type)));
fprintf("============================================================\n");

single = runOnePEH(fast_mode, model, vpName, vcapName, vstoreName, ieqName, irectName, ipName, flipName, iL1Name, iL2Name, ...
    L, R, C, Cp, Crect, Rload_single, VF_bridge, VSrc_eq_amp, ...
    f, stopTime_single, t_start_ss_single, maxStep, ...
    Type, CrossCircuitType, Li, Rsw, R_closed, G_open, Threshold, Tsw, blankingTime, ...
    tEnable, Ieps, gamma, Qsshi, openCircuitVoltage);

printSingleSummary(single);

assignin("base", [TypeTag '_single_result'], single);

%% ============================================================
% SINGLE-RUN PLOTS
% ============================================================

plotSingleRun(single);
% flow = MyUtils.plotPaperStyleEnergyFlow(single);
% assignin("base", [TypeTag '_energy_flow'], flow);
% MyUtils.diagnosePiezoHarvesting(single);

%% ============================================================
% LOAD SWEEP
% ============================================================

if doSweep

    fprintf("\n============================================================\n");
    fprintf("RUNNING Rload SWEEP\n");
    fprintf("============================================================\n");

    N = numel(Rload_list);
    sweepResults = repmat(emptyResultStruct(), N, 1);

    for k = 1:N
        Rload_k = Rload_list(k);
        tauRC = Rload_k * Crect;

        stopTime_k = max(minStopTime, tauMultiplier * tauRC);
        stopTime_k = min(stopTime_k, maxStopTime);

        t_start_ss_k = ssStartFraction * stopTime_k;

        fprintf("\n[%02d/%02d] Rload = %.4e ohm, tau = %.3f s, StopTime = %.3f s\n", ...
            k, N, Rload_k, tauRC, stopTime_k);

        try
            sweepResults(k) = runOnePEH(fast_mode, model, vpName, vcapName, vstoreName, ieqName, irectName, ipName, flipName, iL1Name, iL2Name, ...
                L, R, C, Cp, Crect, Rload_k, VF_bridge, VSrc_eq_amp, ...
                f, stopTime_k, t_start_ss_k, maxStep, ...
                Type, CrossCircuitType, Li, Rsw, R_closed, G_open, Threshold, Tsw, blankingTime, ...
                tEnable, Ieps, gamma, Qsshi, openCircuitVoltage);
        catch ME
            warning("Sweep failed at Rload = %.4e ohm: %s", Rload_k, ME.message);
            sweepResults(k) = emptyResultStruct();
            sweepResults(k).Rload = Rload_k;
        end
    end

    sweepTable = resultsToTable(sweepResults);

    assignin("base", [TypeTag '_sweep_results'], sweepResults);
    assignin("base", [TypeTag '_sweep_table'], sweepTable);

    fprintf("\n============================================================\n");
    fprintf("SWEEP COMPLETE\n");
    fprintf("============================================================\n");

    disp(sweepTable);

    %% Find optimum load based on simulated harvested/load power
    validP = isfinite(sweepTable.Pload_avg_W);
    if any(validP)
        [Pmax, idxLocal] = max(sweepTable.Pload_avg_W(validP));
        validIdx = find(validP);
        idxOpt = validIdx(idxLocal);

        fprintf("\n===== OPTIMUM FROM SIMSCAPE LOAD SWEEP =====\n");
        fprintf("Optimum Rload = %.6e ohm\n", sweepTable.Rload_ohm(idxOpt));
        fprintf("Maximum harvested/load power = %.6f mW\n", Pmax*1000);
        fprintf("Vstore_avg = %.6f V\n", sweepTable.Vstore_avg_V(idxOpt));
        fprintf("Vrect = %.6f V\n", sweepTable.Vrect_V(idxOpt));
        fprintf("Vtilde_rect = %.6f\n", sweepTable.Vtilde_rect(idxOpt));
        fprintf("theta_paper = %.6f rad = %.3f deg\n", ...
            sweepTable.theta_paper_rad(idxOpt), rad2deg(sweepTable.theta_paper_rad(idxOpt)));
        fprintf("Zelec_sim = %.6e + j%.6e ohm\n", ...
            sweepTable.Re_Zelec_sim_ohm(idxOpt), sweepTable.Im_Zelec_sim_ohm(idxOpt));
        fprintf("Zelec_paper = %.6e + j%.6e ohm\n", ...
            sweepTable.Re_Zelec_paper_ohm(idxOpt), sweepTable.Im_Zelec_paper_ohm(idxOpt));
    end

    plotSweepResults(sweepTable, w, Cp);
end

fprintf("\nSaved:\n");
fprintf("  %s_single_result in base workspace\n", TypeTag);
fprintf("  %s_sweep_results and %s_sweep_table if doSweep=true\n", TypeTag, TypeTag);

totalTime = toc; % Stops timer and saves the elapsed time in seconds
fprintf('Total execution time: %.4f seconds.\n', totalTime);

%% ============================================================
% LOCAL FUNCTIONS
% ============================================================

function result = runOnePEH(fast_mode, model, vpName, vcapName, vstoreName, ieqName, irectName, ipName, flipName, iL1Name, iL2Name, ...
    L, R, C, Cp, Crect, Rload, VF_bridge, VSrc_eq_amp, ...
    f, stopTime, t_start_ss, maxStep, ...
    Type, CrossCircuitType, Li, Rsw, R_closed, G_open, Threshold, Tsw, blankingTime, ...
    tEnable, Ieps, gamma, Qsshi, openCircuitVoltage)

    runControl = 1;   % normal harvesting run (closed circuit)
    openCircuit = [0, runControl];

    w = 2*pi*f;
    T = 1/f;

    result = emptyResultStruct();
    
    result.L = L;
    result.R = R;
    result.C = C;
    result.Cp = Cp;
    
    result.Rload = Rload;
    result.Crect = Crect;
    result.VF_bridge = VF_bridge;
    result.VSrc_eq_amp = VSrc_eq_amp;
    result.f = f;
    result.w = w;
    result.Type = string(Type);
    result.CrossCircuitType = string(CrossCircuitType);
    result.gamma = gamma;
    result.Qsshi = Qsshi;
    result.openCircuitVoltage = openCircuitVoltage;
    result.Li = Li;
    result.Rsw = Rsw;
    result.Tsw = Tsw;

    %% Collect all model variables in one place
    params = struct( ...
        'L', L, 'R', R, 'C', C, 'Cp', Cp, ...
        'Rload', Rload, 'Crect', Crect, ...
        'VF_bridge', VF_bridge, ...
        'VSrc_eq_amp', VSrc_eq_amp, ...
        'f', f, 'w', w, ...
        'Type', string(Type), ...
        'Li', Li, 'Rsw', Rsw, 'R_closed', R_closed, ...
        'G_open', G_open, 'Threshold', Threshold, ...
        'Tsw', Tsw, 'blankingTime', blankingTime, ...
        'tEnable', tEnable, 'Ieps', Ieps, ...
        'gamma', gamma, 'Qsshi', Qsshi, 'openCircuit', openCircuit);

    %% Simulation input
    simIn = Simulink.SimulationInput(model);
    
    simIn = simIn.setModelParameter("StopTime", num2str(stopTime));
    simIn = simIn.setModelParameter("ReturnWorkspaceOutputs", "on");

    % fast mode
    if fast_mode
        simIn = simIn.setModelParameter("LimitDataPoints", "on");
        simIn = simIn.setModelParameter("MaxDataPoints", "20000");
        simIn = simIn.setModelParameter("Decimation", "5");
    else
        simIn = simIn.setModelParameter("LimitDataPoints", "off");
        simIn = simIn.setModelParameter("Decimation", "1");
    end

    if ~isempty(maxStep) && isfinite(maxStep) && maxStep > 0
        simIn = simIn.setModelParameter("MaxStep", num2str(maxStep));
    end

    %% Push variables to base workspace and SimulationInput in one loop
    fn = fieldnames(params);
    for i = 1:numel(fn)
        assignin("base", fn{i}, params.(fn{i}));
        simIn = simIn.setVariable(fn{i}, params.(fn{i}));
    end

    %% Run simulation
    simOut = sim(simIn);

    %% Read signals
    [t_vp, vp] = MyUtils.readSignalDirect(simOut, vpName);
    [t_vs, vstore] = MyUtils.readSignalDirect(simOut, vstoreName);
    [t_i, ieq] = MyUtils.readSignalDirect(simOut, ieqName);

    [t_vp, vp] = MyUtils.cleanTimeSignal(t_vp, vp);
    [t_vs, vstore] = MyUtils.cleanTimeSignal(t_vs, vstore);
    [t_i, ieq] = MyUtils.cleanTimeSignal(t_i, ieq);

    % vcap_sim exists only in the BJT cross-circuit variant.
    hasVcap = strcmpi(string(CrossCircuitType), "BJT");
    if hasVcap
        [t_vcap, vcap] = MyUtils.readSignalDirect(simOut, vcapName);
        [t_vcap, vcap] = MyUtils.cleanTimeSignal(t_vcap, vcap);
    else
        t_vcap = [];
        vcap = [];
    end

    [t_ir, irect] = MyUtils.readSignalDirect(simOut, irectName);
    [t_ir, irect] = MyUtils.cleanTimeSignal(t_ir, irect);

    [t_ip, ip] = MyUtils.readSignalDirect(simOut, ipName);
    [t_ip, ip] = MyUtils.cleanTimeSignal(t_ip, ip);

    if isSSHIType(Type) && CrossCircuitType == "BJT"
        [t_iL1, iL1] = MyUtils.readSignalDirect(simOut, iL1Name);
        [t_iL1, iL1] = MyUtils.cleanTimeSignal(t_iL1, iL1);

        [t_iL2, iL2] = MyUtils.readSignalDirect(simOut, iL2Name);
        [t_iL2, iL2] = MyUtils.cleanTimeSignal(t_iL2, iL2);
    else
        t_iL1 = [];
        iL1 = [];
        t_iL2 = [];
        iL2 = [];
    end

    if isSSHIType(Type) && CrossCircuitType == "Switch"
        [t_fp, fp] = MyUtils.readSignalDirect(simOut, flipName);
        [t_fp, fp] = MyUtils.cleanTimeSignal(t_fp, fp);
    else
        t_fp = [];
        fp = [];
    end

    % Use vp time as common time base
    t = t_vp(:);
    vp = vp(:);

    if hasVcap
        vcap = interp1(t_vcap, vcap, t, "linear", "extrap");
    else
        % Keep result arrays aligned without trying to read a missing signal.
        vcap = nan(size(t));
    end

    vstore = interp1(t_vs, vstore, t, "linear", "extrap");
    ieq = interp1(t_i, ieq, t, "linear", "extrap");
    irect = interp1(t_ir, irect, t, "linear", "extrap");
    ip = interp1(t_ip, ip, t, "linear", "extrap");

    if ~isempty(t_iL1)
        iL1 = interp1(t_iL1, iL1, t, "linear", "extrap");
    else
        iL1 = nan(size(t));
    end

    if ~isempty(t_iL2)
        iL2 = interp1(t_iL2, iL2, t, "linear", "extrap");
    else
        iL2 = nan(size(t));
    end

    if isSSHIType(Type) && CrossCircuitType == "Switch"
        fp = interp1(t_fp, fp, t, "previous", "extrap");
    end

    %% Steady-state region
    idx_ss = t >= t_start_ss;

    if sum(idx_ss) < 20
        fprintf("Actual final t = %.6f, points after ss = %d\n", t(end), sum(idx_ss));
        error("Not enough steady-state data. Lower t_start_ss or increase StopTime.");
    end

    t_ss = t(idx_ss);
    vp_ss = vp(idx_ss);
    vcap_ss = vcap(idx_ss);
    vstore_ss = vstore(idx_ss);
    ieq_ss = ieq(idx_ss);
    ip_ss = ip(idx_ss);

    %% One final steady-state cycle
    t2 = t_ss(end);
    t1 = t2 - T;

    idx_cycle = t >= t1 & t <= t2;

    if sum(idx_cycle) < 30
        error("Not enough points in one cycle. Reduce MaxStep or increase simulation resolution.");
    end

    t_c = t(idx_cycle);
    vp_c = vp(idx_cycle);
    vcap_c = vcap(idx_cycle);
    vstore_c = vstore(idx_cycle);
    ieq_c = ieq(idx_cycle);
    irect_c = irect(idx_cycle);
    ip_c = ip(idx_cycle);
    iL1_c = iL1(idx_cycle);
    iL2_c = iL2(idx_cycle);

    if isSSHIType(Type) && CrossCircuitType == "Switch"
        fp_c = fp(idx_cycle);
    else
        fp_c = [];
    end

    tau = t_c - t_c(1);

    %% Flip ON/OFF signal for both versions
    % Switch version: use the logged digital/control flip signal.
    % BJT version: use the real inductor currents. Flip is ON when L1 or L2 current flows.
    flipOn_c = false(size(t_c));
    flipSource = "none";
    flip_eps = NaN;
    flipL1_c = false(size(t_c));
    flipL2_c = false(size(t_c));

    if isSSHIType(Type) && CrossCircuitType == "Switch" && ~isempty(fp_c)
        fpMax = max(abs(fp_c), [], "omitnan");
        if isfinite(fpMax) && fpMax > 0
            flipOn_c = abs(fp_c) > 0.5 * fpMax;
        else
            flipOn_c = fp_c > 0.5;
        end
        flipSource = "flip_sim";

    elseif isSSHIType(Type) && CrossCircuitType == "BJT"
        IflipMax = max(abs([iL1_c(:); iL2_c(:)]), [], "omitnan");

        if isempty(IflipMax) || ~isfinite(IflipMax) || IflipMax <= 0
            flip_eps = NaN;
            flipOn_c = false(size(t_c));
        else
            flip_eps = max(1e-9, 0.02 * IflipMax);
            flipL1_c = abs(iL1_c) > flip_eps;
            flipL2_c = abs(iL2_c) > flip_eps;
            flipOn_c = flipL1_c | flipL2_c;
        end
        flipSource = "BJT inductor current";
    end

    %% Fundamental components
    [vp_F, VpF_amp, VpF_phase] = MyUtils.fundamentalComponent(t_c, vp_c, f);
    [ieq_F_raw, I0_raw, ieq_phase_raw] = MyUtils.fundamentalComponent(t_c, ieq_c, f);

    Vp_phasor = VpF_amp * exp(1j*VpF_phase);
    Ie_phasor_raw = I0_raw * exp(1j*ieq_phase_raw);

    Zelec_raw = Vp_phasor / Ie_phasor_raw;

    % Correct current sign if the electrical side appears to generate negative resistance.
    % This usually means the logged ieq direction is opposite to the paper convention.
    currentSign = 1;
    if real(Zelec_raw) < 0
        currentSign = -1;
    end

    ieq_c_eff = currentSign * ieq_c;
    ieq_ss_eff = currentSign * ieq_ss;
    ieq_F = currentSign * ieq_F_raw;
    Ie_phasor = currentSign * Ie_phasor_raw;

    I0 = abs(Ie_phasor);
    ieq_phase = angle(Ie_phasor);

    % Switch timing against zero-crossings of the equivalent source current.
    switchEvents = MyUtils.computeSwitchEvents(t_c, tau, flipOn_c, ieq_c_eff);

    Zelec_sim = Vp_phasor / Ie_phasor;

    %% Basic simulated power
    Pload_inst = vstore_ss.^2 ./ Rload;
    Pload_avg = trapz(t_ss, Pload_inst) / (t_ss(end) - t_ss(1));

    Vstore_avg = trapz(t_ss, vstore_ss) / (t_ss(end) - t_ss(1));

    %% Interface input power using vp_sim and ip_sim
    % This is the average real power at the piezo/interface port.
    % If the sign looks backwards, change interfaceCurrentSign to -1.
    interfaceCurrentSign = +1;
    Pinterface_inst = vp_ss .* (interfaceCurrentSign * ip_ss);
    Pinterface_avg = trapz(t_ss, Pinterface_inst) / (t_ss(end) - t_ss(1));

    %% Paper SEH / SSHI values at the Simscape operating point
    Voc_sim = I0 / (w * Cp);
    Vrect_sim = Vstore_avg + VF_bridge;
    Vtilde_sim = Vrect_sim / Voc_sim;
    Vtilde_F = VF_bridge / Voc_sim;

    %% Underwater paper Section 4.5 simplified full-wave rectifier result
    % Eq. (29): Vrect = (I0*Rload + pi*Vd)/(pi + w*Cp*Rload)
    % where Vrect = Vs + Vd. This is for the rectifier-only SEH baseline,
    % not for P-SSHI switching.
    Vrect_eq29 = NaN;
    Vs_eq29 = NaN;
    Pload_eq29 = NaN;
    if strcmpi(string(Type), "SEH")
        rect_eq29 = MyUtils.underwaterRectifierEq29(I0, w, Cp, Rload, VF_bridge);
        Vrect_eq29 = rect_eq29.Vrect;
        Vs_eq29 = rect_eq29.Vs;
        Pload_eq29 = rect_eq29.Pload;
    end

    theta_paper = NaN;
    Zelec_paper = NaN + 1j*NaN;
    Rd = NaN;
    Rh = NaN;
    XE = NaN;
    Ph_eq42_auto = NaN;
    Pdelta_eq43_auto = NaN;

    %% Equivalent source amplitude estimated from the simulated fundamental, Eq. 44
    ZL  = 1j*w*L;
    ZC  = 1/(1j*w*C);
    ZCp = 1/(1j*w*Cp);
    Zmech = R + ZL + ZC;
    % Veq_amp = abs(R + ZL + ZC + ZCp) / abs(ZCp) * Voc_sim;
    XL = imag(ZL);
    XC = imag(ZC);

    % Use measured open circuit voltage instead of eqn calculated Voc_sim
    Veq_amp = abs(R + ZL + ZC + ZCp) / abs(ZCp) * openCircuitVoltage;

    paperPoint = paperPointPEH(Type, w, Cp, Vtilde_sim, Vtilde_F, gamma);

    if paperPoint.valid

        theta_paper = paperPoint.theta;
        Zelec_paper = paperPoint.Zelec;
        Rd = paperPoint.Rd;
        Rh = paperPoint.Rh;
        XE = paperPoint.XE;

        X_total = imag(Zmech) + XE;
        denom = X_total^2 + (R + Rd + Rh)^2;

        Ph_eq42_auto = 0.5 * Veq_amp^2 * Rh / denom;
        Pdelta_eq43_auto = 0.5 * Veq_amp^2 * (Rh + Rd) / denom;

    end

    %% Extracted electrical power from time-domain and fundamental-domain
    Pdelta_time = trapz(t_c, vp_c .* ieq_c_eff) / (t_c(end) - t_c(1));

    Pdelta_fundamental = 0.5 * real(Zelec_sim) * I0^2;

    %% Rough theta measurement from simulated clamped region
    % S-SSHI uses a different ideal waveform and does not have the same
    % rectifier-blocked angle theta as SEH/P-SSHI.
    if isSSSHIType(Type)
        theta_sim_rough = NaN;
        theta_sim_exact = NaN;
    else
        theta_sim_rough = MyUtils.estimateThetaFromVpClamp(tau, vp_c, Vrect_sim, T);
        theta_sim_exact = MyUtils.estimateThetaFromRectCurrent(t_c, irect_c, ieq_phase, f);
    end

    %% Ideal paper waveform for one cycle
    vp_paper = nan(size(t_c));
    phi = mod(w*t_c + ieq_phase, 2*pi);
    gamma_eff = gammaForType(Type, gamma);

    if isSSSHIType(Type) && isfinite(Voc_sim) && isfinite(Vrect_sim)

        % S-SSHI Eq. 25.
        offset = ((1 - gamma_eff)/(1 + gamma_eff)) * (Voc_sim - Vrect_sim);

        for kk = 1:length(phi)
            p = phi(kk);

            if p >= 0 && p < pi
                vp_paper(kk) = -Voc_sim*cos(p) + offset;
            else
                vp_paper(kk) = -Voc_sim*cos(p) - offset;
            end
        end

        % Match polarity with simulated vp
        if MyUtils.simpleCorr(vp_paper(:), vp_c(:)) < 0
            vp_paper = -vp_paper;
        end

    elseif isfinite(theta_paper)

        for kk = 1:length(phi)
            p = phi(kk);

            % General SEH/P-SSHI Eq. 21. SEH is the special case gamma = 1.
            if p >= 0 && p < theta_paper
                vp_paper(kk) = Voc_sim * (1 - cos(p)) - gamma_eff * Vrect_sim;

            elseif p >= theta_paper && p < pi
                vp_paper(kk) = Vrect_sim;

            elseif p >= pi && p < pi + theta_paper
                vp_paper(kk) = gamma_eff * Vrect_sim - Voc_sim * (1 + cos(p));

            else
                vp_paper(kk) = -Vrect_sim;
            end
        end

        % Match polarity with simulated vp
        if MyUtils.simpleCorr(vp_paper(:), vp_c(:)) < 0
            vp_paper = -vp_paper;
        end
    end

    %% Store results
    result.valid = true;

    result.t = t;
    result.vp = vp;
    result.hasVcap = hasVcap;
    result.vcap = vcap;
    result.vstore = vstore;
    result.ieq_raw = ieq;
    result.ieq_eff = currentSign * ieq;
    result.irect = irect;

    result.t_ss = t_ss;
    result.vp_ss = vp_ss;
    result.vcap_ss = vcap_ss;
    result.vstore_ss = vstore_ss;
    result.ieq_ss_raw = ieq_ss;
    result.ieq_ss_eff = ieq_ss_eff;

    result.t_cycle = tau;
    result.t_cycle_abs = t_c;
    result.vp_cycle = vp_c;
    result.vcap_cycle = vcap_c;
    result.vstore_cycle = vstore_c;
    result.ieq_cycle_raw = ieq_c;
    result.ieq_cycle_eff = ieq_c_eff;
    result.irect_cycle = irect_c;
    result.ip_cycle = ip_c;
    result.iL1_cycle = iL1_c;
    result.iL2_cycle = iL2_c;
    result.flipOn_cycle = flipOn_c;
    result.flipL1_cycle = flipL1_c;
    result.flipL2_cycle = flipL2_c;
    result.flipSource = flipSource;
    result.flip_eps = flip_eps;
    result.switchEvents = switchEvents;
    result.fp_cycle = fp_c;

    result.vp_F = vp_F;
    result.ieq_F = ieq_F;
    result.vp_paper = vp_paper;

    result.currentSign = currentSign;

    result.VpF_amp = VpF_amp;
    result.VpF_phase = VpF_phase;
    result.I0 = I0;
    result.ieq_phase = ieq_phase;

    result.Pload_inst = Pload_inst;
    result.Pload_avg = Pload_avg;

    result.Pinterface_inst = Pinterface_inst;
    result.Pinterface_avg = Pinterface_avg;
    result.interfaceCurrentSign = interfaceCurrentSign;

    result.Pdelta_time = Pdelta_time;
    result.Pdelta_fundamental = Pdelta_fundamental;

    result.Vstore_avg = Vstore_avg;
    result.Vrect = Vrect_sim;
    result.Voc = Voc_sim;
    result.Vtilde_rect = Vtilde_sim;
    result.Vtilde_F = Vtilde_F;

    result.theta_paper = theta_paper;
    result.theta_sim_rough = theta_sim_rough;

    result.Zelec_sim = Zelec_sim;
    result.Zelec_paper = Zelec_paper;

    result.Rd = Rd;
    result.Rh = Rh;
    result.XE = XE;
    result.XL = XL;
    result.XC = XC;
    result.Zmech = Zmech;

    result.Veq_amp = Veq_amp;
    result.Ph_eq42_auto = Ph_eq42_auto;
    result.Pdelta_eq43_auto = Pdelta_eq43_auto;

    result.Vrect_eq29 = Vrect_eq29;
    result.Vs_eq29 = Vs_eq29;
    result.Pload_eq29 = Pload_eq29;

    result.stopTime = stopTime;
    result.t_start_ss = t_start_ss;
 
    result.theta_sim_exact = theta_sim_exact;
end

function printSingleSummary(r)

    fprintf("\n===== Simscape %s Results =====\n", char(string(r.Type)));
    fprintf("Rload = %.6e ohm\n", r.Rload);
    fprintf("Average harvested/load power = %.6f mW\n", r.Pload_avg * 1000);
    fprintf("Average Vstore = %.6f V\n", r.Vstore_avg);
    fprintf("Vrect = Vstore + VF_bridge = %.6f V\n", r.Vrect);
    fprintf("Peak-to-peak vp = %.6f V\n", max(r.vp_ss) - min(r.vp_ss));
    if isfield(r, "hasVcap") && r.hasVcap
        fprintf("Peak-to-peak vcap = %.6f V\n", max(r.vcap_ss) - min(r.vcap_ss));
    end
    fprintf("Peak-to-peak ieq_eff = %.6e A\n", max(r.ieq_ss_eff) - min(r.ieq_ss_eff));

    fprintf("\n===== Fundamental Components =====\n");
    fprintf("Fundamental ieq amplitude I0 = %.6e A\n", r.I0);
    fprintf("Fundamental vp amplitude = %.6f V\n", r.VpF_amp);
    fprintf("Current sign used = %+d\n", r.currentSign);

    fprintf("\n===== Paper-Style %s Estimates =====\n", char(string(r.Type)));
    fprintf("Voc = I0/(wCp) = %.6f V\n", r.Voc);
    fprintf("Measured actual open-circuit Voc = %.6f V\n", r.openCircuitVoltage);
    fprintf("Vtilde_rect = %.6f\n", r.Vtilde_rect);
    fprintf("Vtilde_F = %.6f\n", r.Vtilde_F);
    fprintf("gamma = %.8f, Qsshi = %.4f\n", r.gamma, r.Qsshi);

    if isfinite(r.theta_paper)
        fprintf("theta_paper = %.6f rad = %.3f deg\n", ...
            r.theta_paper, rad2deg(r.theta_paper));
        fprintf("theta_sim_rough = %.6f rad = %.3f deg\n", ...
            r.theta_sim_rough, rad2deg(r.theta_sim_rough));
        fprintf("theta_sim_exact = %.6f rad = %.3f deg\n", ...
            r.theta_sim_exact, rad2deg(r.theta_sim_exact));
    else
        fprintf("theta_paper = NaN because Vtilde_rect is outside the valid range for this interface\n");
    end

    fprintf("\n===== Equivalent Electrical Impedance =====\n");
    fprintf("Zelec_sim = %.6e + j%.6e ohm\n", real(r.Zelec_sim), imag(r.Zelec_sim));
    fprintf("Zelec_paper = %.6e + j%.6e ohm\n", real(r.Zelec_paper), imag(r.Zelec_paper));

    fprintf("Normalized Zelec_sim: Re*wCp = %.6f, Im*wCp = %.6f\n", ...
        real(r.Zelec_sim)*r.w*r.Cp, imag(r.Zelec_sim)*r.w*r.Cp);

    fprintf("Normalized Zelec_paper: Re*wCp = %.6f, Im*wCp = %.6f\n", ...
        real(r.Zelec_paper)*r.w*r.Cp, imag(r.Zelec_paper)*r.w*r.Cp);

    fprintf("\n===== %s Impedance Decomposition =====\n", char(string(r.Type)));
    fprintf("Rd = %.6e ohm\n", r.Rd);
    fprintf("Rh = %.6e ohm\n", r.Rh);
    fprintf("XE = %.6e ohm\n", r.XE);
    fprintf("XL = %.6e ohm\n", r.XL);
    fprintf("XC = %.6e ohm\n", r.XC);
    fprintf("Zmech = %.6e + j%.6e ohm\n", real(r.Zmech), imag(r.Zmech));
    fprintf("Rd + Rh = %.6e ohm\n", r.Rd + r.Rh);
    fprintf("Re(Zelec_paper) = %.6e ohm\n", real(r.Zelec_paper));
    fprintf("Im(Zelec_paper) = %.6e ohm\n", imag(r.Zelec_paper));

    fprintf("\n===== Harvested vs Extracted Power =====\n");
    fprintf("Simscape harvested/load power Vstore^2/Rload = %.6f mW\n", r.Pload_avg*1000);
    fprintf("Interface input power mean(vp*ip) = %.6f mW\n", r.Pinterface_avg*1000);
    fprintf("Time-domain extracted power mean(vp*ieq_eff) = %.6f mW\n", r.Pdelta_time*1000);
    fprintf("Fundamental extracted power 0.5*Re(Zelec)*I0^2 = %.6f mW\n", r.Pdelta_fundamental*1000);
    fprintf("Eq. 42 harvested power = %.6f mW\n", r.Ph_eq42_auto*1000);
    fprintf("Eq. 43 extracted power = %.6f mW\n", r.Pdelta_eq43_auto*1000);
    fprintf("Underwater Eq. 29 Vrect = %.6f V, Vs = %.6f V\n", ...
        r.Vrect_eq29, r.Vs_eq29);
    fprintf("Underwater Eq. 29 harvested/load power = %.6f mW\n", ...
        r.Pload_eq29*1000);
    fprintf("Predicted dissipated power = %.6f mW\n", ...
        (r.Pdelta_eq43_auto - r.Ph_eq42_auto)*1000);

    fprintf("\n===== Equivalent Source =====\n");
    fprintf("Veq_amp inferred from measured open-circuit Voc = %.6f V\n", r.Veq_amp);
    fprintf("Ideal VSrc_eq_amp used in model source = %.6f V\n", r.VSrc_eq_amp);

    printSwitchTiming(r);
end

function printSwitchTiming(r)

    fprintf("\n===== Switch / Flip Timing, Final Cycle =====\n");

    if ~isfield(r, "flipSource") || strlength(string(r.flipSource)) == 0
        fprintf("No flip source stored.\n");
    else
        fprintf("Flip source = %s\n", char(string(r.flipSource)));
    end

    if isfield(r, "flip_eps") && isfinite(r.flip_eps)
        fprintf("BJT flip current threshold = %.6e A\n", r.flip_eps);
    end

    if isfield(r, "Tsw") && isfinite(r.Tsw)
        fprintf("Expected ideal LC half-period Tsw = %.3f us\n", r.Tsw * 1e6);
    end

    % Print all equivalent-current zero-crossings in the final cycle.
    if isfield(r, "t_cycle_abs") && ~isempty(r.t_cycle_abs)
        tAbs = r.t_cycle_abs(:);
    elseif isfield(r, "t_cycle") && ~isempty(r.t_cycle)
        tAbs = r.t_cycle(:);
    else
        fprintf("No cycle time vector found.\n");
        return;
    end

    if isfield(r, "t_cycle") && ~isempty(r.t_cycle)
        tRel = r.t_cycle(:);
    else
        tRel = tAbs - tAbs(1);
    end

    if isfield(r, "ieq_cycle_eff") && ~isempty(r.ieq_cycle_eff)
        currentForZero = r.ieq_cycle_eff(:);
        currentName = "i_eq";
    elseif isfield(r, "ip_cycle") && ~isempty(r.ip_cycle)
        currentForZero = r.ip_cycle(:);
        currentName = "i_p";
    else
        fprintf("No current signal found for zero-cross timing.\n");
        currentForZero = [];
        currentName = "current";
    end

    if ~isempty(currentForZero) && numel(currentForZero) == numel(tAbs)
        zc = MyUtils.findZeroCrossings(tAbs, tRel, currentForZero);
    else
        zc.tAbs = [];
        zc.tRel = [];
    end

    fprintf("%s zero-crossings in final cycle:\n", char(currentName));
    if isempty(zc.tAbs)
        fprintf("  none found\n");
    else
        for kk = 1:numel(zc.tAbs)
            fprintf("  ZC %d: absolute %.9f s, cycle %.9f s\n", ...
                kk, zc.tAbs(kk), zc.tRel(kk));
        end
    end

    events = r.switchEvents;

    if isempty(events)
        fprintf("No switch/flip ON events found in the final cycle.\n");
        return;
    end

    for kk = 1:numel(events)
        e = events(kk);

        fprintf(['Event %d: closed from %.9f s to %.9f s absolute ' ...
                 '(cycle %.9f s to %.9f s)\n'], ...
            kk, e.tStartAbs, e.tEndAbs, e.tStartRel, e.tEndRel);

        fprintf('         duration = %.3f us\n', e.duration * 1e6);

        if isfinite(e.nearestCurrentZeroAbs)
            fprintf(['         nearest %s zero-cross = %.9f s absolute ' ...
                     '(cycle %.9f s)\n'], ...
                char(currentName), e.nearestCurrentZeroAbs, e.nearestCurrentZeroRel);

            fprintf('         switch delay from zero-cross = %.3f us\n', ...
                e.delayFromZero * 1e6);
        else
            fprintf('         nearest %s zero-cross = not found in final cycle\n', ...
                char(currentName));
        end
    end
end

function plotOpenCircuitVoc(oc)
    figure("Name", "Measured Open-Circuit Voc");
    
    plot(oc.t_cycle, oc.vp_cycle, "LineWidth", 1.4); hold on;
    plot(oc.t_cycle, oc.vp_F, "--", "LineWidth", 1.6);
    
    grid on;
    xlabel("Time within final cycle (s)");
    ylabel("Open-circuit v_p (V)");
    title("Measured Actual Open-Circuit Transducer Voltage");
    legend("Open-circuit v_p", "Fundamental component", "Location", "best");
end

function plotSingleRun(r)

    %% Plot 1: steady-state signals
    figure("Name", "Single Run: Steady-State Simscape Signals");
    tiledlayout(4,1);

    nexttile;
    plot(r.t_ss, r.vp_ss, "LineWidth", 1.2); hold on;
    labels1 = "v_p";
    if isfield(r, "hasVcap") && r.hasVcap
        plot(r.t_ss, r.vcap_ss, "--", "LineWidth", 1.2);
        labels1(end+1) = "v_{cap}";
    end
    grid on;
    ylabel("Voltage (V)");
    title("Steady-State Simscape " + string(r.Type) + " Signals");
    legend(labels1, "Location", "best");

    nexttile;
    plot(r.t_ss, r.ieq_ss_eff, "LineWidth", 1.2);
    grid on;
    ylabel("i_{eq} used (A)");

    nexttile;
    plot(r.t_ss, r.vstore_ss, "LineWidth", 1.2);
    grid on;
    ylabel("V_{store} (V)");

    nexttile;
    plot(r.t_ss, r.Pload_inst*1000, "LineWidth", 1.2);
    grid on;
    ylabel("P_{load} (mW)");
    xlabel("Time (s)");

    %% Plot 2: normalized paper-style waveform comparison
    figure("Name", "Single Run: Paper-Style Waveform Comparison");

    plot(r.t_cycle, MyUtils.normalizeShape(r.ieq_F), "--", "LineWidth", 1.5); hold on;
    plot(r.t_cycle, MyUtils.normalizeShape(r.vp_cycle), "LineWidth", 1.5);
    labels2 = ["i_{eq,F}", "Simscape v_p"];

    if isfield(r, "hasVcap") && r.hasVcap
        plot(r.t_cycle, MyUtils.normalizeShape(r.vcap_cycle), "--", "LineWidth", 1.5);
        labels2(end+1) = "Simscape v_{cap}";
    end

    plot(r.t_cycle, MyUtils.normalizeShape(r.vp_F), ":", "LineWidth", 2.0);
    plot(r.t_cycle, MyUtils.normalizeShape(r.irect_cycle), "LineWidth", 2.0);
    plot(r.t_cycle, MyUtils.normalizeShape(MyUtils.removeSpikes(r.ip_cycle, 0.0003)), "LineWidth", 2.0);
    labels2(end+1:end+3) = ["v_{p,F}", "i_{rect}", "i_{piezo}"];
    if all(isfinite(r.vp_paper))
        plot(r.t_cycle, MyUtils.normalizeShape(r.vp_paper), "-.", "LineWidth", 1.5);
        labels2(end+1) = "Ideal paper v_p";
    end
    legend(labels2, "Location", "best");

    grid on;
    xlabel("Time within one cycle (s)");
    ylabel("Normalized amplitude");
    title("Paper-Style " + string(r.Type) + " Waveform from Simscape");
    xlim([0, 1/r.f]);

    %% Plot 3: absolute one-cycle waveforms
    figure("Name", "Single Run: One-Cycle Absolute Waveforms");

    yyaxis left;
    plot(r.t_cycle, r.vp_cycle, "LineWidth", 1.4); hold on;
    labels3 = "Simscape v_p";

    if isfield(r, "hasVcap") && r.hasVcap
        plot(r.t_cycle, r.vcap_cycle, "--", "LineWidth", 1.4);
        labels3(end+1) = "Simscape v_{cap}";
    end

    plot(r.t_cycle, r.vp_F, ":", "LineWidth", 2.0);
    labels3(end+1) = "v_{p,F}";

    if all(isfinite(r.vp_paper))
        plot(r.t_cycle, r.vp_paper, "-.", "LineWidth", 1.4);
    end
    plot(r.t_cycle, r.vstore_cycle, "-.g", "LineWidth", 1.4);

    ylabel("Voltage (V)");

    yyaxis right;

    cutoff = 100; % no cutoff
    if string(r.Type) == "PSSHI"
        cutoff = 0.005;
    end

    ieq_plot = MyUtils.removeSpikes(r.ieq_cycle_eff, cutoff);
    plot(r.t_cycle, ieq_plot, "-.r", "LineWidth", 1.4);
    plot(r.t_cycle, r.irect_cycle, "-y", "LineWidth", 1.4);

    ip_plot = MyUtils.removeSpikes(r.ip_cycle, cutoff);
    plot(r.t_cycle, ip_plot, "-.m", "LineWidth", 1.4);

    % One simple flip ON/OFF trace for both Switch and BJT versions.
    % Switch version: flipOn_cycle comes from flip_sim.
    % BJT version: flipOn_cycle comes from abs(iL1) or abs(iL2).
    if isfield(r, "flipOn_cycle") && ~isempty(r.flipOn_cycle) && any(r.flipOn_cycle)
        Iscale = 0.8 * max(abs([ieq_plot(:); r.irect_cycle(:); ip_plot(:)]), [], "omitnan");
        if ~isfinite(Iscale) || Iscale <= 0
            Iscale = 1;
        end
        stairs(r.t_cycle, double(r.flipOn_cycle) * Iscale, "-.w", "LineWidth", 1.5);
    end
    ylabel("Current (A)");

    grid on;
    xlabel("Time within one cycle (s)");
    title("One-Cycle Simscape vs Fundamental vs Paper " + string(r.Type));

    if all(isfinite(r.vp_paper))
        labels3(end+1) = "Ideal paper v_p";
    end
    labels3(end+1:end+4) = ["v_{store}", "i_{eq}", "i_{rect}", "i_{piezo}"];
    if isfield(r, "flipOn_cycle") && ~isempty(r.flipOn_cycle) && any(r.flipOn_cycle)
        labels3(end+1) = "flip";
    end
    legend(labels3, "Location", "best");
end

function plotSweepResults(tbl, w, Cp)

    valid = tbl.valid == true & isfinite(tbl.Pload_avg_W);

    if ~any(valid)
        warning("No valid sweep points to plot.");
        return;
    end

    %% Plot harvested power vs Rload
    figure("Name", "Sweep: Harvested Power vs Rload");
    semilogx(tbl.Rload_ohm(valid), tbl.Pload_avg_W(valid)*1000, "o-", "LineWidth", 1.5); hold on;
    semilogx(tbl.Rload_ohm(valid), tbl.Pdelta_time_W(valid)*1000, "s--", "LineWidth", 1.2);
    semilogx(tbl.Rload_ohm(valid), tbl.Pdelta_fundamental_W(valid)*1000, "d:", "LineWidth", 1.2);
    semilogx(tbl.Rload_ohm(valid), tbl.Ph_eq42_auto_W(valid)*1000, "x--", "LineWidth", 1.2);
    semilogx(tbl.Rload_ohm(valid), tbl.Pdelta_eq43_auto_W(valid)*1000, "d:", "LineWidth", 1.2);
    semilogx(tbl.Rload_ohm(valid), tbl.Pload_eq29_W(valid)*1000, "^--", "LineWidth", 1.2);
    grid on;
    xlabel("R_{load} (\Omega)");
    ylabel("Power (mW)");
    title("Harvested vs Extracted Power");
    legend("Harvested/load: Vstore^2/Rload", ...
           "Extracted time-domain: mean(v_p i_{eq})", ...
           "Extracted fundamental", ...
           "Paper Eq. 42", ...
           "Paper Eq. 43", ...
           "Underwater Eq. 29", ...
           "Location", "best");

    %% Plot harvested power vs Vtilde_rect
    validV = valid & isfinite(tbl.Vtilde_rect);

    figure("Name", "Sweep: Power vs Normalized Rectified Voltage");
    plot(tbl.Vtilde_rect(validV), tbl.Pload_avg_W(validV)*1000, "o-", "LineWidth", 1.5); hold on;
    plot(tbl.Vtilde_rect(validV), tbl.Ph_eq42_auto_W(validV)*1000, "s--", "LineWidth", 1.2);
    plot(tbl.Vtilde_rect(validV), tbl.Pdelta_eq43_auto_W(validV)*1000, "d:", "LineWidth", 1.2);
    plot(tbl.Vtilde_rect(validV), tbl.Pdelta_fundamental_W(validV)*1000, "d:", "LineWidth", 1.2);
    plot(tbl.Vtilde_rect(validV), tbl.Pload_eq29_W(validV)*1000, "^--", "LineWidth", 1.2);
    grid on;
    xlabel("$\tilde{V}_{rect} = V_{rect}/V_{oc}$", 'Interpreter', 'latex');
    ylabel("Power (mW)");
    title("Power vs Normalized Rectified Voltage");
    legend("Simscape harvested/load", ...
           "Paper Eq. 42 harvested", ...
           "Paper Eq. 43 extracted", ...
           "Simscape extracted", ...
           "Underwater Eq. 29", ...
           "Location", "best");

    %% Plot impedance components vs Vtilde
    figure("Name", "Sweep: Impedance Decomposition");
    plot(tbl.Vtilde_rect(validV), tbl.Rd_ohm(validV), "o-", "LineWidth", 1.3); hold on;
    plot(tbl.Vtilde_rect(validV), tbl.Rh_ohm(validV), "s-", "LineWidth", 1.3);
    plot(tbl.Vtilde_rect(validV), tbl.XE_ohm(validV), "d-", "LineWidth", 1.3);
    % plot(tbl.Vtilde_rect(validV), tbl.XL_ohm(validV), "d-", "LineWidth", 1.3);
    % plot(tbl.Vtilde_rect(validV), tbl.XC_ohm(validV), "d-", "LineWidth", 1.3);
    plot(tbl.Vtilde_rect(validV), imag(tbl.Zmech(validV)), "d-", "LineWidth", 1.3);
    plot(tbl.Vtilde_rect(validV), tbl.R(validV), "d-", "LineWidth", 1.3);
    grid on;
    xlabel("$\tilde{V}_{rect}$", 'Interpreter', 'latex');
    ylabel("Ohms");
    title("Equivalent Impedance Decomposition");
    legend("R_d dissipative", "R_h harvesting", "X_E reactive", "X_L+X_C", "R", ...
        "Location", "best");

    %% Complex impedance plane
    figure("Name", "Sweep: Normalized Zelec Complex Plane");

    ReSim = tbl.Re_Zelec_sim_ohm(validV) * w * Cp;
    ImSim = tbl.Im_Zelec_sim_ohm(validV) * w * Cp;

    RePaper = tbl.Re_Zelec_paper_ohm(validV) * w * Cp;
    ImPaper = tbl.Im_Zelec_paper_ohm(validV) * w * Cp;

    plot(ReSim, ImSim, "o-", "LineWidth", 1.5); hold on;
    plot(RePaper, ImPaper, "s--", "LineWidth", 1.5);

    grid on;
    xlabel("Re[Z_{elec}] \omega C_p");
    ylabel("Im[Z_{elec}] \omega C_p");
    title("Electrical Part Equivalent Impedance Plane");
    legend("Simscape fundamental", "Paper formula", ...
        "Location", "best");

    %% Re and Im comparison
    figure("Name", "Sweep: Zelec Simscape vs Paper");
    tiledlayout(2,1);

    nexttile;
    plot(tbl.Vtilde_rect(validV), tbl.Re_Zelec_sim_ohm(validV), "o-", "LineWidth", 1.4); hold on;
    plot(tbl.Vtilde_rect(validV), tbl.Re_Zelec_paper_ohm(validV), "s--", "LineWidth", 1.4);
    grid on;
    ylabel("Re[Z_{elec}] (\Omega)");
    title("Real Part of Z_{elec}");
    legend("Simscape", "Paper", "Location", "best");

    nexttile;
    plot(tbl.Vtilde_rect(validV), tbl.Im_Zelec_sim_ohm(validV), "o-", "LineWidth", 1.4); hold on;
    plot(tbl.Vtilde_rect(validV), tbl.Im_Zelec_paper_ohm(validV), "s--", "LineWidth", 1.4);
    grid on;
    xlabel("$\tilde{V}_{rect}$", 'Interpreter', 'latex');
    ylabel("Im[Z_{elec}] (\Omega)");
    title("Imaginary Part of Z_{elec}");
    legend("Simscape", "Paper", "Location", "best");
    legend("Paper", "Location", "best");

    %% Theta validation. Skip for S-SSHI because theta is not defined there.
    if any(isfinite(tbl.theta_paper_rad(validV))) || any(isfinite(tbl.theta_sim_exact_rad(validV)))
        figure("Name", "Sweep: Rectifier Blocked Angle");
        plot(tbl.Vtilde_rect(validV), tbl.theta_paper_rad(validV), "o-", "LineWidth", 1.4); hold on;
        % plot(tbl.Vtilde_rect(validV), tbl.theta_sim_rough_rad(validV), "s--", "LineWidth", 1.4);
        plot(tbl.Vtilde_rect(validV), tbl.theta_sim_exact_rad(validV), "s--", "LineWidth", 1.4);

        grid on;
        xlabel("$\tilde{V}_{rect}$", 'Interpreter', 'latex');
        ylabel("\theta (rad)");
        title("Rectifier Blocked Angle: Paper Formula vs Simscape Estimate");
        % legend("\theta from paper formula", "\theta rough from v_p clamp", ...
        %     "Location", "best");
        legend("\theta from paper formula", "\theta from rectifier current", ...
            "Location", "best");
    end
end

function tf = isPSSHIType(Type)
    tf = any(strcmpi(string(Type), ["PSSHI", "P-SSHI"]));
end

function tf = isSSSHIType(Type)
    tf = any(strcmpi(string(Type), ["SSSHI", "S-SSHI"]));
end

function tf = isSSHIType(Type)
    tf = isPSSHIType(Type) || isSSSHIType(Type);
end

function gamma_eff = gammaForType(Type, gamma)
    if strcmpi(string(Type), "SEH")
        gamma_eff = 1;
    elseif isSSHIType(Type)
        gamma_eff = gamma;
    else
        error("Unsupported Type '%s'. Use 'SEH', 'PSSHI', or 'SSSHI'.", char(string(Type)));
    end
end

function p = paperPointPEH(Type, w, Cp, Vtilde_rect, Vtilde_F, gamma)
    % Computes paper impedance values for SEH, P-SSHI, or S-SSHI at one
    % Vtilde point.
    %   SEH/P-SSHI: Eq. 23/24 and Eq. 31/32/33, with SEH = gamma = 1.
    %   S-SSHI:     Eq. 26 and Eq. 34/35/36.
    
    p.valid = false;
    p.theta = NaN;
    p.Zelec = NaN + 1j*NaN;
    p.Rd = NaN;
    p.Rh = NaN;
    p.XE = NaN;
    
    gamma_eff = gammaForType(Type, gamma);
    
    if ~(isfinite(Vtilde_rect) && isfinite(Vtilde_F) && isfinite(gamma_eff))
        return;
    end

    if Vtilde_rect <= 0
        return;
    end

    % ============================================================
    % S-SSHI: Eq. 26 and Eq. 34-36
    % ============================================================
    if isSSSHIType(Type)

        % gamma must be between -1 and 1 for the factor to be finite.
        if gamma_eff <= -1 || gamma_eff >= 1
            return;
        end

        % S-SSHI useful harvesting region from the analytical model.
        if Vtilde_rect <= Vtilde_F || Vtilde_rect >= 1
            return;
        end

        factor = (1 - gamma_eff) / (1 + gamma_eff);

        % Eq. 26
        Zelec = (1/(w*Cp)) * ( ...
            (4/pi) * factor * (1 - Vtilde_rect) ...
            - 1j );

        % Eq. 34-36
        scale = 4/(pi*w*Cp) * factor;
        Rd = scale * (1 - Vtilde_rect + Vtilde_F) * (1 - Vtilde_rect);
        Rh = scale * (Vtilde_rect - Vtilde_F) * (1 - Vtilde_rect);
        XE = -1/(w*Cp);

        p.valid = true;
        p.theta = NaN;
        p.Zelec = Zelec;
        p.Rd = Rd;
        p.Rh = Rh;
        p.XE = XE;
        return;
    end

    % ============================================================
    % SEH / P-SSHI: Eq. 23/24 and Eq. 31-33
    % ============================================================
    k = 1 + gamma_eff;
    if k <= 0
        return;
    end
    
    % Eq. 24: cos(theta) = 1 - (1 + gamma)*Vtilde_rect
    % For SEH with gamma=1, this becomes Eq. 13.
    arg = 1 - k*Vtilde_rect;
    if arg < -1 || arg > 1
        return;
    end
    
    theta = acos(arg);
    s = sin(theta);
    c = cos(theta);
    
    scale = 1/(pi*w*Cp);
    
    % Eq. 23, electrical equivalent impedance for P-SSHI.
    % With gamma=1, this collapses to the SEH Eq. 16.
    ReTerm = (1 - c) * (4/(1 + gamma_eff) - 1 + c);
    ImTerm = s*c - theta;
    Zelec = scale * (ReTerm + 1j*ImTerm);
    
    % Eq. 31-33, impedance decomposition for P-SSHI.
    % With gamma=1, these collapse to SEH Eq. 27-29.
    Rd = scale * (2*Vtilde_F*(2 - Vtilde_rect*(1 + gamma_eff)) + ...
        Vtilde_rect^2*(1 - gamma_eff^2));
    Rh = 2*scale * (Vtilde_rect - Vtilde_F) * ...
        (2 - Vtilde_rect*(1 + gamma_eff));
    XE = scale * (s*c - theta);
    
    p.valid = true;
    p.theta = theta;
    p.Zelec = Zelec;
    p.Rd = Rd;
    p.Rh = Rh;
    p.XE = XE;
end

function tbl = resultsToTable(res)

    N = numel(res);

    % Build a struct array with the final column names, then convert once.
    for k = N:-1:1
        r = res(k);

        rows(k).valid                = r.valid;
        rows(k).Rload_ohm            = r.Rload;
        rows(k).Vstore_avg_V         = r.Vstore_avg;
        rows(k).Vrect_V              = r.Vrect;
        rows(k).Voc_V                = r.Voc;
        rows(k).Vtilde_rect          = r.Vtilde_rect;
        rows(k).Vtilde_F             = r.Vtilde_F;
        rows(k).theta_paper_rad      = r.theta_paper;
        rows(k).theta_sim_rough_rad  = r.theta_sim_rough;
        rows(k).theta_sim_exact_rad  = r.theta_sim_exact;
        rows(k).Pload_avg_W          = r.Pload_avg;
        rows(k).Pinterface_avg_W     = r.Pinterface_avg;
        rows(k).Pdelta_time_W        = r.Pdelta_time;
        rows(k).Pdelta_fundamental_W = r.Pdelta_fundamental;
        rows(k).Ph_eq42_auto_W       = r.Ph_eq42_auto;
        rows(k).Pdelta_eq43_auto_W   = r.Pdelta_eq43_auto;
        rows(k).Vrect_eq29_V         = r.Vrect_eq29;
        rows(k).Vs_eq29_V            = r.Vs_eq29;
        rows(k).Pload_eq29_W         = r.Pload_eq29;
        rows(k).Re_Zelec_sim_ohm     = real(r.Zelec_sim);
        rows(k).Im_Zelec_sim_ohm     = imag(r.Zelec_sim);
        rows(k).Re_Zelec_paper_ohm   = real(r.Zelec_paper);
        rows(k).Im_Zelec_paper_ohm   = imag(r.Zelec_paper);
        rows(k).Rd_ohm               = r.Rd;
        rows(k).Rh_ohm               = r.Rh;
        rows(k).XE_ohm               = r.XE;
        rows(k).XL_ohm               = r.XL;
        rows(k).XC_ohm               = r.XC;
        rows(k).R                    = r.R;
        rows(k).Zmech                = r.Zmech;
        rows(k).I0_A                 = r.I0;
        rows(k).VpF_amp_V            = r.VpF_amp;
        rows(k).Veq_amp_V            = r.Veq_amp;
        rows(k).currentSign          = r.currentSign;
        rows(k).gamma                = r.gamma;
        rows(k).Qsshi                = r.Qsshi;
        rows(k).openCircuitVoltage          = r.openCircuitVoltage;
        rows(k).Type                 = string(r.Type);
        rows(k).stopTime_s           = r.stopTime;
        rows(k).t_start_ss_s         = r.t_start_ss;
    end

    tbl = struct2table(rows);
end

function result = emptyResultStruct()
    result.valid = false;

    result.L = NaN;
    result.R = NaN;
    result.C = NaN;
    result.Cp = NaN;

    result.Rload = NaN;
    result.Crect = NaN;
    result.VF_bridge = NaN;
    result.VSrc_eq_amp = NaN;
    result.f = NaN;
    result.w = NaN;
    result.Type = "";
    result.CrossCircuitType = "";
    result.gamma = NaN;
    result.Qsshi = NaN;
    result.openCircuitVoltage = [];
    result.Li = NaN;
    result.Rsw = NaN;
    result.Tsw = NaN;

    result.t = [];
    result.vp = [];
    result.hasVcap = false;
    result.vcap = [];
    result.vstore = [];
    result.ieq_raw = [];
    result.ieq_eff = [];

    result.t_ss = [];
    result.vp_ss = [];
    result.vcap_ss = [];
    result.vstore_ss = [];
    result.ieq_ss_raw = [];
    result.ieq_ss_eff = [];
    result.irect = [];

    result.t_cycle = [];
    result.t_cycle_abs = [];
    result.vp_cycle = [];
    result.vcap_cycle = [];
    result.vstore_cycle = [];
    result.ieq_cycle_raw = [];
    result.ieq_cycle_eff = [];
    result.irect_cycle = [];
    result.ip_cycle = [];
    result.iL1_cycle = [];
    result.iL2_cycle = [];
    result.fp_cycle = [];
    result.flipOn_cycle = [];
    result.flipL1_cycle = [];
    result.flipL2_cycle = [];
    result.flipSource = "";
    result.flip_eps = NaN;
    result.switchEvents = [];

    result.vp_F = [];
    result.ieq_F = [];
    result.vp_paper = [];

    result.currentSign = NaN;
    result.VpF_amp = NaN;
    result.VpF_phase = NaN;
    result.I0 = NaN;
    result.ieq_phase = NaN;

    result.Pload_inst = [];
    result.Pload_avg = NaN;

    result.Pinterface_inst = [];
    result.Pinterface_avg = NaN;
    result.interfaceCurrentSign = NaN;

    result.Pdelta_time = NaN;
    result.Pdelta_fundamental = NaN;

    result.Vstore_avg = NaN;
    result.Vrect = NaN;
    result.Voc = NaN;
    result.Vtilde_rect = NaN;
    result.Vtilde_F = NaN;

    result.theta_paper = NaN;
    result.theta_sim_rough = NaN;
    result.theta_sim_exact = NaN;

    result.Zelec_sim = NaN + 1j*NaN;
    result.Zelec_paper = NaN + 1j*NaN;
    result.Rd = NaN;
    result.Rh = NaN;
    result.XE = NaN;
    result.XL = NaN;
    result.XC = NaN;
    result.Zmech = NaN;

    result.Veq_amp = NaN;
    result.Ph_eq42_auto = NaN;
    result.Pdelta_eq43_auto = NaN;

    result.Vrect_eq29 = NaN;
    result.Vs_eq29 = NaN;
    result.Pload_eq29 = NaN;

    result.stopTime = NaN;
    result.t_start_ss = NaN;
end
