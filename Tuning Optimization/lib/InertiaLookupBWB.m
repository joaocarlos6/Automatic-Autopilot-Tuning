function [Mass, Inertia] = InertiaLookupBWB(CG_Loc, WithTail, FTV, MassConfig,PackageFlag)
%% InertiaLookupBWB.m
% AUTHOR : Grant Howard
% February 2, 2021
%
% MODIFIED : Stephen Warwick
% October 6, 2023
%
% Description: Use current AC configuration to lookup TMI values from
% 16Pcnt Flight Test Matrix (SIM Config Worksheet)
%
% rev = '17';


% Last row number in table containing UTail configs
UTAIL_MAX_ROW = 26;

switch FTV
    case "FTV4A"
        
        % Define location of xls doc
        if PackageFlag == 1
            fileDirTestMatrix     = [pwd+"\"];
        else
            fileDirTestMatrix     = 'R:\0080-BA-16.5PCNT BWB HWIL SIMULATION\DOCUMENTS\PICCOLO TUNING EFFORTS\';
        end
        fileNameTestMatrix    = '0062-BA-FD1-Flight Test Matrix BBA 16pcnt (Pre Flight Documentation)_.xlsm';
        
        % Set options and import config table
        valRange    = 'C6:M52';
        opts        = spreadsheetImportOptions('Sheet', 'SIM Config', 'DataRange', valRange, 'NumVariables', 11, 'VariableNamesRange', 'C5:M5');
        TMI_vals    = readtable(strcat(fileDirTestMatrix, fileNameTestMatrix), opts);
     
        % Create config name
        configName = CG_Loc + "-" + MassConfig;
         
        % Search table for correct config
        if WithTail == 1
            rowNum = find(strcmp(TMI_vals.(1)(1:UTAIL_MAX_ROW), configName));
        else
            rowNum = find(strcmp(TMI_vals.(1)(UTAIL_MAX_ROW+2:end), configName)) + UTAIL_MAX_ROW+1;
        end
        
        % Error checking
        if(isempty(rowNum))
            error("Could not find TMI data in 16Pcnt Test Matrix! Check input configuration");
        end
        
        % Copy table values to variables
        Mass    = str2double(TMI_vals.(5)(rowNum));
        Cgz     = str2double(TMI_vals.(7)(rowNum));
        Ixx     = str2double(TMI_vals.(8)(rowNum));
        Iyy     = str2double(TMI_vals.(9)(rowNum));
        Izz     = str2double(TMI_vals.(10)(rowNum));
        Ixz     = str2double(TMI_vals.(11)(rowNum));
        CgMac   = str2double(TMI_vals.(6)(rowNum));
        
        % Check data was read correctly
        if(isnan(Ixx) || isnan(Iyy) || isnan(Izz) || isnan(Ixz) || isnan(CgMac))
            error("Could not find TMI data in 16Pcnt Test Matrix! Check input configuration");
        else
            % Confirm data source
            fprintf("\nTMI values sourced from FTV Config #" + rowNum + " of SIM Config worksheet. (" + TMI_vals.(3)(rowNum) + ")\n");
        end
        
    otherwise
        error('Input FTV configuration does not exist');
end

% Assign to struct and return
Inertia.IXX     = Ixx;
Inertia.IYY     = Iyy;
Inertia.IZZ     = Izz;
Inertia.IXZ     = Ixz;
Inertia.ZCG     = Cgz;
Inertia.CgMac   = CgMac;
end
