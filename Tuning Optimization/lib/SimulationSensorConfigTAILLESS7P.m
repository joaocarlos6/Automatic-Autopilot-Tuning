%% SimulationInitialization.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% March 02, 2023
% Description:

disp('SimulationSensorConfig');

% Define Sensor Parameters for Simulation
%% Sensor Model
NoiseStd.XAccel     =0.1; %m/s^2
NoiseStd.YAccel     =0.1;
NoiseStd.ZAccel     =0.1;
NoiseStd.P          =0.05; %deg/s
NoiseStd.Q          =0.05;
NoiseStd.R          =0.05;
NoiseStd.Roll       =0.01; %deg
NoiseStd.Pitch      =0.01; 
NoiseStd.VRate      =0.001; %m/s
NoiseStd.TAS        =0;
NoiseStd.TASRate    =0; %m/s^2
TASRateCutOff       =1; %Hz
TASRateFilterOrder  =2;
FilterWarmUpTime    =2; % for intialization of estimation of TASRate

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
ftvStaticPositionError          = 1.00;
PiccoloStaticPositionCorrection = 1.00;

%% WOW
SensorModel.WOW.Cell.WOWtransportDelay = 1; % MULTIPLES of dt added as delay to ground contact signal

SensorModel.WOW.Cell.Variant = "LOAD20"; %
% Load Cell based WOW with Switch/Latch Characteristics
SensorModel.WOW.Cell.ConfigurationVersion = SensorModel.WOW.Cell.Variant + ", 0.00s persistance, Latch:0.3s, Loads1:6.5N upper, 3.5N lower, 3Hz LPF, 0.3s Single Wheel Timeout, 20ms Added + 20ms Piccolo Comm Delays.";

% Load Cell based WOW with Switch/Latch Characteristics
% Hysteresis
SensorModel.WOW.Cell.loadThresholdUpper_N   = 6.5; % 85/13 = 6.5, 65/13 = 5
SensorModel.WOW.Cell.loadThresholdLower_N   = 3.5; % 27/13 = 2.1
% Hysteresis Alternate 
SensorModel.WOW.Cell.loadThresholdUpper2_N  = 30; % 85/13 = 6.5, 65/13 = 5
SensorModel.WOW.Cell.loadThresholdLower2_N  = 25; % 27/13 = 2.1

% Timing
SensorModel.WOW.Cell.persistanceTime_s      = 0.000;
SensorModel.WOW.Cell.longLatchTime_s        = 0.300; % Long (primary) latch timer. If dual timer mode disabled, this is the parameter used for single timer.
SensorModel.WOW.Cell.shortLatchTime_s       = 0.300; % Short (secondary) latch timer. Used when dual timer mode enabled
SensorModel.WOW.Cell.timeout                = 0.300; % S, timeout period for single contact (Load 2)

% Enable Flags
SensorModel.WOW.Cell.useDualLogic           = 1;    % Set to 1 to use dual-mode detection logic
SensorModel.WOW.Cell.useDualTimer           = 0;    % Set to 1 to use dual latch timer periods
% Other params
SensorModel.WOW.Cell.dynamicTimeLow         = 0.40; % S, dynamic period for low load cases
SensorModel.WOW.Cell.dynamicTimeHigh        = 0.06; % S, dynamic period for high load cases
SensorModel.WOW.Cell.dynamicTrigger         = 8;    % N, Trigger threshold to switch dynamic periods 
SensorModel.WOW.Cell.dynamicWindow          = 20;   % Samples, size of window used to evaluate peak loads for dynamic timer

%Take-Off Extenion of Load Cell (Load2) 
SensorModel.WOW.Cell.TO_loadThreshold_N     = 275 / 13;
SensorModel.WOW.Cell.TO_persistanceTime_s   = 0.02; % Persistance of 1 sample for Each MLG below load thresh
SensorModel.WOW.Cell.TO_latchTime_s         = 0.5;

% Input Limits
SensorModel.WOW.Cell.SaturationUpper = 100; % N
SensorModel.WOW.Cell.SaturationLower = -1; % N

% Filter configuration
SensorModel.WOW.Cell.fc = 3; % Hz
SensorModel.WOW.Cell.dt = 0.02; % Hz
SensorModel.WOW.Cell.scalar = 1.5;

% NOTE - Constant may need adjusted to shape response for desired fc
SensorModel.WOW.Cell.fp = 0.55*2*pi * SensorModel.WOW.Cell.dt * SensorModel.WOW.Cell.fc * SensorModel.WOW.Cell.scalar; % Filter Constant (for 3db @ 2Hz)

SensorModel.WOW.Cell.b0 = SensorModel.WOW.Cell.fp;
SensorModel.WOW.Cell.b1 = 0;     % I/P Tap Coeffs

SensorModel.WOW.Cell.a0 = 1;
SensorModel.WOW.Cell.a1 = 1-SensorModel.WOW.Cell.fp; % O/P Tap Coeffs

