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


end