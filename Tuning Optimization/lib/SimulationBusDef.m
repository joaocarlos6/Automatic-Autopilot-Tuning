%% SimulationBusDef.m
% AUTHOR : Grant Howard
% MODIFIED : Grant Howard
% December 5, 2023
% Description:
% A common script to define bus objects for use in simulation and auto-coding

% WOW Bus Defs
%% DSC FLAG signals
% Specify elements
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'TEMPUR';
busElements(1).DataType = 'boolean';
%
busElements(2) = Simulink.BusElement;
busElements(2).Name = 'TEMPOR';
busElements(2).DataType = 'boolean';
%
busElements(3) = Simulink.BusElement;
busElements(3).Name = 'ECOMUR';
busElements(3).DataType = 'boolean';
%
busElements(4) = Simulink.BusElement;
busElements(4).Name = 'ECOMOR';
busElements(4).DataType = 'boolean';
%
busElements(5) = Simulink.BusElement;
busElements(5).Name = 'CRAWUR';
busElements(5).DataType = 'boolean';
%
busElements(6) = Simulink.BusElement;
busElements(6).Name = 'CRAWOR';
busElements(6).DataType = 'boolean';
%
busElements(7) = Simulink.BusElement;
busElements(7).Name = 'SYSUR';
busElements(7).DataType = 'boolean';
%
busElements(8) = Simulink.BusElement;
busElements(8).Name = 'SYSOR';
busElements(8).DataType = 'boolean';
%
busElements(9) = Simulink.BusElement;
busElements(9).Name = 'LCINTEG';
busElements(9).DataType = 'boolean';
%
busElements(10) = Simulink.BusElement;
busElements(10).Name = 'WDRST';
busElements(10).DataType = 'boolean';
%
busElements(11) = Simulink.BusElement;
busElements(11).Name = 'BRWNOUT';
busElements(11).DataType = 'boolean';
%
busElements(12) = Simulink.BusElement;
busElements(12).Name = 'REBOOT';
busElements(12).DataType = 'boolean';
%
busElements(13) = Simulink.BusElement;
busElements(13).Name = 'LOWER_FLAGS';
busElements(13).DataType = 'boolean';
% Define bus object with above elements
FLAG_SIGNAL_BUS = Simulink.Bus;
FLAG_SIGNAL_BUS.Elements = busElements;
clear busElements;

%% STAT Signals
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'IPSTAT';
busElements(1).DataType = 'boolean';
%
busElements(2) = Simulink.BusElement;
busElements(2).Name = 'TEMPUR';
busElements(2).DataType = 'boolean';
%
busElements(3) = Simulink.BusElement;
busElements(3).Name = 'TEMPOR';
busElements(3).DataType = 'boolean';
%
busElements(4) = Simulink.BusElement;
busElements(4).Name = 'ECOMUR';
busElements(4).DataType = 'boolean';
%
busElements(5) = Simulink.BusElement;
busElements(5).Name = 'ECOMOR';
busElements(5).DataType = 'boolean';
%
busElements(6) = Simulink.BusElement;
busElements(6).Name = 'CRAWUR';
busElements(6).DataType = 'boolean';
%
busElements(7) = Simulink.BusElement;
busElements(7).Name = 'CRAWOR';
busElements(7).DataType = 'boolean';
%
busElements(8) = Simulink.BusElement;
busElements(8).Name = 'SYSUR';
busElements(8).DataType = 'boolean';
%
busElements(9) = Simulink.BusElement;
busElements(9).Name = 'SYSOR';
busElements(9).DataType = 'boolean';
%
busElements(10) = Simulink.BusElement;
busElements(10).Name = 'LCINTEG';
busElements(10).DataType = 'boolean';
%
busElements(11) = Simulink.BusElement;
busElements(11).Name = 'SCALON';
busElements(11).DataType = 'boolean';
%
busElements(12) = Simulink.BusElement;
busElements(12).Name = 'OLDVAL';
busElements(12).DataType = 'boolean';
%
STAT_SIGNAL_BUS = Simulink.Bus;
STAT_SIGNAL_BUS.Elements = busElements;
clear busElements;

