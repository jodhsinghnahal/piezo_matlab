clearvars -except Rloads Psim
clc; close all;

load('rigorous_SEH_numerical_curve.mat', 'Rload_num', 'Ph');

Rloads = Rloads(:);
Psim = Psim(:);

valid = isfinite(Rloads) & isfinite(Psim) & Rloads > 0 & Psim > 0;
Rloads = Rloads(valid);
Psim = Psim(valid);

Pnum_at_sim = interp1(log10(Rload_num), log10(Ph), log10(Rloads), ...
    'linear', 'extrap');

Pnum_at_sim = 10.^Pnum_at_sim;

error_percent = 100*(Psim - Pnum_at_sim)./Pnum_at_sim;

results = table(Rloads, Pnum_at_sim*1e3, Psim*1e3, error_percent, ...
    'VariableNames', {'Rload_Ohm','Pnum_mW','Psim_mW','Error_percent'});

disp(results);

[Psim_max, idxSim] = max(Psim);
[Pnum_max, idxNum] = max(Ph);

fprintf("\n--- Comparison Summary ---\n");
fprintf("Simscape Pmax = %.6f mW at Rload = %.6g Ohm\n", ...
    Psim_max*1e3, Rloads(idxSim));
fprintf("Numerical Pmax = %.6f mW at Rload = %.6g Ohm\n", ...
    Pnum_max*1e3, Rload_num(idxNum));

figure;
semilogx(Rload_num, Ph*1e3, 'LineWidth', 2); hold on;
semilogx(Rloads, Psim*1e3, 'o', 'LineWidth', 1.5);
grid on;
xlabel('R_{load} (\Omega)');
ylabel('Harvested Power P_h (mW)');
legend('Rigorous numerical model', 'Simscape physical model', ...
    'Location', 'best');
title('Rigorous SEH Numerical vs Simscape Comparison');

figure;
semilogx(Rloads, error_percent, 'o-', 'LineWidth', 1.5);
grid on;
xlabel('R_{load} (\Omega)');
ylabel('Error (%)');
title('Numerical Error Relative to Simscape');