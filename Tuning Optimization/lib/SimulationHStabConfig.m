%% SimulationHStabConfig.m
% AUTHOR : Joao Figueira
% MODIFIED:
% March 11, 2025
% Description: Used to set H-Stab Interface parameters and bus definitions

%% SIMULATION OPTION
AutoTrim_On = 1; % 1 to enable auto-trim; 0 to disable

if isempty(HStab)
    SimulationAircraftConfig
end
% H-Stab initial position is set with variable HStab defined in
% SimulationAircraftConfig.m

%% Control Logic Parameters
% Logic Configuration
HStabSystem.InitSP = Trim_REFSI_FD_IN_nmodeStabCmd; % deg
HStabSystem.CmdRate = 2; % deg/s
HStabSystem.KI = 0.11; 
HStabSystem.LPFalpha = 0.20735;

% Failure Detection
HStabSystem.LimitUpper = 9; % deg
HStabSystem.LimitLower = -7; % deg
HStabSystem.PosTol = 0.5; % deg
HStabSystem.ElvDivUpper = 15; % deg
HStabSystem.ElvDivLower = -15; % deg

%% BUS DEFINITIONS
%% MSG_Statues
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'GS_status';
busElements(1).DataType = 'boolean';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'pitch_cmd_status';
busElements(2).DataType = 'boolean';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'Piccolo_msg_status';
busElements(3).DataType = 'boolean';

busElements(4) = Simulink.BusElement;
busElements(4).Name = 'APM_msg_status';
busElements(4).DataType = 'boolean';

busElements(5) = Simulink.BusElement;
busElements(5).Name = 'Left_Stab_Status';
busElements(5).DataType = 'boolean';

busElements(6) = Simulink.BusElement;
busElements(6).Name = 'Right_Stab_Status';
busElements(6).DataType = 'boolean';

Msg_Statuts_Bus = Simulink.Bus;
Msg_Statuts_Bus.Elements = busElements;
clear busElements;

%% Fail Flag
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'Left_Surf_Status';
busElements(1).DataType = 'boolean';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'Right_Surf_Status';
busElements(2).DataType = 'boolean';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'AT_Status';
busElements(3).DataType = 'boolean';

busElements(4) = Simulink.BusElement;
busElements(4).Name = 'Elv_Cmd_Rcv';
busElements(4).DataType = 'boolean';

busElements(5) = Simulink.BusElement;
busElements(5).Name = 'Stab_Cmd_Rcv';
busElements(5).DataType = 'boolean';

busElements(6) = Simulink.BusElement;
busElements(6).Name = 'APM_Rcv';
busElements(6).DataType = 'boolean';

busElements(7) = Simulink.BusElement;
busElements(7).Name = 'Mode_Cmd_Rcv';
busElements(7).DataType = 'boolean';

Fail_Flag_Bus = Simulink.Bus;
Fail_Flag_Bus.Elements = busElements;
clear busElements;

%% APM Inputs
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'Pic_Mode';
busElements(1).DataType = 'uint8';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'Pic_GlobalOn';
busElements(2).DataType = 'boolean';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'NRC_Control_Active';
busElements(3).DataType = 'boolean';

busElements(4) = Simulink.BusElement;
busElements(4).Name = 'APM_Rcv';
busElements(4).DataType = 'boolean';

APM_Bus = Simulink.Bus;
APM_Bus.Elements = busElements;
clear busElements;

%% Right Servo Feedback
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'RStab_Pos';
busElements(1).DataType = 'single';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'RStab_Status';
busElements(2).DataType = 'boolean';

RServo_FB = Simulink.Bus;
RServo_FB.Elements = busElements;
clear busElements;

%% Left Servo Feedback
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'LStab_Pos';
busElements(1).DataType = 'single';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'LStab_Status';
busElements(2).DataType = 'boolean';

LServo_FB = Simulink.Bus;
LServo_FB.Elements = busElements;
clear busElements;

%% Requests to Servo
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'REQ_READ';
busElements(1).DataType = 'boolean';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'REQ_NEW_L';
busElements(2).DataType = 'boolean';

busElements(3) = Simulink.BusElement;
busElements(3).Name = 'REQ_NEW_R';
busElements(3).DataType = 'boolean';

Servo_Request = Simulink.Bus;
Servo_Request.Elements = busElements;
clear busElements;

%% H-Stab Mode
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'Mode_Cmd_Data';
busElements(1).DataType = 'uint8';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'Mode_Cmd_Rcv';
busElements(2).DataType = 'boolean';

Mode_Cmd = Simulink.Bus;
Mode_Cmd.Elements = busElements;
clear busElements;

%% Position Cmd
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'Stab_Cmd_Data';
busElements(1).DataType = 'single';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'Stab_Cmd_Rcv';
busElements(2).DataType = 'boolean';

HStab_Cmd = Simulink.Bus;
HStab_Cmd.Elements = busElements;
clear busElements;

%% Elv Cmd
busElements(1) = Simulink.BusElement;
busElements(1).Name = 'Elv_Cmd_Data';
busElements(1).DataType = 'single';

busElements(2) = Simulink.BusElement;
busElements(2).Name = 'Elv_Cmd_Rcv';
busElements(2).DataType = 'boolean';

ELV_Cmd = Simulink.Bus;
ELV_Cmd.Elements = busElements;
clear busElements;