%% Health Signals
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'INVALID';
busElements(1).DataType = 'boolean';
%
busElements(2) = Simulink.BusElement;
busElements(2).Name = 'IN_FLIGHT_BIAS';
busElements(2).DataType = 'boolean';
%
busElements(3) = Simulink.BusElement;
busElements(3).Name = 'FINAL_BIAS';
busElements(3).DataType = 'boolean';
%
busElements(4) = Simulink.BusElement;
busElements(4).Name = 'LOAD_TIMEOUT';
busElements(4).DataType = 'boolean';
%
busElements(5) = Simulink.BusElement;
busElements(5).Name = 'FLAG_TIMEOUT';
busElements(5).DataType = 'boolean';
%
busElements(6) = Simulink.BusElement;
busElements(6).Name = 'FLAG_ERROR';
busElements(6).DataType = 'boolean';
%
busElements(7) = Simulink.BusElement;
busElements(7).Name = 'ACTIVE';
busElements(7).DataType = 'boolean';
%
busElements(8) = Simulink.BusElement;
busElements(8).Name = 'FAIL';
busElements(8).DataType = 'boolean';
%
% Define bus object with above elements
HEALTH_SIGNAL_BUS = Simulink.Bus;
HEALTH_SIGNAL_BUS.Elements = busElements;
clear busElements;

%% Top-level Gear Input
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'WOW_N';
busElements(1).DataType = 'single';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'TARE_N';
busElements(2).DataType = 'single';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'DSC_FLAG_WORD';
busElements(3).DataType = 'uint16';

busElements(4) = Simulink.BusElement;
busElements(4).Name = 'DSC_STAT_WORD';
busElements(4).DataType = 'uint16';

busElements(5) = Simulink.BusElement;
busElements(5).Name = "STALE_LOAD";
busElements(5).DataType = 'boolean';

busElements(6) = Simulink.BusElement;
busElements(6).Name = "STALE_FLAGS";
busElements(6).DataType = 'boolean';

GEAR_INPUT_BUS = Simulink.Bus;
GEAR_INPUT_BUS.Elements = busElements;
clear busElements

%% Top-level Gear Output
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'WOW_FILT_N';
busElements(1).DataType = 'single';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'TARE_N';
busElements(2).DataType = 'single';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'RESET_REQUEST';
busElements(3).DataType = 'boolean';

busElements(4) = Simulink.BusElement;
busElements(4).Name = 'Health';
busElements(4).DataType = 'HEALTH_SIGNAL_BUS';

busElements(5) = Simulink.BusElement;
busElements(5).Name = 'Flag';
busElements(5).DataType = 'FLAG_SIGNAL_BUS';

busElements(6) = Simulink.BusElement;
busElements(6).Name = 'Stat';
busElements(6).DataType = 'STAT_SIGNAL_BUS';

GEAR_OUTPUT_BUS = Simulink.Bus;
GEAR_OUTPUT_BUS.Elements = busElements;
clear busElements

%% User Commands
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'SAMPLE';
busElements(1).DataType = 'boolean';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'TARE';
busElements(2).DataType = 'boolean';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'MSG_ENABLE';
busElements(3).DataType = 'boolean';

busElements(4) = Simulink.BusElement;
busElements(4).Name = 'OVERRIDE_ENABLE';
busElements(4).DataType = 'boolean';

busElements(5) = Simulink.BusElement;
busElements(5).Name = 'OVERRIDE_VALUE';
busElements(5).DataType = 'boolean';

USER_CMD_BUS = Simulink.Bus;
USER_CMD_BUS.Elements = busElements;
clear busElements

%% Detection Logic Status
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'CONTACT';
busElements(1).DataType = 'boolean';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'WOW_PCNT';
busElements(2).DataType = 'uint8';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'IS_LANDING_MODE';
busElements(3).DataType = 'boolean';

busElements(4) = Simulink.BusElement;
busElements(4).Name = 'LANDING_FAIL_L';
busElements(4).DataType = 'boolean';

