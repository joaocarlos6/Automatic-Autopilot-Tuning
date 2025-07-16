function cost = RunSimulation(testIndx)
    functionCallTime = datetime('now');
    try
       % Run the simulation.
        sim('Maneuver.slx');

        % Pass to base workspace
        assignin('base','SimVer',SimVer)

        cost = 0;

        % Check for existence of costLog
        if evalin('base','exist(''costLog'')==0')
            costLog = struct('cost',cost); % Add more costs as needed

            costLog.datetimeStart = functionCallTime;
        else
            costLog = evalin('base','costLog');
            costLog.cost(testIndx) = cost;
        end
        assignin('base','costLog',costLog);

    catch e
        disp(e.message)
        if e.identifier == "Simulink:blocks:AssertionAssert"
            simulation_error_message = convertCharsToStrings(e.message);
        else
            simulation_error_message = "Simulation Diverged";
        end
        assignin('base','simulation_error_message',simulation_error_message);

        cost=1e8; % assign very large cost

        costLog = evalin('base','costLog');
        costLog.cost(testIndx) = cost;
        try
            % Pass to base workspace
            assignin('base','SimVer',SimVer)
        catch e
            %do nothing
        end
        assignin('base','costLog',costLog);
    end
end