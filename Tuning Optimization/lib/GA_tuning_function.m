function [cost, StepResponse] = GA_tuning_function(k)
    
    %If incorrect parameter are passed terminate funciton
    % if length(k)<3 || length(k)>4
    %     errordlg('Incorrect length of parameter for the GA_tuning_function','Error')
    %     cost = NaN;
    %     return
    % end
    
    %Assign parameters to base workspace of simualtion
    assignin('base','KP_Pitch',k(1));
    assignin('base','KI_Pitch',k(2));
    % assignin('base','K_TD',k(3));
    % assignin('base','K_TS',k(4));
    assignin('base','Damping',k(3));
    % assignin('base','Stiffness',k(6));

    warning('off','all')
    %Run simulation
    output_cmd_text = evalc("sim('Maneuver.slx')");
    warning('on','all')
   
    %Return cost
    cost = COST.Data(end);
    if COST.Time(end) < 45
        cost = inf;
    end
       

    clear output_cmd_text
    rmdir('slprj','s')

end

