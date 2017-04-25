real_data_columns;   % Find out which columns contain what
load(full_file_path);
Agent = params.user.log;
complete_data_rows = ~isnan(Agent(:, key1_c)) & ~isnan(Agent(:, key2_c)) & Agent(:, frac2_c) > 0;
first20trials = [ones(20,1); zeros(length(Agent)-20,1)];
Agent = Agent(complete_data_rows & ~first20trials,:);