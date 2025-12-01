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

PiccoloGainVersion = "G42 FWD Flap 0 (Gen " + FTV +")";
modelScale = '7P';

disp("* 7P TAILLESS *")
disp("Gains: " + PiccoloGainVersion)

%% Define Control Parameters for Simulation
CLAWs_On = 0; % We elect to disable internal BA CLaws for now...    
dt = 0.02; %Control model loop update rate is controlled by this step. use 20ms for Piccolo 

% Use to control Piccolo states. Set to 1 for flight modes. Set to 0 to use
% landing modes. This can be set conditionally during simulation
% eventually.
inFlight = 1;
AltCruise_m = 640;

% Longitudinal Control Mode (0 == Alt Priority, 1 == Airspeed Priority)
LonMode = 0;

%% Control Allocation Configuration
ControlAllocation = "M8"; % Mixing Matrix M8 for tailless

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

CL_Max      = 0.525;
CL_Max_Nom  = 0.451;
CL_cruise   = 0.243;

% documentation says above and says during TouchDown, use CL_Limit=CL_Max;
CL_Limit    = CL_Max;   % During Short Final/Touchdown this is relaxed to CL_Max limit
CL_Min      = 0;
LiftSlope   = 0.058631; % /deg
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

% Flag to enable airspeed protection logic - 
% This doesn't exist in Piccolo configuration, but may be desireable to
% disable this logic until it is matched and verified.
Enable_TAS_Protection = 0;

%Low Pass Filters
TASBandwidth    = 0.05; %Hz
Fp_TAS          = 0.55*2*pi*TASBandwidth;

TASRateErr2VRate    = 1.00;
TASRateErrInt2VRate = 1.50;
TASRateMax=4.0; % m/s^2; also used in throttle control to saturate desired energy rate

%% Throttle Control
ThrottleTrim    = 0.3;  % 0.2
MaxEnginePower  = 4900; % W 5500

PowerError2Throttle     = 0.9; % 0.9
PowerErrorInt2Throttle  = 0.9; % 0.2
ThrottlePredictionTrust = 0.6; % 0.9
ThrottleRateMax         = 0.2; % 1/s; not in documentation, but in PCC

% EXTERNAL LOGIC
% To apply slower slew during throttle cut in flare.
useFlareSlew        = 1;        % Flag to enable external throttle logic
useElevatorKill     = 1;        % Flag to kill engine based on Elevator. Alternative is rollout state machine
RolloutElevTrigger  = 2;        % Deg, Position Elevator triggers Rollout Throttle, 
ThrottleRateFlare   = 0.045;    % /s, Slew rate to be applied 0.025, 0.05
ThrottleRateRollout = 0.10;     % /s, Slew rate to be applied 0.025
ThrottleRateRever   = 0.045;    % /s, Slew rate to be applied 0.025, 0.05
ThrottleMaxFlare    = 0.50;     % Upper saturation limit
ThrottleMinFlare    = 0.05;     % Lower saturation limit    
ThrottleMinRollout  = 0.00;     % For use

% Low pass filters
ThrottleLpfCutoff   = 0.2; % Hz
Fp_Throttle         = 0.55*2*pi*ThrottleLpfCutoff*dt;   % Better match for 7P with TLA Filter as such?
% Fp_Throttle=0.55*ThrottleLpfCutoff*dt;                % It appears this param is input as Rad/s NOT Hz

EnergyBandwidth     = 0.06; % Hz;0.02

Fp_Energy           = 0.55*2*pi*EnergyBandwidth;
Fp_Energy2          = 0.55*2*pi*EnergyBandwidth*dt;

%Limits
ThrottleMax = 0.95;
ThrottleMin = 0.10;

%%  Vertical Rate Control (Landing Lon Gains)
% BW
AltBandwidth    = 0.06; %Hz, 
Fp_Alt          = 2*pi*0.55*AltBandwidth;

% Limits
ClimbMaxFraction    = 0.21;
DescentMaxFraction  = 0.17;
AltMax              = 10000;
AltMin              = 0;
AltMaxAccel         = 2.0; %m/s/s

%G41 Tuning
AltRateError2Pitch      = 0.4; %0.3; 
AltRateErrorInt2Pitch   = 0.55; %0.15; 
AltRateCmd2Pitch        = 0.4; %0.9; 

%Low Pass Filters
AltRateLpfCutOff    = 5; %Hz
Fp_AltRate          = 0.55*2*pi*AltRateLpfCutOff*dt;

% Used in INS
TasLpfCutoff    = 1.0; %Hz
Fp_TAS_Filter   = 2*pi*TasLpfCutoff*dt;

%Limits
PitchMax    = 25;               % deg
PitchMax    = PitchMax/180*pi;  % radian
PitchMin    = -PitchMax;

