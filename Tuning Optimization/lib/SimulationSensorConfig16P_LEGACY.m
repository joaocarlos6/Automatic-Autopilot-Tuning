%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% February 03, 2022
% Description:

disp('SimulationSensorConfig');

%% Define Sensor Parameters for Simulation


%% Sensor Model
NoiseStd.XAccel = 0.1; %m/s^2
NoiseStd.YAccel = 0.1;
NoiseStd.ZAccel = 0.1;
NoiseStd.P      = 0.05; %deg/s
NoiseStd.Q      = 0.05;
NoiseStd.R      = 0.05;
NoiseStd.Roll   = 0.01; %deg
NoiseStd.Pitch  = 0.01; 
NoiseStd.VRate  = 0.001; %m/s
NoiseStd.TAS        = 0;
NoiseStd.TASRate    = 0; %m/s^2
TASRateCutOff       = 1; %Hz
TASRateFilterOrder  = 2;
FilterWarmUpTime    = 2; % for intialization of estimation of TASRate
NoiseStd.Static     = (40/3); % ~80 Pa pk-pk (+/- 40 Pa)
NoiseStd.Dynamic    = (15/3);% ~30 Pa pk-pk (+/- 15 Pa)

% Accel noise model
SensorModel.IMU.xAccelNoiseVarianceInAir    = (0.1/3)^2;
SensorModel.IMU.yAccelNoiseVarianceInAir    = (0.05/3)^2;
SensorModel.IMU.zAccelNoiseVarianceInAir    = (0.025/3)^2;
% Rolling on ground
SensorModel.IMU.xAccelNoiseVarianceOnGnd    = (1.0/3)^2;
SensorModel.IMU.yAccelNoiseVarianceOnGnd    = (0.5/3)^2;
SensorModel.IMU.zAccelNoiseVarianceOnGnd    = (0.5/3)^2;
% At rest on ground
SensorModel.IMU.xAccelNoiseVarianceAtRest   = (0.05/3)^2;
SensorModel.IMU.yAccelNoiseVarianceAtRest   = (0.05/3)^2;
SensorModel.IMU.zAccelNoiseVarianceAtRest   = (0.05/3)^2;

SensorModel.IMU.noiseScalarMin = 0.1;
SensorModel.IMU.noiseScalarMax = 1.0;

% Air Data Sensor Correction Factors
ftvStaticPositionError          = 1/1.18;
PiccoloStaticPositionCorrection = 1.18;

%% WOW
SensorModel.WOW.Cell.WOWtransportDelay = 2; % 20 ms sampling delay addtional to 20ms comms

