%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% February 03, 2022
% Description:
disp('SimulationTrim');
%% Initialize Simulation Workspace
if ~exist('TrimMaxIterations','var')
    TrimMaxIterations = 100; % FDM Trim Iterations on Init. Default is 100, do not go below 6 for ground Trim!
end
if ~exist('dt','var')
    dt = 0.02; 
end
if ~exist('TrimSetup','var')
    %This should be defined in the SimulationStateConfig Normally
    
    TrimSetup   = 'Piccolo';
%     TrimSetup   = 'OpenLoopStraightAndLevel';
    
    % TrimSetup   = 'OpenLoopOnGround';
end
if ~exist('simTime','var')
    simTime = 110; %s 
end
if ~exist('PackageFlag','var')
    PackageFlag = 0;
end

% Define name and location of FDM on fileserver     
FDMRelease  = 35;

disp("FDM Version: " + FDMRelease)
%% Model Configuration Parameters

FDMPath = 'lib\Flight Dynamics Model\'; %Local Reference for distribution to remote machines

% Define Model
if FDMRelease == 35
    FDMVer      = 'BA-BWB_Scale_Model_SimulationDLL_Ver35\T507Sim';
    if modelScale == "7P"
        FDMDLL      = 't507_7p_T507_7P_sim_Top3_34_Opt2.mexw64';
    elseif modelScale == "16P5"
        FDMDLL      = 't507_16p5_T507_16P5_sim_Top1_71_Opt2.mexw64';
    end
elseif FDMRelease == 33
    FDMVer      = 'BA-BWB_Scale_Model_SimulationDLL_Ver33\T507Sim';
    if modelScale == "7P"
        FDMDLL      = 't507_7p_T507_7P_sim_Top3_27_Opt2.mexw64';
    elseif modelScale == "16P5"
        FDMDLL      = 't507_16p5_T507_16P5_sim_Top1_68_Opt2.mexw64';
    end
else
    error('Unsupported FDMRelease number input');
end

addpath(strcat(FDMPath,FDMVer));
addpath(strcat(FDMPath,FDMVer,'\bin'));

