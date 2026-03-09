% Configure aircraft model for FTV3F
% FTV 3F model Parameters 
if WithTail==1   %UTAIL
    disp("* 3F UTail *");
        
    if strcmp(CGConfig,'TBF')
        % TO BE FLOWN, from BBD FTC8 Vehicle Configuration Release
        % (0073-FTV3F) 2024-05-01, updated with 
        % From TMI release November 27 2024, FTV3F UTAIL TMI CALCULATOR_REV2.xlsx
        xCgLocMacBWB      = 61.6;% PERCENT MAC BWB
        Weight            = 14.8892 * 2.2;% Lbs 
        ZCG               = 0.0096 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.3750 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.3439 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.5851 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'FWD')|| strcmp(CGConfig,'BASE')|| strcmp(CGConfig,'AFT')
        %FWD, BASE, AFT, TBF
        switch CGConfig
            case "FWD"
                xCgLocMacBWB = 59.11;% PERCENT MAC BWB
            case "BASE"
                xCgLocMacBWB = 59.94;% PERCENT MAC BWB
            case "AFT"
                xCgLocMacBWB = 61.6;% PERCENT MAC BWB
            otherwise
                error("something wrong with xCgLocMac parameter selection");
        end
        % Use expirmental inertia
        % From TMI release November 27 2024, FTV3F UTAIL TMI CALCULATOR_REV2.xlsx
        Weight            = 14.8892 * 2.2;% Lbs 
        ZCG               = 0.0096 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.3750 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = ((-0.055*xCgLocMacBWB) + 4.7342) * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = ((-0.055*xCgLocMacBWB) + 5.9754) * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
               
    elseif isnumeric(CGConfig)
        xCgLocMacBWB = CGConfig;% PERCENT MAC BWB
        % From TMI release November 27 2024, FTV3F UTAIL TMI CALCULATOR_REV2.xlsx
        Weight            = 14.8892 * 2.2;% Lbs 
        ZCG               = 0.0096 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.3750 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = ((-0.055*xCgLocMacBWB) + 4.7342) * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = ((-0.055*xCgLocMacBWB) + 5.9754) * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'CUSTOM')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        warning("CGConfig using xCgLocMacBWB_custom parameter");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB
        % Use expirmental inertia
        % TO BE FLOWN, from BFP data obtained 2023-11-23
        Weight            = 14.8892 * 2.2;% Lbs 
        ZCG               = 0.0096 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.3750 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = ((-0.055*xCgLocMacBWB) + 4.7342) * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = ((-0.055*xCgLocMacBWB) + 5.9754) * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
    else
        error("something wrong with CGConfig parameter selection");
    end

elseif WithTail==0 %TAILLESS
    disp("* 3F Tailless *");
      if strcmp(CGConfig,'TBF')
        % From TMI release April 24 2025, FTV3F TAILLESS TMI CALCULATOR_REV0.xlsx
        xCgLocMacBWB      = 58.77;% PERCENT MAC BWB
        Weight            = 14.2520 * 2.2;% Lbs 
        ZCG               = 0.0124 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.3557 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.1525 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.3577 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'FWD')|| strcmp(CGConfig,'BASE')|| strcmp(CGConfig,'AFT')
        %FWD, BASE, AFT, TBF
        switch CGConfig
            case "FWD"
                xCgLocMacBWB = 54.94;% PERCENT MAC BWB
            case "BASE"
                xCgLocMacBWB = 56.61;% PERCENT MAC BWB
            case "AFT"
                xCgLocMacBWB = 58.77;% PERCENT MAC BWB
            otherwise
                error("something wrong with xCgLocMac parameter selection");
        end
        % From TMI release April 24 2025, FTV3F TAILLESS TMI CALCULATOR_REV0.xlsx
        Weight            = 14.2520 * 2.2;% Lbs  
        ZCG               = 0.0124 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.3557 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = (0.0029 * xCgLocMacBWB^2  - 0.3827 * xCgLocMacBWB + 13.479) * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = (0.0029 * xCgLocMacBWB^2  - 0.3827 * xCgLocMacBWB + 14.684) * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
               
    elseif isnumeric(CGConfig)
        xCgLocMacBWB = CGConfig;% PERCENT MAC BWB
        % From TMI release April 24 2025, FTV3F TAILLESS TMI CALCULATOR_REV0.xlsx
        Weight            = 14.2520 * 2.2;% Lbs 
        ZCG               = 0.0124 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.3557 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = (0.0029 * xCgLocMacBWB^2  - 0.3827 * xCgLocMacBWB + 13.479) * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = (0.0029 * xCgLocMacBWB^2  - 0.3827 * xCgLocMacBWB + 14.684) * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
      end
end

if(exist('Aircraft_Mass_Config', 'var'))
    if strcmp(Aircraft_Mass_Config,'CUSTOM')
        warning("Aircraft Mass Config set to CUSTOM and overriden. Inertia assumed to be that of base TBF configuration")
        Weight = MassBWB_custom * 2.2;% Lbs 
    end
end
    
