function [Agent, agentID, runID] = get_agent_data(sim_data, agent, files, file_index, file_dir)

clear Agent
if strcmp(sim_data, 'real')
    file_name = files(file_index(agent)).name;
    [Agent, agentID, runID] = get_real_data(file_dir, file_name);
else
    data_columns;   % Find out which columns contain what
    agent_rows = Data(:, AgentID_c) == agent;
    Agent = Data(agent_rows, :);
    agentID = agent;
    runID = nan;
end