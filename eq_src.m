clear; clc; close all;

load('fitted_van_dyke_params.mat', 'Lfit', 'Rfit', 'Cfit', 'Cpfit');

model = 'piezo_open_circuit_test';  % change to your model name

f0 = 185;
w0 = 2*pi*f0;

simOut = sim(model, 'StopTime', '3');

Vts = simOut.Vp_oc;

Voc_ph = fundamental_phasor(Vts, f0, 30);
Voc_peak = abs(Voc_ph);

Zcp = 1/(1j*w0*Cpfit);
Ztotal_oc = Rfit + 1j*w0*Lfit + 1/(1j*w0*Cfit) + Zcp;

Veq = abs(Ztotal_oc) / abs(Zcp) * Voc_peak;

fprintf("Open-circuit piezo voltage Voc = %.6g V peak\n", Voc_peak);
fprintf("Equivalent source voltage Veq = %.6g V peak\n", Veq);

save('equivalent_source_voltage.mat', 'Veq', 'Voc_peak');

function X = fundamental_phasor(ts, f, nCycles)
t = ts.Time;
x = squeeze(ts.Data);

T = 1/f;
tStart = t(end) - nCycles*T;
idx = t >= tStart;

tt = t(idx);
xx = x(idx);
xx = xx - mean(xx);

w = 2*pi*f;

X = 2/(tt(end)-tt(1)) * trapz(tt, xx .* exp(-1j*w*tt));
end