%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Joao Figueira
% March 06, 2025
% Description: Used as initial call to initialise simulink model required
% workspace vars for simulation.
%% Initialize Simulation Workspace
disp("sim");
if ~exist('TrimMaxIterations','var')
    TrimMaxIterations = 8; % FDM Trim Iterations on Init. Default is 100, do not go below 6 for ground Trim!
end
if ~exist('simTime','var')
   simTime = 150; %s  
end

simulatorMode="Desktop";

% Set in top-level script
%modelScale = '7P'; % Three versions, '7P','16P5', '100P'
%FTV = 2; % Set to 2 or 3 for 7% and 4 for 16.5%

disp("Index: " + int2str(testIndx));

tic
%% Configure Simulation Run
%testIndx = evalin('base','testIndx');

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
    if Flap == 0
        SimulationControlConfig16P;
        disp("16P UTAIL Control Complete");
    elseif Flap == 2
        SimulationControlConfig16P_F2;
        disp("16P UTAIL Control Complete");
    end
else
    if(WithTail)
        if vehicleType == "F"
            if Flap == 0
                SimulationControlConfigUTAIL_CGAFT;
                disp("7P UTAIL f0 Control Complete");
            elseif Flap == 2
                SimulationControlConfigUTAIL_CGAFT_F2;
                disp("7P UTAIL f2 Control Complete");
            end
        else
            SimulationControlConfigUTAIL_CGFWD;
            disp("7P UTAIL f0 Control Complete");
        end
    else
        SimulationControlConfigTAILLESS_CGFWD_F0;
        disp("7P TAILLESS Control Complete");
    end
end

SimulationControlPre
disp("ControlPre Complete");
SimulationTrim
disp("Trim Complete");

if (FTV == 4)
    SimulationHStabConfig
    disp("H-Stab Configuration Complete");
end

SimulationWSMConfig
SimulationCostFunction
disp("Cost Complete");

%% Run Verification Scripts
% VerificationLanding

%%
disp('Time Taken For Simulation Setup/Trimming')
toc