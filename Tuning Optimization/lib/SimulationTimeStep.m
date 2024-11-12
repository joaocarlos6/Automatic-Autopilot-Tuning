%% SimulationTimeStep.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% March 22, 2022
% Description:


if simulatorMode=="SIL_External" || simulatorMode=="Desktop"
    DLLSim.dt    = 1/50; % Iteration Rate Of Simulink for SIL
else
    DLLSim.dt    = 1/100; % Iteration Rate Of Simulink for HIL
end
    DLLSim.SimDt = 1/600; % Iteration rate of the BA FDM
    DLLSim.nDT   = DLLSim.dt / DLLSim.SimDt;
    dt = DLLSim.dt; 