%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% February 03, 2022
% Description:
disp('SimulationControlConfig');
%% Initialize Simulation Workspace
if ~exist('NoiseStd','var')
    SimulationSensorConfig;
end

PiccoloGainVersion  = "G70 As Flown (New TMI), +5% JetCat Offset";
ControlAllocation   = "M2";
modelScale          = '16P5';

%% Define Control Parameters for Simulation
CLAWs_On = 0; % We elect to disable internal BA CLaws for now...    
% dt = 0.02; %Control model loop update rate is controlled by this step. use 20ms for Piccolo 

%% Piccolo Controller Gains
% any low pass filters should have a cut-off frequency lower than
% 1/2*50Hz=25Hz, which is called the Nyquist frequency; otherwise
% distabilizing the system.

%% Vehicle
Sw          = 4.663;% m^2
b           = 5.54; % m;wing span
c           = Sw/b; % m;average wing chord
CL_Max      = 0.54;
CL_Max_Nom  = 0.465;
CL_cruise   = 0.310;

% documentation says above and says during TouchDown, use CL_Limit=CL_Max;
CL_Limit    = CL_Max;   % During Short Final/Touchdown this is relaxed to CL_Max limit
CL_Min      = 0;
LiftSlope   = 0.064285; % /deg
nMax_User   = 2.6;      % in g; from the point of view of structure
nMin_User   = -1.3;     % in g; from the point of view of structure

% Vehicle Mass
% m=166; %kg
m = MassBWB; % Use true model mass (representative of mass estimation in controller)

% Lateral Axis
XInertia = 101.734;  % kgm^2 % Updated TBF4-TOW1

% XInertia=IXX/3417.17; % Direct from model configuration

% Pitch Axis
YInertia = 134.120;  % kgm^2 % Updated TBF4-TOW1

% YInertia=IYY/3417.17;   % Direct from model configuration

% Directional Axis
ZInertia = 220.986;  % kgm^2 % Updated TBF4-TOW1

% ZInertia=IZZ/3417.17;  % Direct from model configuration

VerticalTailArm     = 1.11; %m
SteeringArm         = 1.25;

%% Airspeed Control (airspeed mode)
%Bandwidth
TASBandwidth    = 0.03; %Hz
Fp_TAS          = 0.55*2*pi*TASBandwidth;

% Flag to enable priority switch for TAS protection modes.
% Disabled until better matched.
Enable_TAS_Protection = 0;

TASRateErr2VRate    = 1.90;
TASRateErrInt2VRate = 1.70;
TASRateMax      = 0.7; % m/s^2; also used in throttle control to saturate desired energy rate

% Throttle Control
ThrottleTrim    = 0.14; %0.2
MaxEnginePower  = 50000; %W 50000

% EXTERNAL LOGIC
% To apply slower slew during throttle cut in flare.
useFlareSlew        = 0;        % Flag to enable external throttle logic
useElevatorKill     = 1;        % Flag to kill engine based on Elevator. Alternative is rollout state machine
RolloutElevTrigger  = 2;        % Deg, Position Elevator triggers Rollout Throttle, 
ThrottleRateFlare   = 0.045;    % /s, Slew rate to be applied 0.025, 0.05
ThrottleRateRollout = 0.10;     % /s, Slew rate to be applied 0.025
ThrottleRateRever   = 0.045;    % /s, Slew rate to be applied 0.025, 0.05
ThrottleMaxFlare    = 0.50;     % Upper saturation limit
ThrottleMinFlare    = 0.10;     % Lower saturation limit    
ThrottleMinRollout  = 0.00;     % For use

% Gains
% G71
% PowerError2Throttle=0.5; %0.9
% PowerErrorInt2Throttle=0.2; %0.2
% ThrottlePredictionTrust=0.9; %0.9

% Increased I-term
PowerError2Throttle     = 0.5; %0.9
PowerErrorInt2Throttle  = 0.2; %0.2
ThrottlePredictionTrust = 0.9; %0.9

% Low pass filters
ThrottleLpfCutoff = 0.35; % Hz

% Fp_Throttle=0.55*2*pi*ThrottleLpfCutoff*dt;
Fp_Throttle     = 0.55*2*pi*ThrottleLpfCutoff*dt; % It appears this param is input as Rad/s NOT Hz

EnergyBandwidth = 0.02; %Hz;0.02
Fp_Energy       = 0.55*2*pi*EnergyBandwidth;
Fp_Energy2      = 0.55*2*pi*EnergyBandwidth*dt;

