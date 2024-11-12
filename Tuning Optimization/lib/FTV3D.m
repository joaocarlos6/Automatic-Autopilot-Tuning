% Configure aircraft model for FTV3D
% FTV 3D model Parameters 
if WithTail==1   %UTAIL
    disp("* 3D UTail *");
    
    if strcmp(CGConfig,'TBF')
        % TO BE FLOWN, from BFP data obtained 2023-03-17
        xCgLocMacBWB      = 58.25;% PERCENT MAC BWB
        Weight            = 14.237 * 2.2;% Lbs 
        ZCG               = 0.0110 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.2251 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.5276 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.5921 * 3417.17 * (1+InertiaScale);% In-lbs
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
        Weight            = 14.237 * 2.2;% Lbs 
        ZCG               = 0.0110 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.2251 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.5276 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.5921 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'CUSTOM')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        warning("CGConfig using xCgLocMacBWB_custom parameter");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB
        % Use expirmental inertia
        Weight            = 14.237 * 2.2;% Lbs 
        ZCG               = 0.0110 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.2251 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.5276 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.5921 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0680 * 3417.17 * (1+InertiaScale);% In-lbs
    else
        error("something wrong with CGConfig parameter selection");
    end

elseif WithTail==0 %TAILLESS
    disp("* 3D Tailless *");
    
    if strcmp(CGConfig,'TBF')
        % TO BE FLOWN, from BFP data obtained 2022-03-14
        xCgLocMacBWB      = 55.01;% PERCENT MAC BWB
        Weight            = 13.635 * 2.2;% Lbs 
        ZCG               = 0.0092 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.1737 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.2724 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.2783 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0542 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'FWD')|| strcmp(CGConfig,'BASE')|| strcmp(CGConfig,'AFT')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        switch CGConfig
            case "FWD"
                xCgLocMacBWB = 53.75;% PERCENT MAC BWB
            case "BASE"
                xCgLocMacBWB = 55.00;% PERCENT MAC BWB
            case "AFT"
                xCgLocMacBWB = 56.25;% PERCENT MAC BWB
            otherwise
                error("something wrong with xCgLocMac parameter selection");
        end
        Weight            = 13.635 * 2.2;% Lbs 
        ZCG               = 0.0092 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.1737 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.2724 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.2783 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0542 * 3417.17 * (1+InertiaScale);% In-lbs

    elseif strcmp(CGConfig,'CUSTOM')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        warning("CGConfig using xCgLocMacBWB_custom parameter");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB
        % Use expirmental inertia
        Weight            = 13.635 * 2.2;% Lbs 
        ZCG               = 0.0092 / 0.02540 * (ZCGScale+1);% In inches
        IXX               = 1.1737 * 3417.17 * (1+InertiaScale);% In-lbs
        IYY               = 1.2724 * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ               = 2.2783 * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ               = 0.0542 * 3417.17 * (1+InertiaScale);% In-lbs
    else
        error("something wrong with CGConfig parameter selection");        
    end        
end

if(exist('Aircraft_Mass_Config', 'var'))
    if strcmp(Aircraft_Mass_Config,'CUSTOM')
        warning("Aircraft Mass Config set to CUSTOM and overriden. Inertia assumed to be that of base TBF configuration")
        Weight = MassBWB_custom * 2.2;% Lbs 
    end
end
    
