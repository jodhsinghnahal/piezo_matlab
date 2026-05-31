clear; clc; close all;

load('simscape_impedance_data.mat','freqs','Zmeas');

w = 2*pi*freqs(:);
Zmeas = Zmeas(:);

% Initial guesses
L0  = 300;       % H
R0  = 5e3;       % Ohm
C0  = 3e-9;      % F
Cp0 = 15e-9;     % F

q0 = log([L0, R0, C0, Cp0]);

cost = @(q) impedance_cost(q, w, Zmeas);

qfit = fminsearch(cost, q0);

p = exp(qfit);

Lfit  = p(1);
Rfit  = p(2);
Cfit  = p(3);
Cpfit = p(4);

Zfit = van_dyke(Lfit, Rfit, Cfit, Cpfit, w);

fprintf("L  = %.6g H\n", Lfit);
fprintf("R  = %.6g Ohm\n", Rfit);
fprintf("C  = %.6g F\n", Cfit);
fprintf("Cp = %.6g F\n", Cpfit);
fprintf("f_n = %.3f Hz\n", 1/(2*pi*sqrt(Lfit*Cfit)));

figure;
subplot(2,1,1);
semilogy(freqs, abs(Zmeas), 'o'); hold on;
semilogy(freqs, abs(Zfit), '-', 'LineWidth', 2);
grid on;
xlabel('Frequency (Hz)');
ylabel('|Z| (\Omega)');
legend('Simscape measured','Van Dyke fit');

subplot(2,1,2);
plot(freqs, angle(Zmeas)*180/pi, 'o'); hold on;
plot(freqs, angle(Zfit)*180/pi, '-', 'LineWidth', 2);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase (deg)');
legend('Simscape measured','Van Dyke fit');

save('fitted_van_dyke_params.mat','Lfit','Rfit','Cfit','Cpfit');

function J = impedance_cost(q,w,Zmeas)
p = exp(q);
Zfit = van_dyke(p(1),p(2),p(3),p(4),w);
err = (Zfit - Zmeas)./Zmeas;
J = mean(abs(err).^2);
end

function Z = van_dyke(L,R,C,Cp,w)
jw = 1j*w;
Zm = R + jw*L + 1./(jw*C);
Z = 1 ./ (jw*Cp + 1./Zm);
end