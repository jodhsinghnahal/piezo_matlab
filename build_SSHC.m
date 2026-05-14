%% build_SSHC.m
% Synchronized Switch Harvesting on Capacitor (SSHC)
%
% Two-phase switched-capacitor voltage inversion (no inductor needed).
% Phase 1: S1 closes -> C_aux shares charge with C_piezo (partial inversion)
% Phase 2: S1 opens, S2 closes -> C_aux transfers charge to C_store via D_sshc
% A passive bridge rectifier provides a continuous (lower-power) path in parallel.
%
% Library keys:
%   fl_lib       = Simscape Foundation Library
%   ee_lib       = Simscape Electrical Library
%   nesl_utility = Simscape Utilities

mdl = 'SSHC_Piezo';
if bdIsLoaded(mdl), close_system(mdl,0); end
new_system(mdl);
open_system(mdl);

set_param(mdl,'Solver','ode23t','RelTol','1e-4','AbsTol','1e-6','StopTime','0.5');

ab = @(src,name,varargin) add_block(src,[mdl '/' name],varargin{:});

%% Solver Config & Ground
ab('nesl_utility/Solver Configuration','SolverConfig','Position',[30 30 160 80]);
ab('fl_lib/Electrical/Electrical Elements/Electrical Reference','Gnd','Position',[200 530 230 560]);

%% Piezo Bender
ab('ee_lib/Electromechanical/Piezoelectric/Piezo Bender','PiezoBender','Position',[80 150 200 280]);

%% Mechanical Source
ab('fl_lib/Mechanical/Mechanical Sources/Ideal Force Source','ForceSource','Position',[30 155 70 215]);
ab('simulink/Sources/Sine Wave','SineWave','Frequency','2*pi*100','Amplitude','0.5','Position',[30 80 70 120]);
ab('fl_lib/Mechanical/Mechanical Elements/Mechanical Translational Reference','MechRef','Position',[30 300 60 330]);

%% Motion Sensor
ab('fl_lib/Mechanical/Mechanical Sensors/Ideal Translational Motion Sensor','MotionSensor','Position',[80 310 130 370]);
ab('nesl_utility/PS-Simulink Converter','PS2SL_vel','Position',[150 315 190 345]);

%% SSHC Controller (two-phase)
ab('simulink/Logic and Bit Operations/Detect Decrease','ZC_neg','Position',[220 295 260 325]);
ab('simulink/Logic and Bit Operations/Detect Increase','ZC_pos','Position',[220 335 260 365]);
ab('simulink/Logic and Bit Operations/Logical Operator','OR_gate','Operator','OR','Position',[285 308 325 352]);

% Phase 1 latch + timer
ab('simulink/Logic and Bit Operations/S-R Flip-Flop','FF_ph1','Position',[355 308 395 348]);
ab('simulink/Continuous/Integrator','Timer1', ...
    'ExternalReset','rising','InitialCondition','0','Position',[430 300 470 340]);
ab('simulink/Sources/Constant','One1','Value','1','Position',[375 370 410 400]);
ab('simulink/Math Operations/Relational Operator','Cmp1','Operator','>=','Position',[490 300 530 340]);
ab('simulink/Sources/Constant','T_phi1','Value','50e-6','Position',[430 365 490 395]);

% Phase 2 latch + timer (set when phase 1 ends)
ab('simulink/Logic and Bit Operations/S-R Flip-Flop','FF_ph2','Position',[555 308 595 348]);
ab('simulink/Continuous/Integrator','Timer2', ...
    'ExternalReset','rising','InitialCondition','0','Position',[625 300 665 340]);
ab('simulink/Sources/Constant','One2','Value','1','Position',[570 370 605 400]);
ab('simulink/Math Operations/Relational Operator','Cmp2','Operator','>=','Position',[685 300 725 340]);
ab('simulink/Sources/Constant','T_phi2','Value','50e-6','Position',[625 365 685 395]);

%% SL->PS for S1 and S2
ab('nesl_utility/Simulink-PS Converter','SL2PS_S1','Position',[420 440 460 470]);
ab('nesl_utility/Simulink-PS Converter','SL2PS_S2','Position',[500 440 540 470]);

%% SSHC Switches, Aux Cap, Blocking Diode
ab('ee_lib/Semiconductors & Converters/Switches/Ideal Switch','S1','Position',[260 170 300 210]);
ab('ee_lib/Semiconductors & Converters/Switches/Ideal Switch','S2','Position',[360 170 400 210]);
ab('fl_lib/Electrical/Electrical Elements/Capacitor','C_aux','c','200e-9','Position',[320 240 360 300]);
ab('ee_lib/Semiconductors & Converters/Diodes & Thyristors/Diode','D_sshc','Position',[430 170 470 210]);

%% Passive Bridge Rectifier (parallel, always-on path)
rpos = {[510 110 550 150],[510 190 550 230],[590 110 630 150],[590 190 630 230]};
for k = 1:4
    ab('ee_lib/Semiconductors & Converters/Diodes & Thyristors/Diode', ...
        sprintf('Drect%d',k),'Position',rpos{k});