DLL_Name = strcat(FDMPath,FDMVer,'\',FDMDLL);


%% Do not edit code below this line.
%% SimObj Global label declaration
   global SimObj;
    if isempty(SimObj)
        % Create Object, first call only.
        try
        SimObj = CompiledSimulink(DLL_Name); % Sim Object Processing
        catch e
            disp(e.message)
        end
        SimObj.NUM_ITER_TO_PROPAGATE_ORDINARY_NTSTATES = 4;

        %Trim Setup Definitions
            % IAR166_deltaCorrection_ON
                SimObj.fadd('Defaults','Settings','Param.IAR166_AftFlapAF3_ON',0);
                SimObj.fadd('Defaults','Settings','Param.IAR166_AftFlapAF2_ON',1);
                SimObj.fadd('Defaults','Settings','Param.IAR166_AftFlapAF1_ON',0);

            % Assume all available surefaces exist.
                SimObj.fadd('Defaults','Settings','Param.IAR166_UTail_ON',1);
                SimObj.fadd('Defaults','Settings','Param.PylonRudders_ON',1);
                SimObj.fadd('Defaults','Settings','Param.WgltRudders_ON', 1);

            % Assume all available surefaces exist.
                SimObj.fadd('Defaults','Settings','Param.Flight_InertiaSelect',1);
                SimObj.fadd('Defaults','Settings','Param.Flight_FD_On',1);

            % Set Gear Down to include CD from gear in calculation
                SimObj.fadd('Defaults','Settings','Input.NGearPosnNorm',  1);
                SimObj.fadd('Defaults','Settings','Input.LMGearPosnNorm',  1);
                SimObj.fadd('Defaults','Settings','Input.RMGearPosnNorm',  1);

            % Set Tail On Param
                SimObj.fadd('Defaults','Settings','Param.IAR166_UTail_ON',WithTail);

            % Set Terrain and Atmosphere Defaults
				SimObj.fadd('Defaults','Settings','Param.AirVonkarmanTurbLevel',Turbulence);% 1 - light/ 2 = medium.
				SimObj.fadd('Defaults','Settings','Param.HeightTerrainMGLhFt', TerrainHeight);
				SimObj.fadd('Defaults','Settings','Param.HeightTerrainMGRhFt', TerrainHeight);
				SimObj.fadd('Defaults','Settings','Param.HeightTerrainNGFt',   TerrainHeight);
                SimObj.fadd('Defaults','Settings','Param.Flight_RnwSlopeOn',   0);

            % Set NRC Angular Accelerometers on or off 
            if isequal(SimObj.Param.ac_type,507.16)
                SimObj.fadd('Defaults','Settings','Param.test_pilotAngAccEstimatorEnable',   1-AngularAccelOn);
            end
                
            % Define Flap Configuration
            SimObj.fclear('Flap0Definition')
                SimObj.fadd('Flap0Definition','Settings','Param.REFSI_FD_IN_nmodeFlapLhOBCmd_Deg', 0);
                SimObj.fadd('Flap0Definition','Settings','Param.REFSI_FD_IN_nmodeFlapLhIBCmd_Deg', 0);
                SimObj.fadd('Flap0Definition','Settings','Param.REFSI_FD_IN_nmodeFlapRhIBCmd_Deg', 0);
                SimObj.fadd('Flap0Definition','Settings','Param.REFSI_FD_IN_nmodeFlapRhOBCmd_Deg', 0);
                SimObj.fadd('Flap0Definition','Settings','Param.REFSI_FD_IN_nmodeSlatLhCmd_Deg',  0);
                SimObj.fadd('Flap0Definition','Settings','Param.REFSI_FD_IN_nmodeSlatRhCmd_Deg',  0);

             SimObj.fclear('Flap1Definition')
                SimObj.fadd('Flap1Definition','Settings','Param.REFSI_FD_IN_nmodeFlapLhOBCmd_Deg', 0);
                SimObj.fadd('Flap1Definition','Settings','Param.REFSI_FD_IN_nmodeFlapLhIBCmd_Deg', 0);
                SimObj.fadd('Flap1Definition','Settings','Param.REFSI_FD_IN_nmodeFlapRhIBCmd_Deg', 0);
                SimObj.fadd('Flap1Definition','Settings','Param.REFSI_FD_IN_nmodeFlapRhOBCmd_Deg', 0);
                SimObj.fadd('Flap1Definition','Settings','Param.REFSI_FD_IN_nmodeSlatLhCmd_Deg',  15);
                SimObj.fadd('Flap1Definition','Settings','Param.REFSI_FD_IN_nmodeSlatRhCmd_Deg',  15);

            SimObj.fclear('Flap2Definition')
                SimObj.fadd('Flap2Definition','Settings','Param.REFSI_FD_IN_nmodeFlapLhOBCmd_Deg', 15);
                SimObj.fadd('Flap2Definition','Settings','Param.REFSI_FD_IN_nmodeFlapLhIBCmd_Deg', 15);
                SimObj.fadd('Flap2Definition','Settings','Param.REFSI_FD_IN_nmodeFlapRhIBCmd_Deg', 15);
                SimObj.fadd('Flap2Definition','Settings','Param.REFSI_FD_IN_nmodeFlapRhOBCmd_Deg', 15);
                SimObj.fadd('Flap2Definition','Settings','Param.REFSI_FD_IN_nmodeSlatLhCmd_Deg',  15);
                SimObj.fadd('Flap2Definition','Settings','Param.REFSI_FD_IN_nmodeSlatRhCmd_Deg',  15);

            SimObj.fclear('Flap3Definition')
                SimObj.fadd('Flap3Definition','Settings','Param.REFSI_FD_IN_nmodeFlapLhOBCmd_Deg', 30);
                SimObj.fadd('Flap3Definition','Settings','Param.REFSI_FD_IN_nmodeFlapLhIBCmd_Deg', 30);
                SimObj.fadd('Flap3Definition','Settings','Param.REFSI_FD_IN_nmodeFlapRhIBCmd_Deg', 30);
                SimObj.fadd('Flap3Definition','Settings','Param.REFSI_FD_IN_nmodeFlapRhOBCmd_Deg', 30);
                SimObj.fadd('Flap3Definition','Settings','Param.REFSI_FD_IN_nmodeSlatLhCmd_Deg',  15);
                SimObj.fadd('Flap3Definition','Settings','Param.REFSI_FD_IN_nmodeSlatRhCmd_Deg',  15);

        % Actuator Delays
            if isequal(SimObj.Param.ac_type,507.07)
                SimObj.Limits_DState.LMGStrutInch       = [0.001, 0.15];
                SimObj.Limits_DState.RMGStrutInch       = [0.001, 0.15];
                SimObj.Limits_DState.NGStrutInch        = [0.001, 1.3];
               
                SimObj.fadd('ActDelay','Settings','Param.RudWingPCUDynActuatorResponseDelay',   ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01 Try
                SimObj.fadd('ActDelay','Settings','Param.AilPCUDynActuatorResponseDelay',       ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01
                SimObj.fadd('ActDelay','Settings','Param.ElvObPCUDynActuatorResponseDelay',     ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01
                SimObj.fadd('ActDelay','Settings','Param.ElvIbPCUDynActuatorResponseDelay',     ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01
                SimObj.fadd('ActDelay','Settings','Param.PylonRudPCUDynActuatorResponseDelay',  ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01
                SimObj.fadd('ActDelay','Settings','Param.UTailStabPCUDynActuatorResponseDelay', ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01
                SimObj.fadd('ActDelay','Settings','Param.UTailElvPCUDynActuatorResponseDelay',  ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01
                SimObj.fadd('ActDelay','Settings','Param.UTailRudPCUDynActuatorResponseDelay',  ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01
                SimObj.fadd('ActDelay','Settings','Param.AftFlapPCUDynActuatorResponseDelay',   ActuatorModel.ActuatorCBS15ResponseDelay); % 0.01  
                SimObj.fadd('ActDelay','Settings','Param.BrakePCUDynActuatorResponseDelay',     ActuatorModel.BrakeLatency); % 0.01  
                SimObj.fadd('ActDelay','Settings','Param.TLAPCUDynActuatorResponseDelay',       ActuatorModel.PropulsionEDFLatency); % 0.01  
                SimObj.fadd('ActDelay','Settings','Param.NoseGearPCUDynActuatorResponseDelay',  ActuatorModel.ActuatorHBL6625ResponseDelay); % 0.01  

            elseif isequal(SimObj.Param.ac_type,507.16)
                SimObj.fadd('ActDelay','Settings','Param.ActuatorHBL6625ResponseDelay',             ActuatorModel.ActuatorHBL6625ResponseDelay);      
                SimObj.fadd('ActDelay','Settings','Param.ActuatorCBS20ResponseDelay',               ActuatorModel.ActuatorCBS20ResponseDelay);    
                if FDMRelease >= 24
                    SimObj.fadd('ActDelay','Settings','Param.NoseGearActuatorHitecSG33BLResponseDelay', ActuatorModel.ActuatorHitecSG33BLResponseDelay);        
                end
                SimObj.fadd('ActDelay','Settings','Param.ActuatorCBS15ResponseDelay',               ActuatorModel.ActuatorCBS15ResponseDelay);        
                SimObj.fadd('ActDelay','Settings','Param.ActuatorHitecSG33BLResponseDelay',         ActuatorModel.ActuatorHitecSG33BLResponseDelay);  
                SimObj.fadd('ActDelay','Settings','Param.BrakePCUDynActuatorResponseDelay',         ActuatorModel.BrakeLatency); 
                SimObj.fadd('ActDelay','Settings','Param.TLAPCUDynActuatorResponseDelay',           ActuatorModel.PropulsionJetCatLatency); 
            end
        % Engines
             if isequal(SimObj.Param.ac_type,507.07)
                SimObj.fadd('EngStates','X','DState.EngineLhRPM');
                SimObj.fadd('EngStates','X','DState.EngineRhRPM');
                SimObj.fadd('EngStates','F','Deriv.EngineLhRPM');
                SimObj.fadd('EngStates','F','Deriv.EngineRhRPM');
                SimObj.fadd('EngStatesIC','Settings','Input.TLALhDeg',   0.5);
                SimObj.fadd('EngStatesIC','Settings','Input.TLARhDeg',   0.5);
                SimObj.fadd('EngStatesIC','Settings','DState.EngineLhRPM',   2591);
                SimObj.fadd('EngStatesIC','Settings','DState.EngineRhRPM',   2591);

            elseif isequal(SimObj.Param.ac_type,507.16)
                SimObj.fadd('EngStates','X','DState.N1_duplicate_1',60000);
                SimObj.fadd('EngStates','X','DState.N1_duplicate_2',60000);
                SimObj.fadd('EngStates','F','Deriv.N1_duplicate_1');
                SimObj.fadd('EngStates','F','Deriv.N1_duplicate_2');
                SimObj.fadd('EngStatesIC','Settings','Input.TLALhDeg',   20);
                SimObj.fadd('EngStatesIC','Settings','Input.TLARhDeg',   20);
                SimObj.fadd('EngStatesIC','Settings','DState.N1_duplicate_1',   60000);
                SimObj.fadd('EngStatesIC','Settings','DState.N1_duplicate_2',   60000);
                SimObj.Limits_DState.N1_duplicate_1 = [0.00005, 90000];
                SimObj.Limits_DState.N1_duplicate_2 = [0.00005, 90000];
             end


        % OpenLoop Straight and Level Trim Setup
            SimObj.fclear('OpenLoopStraightAndLevel')

            SimObj.fadd('OpenLoopStraightAndLevel','fsetup','EngStates','EngStatesIC')

            SimObj.fadd('OpenLoopStraightAndLevel','X','Param.REFSI_FD_IN_nmodeTlaLhCmd_Deg');
            SimObj.fadd('OpenLoopStraightAndLevel','X','Param.REFSI_FD_IN_nmodeTlaRhCmd_Deg');
            SimObj.fadd('OpenLoopStraightAndLevel','X','Param.REFSI_FD_IN_nmodeStabCmd',5);

            SimObj.fadd('OpenLoopStraightAndLevel','X','DState.UFtps');
            SimObj.fadd('OpenLoopStraightAndLevel','X','DState.WFtps');
            SimObj.fadd('OpenLoopStraightAndLevel','X','DState.ThetaRad');
            SimObj.fadd('OpenLoopStraightAndLevel','F','Deriv.WFtps');
            SimObj.fadd('OpenLoopStraightAndLevel','F','Deriv.QRdps');
            SimObj.fadd('OpenLoopStraightAndLevel','F','Signal.deltaTLADeg');
            SimObj.fadd('OpenLoopStraightAndLevel','F','Output.GammaDeg                            -     OutputDemand.GammaDeg');
            SimObj.fadd('OpenLoopStraightAndLevel','Settings','SignalDemand.GammaDeg', 0);

            SimObj.fadd('OpenLoopStraightAndLevel','F','Signal.CASKts                              -     SignalDemand.CASKts');
            SimObj.fadd('OpenLoopStraightAndLevel','IC','Param.REFSI_FD_IN_nmodeTlaLhCmd_Deg', 0.9);
            SimObj.fadd('OpenLoopStraightAndLevel','IC','Param.REFSI_FD_IN_nmodeTlaRhCmd_Deg', 0.9);


            SimObj.fadd('OpenLoopStraightAndLevel','X','DState.PhiRad');
            SimObj.fadd('OpenLoopStraightAndLevel','X','DState.PsiRad');
            SimObj.fadd('OpenLoopStraightAndLevel','X','DState.VFtps');
            SimObj.fadd('OpenLoopStraightAndLevel','X','DState.AlphaDotRdps');
            SimObj.fadd('OpenLoopStraightAndLevel','F','Deriv.AlphaDotRdps');

            SimObj.fadd('OpenLoopStraightAndLevel','F','Deriv.PRdps');
            SimObj.fadd('OpenLoopStraightAndLevel','F','Deriv.RRdps');
            SimObj.fadd('OpenLoopStraightAndLevel','F','Deriv.VFtps');

            SimObj.fadd('OpenLoopStraightAndLevel','F','Output.VDotFtps2');

            SimObj.fadd('OpenLoopStraightAndLevel','F','Output.TrackDeg - OutputDemand.TrackDeg');
            SimObj.fadd('OpenLoopStraightAndLevel','Settings','OutputDemand.TrackDeg',Track);  % (heading should = track for no wind).

            SimObj.fadd('OpenLoopStraightAndLevel','F','Output.BetaDeg');

            SimObj.fadd('OpenLoopStraightAndLevel','X','Input.deltaCR');
            SimObj.fadd('OpenLoopStraightAndLevel','X','Input.deltaCN');

			SimObj.fadd('OpenLoopStraightAndLevel','Settings','Param.RnwFreqHz',0);
			SimObj.fadd('OpenLoopStraightAndLevel','Settings','Param.Flight_RnwLatDeg',Latitude);
			SimObj.fadd('OpenLoopStraightAndLevel','Settings','Param.Flight_RnwLongDeg',Longitude);

        % Defaults
            SimObj.fadd('OpenLoopStraightAndLevel','fsetup','Defaults');

        % Piccolo S&L Trim
            SimObj.fadd('Piccolo','X','Param.piccoloAilCmd_Deg');
            SimObj.fadd('Piccolo','X','Param.piccoloElvCmd_Deg');
            SimObj.fadd('Piccolo','X','Param.piccoloRudCmd_Deg');
            SimObj.fadd('Piccolo','X','Input.TLALhDeg',0.5);
            SimObj.fadd('Piccolo','X','Input.TLARhDeg',0.5);
            SimObj.fadd('Piccolo','Settings','Param.piccoloInCmd',1);

            SimObj.fadd('Piccolo','X','DState.UFtps');
            SimObj.fadd('Piccolo','X','DState.VFtps');
            SimObj.fadd('Piccolo','X','DState.WFtps');
            SimObj.fadd('Piccolo','X','DState.ThetaRad');
            SimObj.fadd('Piccolo','X','DState.PhiRad');
            SimObj.fadd('Piccolo','X','DState.PsiRad');


            SimObj.fadd('Piccolo','F','Deriv.UFtps');
            SimObj.fadd('Piccolo','F','Deriv.VFtps');
            SimObj.fadd('Piccolo','F','Deriv.WFtps');
            SimObj.fadd('Piccolo','F','Deriv.PRdps');
            SimObj.fadd('Piccolo','F','Deriv.QRdps');
            SimObj.fadd('Piccolo','F','Deriv.RRdps');

            SimObj.fadd('Piccolo','Settings','Param.claws_pilotCasTrimSpdCmd_Kt',@(obj)(obj.Signal.ismCas_Kt ));

            SimObj.fadd('Piccolo','F','Signal.GammaDeg');
            SimObj.fadd('Piccolo','F','Signal.deltaTLADeg                         -     SignalDemand.deltaTLADeg');
            SimObj.fadd('Piccolo','F','Signal.CASKts                              -     SignalDemand.CASKts');
            SimObj.fadd('Piccolo','F','Signal.BetaDeg');

            SimObj.fadd('Piccolo','fsetup','EngStates','EngStatesIC')


            SimObj.fadd('Piccolo','F','Output.TrackDeg - OutputDemand.TrackDeg');    %NEW
            SimObj.fadd('Piccolo','Settings','OutputDemand.TrackDeg',Track);       %NEW



            SimObj.fadd('Piccolo','Settings','Param.RnwFreqHz',0);                   %NEW
            SimObj.fadd('Piccolo','Settings','Param.Flight_RnwLatDeg',Latitude);     %NEW
            SimObj.fadd('Piccolo','Settings','Param.Flight_RnwLongDeg',Longitude);   %NEW


        % Defaults
            SimObj.fadd('Piccolo','fsetup','Defaults');

            SimObj.fadd('Piccolo','fsetup', 'ActDelay');                   %NEW

        % CLAWs limitations
            %None. We're that good ;)

            SimObj.fclear('OpenLoopOnGround');
            SimObj.fadd('OpenLoopOnGround','X','DState.LMGStrutDotInchps');
            SimObj.fadd('OpenLoopOnGround','X','DState.NGStrutDotInchps');
            SimObj.fadd('OpenLoopOnGround','X','DState.RMGStrutDotInchps');
            if isequal(SimObj.Param.ac_type,507.07)
                SimObj.fadd('OpenLoopOnGround','X','DState.LMGStrutInch',0.12);
                SimObj.fadd('OpenLoopOnGround','X','DState.NGStrutInch',0.15);
                SimObj.fadd('OpenLoopOnGround','X','DState.RMGStrutInch',0.12);
            elseif isequal(SimObj.Param.ac_type,507.16)
                SimObj.fadd('OpenLoopOnGround','X','DState.LMGStrutInch',1.12);
                SimObj.fadd('OpenLoopOnGround','X','DState.NGStrutInch', 0.15);
                SimObj.fadd('OpenLoopOnGround','X','DState.RMGStrutInch',1.12);
            end
            
            SimObj.fadd('OpenLoopOnGround','F','Deriv.LMGStrutDotInchps');
            SimObj.fadd('OpenLoopOnGround','F','Deriv.LMGStrutInch');
            SimObj.fadd('OpenLoopOnGround','F','Deriv.NGStrutDotInchps');
            SimObj.fadd('OpenLoopOnGround','F','Deriv.NGStrutInch');
            SimObj.fadd('OpenLoopOnGround','F','Deriv.RMGStrutDotInchps');
            SimObj.fadd('OpenLoopOnGround','F','Deriv.RMGStrutInch');

            SimObj.fadd('OpenLoopOnGround','X','DState.PresAltFt',0.5);
            SimObj.fadd('OpenLoopOnGround','F','Signal.PresAltFt - Param.Flight_alt');

            SimObj.fadd('OpenLoopOnGround','X','DState.ZposnFt');
            SimObj.fadd('OpenLoopOnGround','F','Signal.ZextLbs');

            SimObj.fadd('OpenLoopOnGround','X','DState.ThetaRad');
            SimObj.fadd('OpenLoopOnGround','X','DState.UFtps');
            SimObj.fadd('OpenLoopOnGround','X','DState.WFtps');

            SimObj.fadd('OpenLoopOnGround','F','Deriv.QRdps');
            SimObj.fadd('OpenLoopOnGround','F','Signal.UFtps');
            SimObj.fadd('OpenLoopOnGround','F','Signal.WFtps');

            SimObj.fadd('OpenLoopOnGround','Settings','Input.LMGearPosnNorm',1);
            SimObj.fadd('OpenLoopOnGround','Settings','Input.RMGearPosnNorm',1);
            SimObj.fadd('OpenLoopOnGround','Settings','Input.NGearPosnNorm',1);
            
            if isequal(SimObj.Param.ac_type,507.07)
                SimObj.fadd('OpenLoopOnGround','Settings','Input.GearPosnNorm',1);
            end
            
            SimObj.fadd('OpenLoopOnGround','Settings','Param.Flight_lgdown',1);
            SimObj.fadd('OpenLoopOnGround','Settings','Input.GearLvrDown',1);
            SimObj.fadd('OpenLoopOnGround','Settings','Param.Flight_Force_Trim_on_Ground',1);
            
            if isequal(SimObj.Param.ac_type,507.16)
                SimObj.fadd('OpenLoopOnGround','Settings','DState.N1_duplicate_1',@(obj)(obj.Signal.N1LhIdleRpm));
                SimObj.fadd('OpenLoopOnGround','Settings','DState.N1_duplicate_2',@(obj)(obj.Signal.N1RhIdleRpm));
            end
            
            % Once these are loaded you must start model with initial
            % speed until unloaded and re-trimmed?????
            if Speed >= 2
                SimObj.fadd('OpenLoopOnGround','F','Signal.CASKts - SignalDemand.CASKts');
                SimObj.fexc('OpenLoopOnGround','F','Signal.UFtps'); 
            elseif Speed < 2
                % Don't have a slick way of undoing this yet. Unload DLL
                % and restart :(
            end
            
            SimObj.fadd('OpenLoopOnGround','IC','DState.ZposnFt',-0.6);
            SimObj.StepLim_DState.LMGStrutInch      = 0.1;
            SimObj.StepLim_DState.RMGStrutInch      = 0.1;
            SimObj.StepLim_DState.NGStrutInch       = 0.1;
            
            if isequal(SimObj.Param.ac_type,507.07)
                SimObj.Limits_DState.LMGStrutInch       = [0.001, 0.15];
                SimObj.Limits_DState.RMGStrutInch       = [0.001, 0.15];
                SimObj.Limits_DState.NGStrutInch        = [0.001, 1.3];
            elseif isequal(SimObj.Param.ac_type,507.16)
                SimObj.Limits_DState.LMGStrutInch       = [0.001, 2.5];
                SimObj.Limits_DState.RMGStrutInch       = [0.001, 2.5];
                SimObj.Limits_DState.NGStrutInch        = [0.001, 2.0];
            end
            SimObj.StepLim_DState.RMGStrutDotInchps = 0.1;
            SimObj.StepLim_DState.LMGStrutDotInchps = 0.1;
            SimObj.StepLim_DState.NGStrutDotInchps  = 0.1;

            SimObj.StepLim_DState.PresAltFt         = 30;
            SimObj.StepLim_DState.ZposnFt       	= 1;
            SimObj.StepLim_DState.ThetaRad          = 0.5*pi/180;
            SimObj.StepLim_DState.nt_DelayNxSensor  = 0.1;
            SimObj.StepLim_DState.nt_DelayNySensor  = 0.1;
            SimObj.StepLim_DState.nt_DelayNzSensor  = 0.1;
            SimObj.StepLim_DState.UFtps             = 5;

    %       Defaults
            SimObj.fadd('OpenLoopOnGround','fsetup','Defaults');

            SimObj.fadd('OpenLoopOnGround','fsetup', 'ActDelay');                   %NEW

        % BA Configuration files (not included)
            AcSetup.ConfigurationXLS     = 'Do not update';
            AcSetup.FlightConditionsFile = [];
            AcSetup.LoadingXLS           = 'Do not update';
            AcSetup.LoadConditionsFile   = [];
            AcSetup.ac_type = SimObj.Param.ac_type;

    end


%% Config definitions

    SimObj.fdeactivate;SimObj.fadd(TrimSetup,'fsetup',['Flap',num2str(Flap),'Definition']);
    SimObj.fadd(TrimSetup,'Settings','Param.AirVonkarmanTurbLevel',Turbulence);% 1 - light/ 2 = medium.
    SimObj.fadd(TrimSetup,'Settings','Input.RefWindDirDeg',WindDir_Deg);
    SimObj.fadd(TrimSetup,'Settings','Input.RefWindSpdKts',WindSpd_Kts);
    SimObj.fadd(TrimSetup,'Settings','OutputDemand.TrackDeg',Track);
    SimObj.fadd(TrimSetup,'Settings','DState.ZposnFt',-TerrainHeight);
    SimObj.fadd(TrimSetup,'Settings','Param.claws_pilotInitCgPosn_Ft',XCG);
    SimObj.fadd('OpenLoopOnGround','Settings','DState.PsiRad',Track*pi/180);
    SimObj.fadd('OpenLoopOnGround','Settings','Param.RnwFreqHz',0);
    SimObj.fadd('OpenLoopOnGround','Settings','Param.Flight_RnwLatDeg',Latitude);
    SimObj.fadd('OpenLoopOnGround','Settings','Param.Flight_RnwLongDeg',Longitude);
    SimObj.fadd(TrimSetup,'Settings','Param.claws_pilotCgCmd_Pct',CGShifterInitPosn_ft);

    SimObj.factivate(TrimSetup);


    FlightCondLoadDefn(SimObj, AcSetup,'AltitudeFt',Alt,'SpeedKts',Speed,...
                'Weight',Weight,'XCG',XCG,'YCG',YCG,'ZCG',ZCG,...
                'IXX',IXX,'IYY',IYY,'IZZ',IZZ,'IXZ',IXZ);
    TrimRes = SimObj.Trim('Silent',1,'IncrTrim',0,'MaxIterations',TrimMaxIterations);

    TopLevelInput = fieldnames(SimObj.Param);
    for iField=TopLevelInput(arrayfun(@(x)~isempty(x{1}),strfind(TopLevelInput,'REFSI_FD_IN_')))'
        if isempty(strfind(iField{1},'_enable')) && isempty(strfind(iField{1},'_sig'))
            %evalin('base',['Trim_',iField{1},' = SimObj.Signal.',strrep(iField{1},'REFSI_FD_IN_',''),';'])
            evalin('caller',['Trim_',iField{1},' = SimObj.Param.',strrep(iField{1},'REFSI_FD_IN_','REFSI_AC_OUT_'),';'])
        end
    end
    iField{1} = 'piccoloInCmd';
    evalin('caller',['Trim_',iField{1},' = SimObj.Param.',iField{1},';'])

    SimObj.Param.CLAWs_Enabled = CLAWs_On;
%% Steve's Hack!
% These will be updated each time you start a sim. No need to clear your
% workspace. Be careful when you change these.
% Writting to these variable will change the parameter for the next sim
% only. If you comment these out, they will return to their default value
% on the next trim.
% Reading the values does not affect the simulation at all.

% % Turbulence
%     SimObj.Param.AirVonkarmanTurbLevel = Turbulence;
%
% % Actuator Delays
%     SimObj.Param.ActuatorCBS20FeedbackDelay = 0.008;
%     SimObj.Param.NoseGearActuatorCBS20FeedbackDelay = 0.008;
%     SimObj.Param.ActuatorCBS15FeedbackDelay = 0.008;
%     SimObj.Param.ActuatorHBL6625FeedbackDelay = 0.008;
%     SimObj.Param.ActuatorHitecSG33BLFeedbackDelay = 0.008;
%
% % Use Aero Loads
% 	SimObj.Param.RudWingUseAeroLoad = 1;
% 	SimObj.Param.AilUprUseAeroLoad = 1;
% 	SimObj.Param.AilLwrUseAeroLoad = 1;
% 	SimObj.Param.ElvObUseAeroLoad = 1;
% 	SimObj.Param.ElvIbUseAeroLoad = 1;
% 	SimObj.Param.PylonUseAeroLoad = 1;
% 	SimObj.Param.UTailElvUseAeroLoad = 1;
% 	SimObj.Param.UTailRudUseAeroLoad = 1;
% 	SimObj.Param.AftFlapUseAeroLoad = 1;
%
% % TLA Delay
%     SimObj.Param.TLAPCUDynActuatorResponseDelay
%
% % Sensor Delays
%     SimObj.Param.ismPhiDegDelay
%     SimObj.Param.ismThetaDegDelay
%     SimObj.Param.ismPsiDegDelay
%     SimObj.Param.ismPDpsDelay
%     SimObj.Param.ismQDpsDelay
%     SimObj.Param.ismRDpsDelay
%     SimObj.Param.NxDelay
%     SimObj.Param.NyDelay
%     SimObj.Param.NzDelay
%     SimObj.Param.CASDelay
%     SimObj.Param.TASDelay
%     SimObj.Param.PresAltDelay
%     SimObj.Param.DynPresDelay
%     SimObj.Param.ismAlphaDelay
%     SimObj.Param.ismBetaDelay
%     SimObj.Param.ismSpdDelay
%     SimObj.Param.ismGPSDelay
%
% % Deadbands/Backlash
%     SimObj.Param.RudWingPCUDynDeadBand
%     SimObj.Param.AilPCUDynDeadBand
%     SimObj.Param.ElvObPCUDynDeadBand
%     SimObj.Param.ElvIbPCUDynDeadBand
%     SimObj.Param.PylonRudPCUDynDeadBand
%     SimObj.Param.UTailStabPCUDynDeadBand
%     SimObj.Param.UTailElvPCUDynDeadBand
%     SimObj.Param.UTailRudPCUDynDeadBand
%     SimObj.Param.AftFlapPCUDynDeadBand
%     SimObj.Param.NoseGearPCUDynDeadBand
%     SimObj.Param.BrakePCUDynDeadBand

%% Define Buses
%
% file to create DLLSimStep function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Static Update List of Inputs to DLL - Do Not Update!
    global Inz;
    Inz.Param.REFSI_FD_IN_nmodeRudLhWingCmd_Deg     = 0;
    Inz.Param.REFSI_FD_IN_nmodeAilLhLowerCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeAilLhUpperCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeElvLhOutbdCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeElvLhInbdCmd_Deg     = 0;
    Inz.Param.REFSI_FD_IN_nmodeRudLhPylonCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeRudLhUTailCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeElvLhUTailCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeAftFlapCmd_Deg       = 0;
    Inz.Param.REFSI_FD_IN_nmodeElvRhUTailCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeRudRhUTailCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeRudRhPylonCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeElvRhInbdCmd_Deg     = 0;
    Inz.Param.REFSI_FD_IN_nmodeElvRhOutbdCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeAilRhUpperCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeAilRhLowerCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeRudRhWingCmd_Deg     = 0;
    Inz.Param.REFSI_FD_IN_nmodeStabCmd              = 0;
    Inz.Param.REFSI_FD_IN_nmodeFlapLhOBCmd_Deg      = 0;
    Inz.Param.REFSI_FD_IN_nmodeFlapLhIBCmd_Deg      = 0;
    Inz.Param.REFSI_FD_IN_nmodeSlatLhCmd_Deg        = 0;
    Inz.Param.REFSI_FD_IN_nmodeSlatRhCmd_Deg        = 0;
    Inz.Param.REFSI_FD_IN_nmodeFlapRhOBCmd_Deg      = 0;
    Inz.Param.REFSI_FD_IN_nmodeFlapRhIBCmd_Deg      = 0;
    Inz.Param.REFSI_FD_IN_nmodeTlaLhCmd_Deg         = 0;
    Inz.Param.REFSI_FD_IN_nmodeTlaRhCmd_Deg         = 0;
    Inz.Input.EngineLhFuelCut                       = 0;
    Inz.Input.EngineRhFuelCut                       = 0;
    Inz.Input.NWCastoring              				= 0; % Signal added in 16P5 Release 25
    Inz.Param.REFSI_FD_IN_nmodeNoseGearCmd_Deg      = 0;
    Inz.Param.REFSI_FD_IN_nmodeSplrLhOutbdCmd_Deg   = 0;
    Inz.Param.REFSI_FD_IN_nmodeSplrLhInbdCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeSplrRhInbdCmd_Deg    = 0;
    Inz.Param.REFSI_FD_IN_nmodeSplrRhOutbdCmd_Deg   = 0;
    Inz.Param.REFSI_FD_IN_nmodeCgShifterCmd_Ft      = 0;
    Inz.Param.piccoloInCmd                          = 0;
    Inz.Param.claws_pilotNzCmd_g                    = 0;
    Inz.Param.claws_isControlSurfaceCmdFromSystem   = 0;
    Inz.Param.claws_nmodeReset                      = 0;
    Inz.Input.RefWindDirDeg                         = 0;
    Inz.Input.RefWindSpdKts                         = 0;
    Inz.Input.PedalBrakeLh 							= 0;
    Inz.Input.PedalBrakeRh                          = 0;
    Inz.Param.REFSI_FD_IN_nmodeBrakeCmd             = 0; % Signal no longer used as of Release 24

% Define SaveList - Can be changed Dynamically
    DLLSim.SaveList={
        'Signal.PresAltFt'
        'Signal.AlphaDeg'
        'Signal.BetaDeg'
        'Signal.GammaDeg'
        'Signal.CASKts'
        'Signal.PDps'
        'Signal.QDps'
        'Signal.RDps'
        'Signal.PhiDeg'
        'Signal.ThetaDeg'
        'Signal.PsiDeg'
        'Signal.TASKts'
        'Signal.HeightAGLFt'
        'Signal.XthrustLbs'
        'Signal.GrndContactLMG'
        'Signal.GrndContactNG'
        'Signal.GrndContactRMG'
        'Signal.DynPresPsf'
        'Signal.PAmbPsf'
        'Signal.XposnFt'
        'Signal.YposnFt'
        'Signal.ZposnFt'
        'Signal.NxG'
        'Signal.NyG'
        'Signal.NzG'
        'Signal.VEarthFtps_0'
        'Signal.VEarthFtps_1'
        'Signal.VEarthFtps_2'
        'Signal.LatitudeDeg'
        'Signal.LongitudeDeg'
        'Signal.ZgrndLhLbs'
        'Signal.ZgrndRhLbs'
        'Signal.ZgrndNgLbs'
        'Signal.Time'
        'Signal.WindUFtps'
        'Signal.WindVFtps'
        'Signal.WindWFtps'
        'Signal.AilLwrLhBDriveDeg'
        'Signal.AilUprLhBDriveDeg'
        'Signal.AilLwrRhBDriveDeg'
        'Signal.AilUprRhBDriveDeg'
        'Signal.ElvLhOBBDriveDeg'
        'Signal.ElvLhIBBDriveDeg'
        'Signal.ElvRhOBBDriveDeg'
        'Signal.ElvRhIBBDriveDeg'
        'Signal.RudPylLhBDriveDeg'
        'Signal.RudUTailLhBDriveDeg'
        'Signal.RudWingletLhBDriveDeg'
        'Signal.ElvUTailLhBDriveDeg'
        'Signal.ElvUTailRhBDriveDeg'
        'Signal.RudPylRhBDriveDeg'
        'Signal.RudUTailRhBDriveDeg'
        'Signal.RudWingletRhBDriveDeg'
        'Signal.AftFlapBDriveDeg'
        'Signal.NWBDriveDeg'
        'Signal.XcgPctMAC'
        'Signal.IxxLbsInch2'
        'Signal.IyyLbsInch2'
        'Signal.IzzLbsInch2'
        'Signal.IxzLbsInch2'
        'Param.REFSI_FD_OUT_PIC_dynPres_Pa'
        'Param.REFSI_FD_OUT_PIC_TAmb_C'
        'Param.REFSI_FD_OUT_PIC_PAmb_Pa'
        'Param.REFSI_FD_OUT_PIC_rollRate_Dps'
        'Param.REFSI_FD_OUT_PIC_pitchRate_Dps'
        'Param.REFSI_FD_OUT_PIC_yawRate_Dps'
        'Param.REFSI_FD_OUT_PIC_accelXDir_Mps2'
        'Param.REFSI_FD_OUT_PIC_accelYDir_Mps2'
        'Param.REFSI_FD_OUT_PIC_accelZDir_Mps2'
        'Param.REFSI_FD_OUT_PIC_GPSUbloxLatitudeDeg'
        'Param.REFSI_FD_OUT_PIC_GPSUbloxLongitudeDeg'
        'Param.REFSI_FD_OUT_PIC_GPSUbloxHeight_m'
        'Param.REFSI_FD_OUT_PIC_vEarthXUblox_Mps'
        'Param.REFSI_FD_OUT_PIC_vEarthYUblox_Mps'
        'Param.REFSI_FD_OUT_PIC_vEarthZUblox_Mps'
        'Param.REFSI_FD_OUT_PIC_GPSNovAftLatitudeDeg'
        'Param.REFSI_FD_OUT_PIC_GPSNovAftLongitudeDeg'
        'Param.REFSI_FD_OUT_PIC_GPSNovAftHeight_m'
        'Param.REFSI_FD_OUT_PIC_vEarthXNovAft_Mps'
        'Param.REFSI_FD_OUT_PIC_vEarthYNovAft_Mps'
        'Param.REFSI_FD_OUT_PIC_vEarthZNovAft_Mps'
        'Signal.ismCas_Kt'
        'Signal.ismTas_Kt'
        'Signal.ismPresAlt_Ft'
        'Signal.ismDynPres_Psf'
        'Signal.ismAoa_Deg'
        'Signal.ismAos_Deg'
        'Signal.speedIncrementImuXRaw_Mps'
        'Signal.speedIncrementImuYRaw_Mps'
        'Signal.speedIncrementImuZRaw_Mps'
        'Signal.rollIncrementRaw_Deg'
        'Signal.pitchIncrementRaw_Deg'
        'Signal.yawIncrementRaw_Deg'
        'Signal.latitudeRaw_Rad'
        'Signal.longitudeRaw_Rad'
        'Signal.heightRaw_M'
        'Signal.speedGpsIneNavXRaw_Mps'
        'Signal.speedGpsIneNavYRaw_Mps'
        'Signal.speedGpsIneNavZRaw_Mps'
        'Signal.isGpsMeasurementValid'
        'Signal.gpsDelay_s'
        'Signal.latitudeStandardDeviation_M'
        'Signal.longitudeStandardDeviation_M'
        'Signal.heightStandardDeviation_M'
        'Signal.speedXStandardDeviation_Mps'
        'Signal.speedYStandardDeviation_Mps'
        'Signal.speedZStandardDeviation_Mps'
        'Signal.gpsMode'
        'Signal.latitudePiccolo_Rad'
        'Signal.longitudePiccolo_Rad'
        'Signal.heightPiccolo_M'
        'Signal.speedGpsIneNavXPiccolo_Mps'
        'Signal.speedGpsIneNavYPiccolo_Mps'
        'Signal.speedGpsIneNavZPiccolo_Mps'
        'Signal.rollAttitudePiccolo_Deg'
        'Signal.pitchAttitudePiccolo_Deg'
        'Signal.yawAttitudePiccolo_Deg'
        'Signal.rollRatePiccolo_Dps'
        'Signal.pitchRatePiccolo_Dps'
        'Signal.yawRatePiccolo_Dps'
        'Signal.nxPiccolo'
        'Signal.nyPiccolo'
        'Signal.nzPiccolo'
        'Signal.piccoloDelay_s'
        'Signal.ismTLALh_Deg'
        'Signal.ismTLARh_Deg'
        'Param.REFSI_AC_OUT_nmodeRudLhWingCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeAilLhLowerCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeAilLhUpperCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeElvLhOutbdCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeElvLhInbdCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeRudLhPylonCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeRudLhUTailCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeElvLhUTailCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeAftFlapCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeElvRhUTailCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeRudRhUTailCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeRudRhPylonCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeElvRhInbdCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeElvRhOutbdCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeAilRhUpperCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeAilRhLowerCmd_Deg'
        'Param.REFSI_AC_OUT_nmodeRudRhWingCmd_Deg'
        };
    
    
    
    
    if isequal(SimObj.Param.ac_type,507.07)
        DLLSim.SaveList = [DLLSim.SaveList;
            'Signal.VoltageLhEngine'
            'Signal.VoltageRhEngine'
            'Signal.VoltagePWMLhEngine'
            'Signal.VoltagePWMRhEngine'
            'Signal.CurrentLhEngine'
            'Signal.CurrentRhEngine'
            'Signal.ismN1Lh_Pct'
            'Signal.ismN1Rh_Pct'
            ];
    else
        DLLSim.SaveList = [DLLSim.SaveList;
            'Signal.AilLwrLhLoadPct'
            'Signal.AilUprLhLoadPct'
            'Signal.AilLwrRhLoadPct'
            'Signal.AilUprRhLoadPct'
            'Signal.ElvLhOBLoadPct'
            'Signal.ElvLhIBLoadPct'
            'Signal.ElvRhOBLoadPct'
            'Signal.ElvRhIBLoadPct'
            'Signal.RudPylLhLoadPct'
            'Signal.RudUTailLhLoadPct'
            'Signal.RudWingletLhLoadPct'
            'Signal.ElvUTailLhLoadPct'
            'Signal.ElvUTailRhLoadPct'
            'Signal.RudPylRhLoadPct'
            'Signal.RudUTailRhLoadPct'
            'Signal.RudWingletRhLoadPct'
            'Signal.AftFlapLoadPct'
            'Signal.HMRudWgltLhInLb'
            'Signal.HMAilLwrLhInLb'
            'Signal.HMAilUprLhInLb'
            'Signal.HMElevonOBLhInLb'
            'Signal.HMElevonIBLhInLb'
            'Signal.HMRudPylLhInLb'
            'Signal.HMElvLhInLb'
            'Signal.HMRudUtailLhInLb'
            'Signal.HMAftFlapInLb'
            'Signal.HMRudUtailRhInLb'
            'Signal.HMElvRhInLb'
            'Signal.HMRudPylRhInLb'
            'Signal.HMElevonIBRhInLb'
            'Signal.HMElevonOBRhInLb'
            'Signal.HMAilUprRhInLb'
            'Signal.HMAilLwrRhInLb'
            'Signal.HMRudWgltRhInLb'
            'Signal.CgShifterPosn_Ft'
            'Signal.N1PctLhCmd'
            'Signal.N1PctRhCmd'
            'Signal.FlapLhOBBDriveDeg'
            'Signal.FlapLhIBBDriveDeg'
            'Signal.SlatLhBDriveDeg'
            'Signal.SlatRhBDriveDeg'
            'Signal.FlapRhOBBDriveDeg'
            'Signal.FlapRhIBBDriveDeg'
            'Signal.BrakeLh'
            'Signal.BrakeRh'
            'Signal.MFS1LhBDriveDeg'
            'Signal.GrndSplrLhBDriveDeg'
            'Signal.GrndSplrRhBDriveDeg'
            'Signal.MFS1RhBDriveDeg'
            'Param.REFSI_FD_OUT_PIC_GPSNovFwdLatitudeDeg'
            'Param.REFSI_FD_OUT_PIC_GPSNovFwdLongitudeDeg'
            'Param.REFSI_FD_OUT_PIC_GPSNovFwdHeight_m'
            'Param.REFSI_FD_OUT_PIC_vEarthXNovFwd_Mps'
            'Param.REFSI_FD_OUT_PIC_vEarthYNovFwd_Mps'
            'Param.REFSI_FD_OUT_PIC_vEarthZNovFwd_Mps'
            'Signal.ismRollAccel_Dps2'
            'Signal.ismPitchAccel_Dps2'
            'Signal.ismYawAccel_Dps2'
            'Signal.ismFuelBurnRateLh_Lpm'
            'Signal.ismFuelBurnRateRh_Lpm'
            'Signal.ismFuelBurntLh_Lbs'
            'Signal.ismFuelBurntRh_Lbs'
            'Signal.ismN1Lh_Pct'
            'Signal.ismN1Rh_Pct'
            'Signal.ismRudWingletLhPosn_Deg'
            'Signal.ismAilLwrLhPosn_Deg'
            'Signal.ismAilUprLhPosn_Deg'
            'Signal.ismElvLhOBPosn_Deg'
            'Signal.ismElvLhIBPosn_Deg'
            'Signal.ismRudPylLhPosn_Deg'
            'Signal.ismRudUTailLhPosn_Deg'
            'Signal.ismElvUTailLhPosn_Deg'
            'Signal.ismElvUTailRhPosn_Deg'
            'Signal.ismRudUTailRhPosn_Deg'
            'Signal.ismRudPylRhPosn_Deg'
            'Signal.ismElvRhIBPosn_Deg'
            'Signal.ismElvRhOBPosn_Deg'
            'Signal.ismAilUprRhPosn_Deg'
            'Signal.ismAilLwrRhPosn_Deg'
            'Signal.ismRudWingletRhPosn_Deg'
            'Signal.ismFlapLhIBPosn_Deg'
            'Signal.ismFlapRhIBPosn_Deg'
            'Signal.ismFlapLhOBPosn_Deg'
            'Signal.ismFlapRhOBPosn_Deg'
            'Signal.ismSlatLhPosn_Deg'
            'Signal.ismSlatRhPosn_Deg'
            'Signal.ismAftFlapPosn_Deg'
            'Signal.ismNoseGearPosn_Deg'
            'Signal.ismStabPosn_Deg'
            'Signal.ismSplrLhOutbdPosn_Deg'
            'Signal.ismSplrLhInbdPosn_Deg'
            'Signal.ismSplrRhInbdPosn_Deg'
            'Signal.ismSplrRhOutbdPosn_Deg'
            'Signal.ismCgShifterPosn_Ft'
            'Signal.ismHeightAboveGround_Ft'
        ];
    end

    SimObj.slclear('TrimList');
    SimObj.sladd('TrimList','Content',DLLSim.SaveList);

    DLLSim.nOuputs = length(DLLSim.SaveList);

    %% Consistency check for Parameters known to require DLL Re-Load (we need a better solution for this)
    if SimObj.Param.IAR166_UTail_ON ~= WithTail
        error('DLL WithTail configuration inconsistent with user workspace. Recommend re-loading Project or changing WithTail in ConfigureMe m-file');
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

disp('Time Taken For Trimming/Setup')
toc
