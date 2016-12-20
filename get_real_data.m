function [Agent, agentID, runID] = get_real_data(file_dir, fileName)

real_data_columns;   % Find out which columns contain what
load([file_dir '/' fileName]);
Agent = params.user.log;
Agent(:, frac2_c) = Agent(:, frac2_c) - 2;   % stage-2 fractals are numbered 3-6 in the real data, but need to be 1-4 for my analysis
complete_data_rows = ~isnan(Agent(:, key1_c)) & ~isnan(Agent(:, key2_c)) & Agent(:, frac2_c) > 0;
Agent = Agent(complete_data_rows,:);
agentID =  fileName(length(fileName)-9:length(fileName)-7);
agentID = str2double(agentID);
runID = fileName(length(fileName)-4);
switch runID
    case 'A'
        runID = 1;
    case 'B'
        runID = 2;
    case 'C'
        runID = 3;
    case 'D'
        runID = 4;
end