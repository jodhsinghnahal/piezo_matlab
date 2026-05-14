%% build_SEH.m
% Standard Energy Harvesting (SEH)
% Piezo Bender -> Full-Wave Bridge Rectifier -> C_rect || R_load
%
% Library keys:
%   fl_lib       = Simscape Foundation Library
%   ee_lib       = Simscape Electrical Library
%   nesl_utility = Simscape Utilities

mdl = 'SEH_Piezo';
if bdIsLoaded(mdl), close_system(mdl,0); end
new_system(mdl);
open_system(mdl);

set_param(mdl,'Solver','ode23t','RelTol','1e-4','AbsTol','1e-6','StopTime','0.5');

ab = @(src,name,varargin) add_block(src,[mdl '/' name],varargin{:});

%% Solver Config & Ground
ab('nesl_utility/Solver Configuration','SolverConfig','Position',[30 30 160 80]);
ab('fl_lib/Electrical/Electrical Elements/Electrical Reference','Gnd','Position',[200 420 230 450]);

%% Piezo Bender
ab('ee_lib/Electromechanical/Mechatronic Actuators/Piezo Bender','PiezoBender','Position',[80 150 200 280]);

%% Mechanical Vibration Source
ab('fl_lib/Mechanical/Mechanical Sources/Ideal Force Source','ForceSource','Position',[30 155 70 215]);
ab('simulink/Sources/Sine Wave','SineWave','Frequency','2*pi*100','Amplitude','0.5','Position',[30 80 70 120]);
ab('fl_lib/Mechanical/Mechanical Elements/Mechanical Translational Reference','MechRef','Position',[30 300 60 330]);

%% Bridge Rectifier (4 Diodes)
positions = {[260 120 300 160],[260 200 300 240],[340 120 380 160],[340 200 380 240]};
for k = 1:4
    ab('ee_lib/Semiconductors & Converters/Diodes & Thyristors/Diode', ...
        sprintf('D%d',k),'Position',positions{k});
end

%% Filter Cap & Load
ab('fl_lib/Electrical/Electrical Elements/Capacitor','C_rect','c','100e-6','Position',[430 130 470 210]);
ab('fl_lib/Electrical/Electrical Elements/Resistor','R_load','r','1e3','Position',[510 130 550 210]);

%% Voltage Sensor & Scope
ab('fl_lib/Electrical/Electrical Sensors/Voltage Sensor','V_out','Position',[510 240 550 280]);
ab('nesl_utility/PS-Simulink Converter','PS2SL_V','Position',[580 244 620 276]);
ab('simulink/Sinks/Scope','Scope_V','Position',[640 239 690 281]);

%% Mechanical lines
add_line(mdl,'SineWave/1','ForceSource/Simulink Input Port');
add_line(mdl,'ForceSource/V','PiezoBender/V','autorouting','smart');
add_line(mdl,'ForceSource/R','MechRef/V','autorouting','smart');
add_line(mdl,'PiezoBender/R','MechRef/V','autorouting','smart');

%% Bridge (LConn1=anode, RConn1=cathode on Simscape Diode)
add_line(mdl,'PiezoBender/p','D1/LConn1','autorouting','smart');
add_line(mdl,'D1/RConn1','C_rect/p','autorouting','smart');
add_line(mdl,'D2/RConn1','PiezoBender/p','autorouting','smart');
add_line(mdl,'C_rect/n','D2/LConn1','autorouting','smart');
add_line(mdl,'PiezoBender/n','D3/LConn1','autorouting','smart');
add_line(mdl,'D3/RConn1','C_rect/p','autorouting','smart');
add_line(mdl,'C_rect/n','D4/LConn1','autorouting','smart');
add_line(mdl,'D4/RConn1','PiezoBender/n','autorouting','smart');

%% Output stage
add_line(mdl,'C_rect/p','R_load/p','autorouting','smart');
add_line(mdl,'C_rect/n','R_load/n','autorouting','smart');
add_line(mdl,'C_rect/n','Gnd/V','autorouting','smart');

%% Measurement
add_line(mdl,'R_load/p','V_out/p','autorouting','smart');
add_line(mdl,'R_load/n','V_out/n','autorouting','smart');
add_line(mdl,'V_out/Voltage','PS2SL_V/Iin','autorouting','smart');
add_line(mdl,'PS2SL_V/Out1','Scope_V/In1','autorouting','smart');
add_line(mdl,'SolverConfig/RConn1','Gnd/V','autorouting','smart');

save_system(mdl);
disp('=== SEH model built. Simulating... ===');
sim(mdl);
disp('SEH done.');
