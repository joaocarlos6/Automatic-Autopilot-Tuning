%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% February 03, 2022
% Description:
disp('SimulationControlConfig');
%% Initialize
if ~exist('NoiseStd','var')
    SimulationSensorConfig;
end

PiccoloGainVersion = "G75.0 (Gen " + FTV +")";
modelScale = '7P';

disp("* 7P UTAIL *")
disp("Gains: " + PiccoloGainVersion)

%% Define Control Parameters for Simulation
CLAWs_On = 0; % We elect to disable internal BA CLaws for now...    
dt = 0.02; %Control model loop update rate is controlled by this step. use 20ms for Piccolo 

% Use to control Piccolo states. Set to 1 for flight modes. Set to 0 to use
% landing modes. This can be set conditionally during simulation
% eventually.
inFlight = 1;
AltCruise_m = testPlans(testIndx).terrainElevation * 0.3048 + 152; % Climb to 500ft AGL

% Longitudinal Control Mode (0 == Alt Priority, 1 == Airspeed Priority)
LonMode = 0;

%% Control Allocation Configuration
ControlAllocation = "M2"; % Mixing Matrix M8 for tailless

%% Piccolo Controller Gains
% any low pass filters should have a cut-off frequency lower than
% 1/2*50Hz=25Hz, which is called the Nyquist frequency; otherwise
% distabilizing the system.

%% Vehicle
Sw          = 0.839;% m^2
b           = 2.37; % m;wing span
c           = Sw/b; % m;average wing chord
VerticalTailArm     = 0.47; %m
SteeringArm         = 0.53;

CL_Max      = 0.530;
CL_Max_Nom  = 0.465;
CL_cruise   = 0.290;

% documentation says above and says during TouchDown, use CL_Limit=CL_Max;
CL_Limit    = CL_Max;   % During Short Final/Touchdown this is relaxed to CL_Max limit
CL_Min      = 0;
LiftSlope   = 0.064285; % /deg
nMax_User   = 2.5;      % in g; from the point of view of structure
nMin_User   = -1.0;     % in g; from the point of view of structure

% Pull mass and inertia from AC configuration
% This is representative since controller configuration will have correct
% knowledge for each vehicle's inertia 

% Vehicle Mass
m = Weight / 2.2; 

% Lateral Axis
XInertia = IXX / 3417.17; %kgm^2
% Pitch Axis
YInertia = IYY / 3417.17; %kg/m^2
% Directional Axis
ZInertia = IZZ / 3417.17; %kg/m^2

%% Airspeed Control (airspeed mode)
%Low Pass Filters
TASBandwidth    = 0.05; %Hz
Fp_TAS          = 0.55*2*pi*TASBandwidth;

Enable_TAS_Protection = 0; % Enable/Disable TAS Protection modes

TASRateErr2VRate    = 1.00;
TASRateErrInt2VRate = 1.50;
TASRateMax=4.0; % m/s^2; also used in throttle control to saturate desired energy rate

%% Throttle Control
ThrottleTrim=0.5; %0.2
MaxEnginePower=5500; %W 5500

% G62
PowerError2Throttle=0.9; %0.9
PowerErrorInt2Throttle=0.9; %0.2
ThrottlePredictionTrust=0.6; %0.9

ThrottleRateMax=0.20; %1/s

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

% Low pass filters
ThrottleLpfCutoff=0.2; % Hz
Fp_Throttle=0.55*2*pi*ThrottleLpfCutoff*dt; % Better match for 7P with TLA Filter as such?
% Fp_Throttle=0.55*ThrottleLpfCutoff*dt; % It appears this param is input as Rad/s NOT Hz

EnergyBandwidth=0.06; %Hz;0.02

Fp_Energy=0.55*2*pi*EnergyBandwidth;
Fp_Energy2=0.55*2*pi*EnergyBandwidth*dt;

%Limits
ThrottleMax=0.95;
ThrottleMin=0.00;

%% Vertical Rate Control
% BW
AltBandwidth = 0.20; %Hz 
Fp_Alt       = 2*pi*0.55*AltBandwidth;

% Limits
ClimbMaxFraction   = 0.21;
DescentMaxFraction = 0.17;
AltMax = 10000;
AltMin = 0;
AltMaxAccel = 2.0; %m/s/s

% G62
AltRateError2Pitch      = 0.55; 
AltRateErrorInt2Pitch   = 0.75; 
AltRateCmd2Pitch        = 0.3;

%Low Pass Filters
AltRateLpfCutOff    = 2; %Hz
Fp_AltRate          = 0.55*2*pi*AltRateLpfCutOff*dt;

% Used in INS
TasLpfCutoff = 1.0; %Hz
Fp_TAS_Filter = 2*pi*TasLpfCutoff*dt;

%Limits
PitchMax = 25; % deg
PitchMax = PitchMax/180*pi; %radian
PitchMin = -PitchMax;

%% Pitch Control
ElevatorTrim    = -8.0; % default: -5

PitchMaxAccel   = 1.10; % rad/s^2; used in rate limiter
PitchBandwidth  = 1.0; %Hz

