
load([file_dir '/' file_name]);
Agent = params.user.log;
complete_data_rows = ~isnan(Agent(:, key1_c)) & ~isnan(Agent(:, key2_c)) & Agent(:, frac2_c) > 0;
remove_first_20 = [zeros(20,1); ones(length(Agent)-20,1)];
Agent = Agent(complete_data_rows & remove_first_20,:);