%% Pitch Control
ElevatorTrim = -5; % default: -5

PitchMaxAccel   = 1.0; % rad/s^2; used in rate limiter
PitchBandwidth  = 0.65; %Hz 1.10

% Tuning
PitchRateError2Accel    = 1.2; 
PitchRateErrorInt2Accel = 8.4; 
PitchDampingTrust       = 0;
PitchStiffnessTrust     = 1; %

%Vehicle Properties
ElevatorPower   = -0.00293;% /deg
PitchDamping    = -0.5; % Cm/qbar
PitchStiffness  = -0.001; % /deg

% Limits
PitchRateMax_User   = 30; % deg/s, used in saturation block
PitchRateMax_User   = PitchRateMax_User/180*pi; % rad/s, used in saturation block
ElevatorMax         = 25; %deg

%Low pass filters
Fp_Pitch    = 0.55*2*pi*PitchBandwidth; % used for generating pitch rate command
Fp_Pitch_2  = 0.55*2*pi*PitchBandwidth*dt; % used in the low pass filter for lift coefficient

PitchRateLpfCutoff  = 5; %Hz; used for filtering the elevator ouput
Fp_Elevator         = 0.55*2*pi*PitchRateLpfCutoff*dt;

%% Lateral Control (Bank to Aileron)
% Track Control
TrackConvergence        = 0.23;%????
HeadingErr2TurnRate     = 0.5;  %????
HeadingErrDer2TurnRate  = 0.3;  %????
TurnErrLPFcutoff        = 0.05; %????
Fp_Turn                 = 0.55*2*pi*TurnErrLPFcutoff;

TurnDerivativeLPFcutoff = TurnErrLPFcutoff;
Fp_TurnDerr             = 0.55*2*pi*TurnDerivativeLPFcutoff;

%% Bank to Roll Rate Cmd
RollBandwidth   = 1.3; %Hz;Original Value 1.1 228b bug fixes this value to 1.3 for flight and 1.0 for landing
Fp_Roll         = RollBandwidth^2; % correction by reviewing the data !!!0.55*2*pi*RollBandwidth is not used !!!
RollMaxAccel    = 0.6; %rad/s^2

% Limits
BankMax_User    = 32;                   % deg/s
BankMax_User    = BankMax_User/180*pi;
RollRateMax     = 35;                   % deg/s
RollRateMax     = RollRateMax/180*pi;   % rad/s

%% Roll Rate to Aileron
AileronTrim=0;
% 
RollRateError2Accel     = 4; %
RollRateErrorInt2Accel  = 5; %
RollDampingTrust        = 0;

% Limits
AileronMax          = 25; % Deg (Piccolo command saturation)
AileronSurfaceMax   = 25; % Deg, actual max range of surface map (for use in mixing logic)

%Vehicle Properties
AileronPower    = 0.002266; % /deg
RollDamping     = -0.3475; % Cl/pbar

%Low pass filters
RollRateLpfCutoff   = 3.0; % Hz
Fp_Aileron          = 0.55*2*pi*RollRateLpfCutoff*dt;

%% Yaw Rate to Rudder (Bank angle defines desired yaw rate)
%
YawRateErr2Rudder       = 2;
SideForceErrInt2Rudder  = 0.2; % it is used in another
% rudder_coordination based on side force/lateral acceleration

% Limits
RudderMax   = 25; %deg
RudderTrim  = -1;

if (FTV == 2)
    % Vehicle Properties
    RudderEffect    = -0.420414; %B/dr; check out the output, do we need unit conversion ?
    RudderPower     = 0.000070; % /deg 

elseif (FTV == 3)
    % Vehicle Properties
    RudderEffect    = -0.42937; %B/dr;
    RudderPower     = 0.000244; % /deg 
end

SideslipEffect = -0.004890; %it is used in sideslip force method

% Low pass filters
YawRateLpfCutoff = 0; % Hz; disable the filter when set to 0 in piccolo;
Fp_Rudder=0.55*2*pi*YawRateLpfCutoff*dt;

%% Brake Control
DecelerationCmd     = 0.1; % m/s/s, braking target
AccelErrInt2Brakes  = 0.2;

%% Steering (Rollout) Control
% Set to 0 to disable taxi control on touchdown
TaxiEnable = 1;

% % Transition - G41 - 3D
% % Outer Loop
Y2VyScalingPower        = 0.3;
TrackY2Vy               = 0.4;

% Inner Loop
TrackVyErrInt2Nosegear  = 0.15;
TrackVyErrPro2Nosegear  = 1.2;
YawRate2Nosegear        = 0.060;
Vy2NosegearScalingPower = 1.65; 

% Rollout Retuned - From UTail - Used for 3D
% Outer Loop
ldg_Y2VyScalingPower        = 0.0;
ldg_TrackY2Vy               = 0.17;

