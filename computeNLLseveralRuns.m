function result = computeNLLseveralRuns(Agent, par, n_fit, output, data_type, hier, complete)
% This function allows to fit parameters jointly to all runs
% In other words, participants are forced to have the same alpha, beta,
% etc. in each run. The only parameter that is allowed to vary between runs
% is w.

%% Calculate NLL for each run - each run uses the same parameters (expect w)
try NLL1 = computeNLL(Agent.Run1, 1, par, n_fit, output, data_type, hier);  % if Agent.Run1 exists
catch
    NLL1 = 0;  % if Agent.Run1 does not exist
end
try NLL2 = computeNLL(Agent.Run2, 2, par, n_fit, output, data_type, hier);
catch
    NLL2 = 0;
end
try NLL3 = computeNLL(Agent.Run3, 3, par, n_fit, output, data_type, hier);
catch
    NLL3 = 0;
end

%% Add the NLL's of all three runs together
if strcmp(complete, 'complete')
    result = NLL1 + NLL2 + NLL3;
else
    result = NLL1;
end