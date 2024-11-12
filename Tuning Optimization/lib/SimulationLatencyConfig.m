%% InitModelLatency.m
% AUTHOR :Stephen Warwick
% MODIFIED: Grant Howard
% December 16, 2021
%   rev = '16';
% Description:  
% Script to define the latency of parameters specific to the SIL/HIL
% simulations.

SensorModel.GPSmodel.GPSNovatel7PositionLatency_ms = 0.040;
SensorModel.GPSmodel.GPSNovatel7VelocityLatency_ms = 0.040;
% SensorModel.GPSmodel.GPSUBlox6PositionLatency_ms = 0.100;
% SensorModel.GPSmodel.GPSUBlox6VelocityLatency_ms = 0.200;
ActuatorModel.SurfaceLatency    = 0.015 ; % Latency in seconds imposed on control surfaces Default shipped value 0.01. Note HWIL addes ~ 10ms latency
ActuatorModel.ActuatorHBL6625ResponseDelay     = 0.015 ;% Latency in seconds imposed on control actuator Default shipped value 0.0132
ActuatorModel.ActuatorCBS20ResponseDelay       = 0.018; % Latency in seconds imposed on control actuator Default shipped value 0.0180
ActuatorModel.ActuatorCBS15ResponseDelay       = 0.018; % Latency in seconds imposed on control actuator Default shipped value 0.0180
ActuatorModel.ActuatorHitecSG33BLResponseDelay = 0.020; % Latency in seconds imposed on control actuator Default shipped value 0.0200
ActuatorModel.PropulsionJetCatLatency          = 0.100; % Latency in seconds imposed on control actuator Default shipped value 0.1000
ActuatorModel.PropulsionEDFLatency             = 0.100; % Latency in seconds imposed on control actuator Default shipped value 0.1000
ActuatorModel.BrakeLatency                     = 0.200; % Latency in seconds imposed on control actuator Default shipped value 0.2000
SensorModel.IMU.PicIMULatency_ms               = 0.012; % Latency in seconds imposed on control actuator Default shipped value 0.0120% 

%% Calculate Latency
SensorModel.IMU.PicIMULatency                  = SensorModel.IMU.PicIMULatency_ms; % Number of simulink iterations
SensorModel.GPSmodel.GPSPositionLatency        = SensorModel.GPSmodel.GPSNovatel7PositionLatency_ms ; % Number of simulink iterations
SensorModel.GPSmodel.GPSVelocityLatency        = SensorModel.GPSmodel.GPSNovatel7VelocityLatency_ms ; % Number of simulink iterations

if simulatorMode == "SIL_External"
    SILCANLatency    = 0.020;
    ActuatorModel.SurfaceLatency                   = ActuatorModel.SurfaceLatency - SILCANLatency + AdditionalLatency; 
    ActuatorModel.ActuatorHBL6625ResponseDelay     = ActuatorModel.ActuatorHBL6625ResponseDelay - SILCANLatency + AdditionalLatency;
    ActuatorModel.ActuatorCBS20ResponseDelay       = ActuatorModel.ActuatorCBS20ResponseDelay  - SILCANLatency + AdditionalLatency;
    ActuatorModel.ActuatorCBS15ResponseDelay       = ActuatorModel.ActuatorCBS15ResponseDelay  - SILCANLatency + AdditionalLatency;
    ActuatorModel.ActuatorHitecSG33BLResponseDelay = ActuatorModel.ActuatorHitecSG33BLResponseDelay - SILCANLatency + AdditionalLatency;
    ActuatorModel.PropulsionJetCatLatency          = ActuatorModel.PropulsionJetCatLatency - SILCANLatency + AdditionalLatency;
    ActuatorModel.PropulsionEDFLatency             = ActuatorModel.PropulsionEDFLatency - SILCANLatency + AdditionalLatency;
    ActuatorModel.BrakeLatency                     = ActuatorModel.BrakeLatency  - SILCANLatency + AdditionalLatency;
    SensorModel.GPSmodel.GPSPositionLatency        = round((SensorModel.GPSmodel.GPSPositionLatency - SILCANLatency + AdditionalLatency)/dt); % Number of simulink iterations
    SensorModel.GPSmodel.GPSVelocityLatency        = round((SensorModel.GPSmodel.GPSVelocityLatency - SILCANLatency + AdditionalLatency)/dt); % Number of simulink iterations