% G62
PitchRateError2Accel    = 3; 
PitchRateErrorInt2Accel = 2; 
PitchDampingTrust       = 0.0;
PitchStiffnessTrust     = 0.5; %0.25; 

%Vehicle Properties
ElevatorPower   = -0.00205983; %-0.00205983; %-0.002106; % /deg 
PitchDamping    = -1.2608; % Cm/qbar
PitchStiffness  = -0.00194915; %-0.00194915; %-0.0041; % /deg %-0.00266; 

% Limits
PitchRateMax_User   = 30; % deg/s, used in saturation block
PitchRateMax_User   = PitchRateMax_User/180*pi; % rad/s, used in saturation block
ElevatorMax         = 25; %deg

%Low pass filters
PitchRateLpfCutoff  = 5; %Hz; bad name; it is actually used for filtering the elevator ouput

Fp_Pitch    = 0.55*2*pi*PitchBandwidth; % used for generating pitch rate command
Fp_Pitch_2  = 0.55*2*pi*PitchBandwidth*dt; % used in the low pass filter for lift coefficient
Fp_Elevator = 0.55*2*pi*PitchRateLpfCutoff*dt;


%% Lateral Control (Bank to Aileron)
% Track Control
TrackConvergence    = 0.260; % Modified for G71
HeadingErr2TurnRate = 0.5; %????
HeadingErrDer2TurnRate = 0.3; %????
TurnErrLPFcutoff    = 0.05; %????
Fp_Turn             = 0.55*2*pi*TurnErrLPFcutoff;

TurnDerivativeLPFcutoff = TurnErrLPFcutoff;
Fp_TurnDerr = 0.55*2*pi*TurnDerivativeLPFcutoff;

%% Bank to Roll Rate Cmd
RollBandwidth   = 1.0; %Hz; Fixed at 1.0 as per Piccolo

Fp_Roll=RollBandwidth^2; % correction by reviewing the data !!!0.55*2*pi*RollBandwidth is not used !!!

RollMaxAccel=0.8; %rad/s^2
% Limits
BankMax_User=36; % deg
BankMax_User=BankMax_User/180*pi;
RollRateMax=35; % deg/s
RollRateMax=RollRateMax/180*pi; % rad/s

%% Roll Rate to Aileron
AileronTrim=0;

% G72 - detuned proportional 
RollRateError2Accel     = 8; %2*15
RollRateErrorInt2Accel  = 6.5; %3*15
YawRateErr2Rudder       = 2.0;
RollRateLpfCutoff       = 2.5; % Hz
RollDampingTrust = 0;

% Limits
AileronMax = 25; % Deg
%Vehicle Properties
AileronPower = 0.00268; % /deg
RollDamping  = -0.3475; % Cl/pbar
%Low pass filters
% RollRateLpfCutoff=2.5; % Hz 
Fp_Aileron=0.55*2*pi*RollRateLpfCutoff*dt;

%% Yaw Rate to Rudder (Bank angle defines desired yaw rate)
SideForceErrInt2Rudder=0.0; % it is used in another rudder_coordination based on side force/lateral acceleration

% Limits
RudderMax   = 25; %deg
RudderTrim  = 0;

if(FTV == 2)
    % Vehicle Properties
    RudderEffect=-0.54431; %B/dr; check out the output, do we need unit conversion ?
    RudderPower= 0.000270; % /deg   
    
elseif(FTV == 3)
    % Vehicle Properties
    RudderEffect=-0.54431; %B/dr
    RudderPower= 0.000443; % /deg 
    
end

SideslipEffect=-0.006037; %it is used in sideslip force method

% Low pass filters
YawRateLpfCutoff=0; % Hz; disable the filter when set to 0 in piccolo;
Fp_Rudder=0.55*2*pi*YawRateLpfCutoff*dt;

%% Brake Control
DecelerationCmd = 0.1; % m/s/s, braking target
AccelErrInt2Brakes = 0.2;

%% Steering (Rollout) Control
% Set to 0 to disable taxi control on touchdown
TaxiEnable = 1;

% Transition 
TrackY2Vy               = 0.20;
TrackVyErrInt2Nosegear  = 0.05;
TrackVyErrPro2Nosegear  = 0.08;
YawRate2Nosegear        = 0.065;
Y2VyScalingPower        = 0.00;
Vy2NosegearScalingPower = 0.55;  

% Rollout
ldg_TrackY2Vy               = 0.17;
ldg_TrackVyErrInt2Nosegear  = 0.01/1.4;
ldg_TrackVyErrPro2Nosegear  = 0.82/15;
ldg_YawRate2Nosegear        = 0.065;
ldg_Y2VyScalingPower        = 0.0;
ldg_Vy2NosegearScalingPower = 0.50;

% Limits 
NosegearMax     = 15; % deg
ldg_NosegearMax = 10; % deg
% Set mixing scalar conditional on FTV
if(FTV == 2)
    AutoNosegear2Rudder=23;    
elseif(FTV == 3)
    AutoNosegear2Rudder=14;
end 

ldg_NosegearMax=10; % deg

