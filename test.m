clear; clc; close all;

%% Exact paper values from Table I
L  = 31e3;          % H
R  = 1e6;           % Ohm
C  = 448e-12;       % F
Cp = 34.69e-9;      % F

alpha = 4.75e-4;    % N/V
f = 42;             % Hz
w = 2*pi*f;

a_rms = 10;         % m/s^2 RMS
a_peak = sqrt(2)*a_rms;

VF = 1.0;           % V, total bridge rectifier drop used by paper
gamma = -0.7;       % SSHI voltage inversion factor

%% Equivalent source voltage
% From paper:
% veq = -(M/alpha)*yddot
% L = M/alpha^2  ->  M/alpha = alpha*L
Veq = alpha * L * a_peak;

XL = w*L;
XC = -1/(w*C);

fprintf("Veq peak = %.4f V\n", Veq);

%% -------- SEH --------
v_seh = linspace(1e-6, 1-1e-6, 20000);
theta_seh = acos(1 - 2*v_seh);

ReZ_seh = (1./(pi*w*Cp)) .* sin(theta_seh).^2;
XE_seh  = (1./(pi*w*Cp)) .* ...
    (sin(theta_seh).*cos(theta_seh) - theta_seh);

I_seh = Veq ./ sqrt((XL + XC + XE_seh).^2 + (R + ReZ_seh).^2);
Voc_seh = I_seh ./ (w*Cp);
vF_seh = VF ./ Voc_seh;

Rh_seh = (4./(pi*w*Cp)) .* (v_seh - vF_seh) .* (1 - v_seh);
Ph_seh = 0.5 .* I_seh.^2 .* Rh_seh;

Vstore_seh = v_seh .* Voc_seh - VF;
Rload_seh = Vstore_seh.^2 ./ Ph_seh;

valid_seh = Ph_seh > 0 & Vstore_seh > 0;

%% -------- P-SSHI --------
vmax_psshi = 2/(1 + gamma);
v_psshi = linspace(1e-6, vmax_psshi-1e-6, 20000);

cos_th = 1 - (1 + gamma).*v_psshi;
theta_psshi = acos(cos_th);

ReZ_psshi = (1./(pi*w*Cp)) .* ...
    ((1 - cos_th) .* (4/(1 + gamma) - 1 + cos_th));

XE_psshi = (1./(pi*w*Cp)) .* ...
    (sin(theta_psshi).*cos(theta_psshi) - theta_psshi);

I_psshi = Veq ./ sqrt((XL + XC + XE_psshi).^2 + ...
    (R + ReZ_psshi).^2);

Voc_psshi = I_psshi ./ (w*Cp);
vF_psshi = VF ./ Voc_psshi;

Rh_psshi = (2./(pi*w*Cp)) .* ...
    (v_psshi - vF_psshi) .* (2 - v_psshi.*(1 + gamma));

Ph_psshi = 0.5 .* I_psshi.^2 .* Rh_psshi;

Vstore_psshi = v_psshi .* Voc_psshi - VF;
Rload_psshi = Vstore_psshi.^2 ./ Ph_psshi;

valid_psshi = Ph_psshi > 0 & Vstore_psshi > 0;

%% -------- S-SSHI --------
v_ssshi = linspace(1e-6, 1-1e-6, 20000);

ReZ_ssshi = (1./(w*Cp)) .* ...
    (4/pi) .* ((1 - gamma)/(1 + gamma)) .* (1 - v_ssshi);

XE_ssshi = -1./(w*Cp) .* ones(size(v_ssshi));

I_ssshi = Veq ./ sqrt((XL + XC + XE_ssshi).^2 + ...
    (R + ReZ_ssshi).^2);

Voc_ssshi = I_ssshi ./ (w*Cp);
vF_ssshi = VF ./ Voc_ssshi;

Rh_ssshi = (4./(pi*w*Cp)) .* ...
    ((1 - gamma)/(1 + gamma)) .* ...
    (v_ssshi - vF_ssshi) .* (1 - v_ssshi);

Ph_ssshi = 0.5 .* I_ssshi.^2 .* Rh_ssshi;

Vstore_ssshi = v_ssshi .* Voc_ssshi - VF;
Rload_ssshi = Vstore_ssshi.^2 ./ Ph_ssshi;

valid_ssshi = Ph_ssshi > 0 & Vstore_ssshi > 0;

%% Find maxima
[Ph_seh_max, i1] = max(Ph_seh(valid_seh));
v1 = v_seh(valid_seh);
r1 = Rload_seh(valid_seh);

[Ph_psshi_max, i2] = max(Ph_psshi(valid_psshi));
v2 = v_psshi(valid_psshi);
r2 = Rload_psshi(valid_psshi);

[Ph_ssshi_max, i3] = max(Ph_ssshi(valid_ssshi));
v3 = v_ssshi(valid_ssshi);
r3 = Rload_ssshi(valid_ssshi);

fprintf("\n--- Theoretical maxima using paper values ---\n");
fprintf("SEH:    %.4f mW at Vtilde = %.4f, Rload = %.3g Ohm\n", ...
    Ph_seh_max*1e3, v1(i1), r1(i1));

fprintf("P-SSHI: %.4f mW at Vtilde = %.4f, Rload = %.3g Ohm\n", ...
    Ph_psshi_max*1e3, v2(i2), r2(i2));

fprintf("S-SSHI: %.4f mW at Vtilde = %.4f, Rload = %.3g Ohm\n", ...
    Ph_ssshi_max*1e3, v3(i3), r3(i3));

%% Recreate Fig. 14 style plots
figure;

subplot(1,3,1);
plot(v_seh(valid_seh), Ph_seh(valid_seh)*1e3, 'LineWidth', 1.4);
grid on;
xlabel('$\tilde V_{rect}$','Interpreter','latex');
ylabel('$P_h$ (mW)','Interpreter','latex');
title('(a) SEH');

subplot(1,3,2);
plot(v_psshi(valid_psshi), Ph_psshi(valid_psshi)*1e3, 'LineWidth', 1.4);
grid on;
xlabel('$\tilde V_{rect}$','Interpreter','latex');
ylabel('$P_h$ (mW)','Interpreter','latex');
title('(b) P-SSHI');

subplot(1,3,3);
plot(v_ssshi(valid_ssshi), Ph_ssshi(valid_ssshi)*1e3, 'LineWidth', 1.4);
grid on;
xlabel('$\tilde V_{rect}$','Interpreter','latex');
ylabel('$P_h$ (mW)','Interpreter','latex');
title('(c) S-SSHI');