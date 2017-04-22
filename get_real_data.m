function [Agent, agentID, runID] = get_real_data(file_dir, file_name)

real_data_columns;   % Find out which columns contain what
load_and_preprocess_data;
agentID =  file_name(length(file_name)-9:length(file_name)-7);
agentID = str2double(agentID);
runID = file_name(length(file_name)-4);
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