SensorModel.WOW.Cell.Variant = "LOAD1";
% Load Cell based WOW with Switch/Latch Characteristics
SensorModel.WOW.Cell.ConfigurationVersion = SensorModel.WOW.Cell.Variant + ", 0.06s persistance, Latch:0.75s, Loads:85N Upper, 27N lower, 2Hz LPF, 40ms Transport Delay Added (60ms Total)";
% Hysteresis
SensorModel.WOW.Cell.loadThresholdUpper_N = 85;
SensorModel.WOW.Cell.loadThresholdLower_N = 27;
% Hysteresis Alternate 
SensorModel.WOW.Cell.loadThresholdUpper2_N  = 65; % Prelim secondary thresholds for 16P
SensorModel.WOW.Cell.loadThresholdLower2_N  = 50; % 
% Timing
SensorModel.WOW.Cell.persistanceTime_s  = 0.06;
SensorModel.WOW.Cell.longLatchTime_s    = 0.750; % Long (primary) latch timer. If dual timer mode disabled, this is the parameter used for single timer.
SensorModel.WOW.Cell.shortLatchTime_s   = 0.40; % Short (secondary) latch timer. Used when dual timer mode enabled
% Configuration Control
SensorModel.WOW.Cell.useDualLogic       = 1;    % Set to 1 to use dual-mode detection logic
SensorModel.WOW.Cell.useDualTimer       = 0;    % Set to 1 to use dual latch timer periods
% Additional Params
SensorModel.WOW.Cell.timeout            = 0.75;    % S, timeout period for single contact (Load 2, 16)
% LOAD5
SensorModel.WOW.Cell.dynamicTimeLow     = 0.50; % S, dynamic period for low load cases
SensorModel.WOW.Cell.dynamicTimeHigh    = 0.06; % S, dynamic period for high load cases
SensorModel.WOW.Cell.dynamicTrigger     = 850;  % N, Trigger threshold to switch dynamic periods 
SensorModel.WOW.Cell.dynamicWindow      = 35;   % Samples, size of window used to evaluate peak loads for dynamic timer
% LOAD 6/7
SensorModel.WOW.Cell.LiftOffLatchTimeSingleWheel = 0.5;  %S, LOAD6 and 7
SensorModel.WOW.Cell.LiftOffLatchTimeDoubleWheel = 0.24; %S, LOAD6 and 7
SensorModel.WOW.Cell.LiftOffBounceRiskTimeout    = 0.75; %S,time for which risk of bounce rejects LiftOff Latch Timers, LOAD7
SensorModel.WOW.Cell.LiftOffBounceRiskThreshold  = 1000; %N, Load at which risk of bounce rejects LiftOff Latch Timers, LOAD7

%Take-Off Extenion of Load Cell
SensorModel.WOW.Cell.TO_loadThreshold_N     = 275;
SensorModel.WOW.Cell.TO_persistanceTime_s   = 0.02; %Persistance of 1 sample for Each MLG below load thresh
SensorModel.WOW.Cell.TO_latchTime_s         = 0.5;

% Input Limits
SensorModel.WOW.Cell.SaturationUpper = 1400; % N
SensorModel.WOW.Cell.SaturationLower = -1; % N

% Filter configuration
SensorModel.WOW.Cell.fc     = 2; % Hz
SensorModel.WOW.Cell.dt     = 0.02; % Hz
SensorModel.WOW.Cell.scalar = 1.6;

% NOTE - Constant may need adjusted to shape response for desired fc
SensorModel.WOW.Cell.fp = 0.55*2*pi * SensorModel.WOW.Cell.dt * SensorModel.WOW.Cell.fc * SensorModel.WOW.Cell.scalar; % Filter Constant (for 3db @ 2Hz)

SensorModel.WOW.Cell.b0 = SensorModel.WOW.Cell.fp;
SensorModel.WOW.Cell.b1 = 0;     % I/P Tap Coeffs

SensorModel.WOW.Cell.a0 = 1;
SensorModel.WOW.Cell.a1 = 1-SensorModel.WOW.Cell.fp; % O/P Tap Coeffs

% n = k*[b0 b1]; % 1 zero
% d = [a0 a1]; % 1 pole

% These settings detect quickly and prevent excessive swithcing. Unsure of
% robustness given latch duration
% SensorModel.WOW.Cell.loadThresholdUpper_N = 100;
% SensorModel.WOW.Cell.loadThresholdLower_N = 10;
% 
% SensorModel.WOW.Cell.persistanceTime_s = 0.1;
% SensorModel.WOW.Cell.latchTime_s = 1.0;

% DSC
DSCnumBits = 24;
numBits = 16;
satMaxMG = 15000;
satMinMG = -300;
dscNoiseMG = 1;
DSCRangeMaxMG = 15000;
DSCRangeMinMG = -15000;
satMaxNG = 1000;
satMinNG = -250;
dscNoiseNG = 0.25;
DSCRangeMaxNG = 1000;
DSCRangeMinNG = -1000;
cellSatMaxMG = 15000;
cellSatMinMG = -15000;
cell2WheelFactorMG = 5.98;
cellSatMaxNG = 1000;
cellSatMinNG = -1000;
cell2WheelFactorNG = 1;