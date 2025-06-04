% Configure aircraft model for FTV2C
% FTV 2C model Parameters
if WithTail==1   %UTAIL
    disp("* 2C UTail *");
    
	if strcmp(CGConfig,'AS_FLOWN')
		% Values as flown FTC2 2022 with UTAIL ->.\0079-BA-BWB_7Pcnt_HIL\Libraries\Configuration\FTV2C\FTV 2C UTAIL.xlsx
		xCgLocMacBWB      = 58.36;% PERCENT MAC BWB
		warning('CGConfig is configured AS_FLOWN. May wish to change to simulation configuration in ConfigureMe m-file');
		Weight                = 14.21 * 2.2;% Lbs 
		ZCG                   = 0.0191/0.0254 * (ZCGScale+1);% In inches
		IXX                   = 1.2809 * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                   = 1.7329 * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                   = 2.5699 * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                   = 0.0390 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'TBF')
        % Data from BFP experiment dated January 19, 2023
        xCgLocMacBWB          = 58.25;% PERCENT MAC BWB
		Weight                = 14.189 * 2.2;% Lbs 
		ZCG                   = 0.0124/0.0254 * (ZCGScale+1);% In inches
		IXX                   = 1.2962 * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                   = 1.5670 * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                   = 2.6715 * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                   = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs % Reuse value from FTV3D estimates in CAD
        
    elseif strcmp(CGConfig,'FWD')|| strcmp(CGConfig,'BASE')|| strcmp(CGConfig,'AFT')
        warning("Selected AC config will overwrite CG posn and use estimated (interpolated) inertias!")
        %FWD, BASE, AFT, TBF
        switch CGConfig
            case "FWD"
                xCgLocMacBWB = 57.00;% PERCENT MAC BWB
            case "BASE"
                xCgLocMacBWB = 58.25;% PERCENT MAC BWB
            case "AFT"
                xCgLocMacBWB = 59.5;% PERCENT MAC BWB
            otherwise
        end
        % Use Inertia Calculator
        [InertiaBWB, MassBWB] = InertiaEstimatorBWB(xCgLocMacBWB, WithTail, modelScale, "FTV2C_GEN2P5");
		Weight                = MassBWB * 2.2;% Lbs    
		ZCG                   = 0.0191/0.0254 * (ZCGScale+1);% In inches
		IXX                   = InertiaBWB.IXX * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                   = InertiaBWB.IYY * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                   = InertiaBWB.IZZ * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                   = InertiaBWB.IXZ * 3417.17 * (1+InertiaScale);% In-lbs  
    elseif strcmp(CGConfig,'CUSTOM')
        warning("CGConfig using xCgLocMacBWB_custom parameter, using estimated (interpolated) inertias!");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB      
        % Use Inertia Calculator
        [InertiaBWB, MassBWB] = InertiaEstimatorBWB(xCgLocMacBWB, WithTail, modelScale, "FTV2C_GEN2P5");
		Weight                = MassBWB * 2.2;% Lbs    
		ZCG                   = 0.0191/0.0254 * (ZCGScale+1);% In inches
		IXX                   = InertiaBWB.IXX * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                   = InertiaBWB.IYY * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                   = InertiaBWB.IZZ * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                   = InertiaBWB.IXZ * 3417.17 * (1+InertiaScale);% In-lbs  
	end 

elseif WithTail==0 %TAILLESS
    disp("* 2C Tailless *");
    
	if strcmp(CGConfig,'AS_FLOWN')
		% Values as flown FTC2 2020 with UTAIL ->.\0079-BA-BWB_7Pcnt_HIL\Libraries\Configuration\FTV2C\FTV 2C TAILLESS.xlsx
		xCgLocMacBWB          = 54.91;% PERCENT MAC BWB
		Weight                = 13.1784 * 2.2;% Lbs
		ZCG                   = 0.0194/0.0254 * (ZCGScale+1);% In 
		IXX                   = 1.1828 * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                   = 1.4231 * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                   = 2.3069 * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                   = 0.0350 * 3417.17 * (1+InertiaScale);% In-lbs 
		warndlg('Aircraft_Type is configured AS_FLOWN. May wish to change to simulation configuration in ConfigureMe m-file');
    
    elseif strcmp(CGConfig,'TBF')
        % Data from BFP experiment dated January 19, 2023
        xCgLocMacBWB          = 55.01;% PERCENT MAC BWB
		Weight                = 13.45 * 2.2;% Lbs 
		ZCG                   = 0.0131/0.0254 * (ZCGScale+1);% In inches
		IXX                   = 1.2282 * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                   = 1.3360 * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                   = 2.4039 * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                   = 0.0542 * 3417.17 * (1+InertiaScale);% In-lbs % Reuse value from FTV3D estimates in CAD
        
    elseif strcmp(CGConfig,'FWD')|| strcmp(CGConfig,'BASE')|| strcmp(CGConfig,'AFT')
        warning("Selected AC config will overwrite CG posn and use estimated (interpolated) inertias!")
        %FWD, BASE, AFT, TBF
        switch CGConfig
            case "FWD"
                xCgLocMacBWB = 53.75;% PERCENT MAC BWB
            case "BASE"
                xCgLocMacBWB = 55.0;% PERCENT MAC BWB
            case "AFT"
                xCgLocMacBWB = 56.25;% PERCENT MAC BWB
            otherwise
        end
         % Use Inertia Calculator
        [InertiaBWB, MassBWB] = InertiaEstimatorBWB(xCgLocMacBWB, WithTail,modelScale, "FTV2C");
	    Weight                = MassBWB * 2.2;% Lbs
		ZCG                   = 0.0179/0.0254 * (ZCGScale+1);% In 
		IXX                   = InertiaBWB.IXX * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                   = InertiaBWB.IYY * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                   = InertiaBWB.IZZ * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                   = InertiaBWB.IXZ * 3417.17 * (1+InertiaScale);% In-lbs 
    elseif strcmp(CGConfig,'CUSTOM')
        warning("CGConfig using xCgLocMacBWB_custom parameter, using estimated (interpolated) inertias!");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB  
        [InertiaBWB, MassBWB] = InertiaEstimatorBWB(xCgLocMacBWB, WithTail,modelScale, "FTV2C");
	    Weight                = MassBWB * 2.2;% Lbs
		ZCG                   = 0.0179/0.0254 * (ZCGScale+1);% In 
		IXX                   = InertiaBWB.IXX * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                   = InertiaBWB.IYY * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                   = InertiaBWB.IZZ * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                   = InertiaBWB.IXZ * 3417.17 * (1+InertiaScale);% In-lbs 
	end

end

if(exist('Aircraft_Mass_Config', 'var'))
    if strcmp(Aircraft_Mass_Config,'CUSTOM')
        warning("Aircraft Mass Config set to CUSTOM and overriden. Inertia assumed to be that of base TBF configuration")
        Weight = MassBWB_custom * 2.2;% Lbs 
    end
end