% DSC Failure Flags - For testing single wheel landing
SensorModel.WOW.Cell.MGR_FAIL = 0;
SensorModel.WOW.Cell.MGL_FAIL = 0;

SensorModel.WOW.Cell.LOAD_TIMEOUT_COUNTS = 5;
SensorModel.WOW.Cell.FLAG_TIMEOUT_COUNTS = 5;
SensorModel.WOW.Cell.FLAG_COUNTS = 5;
SensorModel.WOW.Cell.INVALID_COUNTS = 3;

%% Upstream Parameters
% DSC 
SensorModel.WOW.Cell.dscNoiseMG = 1.00;  % N, pk-pk
SensorModel.WOW.Cell.dscNoiseNG = 0.25;  % N, pk-pk

% K2 Encoding
SensorModel.WOW.Cell.numBits = 16;

% MG Saturation limits for encoding
SensorModel.WOW.Cell.satMaxMG = 15000;
SensorModel.WOW.Cell.satMinMG = -15000;
% NG Saturation limits for encoding (NO NG on 7P)
SensorModel.WOW.Cell.satMaxNG = 1000;
SensorModel.WOW.Cell.satMinNG = -1000;

% MG Wheel sanity range for validity
SensorModel.WOW.Cell.satMaxMGWheel = 200;
SensorModel.WOW.Cell.satMinMGWheel = -25;
% NG Wheel sanity range for validity (NO NG on 7P)
SensorModel.WOW.Cell.satMaxNGWheel = 200;
SensorModel.WOW.Cell.satMinNGWheel = -25;

% Polynomial parameters for DSC to wheel calibration.
% Will use zero bias for consistency with original implementation.
% Bias is subject to change and is corrected through taring procedure.
SensorModel.WOW.Cell.polyA.MGL = 0;
SensorModel.WOW.Cell.polyB.MGL = 1;
SensorModel.WOW.Cell.polyC.MGL = 0; 

SensorModel.WOW.Cell.polyA.MGR = 0;
SensorModel.WOW.Cell.polyB.MGR = 1;
SensorModel.WOW.Cell.polyC.MGR = 0;

% No scaling for NG, but requires a sign inversion.
SensorModel.WOW.Cell.polyA.NG = 0;
SensorModel.WOW.Cell.polyB.NG = 1;
SensorModel.WOW.Cell.polyC.NG = 0;

% Global/Extended Linear Calibration
SensorModel.WOW.Cell.intercept.MGL = 5000;
SensorModel.WOW.Cell.intercept.MGR = 5000;
%
SensorModel.WOW.Cell.gblSlope      = 1;
SensorModel.WOW.Cell.gblOffset     = 0;    

% Inverse polynomials for wheel to cell approximation
% Port
% a = 0.0009132396, b = 5.2432740318, c = 1 (offset for best fit around
% detection thresholds)
SensorModel.WOW.Cell.polyA.inverseMGL = 0;
SensorModel.WOW.Cell.polyB.inverseMGL = 1;
SensorModel.WOW.Cell.polyC.inverseMGL = 0;

% Stbd
% a = 0.0008038506, b = 5.2497314934, c = 1.5 (offset for best fit around
% detection thresholds)
SensorModel.WOW.Cell.polyA.inverseMGR = 0;
SensorModel.WOW.Cell.polyB.inverseMGR = 1;
SensorModel.WOW.Cell.polyC.inverseMGR = 0;

% Nose
SensorModel.WOW.Cell.polyA.inverseNG = 0;
SensorModel.WOW.Cell.polyB.inverseNG = 1;
SensorModel.WOW.Cell.polyC.inverseNG = 0;

% Quantization Parameters - Calibration from 3E
SensorModel.WOW.Cell.calibrationSlopeMG  = 44.7; % Approximate slope of MG calibration (N / mV/V)
SensorModel.WOW.Cell.calibrationSlopeNG  = 1;    % Approximate slope of NG calibration (N / mV/V) - Not installed on 7P (placeholder values)
SensorModel.WOW.Cell.fullScaleRange      = 6;    % FSC in mV/V (+/- 3 mV/V for DSC)
SensorModel.WOW.Cell.effectiveCounts     = 50000;% Effective (noise-free) resolution at given output rate 

%% Deprecated parameters
% Physical
SensorModel.WOW.Cell.cell2WheelFactorMG = 1;
SensorModel.WOW.Cell.cell2WheelFactorNG = 1;
% DSC
DSCnumBits = 24;
% MG
DSCRangeMaxMG = 15000;
DSCRangeMinMG = -15000;
% NG
DSCRangeMaxNG = 1000;
DSCRangeMinNG = -1000;
% Cell
% MG
cellSatMaxMG = 15000;
cellSatMinMG = -15000;
% NG
cellSatMaxNG = 1000;
cellSatMinNG = -1000;

%% Bus Def
SimulationBusDef