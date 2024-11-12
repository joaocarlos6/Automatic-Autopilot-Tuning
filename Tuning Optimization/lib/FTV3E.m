% Configure aircraft model for FTV3E
% FTV 3E model Parameters 
if WithTail==1   %UTAIL
    disp("* 3E UTail *");
    
    if strcmp(CGConfig,'TBF')
        % TO BE FLOWN, from BFP data obtained 2023-11-23, updated
        % 2024-03-01 in FTC6 Vehicle Configuration Release
        xCgLocMacBWB      = 58.25;% PERCENT MAC BWB
        Weight            = 14.466 * 2.2;% Lbs 
        ZCG               = 0.0095 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.2620 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.5506 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.6395 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'FWD')|| strcmp(CGConfig,'BASE')|| strcmp(CGConfig,'AFT')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        %FWD, BASE, AFT, TBF
        switch CGConfig
            case "FWD"
                xCgLocMacBWB = 57.00;% PERCENT MAC BWB
            case "BASE"
                xCgLocMacBWB = 58.25;% PERCENT MAC BWB
            case "AFT"
                xCgLocMacBWB = 59.5;% PERCENT MAC BWB
            otherwise
                error("something wrong with xCgLocMac parameter selection");
        end
        % Use expirmental inertia
        % TO BE FLOWN, from BFP data obtained 2023-11-23
        Weight            = 14.441 * 2.2;% Lbs 
        ZCG               = 0.0095 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.2616 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.5509 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.6401 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'CUSTOM')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        warning("CGConfig using xCgLocMacBWB_custom parameter");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB
        % Use expirmental inertia
        % TO BE FLOWN, from BFP data obtained 2023-11-23
        Weight            = 14.441 * 2.2;% Lbs 
        ZCG               = 0.0095 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.2616 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.5509 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.6401 * 3417.17 * (1+InertiaScale);% In-lbs
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
    
