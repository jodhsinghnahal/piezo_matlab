clear; clc; close all;
f_test = 42;
CrossCircuitTest = "BJT";
Type_test = "PSSHI";
WindingRatio_test = 1.0;
idk;

% C1Test = 0.022;
% switchFracTest = 0.05;

% Simscape pwr = 0.009678 mW
% Rload = 5.994843e+04; power = 0.029468 mW

% Simscape harvested/load power Vstore^2/Rload = 0.018663 mW
% Optimum Rload = 1.668101e+05 ohm
% Maximum harvested/load power = 0.051068 mW

% water, 250, Switch vs BJT, C1 = 2.2e-9:
% Optimum Rload = 1.668101e+05 ohm
% Maximum harvested/load power = 25.504079 mW
% Optimum Rload = 2.154435e+04 ohm
% Maximum harvested/load power = 3.926630 mW

% Water, Switch, 250: Simscape harvested/load power Vstore^2/Rload = 9.865264 mW
% Water, Switch, 250, C1 = 2.1338e-08: Simscape harvested/load power Vstore^2/Rload = 7.224114 mW

% switchFracTest = 0.00025;
% idk;
% 
% switchFracTest = 0.0005;
% idk;

% switchFracTest = 0.001;
% idk;
% 
% switchFracTest = 0.0025;
% idk;
% 
% switchFracTest = 0.005;
% idk;
% 
% switchFracTest = 0.01;
% idk;
% 
% switchFracTest = 0.0125;
% idk;
% 
% switchFracTest = 0.015;
% idk;
% 
% switchFracTest = 0.025;
% idk;
% 
% switchFracTest = 0.05;
% idk;
% 
% switchFracTest = 0.075;
% idk;
% 
% switchFracTest = 0.1;
% idk;