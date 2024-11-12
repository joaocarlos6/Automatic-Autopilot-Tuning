% Configure aircraft model for FTV4A
% MassBWB set in TMIInit.m
disp("* 4A UTail *");
% Run InertiaCalculatorBWB to lookup TMI values from Flight Test Matrix
[MassBWB, InertiaBWB] = InertiaLookupBWB(CGConfig, WithTail, "FTV4A", AircraftMassConfig, PackageFlag);
Weight                = MassBWB * 2.2;% Lbs    
ZCG                   = InertiaBWB.ZCG/0.0254 * (ZCGScale+1);       % In 
IXX                   = InertiaBWB.IXX * 3417.17 * (1+InertiaScale);% In-lbs
IYY                   = InertiaBWB.IYY * 3417.17 * (1+InertiaScale);% In-lbs
IZZ                   = InertiaBWB.IZZ * 3417.17 * (1+InertiaScale);% In-lbs
IXZ                   = InertiaBWB.IXZ * 3417.17 * (1+InertiaScale);% In-lbs
xCgLocMacBWB          = InertiaBWB.CgMac; % %MAC

% copy from initcalculation.m
YCG         = 0; % Only use 0. Alternate trim setup needed for lateral assymetry.
Cbar        = 1.570;  
XCGMeters   = (xCgLocMacBWB/100*Cbar + 0.8855583);         % cg location relative to nose [m]
XCG         = (XCGMeters/0.165)/0.0254 * 0.6412 - 253.52; %CG % = 0.6412*In - 253.52 
%xCgLocMacConventional = (xCgLocMacBWB * 2.4028) - 118.03;% Conventional or "Skinny" Mac location