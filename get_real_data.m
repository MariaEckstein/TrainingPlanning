function [Agent, agentID, runID] = get_real_data(file_dir, fileName)

real_data_columns;   % Find out which columns contain what
load([file_dir '/' fileName]);
Agent = params.user.log;
complete_data_rows = ~isnan(Agent(:, key1_c)) & ~isnan(Agent(:, key2_c)) & Agent(:, frac2_c) > 0;
remove_first_20 = [zeros(20,1); ones(length(Agent)-20,1)];
Agent = Agent(complete_data_rows & remove_first_20,:);
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