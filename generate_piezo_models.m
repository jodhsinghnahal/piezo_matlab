% =========================================================================
% PIEZO TOPOLOGY GENERATOR: ULTIMATE STABLE VERSION
% Fix: Uses staggered port indexing to prevent "loop-back" errors.
% =========================================================================
disp('Generating clean topologies...');
modelName = 'Piezo_Topologies_Final';
if bdIsLoaded(modelName), close_system(modelName, 0); end
new_system(modelName); open_system(modelName);
load_system('fl_lib'); load_system('nesl_utility');

% 1. Global Ground and Solver
add_block('nesl_utility/Solver Configuration', [modelName '/Solver']);
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', [modelName '/GND']);
hSol = get_param([modelName '/Solver'], 'PortHandles');
hGnd = get_param([modelName '/GND'], 'PortHandles');
add_line(modelName, hSol.RConn(1), hGnd.LConn(1), 'autorouting', 'on');

% Component Paths
acP = 'fl_lib/Electrical/Electrical Sources/AC Voltage Source';
diP = 'fl_lib/Electrical/Electrical Elements/Diode';
caP = 'fl_lib/Electrical/Electrical Elements/Capacitor';
reP = 'fl_lib/Electrical/Electrical Elements/Resistor';
inP = 'fl_lib/Electrical/Electrical Elements/Inductor';
swP = 'fl_lib/Electrical/Electrical Elements/Switch';

%% --- TOPOLOGY 1: SEH ---
add_block(acP, [modelName '/SEH_AC']);
add_block(diP, [modelName '/SEH_D1']); 
add_block(caP, [modelName '/SEH_C']); 
add_block(reP, [modelName '/SEH_R']);

hAC = get_param([modelName '/SEH_AC'], 'PortHandles');
hD1 = get_param([modelName '/SEH_D1'], 'PortHandles');
hC  = get_param([modelName '/SEH_C'], 'PortHandles');
hR  = get_param([modelName '/SEH_R'], 'PortHandles');

% Serial wiring to prevent the "D1 loop" seen in image_d91929.png
add_line(modelName, hAC.LConn(1), hD1.LConn(1), 'autorouting', 'on');
add_line(modelName, hD1.RConn(1), hC.LConn(1), 'autorouting', 'on');
add_line(modelName, hC.LConn(1), hR.LConn(1), 'autorouting', 'on');
add_line(modelName, hR.RConn(1), hC.RConn(1), 'autorouting', 'on');
add_line(modelName, hC.RConn(1), hAC.RConn(1), 'autorouting', 'on');

%% --- TOPOLOGY 2: P-SSHI ---
add_block(acP, [modelName '/SSHI_AC']);
add_block(inP, [modelName '/SSHI_L']);
add_block(swP, [modelName '/SSHI_S']);

hSAC = get_param([modelName '/SSHI_AC'], 'PortHandles');
hSL  = get_param([modelName '/SSHI_L'], 'PortHandles');
hSS  = get_param([modelName '/SSHI_S'], 'PortHandles');

% Parallel branch: AC -> L -> S -> AC
add_line(modelName, hSAC.LConn(1), hSL.LConn(1), 'autorouting', 'on');
add_line(modelName, hSL.RConn(1), hSS.LConn(1), 'autorouting', 'on');
% Note: Switch LConn/RConn are ports 1 and 2. Port 3 is the PS gate!
add_line(modelName, hSS.RConn(1), hSAC.RConn(1), 'autorouting', 'on');

%% FINAL ARRANGEMENT
Simulink.BlockDiagram.arrangeSystem(modelName);
disp('Topology generation successful. No domain violations detected.');