%Limits
ThrottleMax     = 0.80;
ThrottleMin     = 0.03; % Std 
ThrottleRateMax = 0.14; %s; not in documentation, but in PCC

JetCatOffset = 5; % Pcnt, offset to jetCat command to simulate higher thrust
%%  Vertical Rate Control (Landing Lon Gains)
% Bandwidth
AltBandwidth    = 0.18; %Hz 
Fp_Alt          = 0.55*AltBandwidth;

% Limits
ClimbMaxFraction   = 0.24;
DescentMaxFraction = 0.20;
AltMax             = 10000;
AltMin             = 0;

% Gains
% G70 Vertical Rate Pitch
% AltRateError2Pitch=0.40; 
% AltRateErrorInt2Pitch=0.45;  
% AltRateCmd2Pitch=0.60;
% AltMaxAccel = 0.9; %m/s/s

% G71 RC 2 Vertical Rate Pitch 
% AltRateError2Pitch=0.18; % 0.17
% AltRateErrorInt2Pitch=0.40; %0.38,  
% AltRateCmd2Pitch=0.25; %0.45
% AltMaxAccel = 2.5; %m/s/s, 

% % Tuning (Flaps)
AltRateError2Pitch      = 0.40; %0.17
AltRateErrorInt2Pitch   = 0.45; %0.50  
AltRateCmd2Pitch        = 0.60; %0.45
AltMaxAccel             = 0.9; %m/s/s, 

% Filters

% Airspeed Filter
TasLpfCutoff    = 1.0; %Hz
Fp_TAS_Filter   = 2*pi*TasLpfCutoff*dt;

% Vrate Filter
AltRateLpfCutOff    = 3; %Hz, lpf on pitch command output from vrate2pitch loop
Fp_AltRate          = 0.55*2*pi*AltRateLpfCutOff*dt;

%Limits
PitchMax    = 25; % deg
PitchMax    = PitchMax/180*pi; %radian
PitchMin    = -PitchMax;

%% Pitch Control
ElevatorTrim =-3.5; % default: -5

% Rebalance for gain margin + trimming
% PitchRateError2Accel=1.6; 
% PitchRateErrorInt2Accel=0.45; 
% PitchDampingTrust=0.2;
% PitchStiffnessTrust=0.4;

% RC 2 Pitch to Pitch Rate Adjustments
PitchRateError2Accel    = 1.60; %1.7, 
PitchRateErrorInt2Accel = 0.45; %1, 
PitchDampingTrust       = 0.2;
PitchStiffnessTrust     = 0.4;

PitchMaxAccel   = 1.20; % rad/s^2; used in rate limiter

%Vehicle Properties
ElevatorPower   = -0.002209; % /deg
PitchDamping    = -1.2608; % Cm/qbar
PitchStiffness  = -0.0041; % /deg

% Limits
PitchRateMax_User   = 30; % deg/s, used in saturation block
PitchRateMax_User   = PitchRateMax_User/180*pi; % rad/s, used in saturation block
ElevatorMax         = 25; %deg

%Low pass filters
PitchBandwidth  = 0.9; %Hz

Fp_Pitch        = 0.55*2*pi*PitchBandwidth; % used for generating pitch rate command
Fp_Pitch_2      = 0.55*2*pi*PitchBandwidth*dt; % used in the low pass filter for lift coefficient

PitchRateLpfCutoff 	= 3; %Hz; lpf on elevator ouput
Fp_Elevator         = 0.55*2*pi*PitchRateLpfCutoff*dt;

%% Lateral Control (Bank to Aileron)
% Track Control
TrackConvergence        = 0.21; %????
HeadingErr2TurnRate     = 0.5; %????
HeadingErrDer2TurnRate  = 0.3; %????
TurnErrLPFcutoff        = 0.01; %????
Fp_Turn                 = 0.55*2*pi*TurnErrLPFcutoff;

TurnDerivativeLPFcutoff = TurnErrLPFcutoff;
Fp_TurnDerr             = 0.55*2*pi*TurnDerivativeLPFcutoff;

%% Bank to Roll Rate Cmd
% Bandwidth
RollBandwidth   = 1.2; %Hz;1.2
Fp_Roll         = RollBandwidth^2; % correction by reviewing the data !!!0.55*2*pi*RollBandwidth is not used !!!

% Limits
RollMaxAccel    = 0.60; %rad/s^2

BankMax_User    = 30; % deg/s
BankMax_User    = BankMax_User/180*pi;
RollRateMax     = 30; % deg/s
RollRateMax     = RollRateMax/180*pi; % rad/s

%% Roll Rate to Aileron
AileronTrim = 0;

