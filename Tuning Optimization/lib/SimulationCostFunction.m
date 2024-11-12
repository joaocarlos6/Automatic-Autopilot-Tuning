%% SimulationCostFunction.m
% AUTHOR :Stephen Warwick
% MODIFIED: Stephen Warwick
% February 03, 2022
% Description: Used to define cost function for Optimization. Also used to
% identify simulation divergence during verification.


% Parameter Explore?


%   Flare Trial 5 Cost Weight Function
    GeneticOpt.Qnorm    = 1;    % VerticalRateErr
    GeneticOpt.Rnorm    = 1;    % PitchCmd Magnitude
    GeneticOpt.Cnorm    = 1;    % PitchCmd Rate

    GeneticOpt.Quser=40;    % VerticalRate Error
    GeneticOpt.Ruser=5;     % PitchCmd Magnitude
    GeneticOpt.Cuser=1;     % PitchCmd Rate

    GeneticOpt.Q = GeneticOpt.Qnorm.*GeneticOpt.Quser;
    GeneticOpt.R = GeneticOpt.Rnorm.*GeneticOpt.Ruser;
    GeneticOpt.C = GeneticOpt.Cnorm.*GeneticOpt.Cuser;

    Q = GeneticOpt.Q;
    R = GeneticOpt.R;
    C = GeneticOpt.C;