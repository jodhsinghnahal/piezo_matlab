%% ============================================================
%  Piezo Energy Harvester Topology Generator
%
%  Creates directly from Simscape blocks:
%
%   1. SEH
%   2. Parallel SSHI
%   3. Series SSHI
%   4. SECE
%   5. SSHC
%
%  NO openExample() dependency
%
%  Requires:
%   Simscape
%   Simscape Electrical
%
% ============================================================

%clc;
%clear;
%bdclose all;

%% ============================================================
% GENERATE ALL TOPOLOGIES
%% ============================================================

create_SEH("SEH_Model");
create_parallel_SSHI("Parallel_SSHI_Model");
create_series_SSHI("Series_SSHI_Model");
create_SECE("SECE_Model");
create_SSHC("SSHC_Model");

disp("DONE");

%% ============================================================
% COMMON MODEL SETUP
%% ============================================================

function setup_model(model)

new_system(model);
open_system(model);

set_param(model,'StopTime','0.5');

% Solver config
add_block( ...
    'simscape/Utilities/Solver Configuration', ...
    model + "/Solver", ...
    'Position',[40 300 100 360]);

% Electrical reference
add_block( ...
    'fl_lib/Electrical/Electrical Elements/Electrical Reference', ...
    model + "/ElectricalRef", ...
    'Position',[120 320 160 360]);

% Mechanical translational reference
add_block( ...
    'fl_lib/Mechanical/Translational Elements/Mechanical Translational Reference', ...
    model + "/MechRef", ...
    'Position',[40 120 80 160]);

end

%% ============================================================
% PIEZO MODEL
%
% Simple equivalent:
%   Current source || capacitor
%
% I = alpha * velocity
%
%% ============================================================

function add_piezo(model)

% Velocity source
add_block( ...
    'fl_lib/Mechanical/Mechanical Sources/Ideal Translational Velocity Source', ...
    model + "/VelocitySource", ...
    'Position',[120 80 200 160]);

% Sine wave
add_block( ...
    'fl_lib/Physical Signals/Sources/PS Sine Wave', ...
    model + "/Sine", ...
    'Amplitude','0.02', ...
    'Frequency','100', ...
    'Position',[20 20 80 60]);

% Translational electromechanical converter
add_block( ...
    'fl_lib/Electrical/Electrical Elements/Translational Electromechanical Converter', ...
    model + "/EMConverter", ...
    'Position',[280 70 380 180]);

% Piezo capacitance
add_block( ...
    'fl_lib/Electrical/Electrical Elements/Capacitor', ...
    model + "/PiezoCap", ...
    'Capacitance','100e-9', ...
    'Position',[420 80 480 140]);

% Connect PS
add_line(model,'Sine/R','VelocitySource/S');

% Mechanical side
add_line(model,'VelocitySource/R','EMConverter/R');
add_line(model,'MechRef/R','VelocitySource/C');
add_line(model,'MechRef/R','EMConverter/C');

% Electrical side
add_line(model,'EMConverter/+','PiezoCap/1');
add_line(model,'EMConverter/-','PiezoCap/2');

end

%% ============================================================
% FULL BRIDGE RECTIFIER
%% ============================================================

function add_rectifier(model)

x = 560;
y = 80;

for k = 1:4

    add_block( ...
        'fl_lib/Electrical/Electrical Elements/Diode', ...
        model + "/D" + num2str(k), ...
        'Position',[x+100*(k-1) y x+40+100*(k-1) y+40]);

end

end

%% ============================================================
% LOAD
%% ============================================================

function add_load(model)

add_block( ...
    'fl_lib/Electrical/Electrical Elements/Capacitor', ...
    model + "/Cload", ...
    'Capacitance','100e-6', ...
    'Position',[980 80 1040 140]);

add_block( ...
    'fl_lib/Electrical/Electrical Elements/Resistor', ...
    model + "/Rload", ...
    'Resistance','100e3', ...
    'Position',[980 200 1040 260]);

end

%% ============================================================
% CONNECT RECTIFIER
%% ============================================================

function connect_basic_rectifier(model)

% Piezo to bridge
add_line(model,'PiezoCap/1','D1/1');
add_line(model,'PiezoCap/1','D2/2');

add_line(model,'PiezoCap/2','D3/1');
add_line(model,'PiezoCap/2','D4/2');

% DC+
add_line(model,'D1/2','Cload/1');
add_line(model,'D3/2','Cload/1');

add_line(model,'D1/2','Rload/1');
add_line(model,'D3/2','Rload/1');

% DC-
add_line(model,'D2/1','ElectricalRef/1');
add_line(model,'D4/1','ElectricalRef/1');

add_line(model,'Cload/2','ElectricalRef/1');
add_line(model,'Rload/2','ElectricalRef/1');

end

%% ============================================================
% VOLTAGE SENSOR + SCOPE
%% ============================================================

function add_measurement(model)

add_block( ...
    'fl_lib/Electrical/Electrical Sensors/Voltage Sensor', ...
    model + "/Vsense", ...
    'Position',[1120 100 1180 160]);

add_block( ...
    'simscape/Utilities/PS-Simulink Converter', ...
    model + "/PS2SL", ...
    'Position',[1220 100 1280 140]);