end

%% Storage Cap & Load
ab('fl_lib/Electrical/Electrical Elements/Capacitor','C_store','c','100e-6','Position',[660 120 700 200]);
ab('fl_lib/Electrical/Electrical Elements/Resistor','R_load','r','1e3','Position',[740 120 780 200]);

%% Measurement
ab('fl_lib/Electrical/Electrical Sensors/Voltage Sensor','V_out','Position',[740 240 780 280]);
ab('nesl_utility/PS-Simulink Converter','PS2SL_V','Position',[800 244 840 276]);
ab('simulink/Sinks/Scope','Scope_V','Position',[860 239 910 281]);

%% Mechanical
add_line(mdl,'SineWave/1','ForceSource/Simulink Input Port');
add_line(mdl,'ForceSource/V','PiezoBender/V','autorouting','smart');
add_line(mdl,'ForceSource/R','MechRef/V','autorouting','smart');
add_line(mdl,'PiezoBender/R','MechRef/V','autorouting','smart');
add_line(mdl,'MotionSensor/V','PiezoBender/V','autorouting','smart');
add_line(mdl,'MotionSensor/R','MechRef/V','autorouting','smart');
add_line(mdl,'MotionSensor/V','PS2SL_vel/Iin','autorouting','smart');

%% Controller
add_line(mdl,'PS2SL_vel/Out1','ZC_neg/u');
add_line(mdl,'PS2SL_vel/Out1','ZC_pos/u');
add_line(mdl,'ZC_neg/y','OR_gate/In1');
add_line(mdl,'ZC_pos/y','OR_gate/In2');
% Phase 1
add_line(mdl,'OR_gate/1','FF_ph1/S');
add_line(mdl,'OR_gate/1','Timer1/Trigger');
add_line(mdl,'One1/1','Timer1/In1');
add_line(mdl,'Timer1/1','Cmp1/In1');
add_line(mdl,'T_phi1/1','Cmp1/In2');
add_line(mdl,'Cmp1/1','FF_ph1/R');
% Phase 2 (triggered by end of phase 1)
add_line(mdl,'Cmp1/1','FF_ph2/S');
add_line(mdl,'Cmp1/1','Timer2/Trigger');
add_line(mdl,'One2/1','Timer2/In1');
add_line(mdl,'Timer2/1','Cmp2/In1');
add_line(mdl,'T_phi2/1','Cmp2/In2');
add_line(mdl,'Cmp2/1','FF_ph2/R');
% Switch gates
add_line(mdl,'FF_ph1/Q','SL2PS_S1/Iin');
add_line(mdl,'FF_ph2/Q','SL2PS_S2/Iin');
add_line(mdl,'SL2PS_S1/Iout','S1/Simulink Input Port');
add_line(mdl,'SL2PS_S2/Iout','S2/Simulink Input Port');

%% SSHC switched-cap branch
% Piezo+ -> S1 -> junction -> S2 -> D_sshc -> C_store+
% C_aux: junction to Piezo-
add_line(mdl,'PiezoBender/p','S1/LConn1','autorouting','smart');
add_line(mdl,'S1/RConn1','S2/LConn1','autorouting','smart');
add_line(mdl,'S1/RConn1','C_aux/p','autorouting','smart');
add_line(mdl,'C_aux/n','PiezoBender/n','autorouting','smart');
add_line(mdl,'S2/RConn1','D_sshc/LConn1','autorouting','smart');
add_line(mdl,'D_sshc/RConn1','C_store/p','autorouting','smart');

%% Passive bridge (parallel with piezo)
add_line(mdl,'PiezoBender/p','Drect1/LConn1','autorouting','smart');
add_line(mdl,'Drect1/RConn1','C_store/p','autorouting','smart');
add_line(mdl,'C_store/n','Drect2/LConn1','autorouting','smart');
add_line(mdl,'Drect2/RConn1','PiezoBender/p','autorouting','smart');
add_line(mdl,'PiezoBender/n','Drect3/LConn1','autorouting','smart');
add_line(mdl,'Drect3/RConn1','C_store/p','autorouting','smart');
add_line(mdl,'C_store/n','Drect4/LConn1','autorouting','smart');
add_line(mdl,'Drect4/RConn1','PiezoBender/n','autorouting','smart');

%% Output
add_line(mdl,'C_store/p','R_load/p','autorouting','smart');
add_line(mdl,'C_store/n','R_load/n','autorouting','smart');
add_line(mdl,'C_store/n','Gnd/V','autorouting','smart');
add_line(mdl,'R_load/p','V_out/p','autorouting','smart');
add_line(mdl,'R_load/n','V_out/n','autorouting','smart');
add_line(mdl,'V_out/Voltage','PS2SL_V/Iin','autorouting','smart');
add_line(mdl,'PS2SL_V/Out1','Scope_V/In1','autorouting','smart');
add_line(mdl,'SolverConfig/RConn1','Gnd/V','autorouting','smart');

save_system(mdl);
disp('=== SSHC model built. Simulating... ===');
sim(mdl);
disp('SSHC done.');
