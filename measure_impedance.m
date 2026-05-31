clear; clc; close all;

model = 'impedence_analyze';   % change to your model name

Itest = 1e-6;                     % 1 microamp peak
freqs = linspace(50, 350, 100);   % Hz

Zmeas = zeros(size(freqs));

for k = 1:length(freqs)
    ftest = freqs(k);

    % these variables are used by the PS Sine Wave block
    assignin('base','ftest',ftest);
    assignin('base','Itest',Itest);

    Tstop = max(0.5, 80/ftest);   % enough cycles

    simOut = sim(model, 'StopTime', num2str(Tstop));

    Vts = simOut.Vpiezo;
    Its = simOut.Ipiezo;

    Vph = fundamental_phasor(Vts, ftest, 20);
    Iph = fundamental_phasor(Its, ftest, 20);

    Zmeas(k) = Vph / Iph;

    fprintf("f = %.1f Hz, |Z| = %.3g Ohm, phase = %.1f deg\n", ...
        ftest, abs(Zmeas(k)), angle(Zmeas(k))*180/pi);
end

figure;
subplot(2,1,1);
semilogy(freqs, abs(Zmeas), 'o-', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('|Z_{in}| (\Omega)');
title('Measured Piezo Input Impedance from Simscape');

subplot(2,1,2);
plot(freqs, angle(Zmeas)*180/pi, 'o-', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');

save('simscape_impedance_data.mat','freqs','Zmeas');

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

    % peak phasor
    X = 2/(tt(end)-tt(1)) * trapz(tt, xx .* exp(-1j*w*tt));
end