% Configure aircraft model for FTV3C
% FTV 3C model Parameters 
if WithTail==1   %UTAIL
    disp("* 3C UTail *");
    
    if (strcmp(CGConfig, 'AS_FLOWN'))
        error("3C AS_FLOWN config not currently available!")
        % Will need other params here such as mass & CG for this to work in
        % current desktop sim setup
        %         AS FLOWN IN AUGUST FTC 1 2020
%         IXX                   =  1.4225 * 3417.17 * (1+InertiaScale);% In-lbs
%         IYY                   =  1.5418 * 3417.17 * (1+InertiaScale);% In-lbs
%         IZZ                   =  3.0209 * 3417.17 * (1+InertiaScale);% In-lbs
%         IXZ                   =  0.0540 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'TBF')
        % TO BE FLOWN, from COMMISSIONING 4, BFP data obtained 2022-11-25
        xCgLocMacBWB      = 58.27;% PERCENT MAC BWB
		Weight            = 15.044 * 2.2;% Lbs 
		ZCG               = 0.0123/0.0254 * (ZCGScale+1);% In inches
		IXX               = 1.4264 * 3417.17 * (1+InertiaScale);% In-lbs
		IYY               = 1.7502 * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ               = 3.0082 * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ               = 0.0776 * 3417.17 * (1+InertiaScale);% In-lbs
        
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
        [InertiaBWB, MassBWB] = InertiaEstimatorBWB(xCgLocMacBWB, WithTail, modelScale, "FTV3C");
        Weight                = MassBWB * 2.2;% Lbs    
        ZCG                   = 0.0174/0.0254 * (ZCGScale+1);% In inches
        IXX                   = InertiaBWB.IXX * 3417.17 * (1+InertiaScale);% In-lbs
        IYY                   = InertiaBWB.IYY * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ                   = InertiaBWB.IZZ * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ                   = InertiaBWB.IXZ * 3417.17 * (1+InertiaScale);% In-lbs 
    elseif strcmp(CGConfig,'CUSTOM')
        warning("CGConfig using xCgLocMacBWB_custom parameter, using estimated (interpolated) inertias!");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB   
       [InertiaBWB, MassBWB] = InertiaEstimatorBWB(xCgLocMacBWB, WithTail, modelScale, "FTV3C");
        Weight                = MassBWB * 2.2;% Lbs    
        ZCG                   = 0.0174/0.0254 * (ZCGScale+1);% In inches
        IXX                   = InertiaBWB.IXX * 3417.17 * (1+InertiaScale);% In-lbs
        IYY                   = InertiaBWB.IYY * 3417.17 * (1+InertiaScale);% In-lbs
        IZZ                   = InertiaBWB.IZZ * 3417.17 * (1+InertiaScale);% In-lbs
        IXZ                   = InertiaBWB.IXZ * 3417.17 * (1+InertiaScale);% In-lbs 
    else
        error("something wrong with CGConfig parameter selection");        
    end

elseif WithTail==0 %TAILLESS
    disp("* 3C Tailless *");
    
    if strcmp(CGConfig,'TBF')
        % TO BE FLOWN, from COMMISSIONING 4, BFP data obtained 2022-11-24
        xCgLocMacBWB      = 55.01;% PERCENT MAC BWB
		Weight            = 14.236 * 2.2;% Lbs 
		ZCG               = 0.0124/0.0254 * (ZCGScale+1);% In inches
		IXX               = 1.3235 * 3417.17 * (1+InertiaScale);% In-lbs
		IYY               = 1.3556 * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ               = 2.5340 * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ               = 0.0593 * 3417.17 * (1+InertiaScale);% In-lbs
        
    elseif strcmp(CGConfig,'FWD')|| strcmp(CGConfig,'BASE')|| strcmp(CGConfig,'AFT')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        
        %FWD, BASE, AFT, TBF
        switch CGConfig
            case "FWD"
                xCgLocMacBWB = 54.00;% PERCENT MAC BWB
            case "BASE"
                xCgLocMacBWB = 54.75;% PERCENT MAC BWB
            case "AFT"
                xCgLocMacBWB = 56.0;% PERCENT MAC BWB
            otherwise
        end
        % Use expirmental inertia
        Weight                  = 14.236 * 2.2;% Lbs 
        ZCG                     = 0.014/0.0254 * (ZCGScale+1);% In 
		IXX                     = 1.3235 * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                     = 1.3556 * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                     = 2.5340 * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                     = 0.0593 * 3417.17 * (1+InertiaScale);% In-lbs
    elseif strcmp(CGConfig,'CUSTOM')
        warning("Selected AC config will overwrite CG posn without inertia adjustment!")
        warning("CGConfig using xCgLocMacBWB_custom parameter");
        xCgLocMacBWB = xCgLocMacBWB_custom;% PERCENT MAC BWB 
        Weight                  = 14.236 * 2.2;% Lbs 
        ZCG                     = 0.014/0.0254 * (ZCGScale+1);% In 
		IXX                     = 1.3235 * 3417.17 * (1+InertiaScale);% In-lbs
		IYY                     = 1.3556 * 3417.17 * (1+InertiaScale);% In-lbs
		IZZ                     = 2.5340 * 3417.17 * (1+InertiaScale);% In-lbs
		IXZ                     = 0.0593 * 3417.17 * (1+InertiaScale);% In-lbs
    end
end

if(exist('Aircraft_Mass_Config', 'var'))
    if strcmp(Aircraft_Mass_Config,'CUSTOM')
        warning("Aircraft Mass Config set to CUSTOM and overriden. Inertia assumed to be that of base TBF configuration")
        Weight = MassBWB_custom * 2.2;% Lbs 
    end
end
