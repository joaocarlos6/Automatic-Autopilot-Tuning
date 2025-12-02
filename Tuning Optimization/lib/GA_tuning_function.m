function [cost, StepResponse] = GA_tuning_function(k)
    
    %If incorrect parameter are passed terminate funciton
    % if length(k)<3 || length(k)>4
    %     errordlg('Incorrect length of parameter for the GA_tuning_function','Error')
    %     cost = NaN;
    %     return
    % end
    
    %Assign parameters to base workspace of simualtion
    assignin('base','KP_Vrate',k(1));
    assignin('base','KI_Vrate',k(2));
    assignin('base','FF_Vrate',k(3));
    assignin('base','PB',k(4));

    warning('off','all')
    %Run simulation
    output_cmd_text = evalc("sim('Landing_VV.slx')");
    warning('on','all')
   
    %Return cost
    cost = COST.Data(end);
    if SimVer.Sim_Pic3.apMode.Data(end) ~= 11
        cost = inf;
    end
       
    clear output_cmd_text
    rmdir('slprj','s')

end

