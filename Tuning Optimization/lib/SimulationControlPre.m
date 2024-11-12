%% SimulationControlTrim.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% February 03, 2022
% Description: We cannot match integration values with REF immediately, so
% we will reinitialise our Sim integrators from 0, and take the initial
% command states and add them as trims 

Qmin=0.5*1.225*(IASmin)^2;
QminFlare  = 0.5*1.225*(IASstall)^2*1.1;
QminBounce = 0.5*1.225*(IASstall)^2*0.8;
IASbounce = IASstall*0.8;

% Flag/Speed to execute a rejected takeoff. Set to 0 to disable.
% If non-zero, will be applied to each test case in the plan.
% Note - this is here for compatibilty but does not have an effect on landing sims.
RTO_Speed = 0;

PiccoloStartingStateMachine = 5; % 1 Transition, 2 Liftoff, 3 Climbout,4 Flying, 5 Landing, 8 Final, 9 Short Final, 10 Touchdown, 11 Rollout
TrackDistance2Short = (Alt*0.3048) - ShortFinalHeight; % For landing Track Definition

RateLimitAltAccelInit   = 0;
RateLimitPitchRateAccel = 0;
RateLimitRollRateAccel  = 0;
%% Automated Integrator Init
AltitudeRate2PitchCmdIntegratorInit = 0.1;
Pitch2ElevatorIntegratorInit = -4;
Bank2AileronIntegratorInit = 0;
Yaw2RudderSideForceIntegratorInit = 0;
ThrottleControlAltitudeModeIntegratorInit =0;

%% Automated Filter Init
LPFvRate2PitchInit = 0.1;
LPFenergyFFInit    = 0; % Trim with 0.6 Test 13, 0.2 test 22
LPFthrottleInit    = ThrottleTrim;
LPFelevatorInit    = -5;
LPFaileronInit     = 0;
LPFrudderInit      = 0;
LPFtasInit         = 0;
LPFclestInit       = 0;
LPFturnErrInit     = 0;
%% Intermediate Integrator 
% AltitudeRate2PitchCmdIntegratorInit = (REF.pitchCmd.Data(1)*pi/180) - ((REF.VRateCmd.Data(1)*AltRateCmd2Pitch/REF.TAS.Data(1)) + ((REF.VRateCmd.Data(1) - REF.VRate.Data(1))/REF.TAS.Data(1))*AltRateError2Pitch);
% 
% ThrottleControlAltitudeModeIntegratorInit = 0;
% Yaw2RudderSideForceIntegratorInit = 0;
% Pitch2ElevatorIntegratorInit = 0;
% Bank2AileronIntegratorInit = 0;

%% Disable Integrators
% AltRateErrorInt2Pitch  = 0;
% PowerErrorInt2Throttle = 0;
% PitchRateErrorInt2Accel= 0;
% RollRateErrorInt2Accel = 0;
% SideForceErrInt2Rudder = 0;

%% Disable Filters
% RollRateLpfCutoff = 0;
% PitchRateLpfCutoff = 0;
% YawRateLpfCutoff = 0;
% AltRateLpfCutOff = 0;
% EnergyBandwidth = 0;
% ThrottleLpfCutoff = 0;

%% Manual Integrator Init Estimates (Requires Integrator to be disabled when run)
% Pitch2ElevatorIntegratorInit = REF.elevator.data(2); 
% Bank2AileronIntegratorInit = REF.aileron.data(2);

%% Manual Trim Override


%% Manual Filter Init Override
% LPFvRate2PitchInit = REF.pitchCmd.Data(1);
% LPFenergyFFInit = REF.VRate.Data(1); % Trim with 0.6 Test 13, 0.2 test 22
% LPFthrottleInit = REF.throttle.Data(1);
% LPFelevatorInit = REF.elevator.Data(1);
% LPFaileronInit  = REF.aileron.Data(1);
% LPFrudderInit   = REF.rudder.Data(1);
% LPFtasInit      = REF.TAS.Data(1);
% LPFvRateInit = 0;

LPFtasInit         = V_init + 2;

%Calculate Xpos Track from top of glide slope to ground
Segment1 = PreApproachSegment; %m flying level in trim flight
Segment2 = ((Alt*0.3048)-ShortFinalHeight)/tan(FinalDescentSlope_Deg*pi/180);
Segment3 = (ShortFinalHeight - (TerrainHeight*0.3048))/tan(ShortDescentSlope_Deg*pi/180);
xPosApproachSegment= Segment1 + Segment2 + Segment3;