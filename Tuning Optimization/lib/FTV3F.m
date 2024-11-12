% Configure aircraft model for FTV3F
% FTV 3F model Parameters 
if WithTail==1   %UTAIL
    % disp("* 3F UTail *");
    
    
    if strcmp(CGConfig,'TBF')
        % TO BE FLOWN, from BBD FTC8 Vehicle Configuration Release
        % (0073-FTV3F) 2024-05-01, updated with 
        %TMI release August 16 2024, FTV3F UTAIL TMI CALCULATOR_REV0.xlsx
        xCgLocMacBWB      = 59.0;% PERCENT MAC BWB
        Weight            = 14.6170 * 2.2;% Lbs 
        ZCG               = 0.0113 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.3740 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.4881 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.7295 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'FWD')|| strcmp(CGConfig,'BASE')|| strcmp(CGConfig,'AFT')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        %FWD, BASE, AFT, TBF
        switch CGConfig
            case "FWD"
                xCgLocMacBWB = 57.75;% PERCENT MAC BWB
            case "BASE"
                xCgLocMacBWB = 59.00;% PERCENT MAC BWB
            case "AFT"
                xCgLocMacBWB = 60.25;% PERCENT MAC BWB
            otherwise
                error("something wrong with xCgLocMac parameter selection");
        end
        % Use expirmental inertia
        % From TMI release August 16 2024, FTV3F UTAIL TMI CALCULATOR_REV0.xlsx
        Weight            = 14.6170 * 2.2;% Lbs 
        ZCG               = 0.0090 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.37401 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = ((-0.0658*xCgLocMacBWB) + 5.37774) * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = ((-0.0658*xCgLocMacBWB) + 6.61917) * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
               
    elseif isnumeric(CGConfig)
        xCgLocMacBWB = CGConfig;% PERCENT MAC BWB
        % From TMI release August 16 2024, FTV3F UTAIL TMI CALCULATOR_REV0.xlsx
        Weight            = 14.6170 * 2.2;% Lbs 
        ZCG               = 0.0090 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.37401 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = ((-0.0658*xCgLocMacBWB) + 5.37774) * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = ((-0.0658*xCgLocMacBWB) + 6.61917) * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'CUSTOM')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        warning("CGConfig using xCgLocMacBWB_custom parameter");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB
        % Use expirmental inertia
        % TO BE FLOWN, from BFP data obtained 2023-11-23
        Weight            = 14.6170 * 2.2;% Lbs 
        ZCG               = 0.0090 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.37401 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = ((-0.0658*xCgLocMacBWB) + 5.37774) * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = ((-0.0658*xCgLocMacBWB) + 6.61917) * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
    else
        error("something wrong with CGConfig parameter selection");
    end

elseif WithTail==0 %TAILLESS
    disp("* 3E Tailless *");
    error("No 3E Tailless config available!");
end

if(exist('Aircraft_Mass_Config', 'var'))
    if strcmp(Aircraft_Mass_Config,'CUSTOM')
        warning("Aircraft Mass Config set to CUSTOM and overriden. Inertia assumed to be that of base TBF configuration")
        Weight = MassBWB_custom * 2.2;% Lbs 
    end
end
    
