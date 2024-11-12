%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% February 03, 2022
% Description:
disp('SimulationAircraftConfig');
%% Initialize Simulation Workspace
if ~exist('FTV','var')
    FTV = 3; % Set to FTV3 for 7% and FTV4 for 16.5%
    modelScale = '7P'; % Three versions, '7P','16P5', '100P'
end

if(~exist('WithTail','var'))
    WithTail = 1; % Set to 0 to remove Tail 
end
    
if ~exist('PackageFlag','var')
    PackageFlag = 0;
end

%% Define Aircraft Model Parameters for Simulation

    Flap                 = 0;% 0,1,2,3
    HStab                = 0;% Deg
    CGShifterInitPosn_ft = 0; % ft - inital position of CG shifter
   
    if FTV == 2
        CGConfig        = testPlans(testIndx).CG;
        InertiaScale    = testPlans(testIndx).inertiaScale; % scale as percentage from test plan
        ZCGScale        = 0;
        
        % Can optionally set custom CG posn but accuracy may vary...
        %%xCgLocMacBWB_custom = testPlans(testIndx).CG;
        %%CGConfig = "SIMULATION"; % This will fall through CG switch statement to allow overriding of CG value
        
        FTV2C % Vehicle config script

        Cbar                    = 0.666;  
        XCG_m                   = (xCgLocMacBWB/100*Cbar + 0.37569);        % CG location relative to nose [m] WARNING: 0.37569 NEEDS TO BE UPDATED FOR 16.5%
        XCG                     = (XCG_m/0.07)/0.0254 * 0.6412 - 253.52;    % CG % = 0.6412*In - 253.52 
        xCgLocMacConventional   = (xCgLocMacBWB * 2.4028) - 118.03;         % Conventional or "Skinny" Mac location
        
        YCG                         = 0; % Only use 0. Alternate trim setup needed for lateral assymetry.
        DesktopSimTerrainOffset_m   = 0.18194;
        TerrainHeight2GPSmeasurementHeightOffset = 0.6;
        
    elseif FTV==3
        CGConfig        = testPlans(testIndx).CG;
        InertiaScale    = testPlans(testIndx).inertiaScale; % scale as percentage from test plan
        ZCGScale        = 0;
        
        % Can optionally set custom CG posn but accuracy may vary...
        %%xCgLocMacBWB_custom = testPlans(testIndx).CG;
        %%CGConfig = "SIMULATION"; % This will fall through CG switch statement to allow overriding of CG value
        
        if(vehicleType == "C")
            FTV3C % Charlie config script
        elseif(vehicleType == "D")
            FTV3D % Delta config script
        elseif(vehicleType == "E")
            FTV3E % Echo
        elseif(vehicleType == "F")
            FTV3F % Echo config script
            
        else
            error("Unsupported Gen 3 model!");
        end
        
        Cbar                    = 0.666;
        XCG_m                   = (xCgLocMacBWB/100*Cbar + 0.37569);        % CG location relative to nose [m] WARNING: 0.37569 NEEDS TO BE UPDATED FOR 16.5%
        XCG                     = (XCG_m/0.07)/0.0254 * 0.6412 - 253.52;    % CG % = 0.6412*In - 253.52 
        xCgLocMacConventional   = (xCgLocMacBWB * 2.4028) - 118.03;         % Conventional or "Skinny" Mac location
        
        YCG                         = 0; % Only use 0. Alternate trim setup needed for lateral assymetry.
        DesktopSimTerrainOffset_m   = 0.18194;        
        TerrainHeight2GPSmeasurementHeightOffset = 0.6;  
        
    elseif FTV==4
        WithTail = 1; % Override tail flag (we're not ready yet!)
        % Set CG Configuration. Allowable values: FWD, BASE, AFT, AFT*
        % For special CG locations, use custom CG configuration below
        CGConfig                = testPlans(testIndx).CG;
        % Set aircraft mass configuration here. Representative of fuel load.
        % Allowable types: TOW1, TOW3, MTOW, EMPTY
        AircraftMassConfig      = testPlans(testIndx).mass;
        
        % Scaling Parameters
        InertiaScale            = testPlans(testIndx).inertiaScale; % scale as percentage from test plan

        ZCGScale                                    = 0; % scale as percentage
        WheelContact2AftNovatelAntenna_Ft           = 2.02; % Offset from ground to 16P5 Aft Novatel. Note touchdown altitudes measured from waterline where AP installed roughly
        TerrainHeight2GPSmeasurementHeightOffset    = WheelContact2AftNovatelAntenna_Ft;
        DesktopSimTerrainOffset_m                   = 0.406;
        FTV4A; % Lookup Inertias and Mass from Excel Reference Table
        
        AngularAccelOn = 0; % Set angular accel flag
     else
        error('undefined FTV');
    end
    
    %% Latency Setup
    % Additional transport delay for verification
    AdditionalLatency = 0.010 + testPlans(testIndx).delay; % 0.01s

    EngineLhFuelCut = 0;
    if (EngineLhFuelCut)
        warning("Left Engine Fuel Cut Configured!")
    end
    EngineRhFuelCut = 0;
    if (EngineRhFuelCut)
        warning("Right Engine Fuel Cut Configured!")
    end