busElements(5) = Simulink.BusElement;
busElements(5).Name = 'LANDING_FAIL_R';
busElements(5).DataType = 'boolean';

busElements(6) = Simulink.BusElement;
busElements(6).Name = 'TAKEOFF_FAIL_L';
busElements(6).DataType = 'boolean';

busElements(7) = Simulink.BusElement;
busElements(7).Name = 'TAKEOFF_FAIL_R';
busElements(7).DataType = 'boolean';

DETECTION_BUS = Simulink.Bus;
DETECTION_BUS.Elements = busElements;
clear busElements

%% SensorModel Bus for use with Unit Testing
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'loadThresholdUpper_N';
busElements(1).DataType = 'single';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'loadThresholdLower_N';
busElements(2).DataType = 'single';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'persistanceTime_s';
busElements(3).DataType = 'single';

busElements(4) = Simulink.BusElement;
busElements(4).Name = 'longLatchTime_s';
busElements(4).DataType = 'single';

busElements(5) = Simulink.BusElement;
busElements(5).Name = 'shortLatchTime_s';
busElements(5).DataType = 'single';

busElements(6) = Simulink.BusElement;
busElements(6).Name = 'timeout_s';
busElements(6).DataType = 'single';

busElements(7) = Simulink.BusElement;
busElements(7).Name = 'TO_loadThreshold_N';
busElements(7).DataType = 'single';

busElements(8) = Simulink.BusElement;
busElements(8).Name = 'TO_persistanceTime_s';
busElements(8).DataType = 'single';

busElements(9) = Simulink.BusElement;
busElements(9).Name = 'TO_latchTime_s';
busElements(9).DataType = 'single';

busElements(10) = Simulink.BusElement;
busElements(10).Name = 'SaturationUpper';
busElements(10).DataType = 'single';

busElements(11) = Simulink.BusElement;
busElements(11).Name = 'SaturationLower';
busElements(11).DataType = 'single';

busElements(12) = Simulink.BusElement;
busElements(12).Name = 'LOAD_TIMEOUT_COUNTS';
busElements(12).DataType = 'uint8';

busElements(13) = Simulink.BusElement;
busElements(13).Name = 'FLAG_TIMEOUT_COUNTS';
busElements(13).DataType = 'uint8';

busElements(14) = Simulink.BusElement;
busElements(14).Name = 'INVALID_COUNTS';
busElements(14).DataType = 'uint8';

busElements(15) = Simulink.BusElement;
busElements(15).Name = 'FLAG_COUNTS';
busElements(15).DataType = 'uint8';

busElements(16) = Simulink.BusElement;
busElements(16).Name = 'satMaxMG';
busElements(16).DataType = 'single';

busElements(17) = Simulink.BusElement;
busElements(17).Name = 'satMinMG';
busElements(17).DataType = 'single';

busElements(18) = Simulink.BusElement;
busElements(18).Name = 'satMaxNG';
busElements(18).DataType = 'single';

busElements(19) = Simulink.BusElement;
busElements(19).Name = 'satMinNG';
busElements(19).DataType = 'single';

busElements(20) = Simulink.BusElement;
busElements(20).Name = 'satMaxMGWheel';
busElements(20).DataType = 'single';

busElements(21) = Simulink.BusElement;
busElements(21).Name = 'satMinMGWheel';
busElements(21).DataType = 'single';

busElements(22) = Simulink.BusElement;
busElements(22).Name = 'satMaxNGWheel';
busElements(22).DataType = 'single';

busElements(23) = Simulink.BusElement;
busElements(23).Name = 'satMinNGWheel';
busElements(23).DataType = 'single';

busElements(24) = Simulink.BusElement;
busElements(24).Name = 'dt';
busElements(24).DataType = 'single';

busElements(25) = Simulink.BusElement;
busElements(25).Name = 'dt_ms';
busElements(25).DataType = 'uint8';

busElements(26) = Simulink.BusElement;
busElements(26).Name = 'fc';
busElements(26).DataType = 'uint16';

SensorModel_Bus = Simulink.Bus;
SensorModel_Bus.Elements = busElements;
clear busElements;