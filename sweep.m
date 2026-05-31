model = 'piezo_har';   % replace with exact Simulink file name, no .slx

Crect = 1e-6;
Rloads = logspace(3, 7, 25);   % 1 kOhm to 10 MOhm

Psim = zeros(size(Rloads));
Vdc = zeros(size(Rloads));
Vripple = zeros(size(Rloads));

for k = 1:length(Rloads)
    Rload = Rloads(k);

    Tstop = max(3, 8*Rload*Crect);

    simOut = sim(model, 'StopTime', num2str(Tstop));

    % Get Vload safely
    if isprop(simOut, 'Vload')
        Vload_ts = simOut.Vload;
    elseif evalin('base', 'exist(''Vload'', ''var'')')
        Vload_ts = evalin('base', 'Vload');
    else
        error('Vload was not logged. Check the To Workspace block variable name and save format.');
    end

    t = Vload_ts.Time;
    v = Vload_ts.Data;

    idx = t > 0.8*t(end);

    Vdc(k) = mean(v(idx));
    Psim(k) = mean(v(idx).^2 ./ Rload);
    Vripple(k) = rms(v(idx) - Vdc(k));

    fprintf("Rload = %.3g Ohm, Vdc = %.3f V, P = %.4f mW\n", ...
        Rload, Vdc(k), Psim(k)*1e3);
end

figure;
semilogx(Rloads, Psim*1e3, 'o-', 'LineWidth', 1.5);
grid on;
xlabel('R_{load} (\Omega)');
ylabel('Harvested Power P_h (mW)');
title('Simscape SEH Load Sweep');