%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% February 03, 2022
% Description: Used as initial call to initialise simulink model required
% workspace vars for simulation.
%% Initialize Simulation Workspace
disp("sim");
if ~exist('TrimMaxIterations','var')
    TrimMaxIterations = 8; % FDM Trim Iterations on Init. Default is 100, do not go below 6 for ground Trim!
end
if ~exist('simTime','var')
   simTime = 40; %s  
end

simulatorMode="Desktop";


disp("Index: " + int2str(testIndx));

tic
%% Configure Simulation Run

SimulationTimeStep
disp("TimeStep Complete");
SimulationAircraftConfig
disp("SimAirConfig Complete");
SimulationLatencyConfig
disp("LatencyConfig Complete");

% Select sensor configuration
if(FTV == 4)
   SimulationSensorConfig16P 
   disp("SensorConfig 16P Complete");
else
   if(WithTail)
    SimulationSensorConfigUTAIL7P
    disp("SensorConfig UTail 7P Complete");
   else
    SimulationSensorConfigTAILLESS7P
    disp("SensorConfig Tailless 7P Complete");
   end
end

SimulationBusDef
disp("BusDefinition Complete")

SimulationStateConfig
disp("StateConfig Complete");

% Select control configuration
if(FTV == 4)
    SimulationControlConfig16P;
    disp("16P UTAIL Control Complete");
else
    if(WithTail)
        SimulationControlConfigUTAIL;
        disp("7P UTAIL Control Complete");
    else
        SimulationControlConfigTAILLESS;
        disp("7P TAILLESS Control Complete");
    end
end

SimulationControlPre
disp("ControlPre Complete");
SimulationTrim
disp("Trim Complete");

%%
disp('Time Taken For Simulation Setup/Trimming')
toc