%     SensorModel.IMU.PicIMULatency                  = round((SensorModel.IMU.PicIMULatency - SILCANLatency + AdditionalLatency)/dt); % Estimate of Piccolo IMU Sensor Latency
elseif simulatorMode == "Desktop"
    DesktopLatency    = 0.00;
    ActuatorModel.SurfaceLatency                   = ActuatorModel.SurfaceLatency - DesktopLatency + AdditionalLatency; 
    ActuatorModel.ActuatorHBL6625ResponseDelay     = ActuatorModel.ActuatorHBL6625ResponseDelay - DesktopLatency + AdditionalLatency;
    ActuatorModel.ActuatorCBS20ResponseDelay       = ActuatorModel.ActuatorCBS20ResponseDelay  - DesktopLatency + AdditionalLatency;
    ActuatorModel.ActuatorCBS15ResponseDelay       = ActuatorModel.ActuatorCBS15ResponseDelay  - DesktopLatency + AdditionalLatency;
    ActuatorModel.ActuatorHitecSG33BLResponseDelay = ActuatorModel.ActuatorHitecSG33BLResponseDelay - DesktopLatency + AdditionalLatency;
    ActuatorModel.PropulsionJetCatLatency          = ActuatorModel.PropulsionJetCatLatency - DesktopLatency + AdditionalLatency;
    ActuatorModel.PropulsionEDFLatency             = ActuatorModel.PropulsionEDFLatency - DesktopLatency + AdditionalLatency;
    ActuatorModel.BrakeLatency                     = ActuatorModel.BrakeLatency  - DesktopLatency + AdditionalLatency;
    SensorModel.GPSmodel.GPSPositionLatency        = round((SensorModel.GPSmodel.GPSPositionLatency - DesktopLatency + AdditionalLatency)/dt); % Number of simulink iterations
    SensorModel.GPSmodel.GPSVelocityLatency        = round((SensorModel.GPSmodel.GPSVelocityLatency - DesktopLatency + AdditionalLatency)/dt); % Number of simulink iterations
    SensorModel.IMU.PicIMULatency                  = round((SensorModel.IMU.PicIMULatency - DesktopLatency + AdditionalLatency)/dt); % Estimate of Piccolo IMU Sensor Latency
else
    HILCANLatency    = 0.015; % Latency in seconds HIL Inherently adds to Actuator Commands,IMU data, GPS data, and all other sensors
    ActuatorModel.SurfaceLatency                   = ActuatorModel.SurfaceLatency - HILCANLatency + AdditionalLatency; % Latency in seconds imposed on control surfaces Default shipped value 0.01. Note HWIL addes ~ 10ms latency
    ActuatorModel.ActuatorHBL6625ResponseDelay     = ActuatorModel.ActuatorHBL6625ResponseDelay - HILCANLatency + AdditionalLatency;% Latency in seconds imposed on control actuator Default shipped value 0.0132
    ActuatorModel.ActuatorCBS20ResponseDelay       = ActuatorModel.ActuatorCBS20ResponseDelay - HILCANLatency + AdditionalLatency; % Latency in seconds imposed on control actuator Default shipped value 0.0180
    ActuatorModel.ActuatorCBS15ResponseDelay       = ActuatorModel.ActuatorCBS15ResponseDelay - HILCANLatency + AdditionalLatency; % Latency in seconds imposed on control actuator Default shipped value 0.0180
    ActuatorModel.ActuatorHitecSG33BLResponseDelay = ActuatorModel.ActuatorHitecSG33BLResponseDelay - HILCANLatency + AdditionalLatency;  % Latency in seconds imposed on control actuator Default shipped value 0.0200
    ActuatorModel.PropulsionJetCatLatency          = ActuatorModel.PropulsionJetCatLatency - HILCANLatency + AdditionalLatency;
    ActuatorModel.PropulsionEDFLatency             = ActuatorModel.PropulsionEDFLatency - HILCANLatency + AdditionalLatency;
    ActuatorModel.BrakeLatency                     = ActuatorModel.BrakeLatency - HILCANLatency + AdditionalLatency;
    SensorModel.GPSmodel.GPSPositionLatency        = round((SensorModel.GPSmodel.GPSPositionLatency - HILCANLatency + AdditionalLatency)/dt); % Number of simulink iterations
    SensorModel.GPSmodel.GPSVelocityLatency        = round((SensorModel.GPSmodel.GPSVelocityLatency - HILCANLatency + AdditionalLatency)/dt); % Number of simulink iterations
%     SensorModel.IMU.PicIMULatency                  = round((SensorModel.IMU.PicIMULatency - HILCANLatency + AdditionalLatency)/dt); % Number of simulink iterations
end

%% Check to make sure values which break the model have been generated.
if ActuatorModel.SurfaceLatency <= DLLSim.SimDt
    ActuatorModel.SurfaceLatency = 0;
end
if ActuatorModel.ActuatorHBL6625ResponseDelay <= DLLSim.SimDt
    ActuatorModel.ActuatorHBL6625ResponseDelay = 0;
end
if ActuatorModel.ActuatorCBS20ResponseDelay <= DLLSim.SimDt
    ActuatorModel.ActuatorCBS20ResponseDelay = 0;
end
if ActuatorModel.ActuatorCBS15ResponseDelay <= DLLSim.SimDt
    ActuatorModel.ActuatorCBS15ResponseDelay = 0;
end
if ActuatorModel.ActuatorHitecSG33BLResponseDelay <= DLLSim.SimDt
    ActuatorModel.ActuatorHitecSG33BLResponseDelay = 0;
end
if ActuatorModel.PropulsionJetCatLatency <= DLLSim.SimDt
    ActuatorModel.PropulsionJetCatLatency = 0;
end
if ActuatorModel.PropulsionEDFLatency <= DLLSim.SimDt
    ActuatorModel.PropulsionEDFLatency = 0;
end
if ActuatorModel.BrakeLatency <= DLLSim.SimDt
    ActuatorModel.BrakeLatency = 0;
end
if SensorModel.GPSmodel.GPSPositionLatency < 0
    SensorModel.GPSmodel.GPSPositionLatency = 0;
end
if SensorModel.GPSmodel.GPSVelocityLatency < 0
    SensorModel.GPSmodel.GPSVelocityLatency = 0;
end
if SensorModel.IMU.PicIMULatency < 0
    SensorModel.IMU.PicIMULatency = 0;
end