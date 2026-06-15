classdef MyUtils
    methods (Static)
        function [t, y] = readSignalDirect(simOut, name)
        
            name = char(name);
        
            try
                sig = simOut.get(name);
            catch
                try
                    sig = evalin("base", name);
                catch
                    error("Could not find signal '%s'. Check your To Workspace signal name.", name);
                end
            end
        
            [t, y] = MyUtils.signalToTimeData(sig, simOut);
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
        
            % y ≈ a sin(wt) + b cos(wt)
            A = [sin(w*t), cos(w*t)];
            coeff = A \ y;
        
            a = coeff(1);
            b = coeff(2);
        
            amp = hypot(a, b);
            phase = atan2(b, a);
        
            yF = amp * sin(w*t + phase);
        end
        
        function theta_est = estimateThetaFromVpClamp(tau, vp, Vrect, T)
        
            theta_est = NaN;
        
            if ~isfinite(Vrect) || Vrect <= 0 || numel(tau) < 20
                return;
            end
        
            tau = tau(:);
            vp = vp(:);
        
            % Uniform grid for rough duty-cycle estimate
            tq = linspace(0, T, 1000).';
            vpq = interp1(tau, vp, tq, "linear", "extrap");
        
            % Detect when bridge is approximately clamping vp near +/- Vrect.
            tol = max(0.03 * abs(Vrect), 0.10);
            conducting = abs(abs(vpq) - abs(Vrect)) < tol;
        
            conductingFraction = mean(conducting, "omitnan");
        
            % Total conducting phase over full cycle = 2*pi*conductingFraction
            % For SEH, total conducting phase = 2*(pi - theta)
            totalConductingPhase = 2*pi*conductingFraction;
        
            theta_est = pi - totalConductingPhase/2;
        
            if theta_est < 0 || theta_est > pi
                theta_est = NaN;
            end
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
        
        function oc = measureOpenCircuitVoc(model, vpName, ...
                L, R, C, Cp, Crect, Rload, VF_bridge, VSrc_eq_amp, ...
                f, stopTime, t_start_ss, maxStep, ...
                Type, Li, Rsw, R_closed, G_open, Threshold, Tsw, blankingTime, ...
                tEnable, Ieps, gamma, Qsshi)

            ocControl  = 0;   % open-circuit measurement
            openCircuit  = [0, ocControl];

            w = 2*pi*f;
            T = 1/f;

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
                'gamma', gamma, 'Qsshi', Qsshi, ...
                'openCircuit', openCircuit);

            simIn = Simulink.SimulationInput(model);

            simIn = simIn.setModelParameter("StopTime", num2str(stopTime));
            simIn = simIn.setModelParameter("ReturnWorkspaceOutputs", "on");
            simIn = simIn.setModelParameter("LimitDataPoints", "off");
            simIn = simIn.setModelParameter("Decimation", "1");

            if ~isempty(maxStep) && isfinite(maxStep) && maxStep > 0
                simIn = simIn.setModelParameter("MaxStep", num2str(maxStep));
            end

            fn = fieldnames(params);

            for i = 1:numel(fn)
                assignin("base", fn{i}, params.(fn{i}));
                simIn = simIn.setVariable(fn{i}, params.(fn{i}));
            end

            simOut = sim(simIn);

            [t_vp, vp] = MyUtils.readSignalDirect(simOut, vpName);
            [t_vp, vp] = MyUtils.cleanTimeSignal(t_vp, vp);

            t = t_vp(:);
            vp = vp(:);

            idx_ss = t >= t_start_ss;

            if sum(idx_ss) < 20
                fprintf("Actual final t = %.6f, points after ss = %d\n", t(end), sum(idx_ss));
                error("Not enough steady-state data for open-circuit Voc measurement.");
            end

            t_ss = t(idx_ss);
            vp_ss = vp(idx_ss);

            t2 = t_ss(end);
            t1 = t2 - T;

            idx_cycle = t >= t1 & t <= t2;

            if sum(idx_cycle) < 30
                error("Not enough points in final open-circuit cycle.");
            end

            t_c = t(idx_cycle);
            vp_c = vp(idx_cycle);

            [vp_F, Voc_amp, Voc_phase] = MyUtils.fundamentalComponent(t_c, vp_c, f);

            oc.t = t;
            oc.vp = vp;
            oc.t_ss = t_ss;
            oc.vp_ss = vp_ss;

            oc.t_cycle = t_c - t_c(1);
            oc.vp_cycle = vp_c;
            oc.vp_F = vp_F;

            oc.Voc_amp = Voc_amp;
            oc.Voc_phase = Voc_phase;
            oc.Voc_pp = max(vp_c) - min(vp_c);
            oc.Voc_half_pp = 0.5 * oc.Voc_pp;

            oc.openCircuit = openCircuit;
            oc.f = f;
            oc.w = w;
            oc.stopTime = stopTime;
            oc.t_start_ss = t_start_ss;
        end

        function theta_est = estimateThetaFromRectCurrent(t, irect, ieq_phase, f)
        
            theta_est = NaN;
        
            t = t(:);
            irect = abs(irect(:));
        
            w = 2*pi*f;
        
            % Phase referenced to equivalent current source
            phi = mod(w*t + ieq_phase, 2*pi);
        
            % Sort by phase
            [phi, idx] = sort(phi);
            irect = irect(idx);
        
            % Use only positive half-cycle
            posHalf = phi >= 0 & phi <= pi;
            phi_pos = phi(posHalf);
            i_pos = irect(posHalf);
        
            if numel(phi_pos) < 10 || max(i_pos) <= 0
                return;
            end
        
            % Smooth current slightly to remove numerical spikes
            i_pos = movmean(i_pos, 5);
        
            % Threshold relative to max conduction current
            threshold = max(1e-10, 0.05 * max(i_pos));
        
            conducting = i_pos > threshold;
        
            if ~any(conducting)
                return;
            end
        
            % Find all continuous conduction regions
            d = diff([false; conducting; false]);
            runStarts = find(d == 1);
            runEnds   = find(d == -1) - 1;
        
            % SEH positive-half conduction should end near pi.
            % Choose the conduction region whose end is closest to pi.
            [~, bestRun] = min(abs(phi_pos(runEnds) - pi));
        
            startIdx = runStarts(bestRun);
        
            if startIdx <= 1
                theta_est = phi_pos(startIdx);
                return;
            end
        
            % Interpolate crossing for better accuracy
            phi1 = phi_pos(startIdx - 1);
            phi2 = phi_pos(startIdx);
        
            i1 = i_pos(startIdx - 1);
            i2 = i_pos(startIdx);
        
            if i2 == i1
                theta_est = phi2;
            else
                theta_est = phi1 + (threshold - i1) * (phi2 - phi1) / (i2 - i1);
            end
        
            if theta_est < 0 || theta_est > pi
                theta_est = NaN;
            end
        end
    end
end
