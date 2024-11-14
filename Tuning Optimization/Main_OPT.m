clear all 
close all
clc

addpath(genpath("lib\"))

%% OPTIONS
optimizationName = 'Piccolo_FTV3F_AFT_CG';
dev_mode = true;        %Setting this to true enables developer mode which disables some features making it faster to run the code
% flag_optfilter = 0;     %1-Optimize DGYRO low pass filter, 0-No filter optimization of DGYRO
% flag_noise = 1;         %0-to disable noise, 1-to enable noise
% flag_NoiseLvl= 1;       %0-correct sensor noise levels for each axis, 1-highest level of sensor noise, 2-increase sensor noise x5 

%OPTIMIZATION SETTINGS
gaopt.PopulationSize = 200;                      %Size of the population.
gaopt.MaxGenerations = 100*gaopt.PopulationSize;  %Maximum number of iterations before the algorithm halts {100*population size}
gaopt.MaxTime = 18*60*60;            %The algorithm stops after running for MaxTime seconds {inf}
gaopt.MaxStallTime = inf;                       %The algorithm stops if there is no improvement in the objective function for MaxStallTime seconds {inf}
gaopt.FunctionTolerance = 1e-6;                 %The algorithm stops if the average relative change in the best fitness function value over MaxStallGenerations generations is less than or equal to FunctionTolerance {1e-6}
gaopt.MaxStallGenerations = 25;                 %The algorithm stops if the average relative change in the best fitness function value over MaxStallGenerations generations is less than or equal to FunctionTolerance.  {50}

%% Simulation settings
WithTail = 1;

% Vehicle
FTV                        = 3; % Vehicle Generation 
vehicleType                = "F";
testPlans.CG                = [ 61.61 ];
testPlans.mass              = [ "7P" ];    % Placeholder for 7P
testPlans.inertiaScale      = [0];         % Inertia scale

testPlans.descentSlope      = [3]; % Target descent slope (deg)
testPlans.speedOffset       = [0]; % Offset to approach speed target (m/s)
testPlans.rolloutTrackOffset= [0]; % At Touchdown offset track rollout control tracks (m)

% Terrain
testPlans.terrainElevation  = [373];   % Terrain elevation settings (ft); Dolbeau = 373, Foremost = 2904,
testPlans.terrainOffset     = [0];     % Offset applied to sim terrain height (simulate elevation knowledge errors)

% Conditions
windSpeed = [0];                % Set of wind speeds (kts)
windTurb  = [0.0];              % Turbulence to accompany each speed
windDir   = [0];                % Set of wind directions (WRT runway)
testPlans.winds             = [windSpeed,windTurb,windDir];

% Gusting
testPlans.gustType          = ["NONE"];         % Gust ramp type
testPlans.gustSpd           = [0];              % Set of gust speeds (kts)    
testPlans.gustTriggerVal    = [1];              % Value that will trigger gust start, dependent on trigger type selected above.
% Note – Flare height = 2m
testPlans.gustTrigger       = ["Below_AGL"];    % Gust Trigger Type % Variants: Above_AGL, Below_AGL, Above_IAS

% Latency
testPlans.delay             = [0.010]; % Set of latencies (ms)

testIndx = 1;

pilotTime = 15; % s - time of maneuver
trimTime = 5; % s - time to let controller trim in the commanded initial position
stepTime = pilotTime + trimTime;

Q = 10000;
R = 0.02;
C = 0.001;
%% File Paths
addpath lib
plotsFolderPath = fullfile(pwd, 'Plots',optimizationName);
if ~exist(plotsFolderPath, 'dir')
    mkdir(plotsFolderPath);
end

% %% LOAD SID MODEL DATA
% if dev_mode
%     SID_filePath = [fileparts(pwd) '\System Identification\Result SID Models\MiniE_FlexibleStructure_np2.mat'];
%     load(SID_filePath)
% else
%     [SID_file,SID_path] = uigetfile('*.mat', 'Select a SID model mat file');
%     load([SID_path SID_file]);
% end

%% Variable initialization
axis_name = {'pitch'};
fun = @GA_tuning_function;

%Parameter resolution [Kp ki kd pitchbandwidth ]
gain_resolution = [1/0.05 1/0.05 1/0.05 1/0.05];

% %Parameters limit [Kp ki kd]
% lb.roll = [0.01, 0, 0];
% ub.roll = [2, 2, 1];

lb.pitch = [1, 3, 0.2, 0.6];
ub.pitch = [5, 8, 0.8, 1.2];

% lb.yaw = [0, 0, 0];
% ub.yaw = [5, 5, 2];

%If optimizing the LPF filter at the same time, add resolution and limits
% if flag_optfilter
%     gain_resolution = [gain_resolution 1];
% 
%     lb.roll = [lb.roll 12];
%     ub.roll = [ub.roll 120];
%     lb.pitch = [lb.pitch 12];
%     ub.pitch = [ub.pitch 120];
%     lb.yaw = [lb.yaw 12];
%     ub.yaw = [ub.yaw 120];
% end

%% Optimization
for i=1:1 %Repeat optimization for all axis
    disp(' ')
    disp(['***********   TUNING OPTIMIZATION FOR ', upper(axis_name{i}), ' AXIS   ***********'])

    %Set coefficients
    % K_init=params.(axis{i}).(['MC_' upper(axis{i}) 'RATE_K']);
    % P_init=params.(axis{i}).(['MC_' upper(axis{i}) 'RATE_P']);
    % I_init=params.(axis{i}).(['MC_' upper(axis{i}) 'RATE_I']);
    % D_init=params.(axis{i}).(['MC_' upper(axis{i}) 'RATE_D']);
    % windup_limit = params.(axis{i}).(['MC_' upper(axis{i}(1)) 'R_INT_LIM']); 
    % 
    %PID scaler standard form (not used)
    % K=K_init;
    
    %Feed forward (not used)
    % FF=0;
    %Feed forward initial guess from dynamic inversion
    %[OL_step_response,~] = step(A_temp);
    %FF=1/max(OL_step_response);

    %Original filter values
    % gyro_cutoff = params.(axis{i}).IMU_GYRO_CUTOFF;
    % dgyro_cutoff_init = params.(axis{i}).IMU_DGYRO_CUTOFF;
    
    %Variable selection for axis
    % G_temp=SID_model_and_control.(axis{i}){1};
    % A_temp=SID_model.(axis{i}){1};
    % Q = Q_list(i);
    % R = R_list(i);
    % C = C_list(i);
    StopTime = 30;

    %Set initial parameters for optimization 
    clear Initialparam
    Initialparam = [2.8 4.5 0.7 0.75];
    % if flag_optfilter
    %     Initialparam(4) = dgyro_cutoff_init;
    % else
    %     dgyro_cutoff = dgyro_cutoff_hardcode;%dgyro_cutoff_init; %Fix DGYRO value for optimization
    % end
    Initialparam = Initialparam.*gain_resolution;

    %Get cost function value from the initial parameters (SID flight gains)
    [InitialCostScore.(axis_name{i}), StepResponseIni.(axis_name{i})] = GA_tuning_function([Initialparam]);
    disp(' ')
    disp(['The cost value with the initial tuning gains is: ' num2str(InitialCostScore.(axis_name{i}))])

    %Optimization
    lb_temp = lb.(axis_name{i}).*gain_resolution;
    ub_temp = ub.(axis_name{i}).*gain_resolution;
    Initialparam_const = max(min(ub_temp,Initialparam),lb_temp);
    IntCon = 1:length(Initialparam_const);
    ga_options = optimoptions('ga','PlotFcn',{@gaplotgenealogy, @gaplotbestf, @gaplotbestindiv},...
        'InitialPopulationMatrix',Initialparam_const,'PopulationSize',gaopt.PopulationSize,'MaxTime',gaopt.MaxTime,...
        'MaxStallTime',gaopt.MaxStallTime,'MaxStallGenerations',gaopt.MaxStallGenerations,'MaxGenerations',gaopt.MaxGenerations);

    [opt_gains.(axis_name{i}),fval.(axis_name{i}),exitflag.(axis_name{i}),output.(axis_name{i}),population.(axis_name{i}),scores.(axis_name{i})]  ...
        = ga(fun,length(Initialparam_const),[],[],[],[],lb_temp,ub_temp,[],IntCon,ga_options);
    
    saveas(gcf, [plotsFolderPath '\GeneticAlgorithm_' axis_name{i} '.png']);
    saveas(gcf, [plotsFolderPath '\GeneticAlgorithm_' axis_name{i} '.fig']);

    %Re-scale optimized gains with the resolution
    opt_gains.(axis_name{i}) = opt_gains.(axis_name{i})./gain_resolution;

    %Print result to console
    disp(' ')
    disp(['The optimized gains are: ' num2str(opt_gains.(axis_name{i}))])
    disp(['The cost value with the optimized tuning gains is: ' num2str(fval.(axis_name{i})) ' an improvement of ' num2str((InitialCostScore.(axis_name{i})-fval.(axis_name{i}))./fval.(axis_name{i})*100) '% compared to the intial tuning.'])
    
    %% Plots
    %RUN SIMULATION AND SAVE PLOTS OF IMPROVED RESULTS
    [~,StepResponse.(axis_name{i})] = GA_tuning_function(opt_gains.(axis_name{i}).*gain_resolution);

    plotname = ['Performance comprison of optimized vs initial gains for ',axis_name{i},'-rate'];
    figure('Name',plotname)
    plot([0 20 20.02 30],[4.97 4.97 6.97 6.97],'LineWidth',1.5)
    hold on
    plot(StepResponse.(axis_name{i}),'LineWidth',1.5)
    plot(StepResponseIni.(axis_name{i}),'LineWidth',1.5)
    text(0.1,0.4,{'Optm Gains:',['Kp=' num2str(opt_gains.(axis_name{i})(1))],['Ki=' num2str(opt_gains.(axis_name{i})(2))],['Kts=' num2str(opt_gains.(axis_name{i})(3))]})
    ylabel('Pitch (deg)');
    title(plotname);
    legend('Setpoint', 'Optimized response','Initial response')
    grid on 
    grid minor
    saveas(gcf, [plotsFolderPath '\' plotname '.png']);
    saveas(gcf, [plotsFolderPath '\' plotname '.fig']);

    % %Run step simulation for last generation 
    % plotname = ['Step response of last GA generation for ',axis_name{i},'-rate'];
    % figure('Name',plotname)
    % for j=1:size(population.(axis_name{i}),1)
    %     [~,reults_tmp] = GA_tuning_function(population.(axis_name{i})(j,:));
    %     plot(reults_tmp.Time,reults_tmp.Data)
    %     hold on
    % end
    % grid on; grid minor
    % p1 = plot(StepResponse.(axis_name{i}).Time,StepResponse.(axis_name{i}).Data(:,1),'k','LineWidth',1.5);
    % p2 = plot(StepResponse.(axis_name{i}).Time,StepResponse.(axis_name{i}).Data(:,3),'r','LineWidth',2);
    % ylabel('Angular-rate (rad/s)')
    % xlabel('Time (seconds)')
    % title(plotname);
    % legend([p1 p2],{'Setpoint','Selected Optimal Chromosome'})
    % saveas(gcf, [plotsFolderPath '\' plotname '.png']);
    % saveas(gcf, [plotsFolderPath '\' plotname '.fig']);
end


%% Save optimize parameter and results
resultFolderPath = fullfile(pwd, 'Results');
if ~exist(resultFolderPath, 'dir')
    mkdir(resultFolderPath);
end
save([resultFolderPath,'\',optimizationName],'InitialCostScore', 'StepResponse','opt_gains','fval','exitflag','output', 'population', 'scores')




