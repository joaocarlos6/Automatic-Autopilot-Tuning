%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% June 19, 2024
% Description:
% disp('SimulationStateConfig');
%% Initialize Simulation Workspace
if ~exist('TerrainHeight2GPSmeasurementHeightOffset','var')
    SimulationAircraftConfig
end

%% Define State Parameters for Simulation
    % Position
    Longitude            = -71.624729;  % Alma HWIL test Box 
    Latitude             = 48.496366;   % Degrees
    % Elevation
    TerrainHeight_Base   = testPlans(testIndx).terrainElevation - TerrainHeight2GPSmeasurementHeightOffset; % Ft, Baseline Terrain Height without elevation offset (controller knowledge)
    TerrainHeight        = TerrainHeight_Base + testPlans(testIndx).terrainOffset; % Ft, Actual Terrain Height to be configured in FDM
    % Heading
    Track                = 0; % Deg Needs to be implemented
    RwyHdg_Corrected     = 0; % AC Track is 0 deg (N) for simplification
    
    if FTV==3 || FTV==2
        Speed   = 32*1.944; % Kts
        Alt     = 500 + TerrainHeight;% Ft 
        PreApproachSegment = 280; %m This is pre-approach track in level flight
        
    elseif FTV==4
        Speed   = 41*1.944; % Kts
        Alt     = 1000 + TerrainHeight;% Ft
        PreApproachSegment = 500; %m This is pre-approach track in level flight
        
    else
        error('undefined FTV');
    end
   
    % Winds
    WindSpd_Kts         = testPlans(testIndx).winds(1); % knots
    Turbulence          = testPlans(testIndx).winds(2); % 0 = None, 1 = Light  
    WindDir_Deg         = testPlans(testIndx).winds(3); % Deg
    WindVertSpd_Kts     = 0;
    % Gusts
    GustType            = testPlans(testIndx).gustType;
    GustSpd_Kts         = testPlans(testIndx).gustSpd;
    GustTrigger         = testPlans(testIndx).gustTrigger;
    GustTriggerVal      = testPlans(testIndx).gustTriggerVal;
    
    TrimSetup   = 'Piccolo';
    %TrimSetup  = 'OpenLoopStraightAndLevel';
    %TrimSetup  = 'OpenLoopOnGround';

    g=9.81;  % Gravity constant estimate