RollRateError2Accel    = 7; 
RollRateErrorInt2Accel = 8;
YawRateErr2Rudder      = 6;
RollDampingTrust       = 0;

% Limits
AileronMax          = 25; % Deg (Piccolo command saturation)
AileronSurfaceMax   = 45; % Deg, actual max range of surface map (for use in mixing logic)

%Vehicle Properties
AileronPower    = 0.00268; % /deg
RollDamping     = -0.3475; % Cl/pbar
%Low pass filters
RollRateLpfCutoff   = 3; % Hz 
Fp_Aileron          = 0.55*2*pi*RollRateLpfCutoff*dt;

%% Yaw Rate to Rudder (Bank angle defines desired yaw rate)
SideForceErrInt2Rudder = 0; % it is used in another
% rudder_coordination based on side force/lateral acceleration

% Limits
RudderMax       = 25; %deg
RudderTrim      = 0;

% Vehicle Properties
RudderEffect    = -0.54431; %B/dr; check out the output, do we need unit conversion ?
RudderPower     = 0.000443; % /deg 
% YawDamping=; % in the controller window, but not in the documentation
SideslipEffect  = -0.006037; %it is used in sideslip force method

% Low pass filters
YawRateLpfCutoff    = 0; % Hz; disable the filter when set to 0 in piccolo;
Fp_Rudder           = 0.55*2*pi*YawRateLpfCutoff*dt;

%% Brake Control
DecelerationCmd     = 3.1; % m/s/s, braking target
AccelErrInt2Brakes  = 0.15;

%% Steering (Rollout) Control

% Set to 0 to disable taxi control on touchdown
TaxiEnable = 1;

% Transition Trial 11 as verified
% TrackY2Vy=0.028;
% TrackVyErrInt2Nosegear=0.13;
% TrackVyErrPro2Nosegear=0.5;
% YawRate2Nosegear=0.28;
% Y2VyScalingPower=0.24;
% Vy2NosegearScalingPower=1.00; 

%Mixer
AutoNosegear2Rudder = 26; % NOTE this is the mixing value from transition
% Limits 
NosegearMax         = 15; % deg

%Mixer
% AutoNosegear2Rudder=19; %Shared with Transition Control
% Limits 
ldg_NosegearMax = 10; % deg

% yaw damp reduction
ldg_TrackY2Vy               = 0.07;
ldg_TrackVyErrInt2Nosegear  = 0.1250;
ldg_TrackVyErrPro2Nosegear  = 0.35;
% ldg_YawRate2Nosegear=0.20;
ldg_YawRate2Nosegear        = 0.175;
ldg_Y2VyScalingPower        = 0.175;
ldg_Vy2NosegearScalingPower = 1.075;

%Track offset bias
taxiTrackOffset = testPlans(testIndx).rolloutTrackOffset; %m, to command offset track during landing

