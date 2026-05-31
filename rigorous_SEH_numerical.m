clear; clc; close all;

load('fitted_van_dyke_params.mat', 'Lfit', 'Rfit', 'Cfit', 'Cpfit');
load('equivalent_source_voltage.mat', 'Veq');

f = 185;
w = 2*pi*f;

L = Lfit;
R = Rfit;
C = Cfit;
Cp = Cpfit;

% Set this to match your rectifier.
% If you want the cleanest comparison, make your Simscape diode ideal and use VF = 0.
% If using real diodes, use an effective total bridge drop, often 0.8-1.4 V.
VF = 1.0;

% Sweep normalized rectified voltage
vtilde = linspace(1e-6, 1-1e-6, 200000);

theta = acos(1 - 2*vtilde);

XL = w*L;
XC = -1/(w*C);

ReZ = (1./(pi*w*Cp)) .* sin(theta).^2;

XE = (1./(pi*w*Cp)) .* ...
    (sin(theta).*cos(theta) - theta);

Ieq = Veq ./ sqrt((XL + XC + XE).^2 + (R + ReZ).^2);

Voc = Ieq ./ (w*Cp);

vFtilde = VF ./ Voc;

Rh = (4./(pi*w*Cp)) .* (vtilde - vFtilde) .* (1 - vtilde);
Rd = (4./(pi*w*Cp)) .* vFtilde .* (1 - vtilde);

Ph = 0.5 .* Ieq.^2 .* Rh;

Vstore = vtilde .* Voc - VF;

Rload_num = Vstore.^2 ./ Ph;

valid = isfinite(Rload_num) & isfinite(Ph) & ...
    Rload_num > 0 & Ph > 0 & Vstore > 0 & Rh > 0;

Rload_num = Rload_num(valid);
Ph = Ph(valid);
Vstore = Vstore(valid);
vtilde = vtilde(valid);
Ieq = Ieq(valid);
Voc = Voc(valid);

[Rload_num, idxSort] = sort(Rload_num);
Ph = Ph(idxSort);
Vstore = Vstore(idxSort);
vtilde = vtilde(idxSort);
Ieq = Ieq(idxSort);
Voc = Voc(idxSort);

[Phmax, idxMax] = max(Ph);

fprintf("\n--- Rigorous SEH Numerical Result ---\n");
fprintf("Pmax = %.6f mW\n", Phmax*1e3);
fprintf("Ropt = %.6g Ohm\n", Rload_num(idxMax));
fprintf("Vstore at optimum = %.6g V\n", Vstore(idxMax));
fprintf("Vrect/Voc at optimum = %.4f\n", vtilde(idxMax));

save('rigorous_SEH_numerical_curve.mat', ...
    'Rload_num', 'Ph', 'Vstore', 'vtilde', 'Ieq', 'Voc');

figure;
semilogx(Rload_num, Ph*1e3, 'LineWidth', 2);
grid on;
xlabel('R_{load} (\Omega)');
ylabel('Numerical Harvested Power P_h (mW)');
title('Rigorous SEH Numerical Prediction');