function [Agent, agentID, runID] = get_real_data(full_file_path)

load_and_preprocess_data;
[file_dir, file_name] = fileparts(full_file_path);
agentID = file_name(length(file_name)-5:length(file_name)-3);
agentID = str2double(agentID);
runID = file_name(length(file_name));
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