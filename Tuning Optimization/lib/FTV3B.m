% Configure aircraft model for FTV3B
% FTV 3B model Parameters
if WithTail==1   %UTAIL
    % CG Location Override - Limited intertia data for 3B
    %xCgLocMacBWB          = 57;% PERCENT MAC BWB... CMD Window outputs result in Skinny up to 56-63 is okay for Piccolo
    Weight                = 14.55 * 2.2;% Lbs    
    ZCG                   = 0.0170/0.0254 * (ZCGScale+1);% In inches
    IXX                   = 1.3728 * 3417.17 * (1+InertiaScale);% In-lbs
    IYY                   = 1.9706 * 3417.17 * (1+InertiaScale);% In-lbs
    IZZ                   = 3.0145 * 3417.17 * (1+InertiaScale);% In-lbs
    IXZ                   = 0.050 * 3417.17 * (1+InertiaScale);% In-lbs
else
    Error("No FTV3B Tailless Config!");
end