% Inner Loop
ldg_TrackVyErrInt2Nosegear  = 0.01/1.4;
ldg_TrackVyErrPro2Nosegear  = 0.82/15;
ldg_YawRate2Nosegear        = 0.065;
ldg_Vy2NosegearScalingPower = 0.60;

% Limits 
NosegearMax     = 15; % deg
ldg_NosegearMax = 10; % deg

if(FTV == 2)
    AutoNosegear2Rudder = 90;  % Value used in 2C Tailless w/o winglets
elseif(FTV == 3)
    AutoNosegear2Rudder = 25.2;% Value used in 3C Tailless
end

%Track offset bias
taxiTrackOffset = testPlans(testIndx).rolloutTrackOffset; %m, to command offset track during landing

%% Flight Nominal
% See page 13 of FWG3 CLaws - 
% IASmin = sqrt(2*m*9.81/(1.225*Sw*CL_Limit);
% Where CL_Limit = 0.9 * CL_Max_Nom, for modes 0 - 8;
% Document indicates CL_Limit = CL_Max, for modes >= 9, 

IASmin          = sqrt(2*m*9.81*1.1/(1.225*Sw*CL_Max_Nom));
IASmax          = 43.7; % Set as static limit (ldg limits)
IASstall        = sqrt(2*m*9.81/(1.225*Sw*CL_Max));

IAScruiseCMD    = sqrt(2*m*9.81/(1.225*Sw*CL_cruise));

%% Launch/Take-Off/Climbout
ClimboutMaxBank = 5.0; %Deg, allowable bank command
ClimboutTimer   = 7.0; %s, time from start of climbout until advancing to Flight state machine

%% Landing / Flare Control
IASfinalCMD = 1.23 * IASmin;
IASshortCMD = 1.21 * IASmin;
IASflareCMD = 0 * IASmin; % Disable throttle control in flare for consistency

%Speed Fraction Protection Limits
if IASshortCMD < IASstall
    IASshortCMD = IASstall;
end

if IASflareCMD < IASstall && IASflareCMD~=0 %If we command 0 engines go to idle
    IASflareCMD = IASstall;
end

% Slope for final
FinalDescentSlope_Deg = testPlans(testIndx).descentSlope; %Deg

% Slope for short-final
% ShortDescentSlope_Deg = testPlans(testIndx).descentSlope; %Deg, Constant Slope
% ShortDescentSlope_Deg = testPlans(testIndx).descentSlope - 0.5; %Deg, we subtrack 0.5 degree in short approach to match previous flights
ShortDescentSlope_Deg = testPlans(testIndx).descentSlope-0.25; % Deg, 0.25 degree reduction (consistent with 16P)

ShortFinalHeight = (12.5 * IASshortCMD * sin(ShortDescentSlope_Deg*pi/180)) + (TerrainHeight*0.3048); %m, 26.66m @ 3deg glide slope approx 13.5s from touchdown

LdgEngineKillTime = -1; % s, Estimated time to touchdown, negative number inhibits function
LdgEngineKillTimeFromFlare = 1.7; %have not worked out logic for this yet, this is average from FTV2C landings

FlareHeight             = 2.2; %2.75; %m 
FlareVerticalRate_mps   = -0.1;

WOWarmed = 1; %-1 indicates disarmed, 0-100 indicates armed

EarlyTouchdownThreshold = 3;
TouchdownThreshold      = 3;

RollingElevator         = 6.5; %deg
ElevatorDeflectionRate  = 10; %deg/s

MaxTouchdownBank    = 5; 
RolloutWingLeveling = 1; 

%% Flaps
% Flap commands per mode (deg)
flapMax     = 0; % Set to 0 to disable flaps
flapRate    = 6.60; % Flap deployment rate (deg/s)

dCl_per_dFlap = 0; % No CL change when using split ailerons 
% dCl_per_dFlap = 0.010775; %[/deg]

dCd_per_dFlap = 0; %[/deg] Change in Cd per flap deflection. Appears unused in controller.. 

goAroundFlaps   = 0;
downwindFlaps   = 0;
baseLegFlaps    = 0;
finalApproachFlaps  = 0;
shortFinalFlaps     = 0; 
rolloutFlaps        = 0;

elevonBias = 0;

%% Launch
% Cross track abort settings
% Flag to allow auto-abort due to cross track limit
% (Will still be logged if disabled)
EnableCrossTrackAbort = 1;
% Abort Threshold
MaxCrossError = 5.0; % m

% Elevator in Transition Phase
LaunchRollingElevator   = -1; % deg
RotationElevator        = -4;% deg
RotationTime            = 3.5;   % s
RotationSpeedFraction   = 1.32;

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
