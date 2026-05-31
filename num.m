clear; clc; close all;

%% Parameters from your current Simscape Piezo Bender screenshot
Cp = 15e-9;              % F
Vrated = 180;            % V
Fblock = 0.414;          % N
xfree = 0.233e-3;        % m
M = 1.6e-3;              % kg

alpha = Fblock / Vrated;
K = Fblock / xfree;

L = M / alpha^2;
C = alpha^2 / K;

% Rayleigh damping: using stiffness-proportional value from your screenshot
beta = 1e-5;             % s
D = beta * K;
R = D / alpha^2;

%% Excitation
f = 185;                 % Hz
w = 2*pi*f;

a_rms = 10;              % m/s^2, same style as paper
a_peak = sqrt(2)*a_rms;

v_source_peak = a_peak / w;
Veq = (M/alpha) * a_peak;

fprintf("Use PS Sine Wave amplitude = %.6f m/s\n", v_source_peak);
fprintf("alpha = %.6g N/V\n", alpha);
fprintf("K = %.6g N/m\n", K);
fprintf("L = %.6g H\n", L);
fprintf("C = %.6g F\n", C);
fprintf("Cp = %.6g F\n", Cp);
fprintf("R = %.6g Ohm\n", R);
fprintf("Veq = %.6g V peak\n", Veq);
fprintf("Approx natural frequency = %.3f Hz\n", 1/(2*pi*sqrt(L*C)));

%% Rectifier setting
% Use VF = 0 if your Simscape rectifier is ideal.
% Use VF = 1.0 if your bridge has about 1 V total conducting drop.
VF = 1.0;

%% Sweep normalized rectified voltage
vtilde = linspace(1e-6, 1-1e-6, 200000);

theta = acos(1 - 2*vtilde);

ReZ = (1./(pi*w*Cp)) .* sin(theta).^2;
XE  = (1./(pi*w*Cp)) .* (sin(theta).*cos(theta) - theta);

XL = w*L;
XC = -1/(w*C);

Ieq = Veq ./ sqrt((XL + XC + XE).^2 + (R + ReZ).^2);

Voc = Ieq ./ (w*Cp);

vFtilde = VF ./ Voc;

Rh = (4./(pi*w*Cp)) .* (vtilde - vFtilde) .* (1 - vtilde);
Rd = (4./(pi*w*Cp)) .* vFtilde .* (1 - vtilde);

Ph = 0.5 .* Ieq.^2 .* Rh;

Vstore = vtilde .* Voc - VF;
Rload_num = Vstore.^2 ./ Ph;

valid = Ph > 0 & Vstore > 0 & isfinite(Rload_num);

Rload_num = Rload_num(valid);
Ph = Ph(valid);
Vstore = Vstore(valid);
vtilde = vtilde(valid);

[Phmax, idx] = max(Ph);

fprintf("\n--- Numerical SEH prediction ---\n");
fprintf("Max harvested power = %.6f W = %.3f mW\n", Phmax, Phmax*1e3);
fprintf("Optimal Rload = %.6g Ohm\n", Rload_num(idx));
fprintf("Optimal Vstore = %.6g V\n", Vstore(idx));
fprintf("Optimal Vrect/Voc = %.4f\n", vtilde(idx));

figure;
semilogx(Rload_num, Ph*1e3, 'LineWidth', 1.5);
grid on;
xlabel('R_{load} (\Omega)');
ylabel('P_h (mW)');
title('Numerical SEH Power Prediction Using Your Simscape Parameters');