add_block( ...
    'simulink/Sinks/Scope', ...
    model + "/Scope", ...
    'Position',[1320 90 1380 150]);

add_line(model,'Cload/1','Vsense/+');
add_line(model,'ElectricalRef/1','Vsense/-');

add_line(model,'Vsense/V','PS2SL/1');
add_line(model,'PS2SL/1','Scope/1');

end

%% ============================================================
% SEH
%% ============================================================

function create_SEH(model)

setup_model(model);

add_piezo(model);

add_rectifier(model);

add_load(model);

connect_basic_rectifier(model);

add_measurement(model);

save_system(model);

end

%% ============================================================
% PARALLEL SSHI
%% ============================================================

function create_parallel_SSHI(model)

create_SEH(model);

load_system(model);

% Inductor
add_block( ...
    'fl_lib/Electrical/Electrical Elements/Inductor', ...
    model + "/Lsshi", ...
    'Inductance','10e-3', ...
    'Position',[520 320 580 380]);

% Switch
add_block( ...
    'fl_lib/Electrical/Electrical Elements/Switch', ...
    model + "/SWsshi", ...
    'Position',[620 320 700 380]);

% Pulse generator
add_block( ...
    'simulink/Sources/Pulse Generator', ...
    model + "/Pulse", ...
    'Amplitude','1', ...
    'Period','0.01', ...
    'PulseWidth','2', ...
    'Position',[520 440 600 480]);

% Simulink-PS
add_block( ...
    'simscape/Utilities/Simulink-PS Converter', ...
    model + "/SL2PS", ...
    'Position',[640 440 700 480]);

% Connections
add_line(model,'Pulse/1','SL2PS/1');

% Parallel branch across piezo
add_line(model,'PiezoCap/1','Lsshi/1');
add_line(model,'Lsshi/2','SWsshi/1');
add_line(model,'SWsshi/2','PiezoCap/2');

save_system(model);

end

%% ============================================================
% SERIES SSHI
%% ============================================================

function create_series_SSHI(model)

create_SEH(model);

load_system(model);

add_block( ...
    'fl_lib/Electrical/Electrical Elements/Inductor', ...
    model + "/Lseries", ...
    'Inductance','10e-3', ...
    'Position',[460 80 520 140]);

add_block( ...
    'fl_lib/Electrical/Electrical Elements/Switch', ...
    model + "/SWseries", ...
    'Position',[560 80 640 140]);

% Break original connection
delete_line(model,'PiezoCap/1','D1/1');

% Insert series branch
add_line(model,'PiezoCap/1','Lseries/1');
add_line(model,'Lseries/2','SWseries/1');
add_line(model,'SWseries/2','D1/1');

save_system(model);

end

%% ============================================================
% SECE
%% ============================================================

function create_SECE(model)

create_SEH(model);

load_system(model);

add_block( ...
    'fl_lib/Electrical/Electrical Elements/Inductor', ...
    model + "/Lsece", ...
    'Inductance','20e-3', ...
    'Position',[760 320 820 380]);

add_block( ...
    'fl_lib/Electrical/Electrical Elements/Switch', ...
    model + "/SWsece", ...
    'Position',[860 320 940 380]);

add_block( ...
    'simulink/Sources/Pulse Generator', ...
    model + "/PulseSECE", ...
    'Amplitude','1', ...
    'Period','0.01', ...
    'PulseWidth','1', ...
    'Position',[760 440 840 480]);

add_block( ...
    'simscape/Utilities/Simulink-PS Converter', ...
    model + "/SL2PS_SECE", ...
    'Position',[880 440 940 480]);

add_line(model,'PulseSECE/1','SL2PS_SECE/1');

% Extraction path
add_line(model,'Cload/1','Lsece/1');
add_line(model,'Lsece/2','SWsece/1');
add_line(model,'SWsece/2','ElectricalRef/1');

save_system(model);

end

%% ============================================================
% SSHC
%% ============================================================

function create_SSHC(model)

create_SEH(model);

load_system(model);

% Switching capacitor
add_block( ...
    'fl_lib/Electrical/Electrical Elements/Capacitor', ...
    model + "/Csshc", ...
    'Capacitance','1e-6', ...
    'Position',[520 320 580 380]);

% Switch
add_block( ...
    'fl_lib/Electrical/Electrical Elements/Switch', ...
    model + "/SWsshc", ...
    'Position',[620 320 700 380]);

% Pulse
add_block( ...
    'simulink/Sources/Pulse Generator', ...
    model + "/PulseSSHC", ...
    'Amplitude','1', ...
    'Period','0.01', ...
    'PulseWidth','2', ...
    'Position',[520 440 600 480]);

% Converter
add_block( ...
    'simscape/Utilities/Simulink-PS Converter', ...
    model + "/SL2PS_SSHC", ...
    'Position',[640 440 700 480]);

add_line(model,'PulseSSHC/1','SL2PS_SSHC/1');

% Connect capacitor inversion branch
add_line(model,'PiezoCap/1','Csshc/1');
add_line(model,'Csshc/2','SWsshc/1');
add_line(model,'SWsshc/2','PiezoCap/2');

save_system(model);

end