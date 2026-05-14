%% build_SSHI.m
% Synchronized Switch Harvesting on Inductor (SSHI) - Parallel topology
%
% At each velocity zero-crossing, switch S_ssh closes for
%   T_flip = pi * sqrt(L_ssh * C_p)
% to invert the piezo terminal voltage via LC resonance.
% This boosts harvested power 2-4x vs SEH.
%
% Library keys:
%   fl_lib       = Simscape Foundation Library
%   ee_lib       = Simscape Electrical Library
%   nesl_utility = Simscape Utilities

mdl = 'SSHI_Piezo';
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

%% Motion Sensor (to detect velocity zero-crossings)
ab('fl_lib/Mechanical/Mechanical Sensors/Ideal Translational Motion Sensor','MotionSensor','Position',[80 310 130 370]);
ab('nesl_utility/PS-Simulink Converter','PS2SL_vel','Position',[150 315 190 345]);

%% SSHI Controller: ZC detection -> SR latch -> switch gate
ab('simulink/Logic and Bit Operations/Detect Decrease','ZC_neg','Position',[220 295 260 325]);
ab('simulink/Logic and Bit Operations/Detect Increase','ZC_pos','Position',[220 335 260 365]);
ab('simulink/Logic and Bit Operations/Logical Operator','OR_gate','Operator','OR','Position',[285 308 325 352]);
ab('simulink/Logic and Bit Operations/S-R Flip-Flop','SRFF','Position',[350 308 390 352]);

% Timer to auto-reset latch after T_flip = pi*sqrt(L*Cp)
% L_ssh=10mH, Cp=50nF (typical) -> T_flip ~ 70 us
ab('simulink/Continuous/Integrator','Timer', ...
    'ExternalReset','rising','InitialCondition','0','Position',[420 300 460 340]);
ab('simulink/Sources/Constant','One','Value','1','Position',[370 360 405 390]);
ab('simulink/Math Operations/Relational Operator','Cmp','Operator','>=','Position',[485 300 525 340]);
ab('simulink/Sources/Constant','T_flip','Value','pi*sqrt(10e-3*50e-9)','Position',[420 360 485 390]);

%% SL->PS for switch gate
ab('nesl_utility/Simulink-PS Converter','SL2PS_sw','Position',[430 430 470 460]);

%% SSHI branch: Ideal Switch + Inductor + parasitic R (in parallel with piezo)
ab('ee_lib/Semiconductors & Converters/Switches/Ideal Switch','S_ssh','Position',[260 320 300 360]);
ab('fl_lib/Electrical/Electrical Elements/Inductor','L_ssh','l','10e-3','Position',[330 320 370 360]);
ab('fl_lib/Electrical/Electrical Elements/Resistor','R_coil','r','5','Position',[400 320 440 360]);

%% Bridge Rectifier
positions = {[260 120 300 160],[260 200 300 240],[340 120 380 160],[340 200 380 240]};
for k = 1:4
    ab('ee_lib/Semiconductors & Converters/Diodes & Thyristors/Diode', ...
        sprintf('D%d',k),'Position',positions{k});
end

%% Output Stage
ab('fl_lib/Electrical/Electrical Elements/Capacitor','C_rect','c','100e-6','Position',[450 130 490 210]);
ab('fl_lib/Electrical/Electrical Elements/Resistor','R_load','r','1e3','Position',[530 130 570 210]);

%% Measurement
ab('fl_lib/Electrical/Electrical Sensors/Voltage Sensor','V_out','Position',[530 240 570 280]);
ab('nesl_utility/PS-Simulink Converter','PS2SL_V','Position',[600 244 640 276]);
ab('simulink/Sinks/Scope','Scope_V','Position',[660 239 710 281]);

%% Mechanical lines
add_line(mdl,'SineWave/1','ForceSource/Simulink Input Port');
add_line(mdl,'ForceSource/V','PiezoBender/V','autorouting','smart');
add_line(mdl,'ForceSource/R','MechRef/V','autorouting','smart');
add_line(mdl,'PiezoBender/R','MechRef/V','autorouting','smart');
add_line(mdl,'MotionSensor/V','PiezoBender/V','autorouting','smart');
add_line(mdl,'MotionSensor/R','MechRef/V','autorouting','smart');
add_line(mdl,'MotionSensor/V','PS2SL_vel/Iin','autorouting','smart');

%% Controller lines
add_line(mdl,'PS2SL_vel/Out1','ZC_neg/u');
add_line(mdl,'PS2SL_vel/Out1','ZC_pos/u');
add_line(mdl,'ZC_neg/y','OR_gate/In1');
add_line(mdl,'ZC_pos/y','OR_gate/In2');
add_line(mdl,'OR_gate/1','SRFF/S');
add_line(mdl,'OR_gate/1','Timer/Trigger');
add_line(mdl,'One/1','Timer/In1');
add_line(mdl,'Timer/1','Cmp/In1');
add_line(mdl,'T_flip/1','Cmp/In2');
add_line(mdl,'Cmp/1','SRFF/R');
add_line(mdl,'SRFF/Q','SL2PS_sw/Iin');
add_line(mdl,'SL2PS_sw/Iout','S_ssh/Simulink Input Port');

%% SSHI branch (parallel with piezo)
add_line(mdl,'PiezoBender/p','S_ssh/LConn1','autorouting','smart');
add_line(mdl,'S_ssh/RConn1','L_ssh/p','autorouting','smart');
add_line(mdl,'L_ssh/n','R_coil/p','autorouting','smart');
add_line(mdl,'R_coil/n','PiezoBender/n','autorouting','smart');

%% Bridge
add_line(mdl,'PiezoBender/p','D1/LConn1','autorouting','smart');
add_line(mdl,'D1/RConn1','C_rect/p','autorouting','smart');
add_line(mdl,'D2/RConn1','PiezoBender/p','autorouting','smart');
add_line(mdl,'C_rect/n','D2/LConn1','autorouting','smart');
add_line(mdl,'PiezoBender/n','D3/LConn1','autorouting','smart');
add_line(mdl,'D3/RConn1','C_rect/p','autorouting','smart');
add_line(mdl,'C_rect/n','D4/LConn1','autorouting','smart');
add_line(mdl,'D4/RConn1','PiezoBender/n','autorouting','smart');

%% Output
add_line(mdl,'C_rect/p','R_load/p','autorouting','smart');
add_line(mdl,'C_rect/n','R_load/n','autorouting','smart');
add_line(mdl,'C_rect/n','Gnd/V','autorouting','smart');
add_line(mdl,'R_load/p','V_out/p','autorouting','smart');
add_line(mdl,'R_load/n','V_out/n','autorouting','smart');
add_line(mdl,'V_out/Voltage','PS2SL_V/Iin','autorouting','smart');
add_line(mdl,'PS2SL_V/Out1','Scope_V/In1','autorouting','smart');
add_line(mdl,'SolverConfig/RConn1','Gnd/V','autorouting','smart');

save_system(mdl);
disp('=== SSHI model built. Simulating... ===');
sim(mdl);
disp('SSHI done.');
