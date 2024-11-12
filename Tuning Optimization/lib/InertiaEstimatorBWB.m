function [Inertia,Mass] = InertiaEstimatorBWB(xCgLocMacBWB, WithTail, modelScale, FTV)
%% InertiaCalculatorBWB.m
% AUTHOR :Stephen Warwick
% MODIFIED: Grant Howard
% November 23, 2020
  rev = '73';
  build = '1';
% Description: 

switch FTV
    case "FTV3C"
        if WithTail == 1
            m   = 14.703;  %kg 
            Ixx = 1.4178; %kg*m^2
            Iyy = -0.0786 * xCgLocMacBWB + 6.0874;
            Izz = -0.0786 * xCgLocMacBWB + 7.5605;
            Ixz = -0.00106 * xCgLocMacBWB + 0.1157;
        elseif WithTail == 0
            m   = 13.875;  %kg 
            Ixx = 1.391; %kg*m^2
            Iyy = -0.0689 * xCgLocMacBWB + 5.0315;
            Izz = -0.0689 * xCgLocMacBWB + 6.4312;
            Ixz = -0.0009 * xCgLocMacBWB + 0.1034;
        end
        
    case "FTV2C"
        if WithTail == 1
            m   = 13.9884;  %kg 
            Ixx = 1.2456; %kg*m^2
            Iyy = (-0.06003 * xCgLocMacBWB + 5.2154);
            Izz = (-0.06001 * xCgLocMacBWB + 6.1557);
            Ixz = 0.039;
        elseif WithTail == 0
            m   = 13.1784;
            Ixx = 1.1828;
            Iyy = -0.05333 * xCgLocMacBWB + 4.3525;
            Izz = -0.05329 * xCgLocMacBWB + 5.23421;
            Ixz = 0.035;
        end
    case "FTV2C_GEN2P5"
        if WithTail == 1
            %Mass as measured TBF for April 2022
            m   = 14.2;  %kg
            %Inertia estimates are from October 2020 Configuration.
            Ixx = 1.2456; %kg*m^2
            Iyy = (-0.06003 * xCgLocMacBWB + 5.2154);
            Izz = (-0.06001 * xCgLocMacBWB + 6.1557);
            Ixz = 0.039;
        elseif WithTail == 0
            m   = 13.1784;
            Ixx = 1.1828;
            Iyy = -0.05333 * xCgLocMacBWB + 4.3525;
            Izz = -0.05329 * xCgLocMacBWB + 5.23421;
            Ixz = 0.035;
        end
    otherwise
        error('Input FTV configuration does not exist');
end

Inertia.IXX = Ixx;
Inertia.IYY = Iyy;
Inertia.IZZ = Izz;
Inertia.IXZ = Ixz;
Mass = m;
end