%% Flight Nominal
% See page 13 of FWG3 CLaws - 
% IASmin = sqrt(2*m*9.81/(1.225*Sw*CL_Limit);
% Where CL_Limit = 0.9 * CL_Max_Nom, for modes 0 - 8;
% Document indicates CL_Limit = CL_Max, for modes >= 9, 
% Does this mean Vstall becomes Vmin in these modes?

% IASmin   = sqrt(1.1*2*m*9.81/(1.225*Sw*CL_Max_Nom)); % This calc was used
% here but does not match Piccolo implementation!
% Below is the correct formula:
IASmin          = sqrt(2*m*9.81/(1.225*Sw*0.9*CL_Max_Nom));
IASmax          = 46; % Set as static limit (ldg limits)
IASstall        = sqrt(2*m*9.81/(1.225*Sw*CL_Max));
IAScruiseCMD    = sqrt(2*m*9.81/(1.225*Sw*CL_cruise));

%% Launch/Take-Off/Climbout
ClimboutMaxBank = 7.0; %Deg, allowable bank command
ClimboutTimer   = 7.0; %s, time from start of climbout until advancing to Flight state machine

%% Flaps
% Limits
flapMax     = 0;  % Disabled
% flapMax     = 33; % Vanilla Flaps
% flapMax     = 25; % Flaperons
% flapMax     = 35; % Split Aileron (FTD)

flapRate    = 7.5; % FTD delpoyment rate (deg/s)
% flapRate    = 6.6; % FLAP
% flapRate    = 3; % FLAPERON deployment rate (deg/s)

% Aero params
dCl_per_dFlap = 0; % No CL change when using split ailerons. Unknown for Flaperon 
% dCl_per_dFlap = 0.005581818; %[/deg]
% estimate to sim

dCd_per_dFlap = 0; %[/deg] Change in Cd per flap deflection. Appears unused in controller.. 

% Flap commands per mode (deg)
goAroundFlaps   = 0;
downwindFlaps   = 0;
baseLegFlaps    = 0;
finalApproachFlaps  = 0;
shortFinalFlaps     = 0; 
rolloutFlaps        = 0;

% IF using M2 with basic flaps, OR FTD Mixing,
% this offset applied to elevons/flaperons when flaps commanded over 15.5 deg
% elevonBias = 7.5;
elevonBias = 0;

%% Landing / Flare Control
% Flap-up
IASfinalCMD = 1.10 * IASmin;
IASshortCMD = 1.10 * IASmin;
IASflareCMD = 0.0 * IASmin;

% Flapped
% IASfinalCMD = 1.04 * IASmin;
% IASshortCMD = 1.04 * IASmin;
% IASflareCMD = 0.0 * IASmin;

%Speed Fraction Protection Limits
if IASshortCMD < IASstall
    IASshortCMD = IASstall;
end
if IASflareCMD < IASstall && IASflareCMD~=0 %If we command 0 engines go to idle
    IASflareCMD = IASstall;
end

% Currently using constant slope for final + short final
FinalDescentSlope_Deg = testPlans(testIndx).descentSlope; %Deg
ShortDescentSlope_Deg = testPlans(testIndx).descentSlope; % Maintain slope in short final
% ShortDescentSlope_Deg = testPlan(testIndx).descentSlope -0.25; %Deg

% Set Slopes (not to be used for verif)
% FinalDescentSlope_Deg = 3.250;
% ShortDescentSlope_Deg = 3.250;

ShortFinalHeight = (13.5 * IASshortCMD * sin(ShortDescentSlope_Deg*pi/180)) + (TerrainHeight*0.3048); %m, 26.66m @ 3deg glide slope approx 13.5s from touchdown

LdgEngineKillTime = -1; % s, Estimated time to touchdown, negative number inhibits function
LdgEngineKillTimeFromFlare = 1.7; %have not worked out logic for this yet, this is average from FTV2C landings

% FlareHeight= 5;
% RC 5 Flare Height Adjustments
% FlareHeight = 5.2 ; %m 4.2 is minimum at 3.5deg slope, 3.7m at 3.0deg,
FlareHeight = 4.8;

% RC5 Vertical Rate Command Adjustments
% FlareVerticalRate_mps = -0.25;
% FlareVerticalRate_mps = -0.54;
FlareVerticalRate_mps = -0.5;
% FlareVerticalRate_mps = -0.5;

WOWarmed = 1; %-1 indicates disarmed, 0-100 indicates armed

EarlyTouchdownThreshold = 3.0;
TouchdownThreshold      = 3;

% Deflection rate
% RollingElevator = 2.5; %deg
RollingElevator         = 5; % deg
ElevatorDeflectionRate  = 12;% deg/s 

MaxTouchdownBank        = 5; % deg
RolloutWingLeveling     = 1; 

%% Launch
% Elevator in Transition Phase
LaunchRollingElevator   =-1.5; % deg
RotationElevator        = -6.5;% deg
RotationTime            = 5;   % s
RotationSpeedFraction   = 1.08;

PrelaunchBrakes = 0.10;

RotationRate = (RotationElevator - LaunchRollingElevator)/RotationTime;
RotationSpeed = RotationSpeedFraction * IASmin;

% Acceleration
SlowThrottleRate    = 0.006; % /s
FastThrottleRate    = 0.05;  % /s
ThrottleSwitchSpeed = 4; %m/s

PrelaunchThrottle   = 0.03;

%% Initial Values in Plant
V_init  = Speed*0.5144; %m/s
DP_init = 0.5*1.225*V_init^2; % Pa

%% Closed Loop DeRotation
DeRotateLogicRev    = 2;
NoseDownLimit_Deg   = 2.5;
DeRotateRamp_Dps	= 3;  %Fast case DeRotation with minimal bounce 4.5dps, cause lift off following touchdown with -4.5dps
DeRotateLogicHoldNoseUpTimer = 0.1; %s
DeRotateLogicEndTimer       = abs((NoseDownLimit_Deg-1)/DeRotateRamp_Dps);
DeRotateLogicTimerTimeout   = 2; %s, 2 seconds for normal function, 10 seconds for testing forced reversion on lift off

DeRotateUpperCmdSaturation = 7;
DeRotateLowerCmdSaturation = 0;