%Track offset bias
taxiTrackOffset = testPlans(testIndx).rolloutTrackOffset; %m, to command offset track during landing

%% Flight Nominal
% See page 13 of FWG3 CLaws - 
% IASmin = sqrt(2*m*9.81/(1.225*Sw*CL_Limit);
% Where CL_Limit = 0.9 * CL_Max_Nom, for modes 0 - 8;
% Document indicates CL_Limit = CL_Max, for modes >= 9, 

IASmin          = sqrt(2*m*9.81/(1.225*Sw*0.9*CL_Max_Nom));
IASmax          = 35; % Set as static limit
IASstall        = sqrt(2*m*9.81/(1.225*Sw*CL_Max));
IAScruiseCMD    = sqrt(2*m*9.81/(1.225*Sw*CL_cruise));

%% Launch/Take-Off/Climbout
ClimboutMaxBank = 7.0; %Deg, allowable bank command
ClimboutTimer = 7.0; %s, time from start of climbout until advancing to Flight state machine

%% Landing / Flare Control
IASfinalCMD = 1.15 * IASmin;
IASshortCMD = 1.10 * IASmin;
IASflareCMD = 0.96 * IASmin;

%Speed Fraction Protection Limits
if IASshortCMD < IASstall
    IASshortCMD = IASstall;
end
if IASflareCMD < IASstall && IASflareCMD~=0 %If we command 0 engines go to idle
    IASflareCMD = IASstall;
end

% Currently using constant slope for final + short final
FinalDescentSlope_Deg = testPlans(testIndx).descentSlope; %Deg
ShortDescentSlope_Deg = testPlans(testIndx).descentSlope - 0.5; %Deg, we subtrack 0.5 degree in short approach to match previous flights
% ShortDescentSlope_Deg = testPlans(testIndx).descentSlope; %Deg, we subtrack 0.5 degree in short approach to match previous flights

ShortFinalHeight = (12.5 * IASshortCMD * sin(ShortDescentSlope_Deg*pi/180)) + (TerrainHeight*0.3048); %m, 26.66m @ 3deg glide slope approx 13.5s from touchdown

LdgEngineKillTime = -1; % s, Estimated time to touchdown, negative number inhibits function
LdgEngineKillTimeFromFlare = 1.7; %have not worked out logic for this yet, this is average from FTV2C landings

FlareHeight= 2.0; %m
FlareVerticalRate_mps = -0.15;

WOWarmed = 1; %-1 indicates disarmed, 0-100 indicates armed

EarlyTouchdownThreshold = 2.5;
TouchdownThreshold = 1.4;

% G65
RollingElevator = 7.0; %deg
ElevatorDeflectionRate = 12; %deg/s

MaxTouchdownBank = 5; %G63 and up
RolloutWingLeveling = 1; 

%% Flaps
% Flap commands per mode (deg)
flapMax     = 0; % Set to 0 to disable flaps
flapRate    = 7.5; % Flap deployment rate (deg/s)

dCl_per_dFlap = 0; % No CL change when using split ailerons 
% dCl_per_dFlap = 0.005581818; %[/deg]

dCd_per_dFlap = 0; %[/deg] Change in Cd per flap deflection. Appears unused in controller.. 

goAroundFlaps   = 0;
downwindFlaps   = 0;
baseLegFlaps    = 10;
finalApproachFlaps  = 10;
shortFinalFlaps     = 10;
rolloutFlaps        = 15;

elevonBias = 0;

%% Launch
% Cross track abort settings
% Flag to allow auto-abort due to cross track limit
% (Will still be logged if disabled)
EnableCrossTrackAbort = 1;
% Abort Threshold
MaxCrossError = 4.0; % m

% Elevator in Transition Phase
LaunchRollingElevator   = 1.00; % deg
RotationElevator        = -5.70;% deg
RotationTime            = 3.6;   % s
RotationSpeedFraction   = 1.03;

PrelaunchBrakes = 0.10;

RotationRate = (RotationElevator - LaunchRollingElevator)/RotationTime;
RotationSpeed = RotationSpeedFraction * IASmin;

% Acceleration
SlowThrottleRate    = 0.012; % /s
FastThrottleRate    = 0.100;  % /s
ThrottleSwitchSpeed = 4.0; %m/s

PrelaunchThrottle   = 0.03;

%% Initial Values in Plant
V_init=Speed*0.5144; %m/s
DP_init=0.5*1.225*V_init^2; % Pa

%% Closed Loop DeRotation
DeRotateLogicRev = 2;
NoseDownLimit_Deg = 2.5;
DeRotateRamp_Dps = 8;  %Fast case DeRotation with minimal bounce 4.5dps, cause lift off following touchdown with -4.5dps
DeRotateLogicHoldNoseUpTimer = 0.1; %s
DeRotateLogicEndTimer = abs((NoseDownLimit_Deg-1)/DeRotateRamp_Dps);
DeRotateLogicTimerTimeout = 2; %s, 2 seconds for normal function, 10 seconds for testing forced reversion on lift off

DeRotateUpperCmdSaturation = 7;
DeRotateLowerCmdSaturation = 0;
