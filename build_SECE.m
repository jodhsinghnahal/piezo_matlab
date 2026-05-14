%% build_SECE.m
% Synchronous Electric Charge Extraction (SECE)
%
% At each velocity zero-crossing (displacement extremum), switch S_sece
% closes for T_ext = pi*sqrt(L_sece * C_p) to extract all piezo charge
% via LC resonance into C_store through blocking diode D_ext.
% Between events, piezo is open-circuit so voltage builds freely.
%
% Library keys:
%   fl_lib       = Simscape Foundation Library
%   ee_lib       = Simscape Electrical Library
%   nesl_utility = Simscape Utilities

mdl = 'SECE_Piezo';
if bdIsLoaded(mdl), close_system(mdl,0); end
new_system(mdl);
open_system(mdl);

set_param(mdl,'Solver','ode23t','RelTol','1e-4','AbsTol','1e-6','StopTime','0.5');

ab = @(src,name,varargin) add_block(src,[mdl '/' name],varargin{:});

%% Solver Config & Ground
ab('nesl_utility/Solver Configuration','SolverConfig','Position',[30 30 160 80]);
ab('fl_lib/Electrical/Electrical Elements/Electrical Reference','Gnd','Position',[200 500 230 530]);

%% Piezo Bender
ab('ee_lib/Electromechanical/Piezoelectric/Piezo Bender','PiezoBender','Position',[80 150 200 280]);

%% Mechanical Source
ab('fl_lib/Mechanical/Mechanical Sources/Ideal Force Source','ForceSource','Position',[30 155 70 215]);
ab('simulink/Sources/Sine Wave','SineWave','Frequency','2*pi*100','Amplitude','0.5','Position',[30 80 70 120]);
ab('fl_lib/Mechanical/Mechanical Elements/Mechanical Translational Reference','MechRef','Position',[30 300 60 330]);

%% Motion Sensor
ab('fl_lib/Mechanical/Mechanical Sensors/Ideal Translational Motion Sensor','MotionSensor','Position',[80 310 130 370]);
ab('nesl_utility/PS-Simulink Converter','PS2SL_vel','Position',[150 315 190 345]);

%% SECE Controller
ab('simulink/Logic and Bit Operations/Detect Decrease','ZC_neg','Position',[220 295 260 325]);
ab('simulink/Logic and Bit Operations/Detect Increase','ZC_pos','Position',[220 335 260 365]);
ab('simulink/Logic and Bit Operations/Logical Operator','OR_gate','Operator','OR','Position',[285 308 325 352]);
ab('simulink/Logic and Bit Operations/S-R Flip-Flop','SRFF','Position',[350 308 390 352]);

% Timer: resets latch after T_ext = pi*sqrt(L*Cp)
% L_sece=5mH, Cp=50nF -> T_ext ~ 99 us
ab('simulink/Continuous/Integrator','Timer', ...
    'ExternalReset','rising','InitialCondition','0','Position',[420 300 460 340]);
ab('simulink/Sources/Constant','One','Value','1','Position',[370 360 405 390]);
ab('simulink/Math Operations/Relational Operator','Cmp','Operator','>=','Position',[485 300 525 340]);
ab('simulink/Sources/Constant','T_ext','Value','pi*sqrt(5e-3*50e-9)','Position',[420 360 485 390]);

%% SL->PS for switch gate
ab('nesl_utility/Simulink-PS Converter','SL2PS_sw','Position',[430 430 470 460]);

%% SECE Extraction Branch: S_sece -> L_sece -> D_ext -> C_store
ab('ee_lib/Semiconductors & Converters/Switches/Ideal Switch','S_sece','Position',[260 170 300 210]);
ab('fl_lib/Electrical/Electrical Elements/Inductor','L_sece','l','5e-3','Position',[330 170 370 210]);
ab('ee_lib/Semiconductors & Converters/Diodes & Thyristors/Diode','D_ext','Position',[400 170 440 210]);

%% Storage Cap & Load
ab('fl_lib/Electrical/Electrical Elements/Capacitor','C_store','c','100e-6','Position',[480 130 520 210]);
ab('fl_lib/Electrical/Electrical Elements/Resistor','R_load','r','1e3','Position',[560 130 600 210]);

%% Measurement
ab('fl_lib/Electrical/Electrical Sensors/Voltage Sensor','V_out','Position',[560 240 600 280]);
ab('nesl_utility/PS-Simulink Converter','PS2SL_V','Position',[620 244 660 276]);
ab('simulink/Sinks/Scope','Scope_V','Position',[680 239 730 281]);

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
add_line(mdl,'OR_gate/1','SRFF/S');
add_line(mdl,'OR_gate/1','Timer/Trigger');
add_line(mdl,'One/1','Timer/In1');
add_line(mdl,'Timer/1','Cmp/In1');
add_line(mdl,'T_ext/1','Cmp/In2');
add_line(mdl,'Cmp/1','SRFF/R');
add_line(mdl,'SRFF/Q','SL2PS_sw/Iin');
add_line(mdl,'SL2PS_sw/Iout','S_sece/Simulink Input Port');

%% Extraction branch
add_line(mdl,'PiezoBender/p','S_sece/LConn1','autorouting','smart');
add_line(mdl,'S_sece/RConn1','L_sece/p','autorouting','smart');
add_line(mdl,'L_sece/n','D_ext/LConn1','autorouting','smart');
add_line(mdl,'D_ext/RConn1','C_store/p','autorouting','smart');
add_line(mdl,'PiezoBender/n','C_store/n','autorouting','smart');

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
disp('=== SECE model built. Simulating... ===');
sim(mdl);
disp('SECE done.');
