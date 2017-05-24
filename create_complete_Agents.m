
raw_file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';
files = dir(raw_file_dir);
file_index = find(~[files.isdir]);
n_files = length(file_index);

for subjID = 101:222
    Agent = [];
    % Get run 1
    file_name = sprintf('TS_%03d_1A.mat', subjID);
    try load(fullfile(raw_file_dir, file_name)); Agent.Run1 = params.user.log; catch; end
    % Get run 2
    file_name = sprintf('TS_%03d_1B.mat', subjID);
    try load(fullfile(raw_file_dir, file_name)); Agent.Run2 = params.user.log; catch; end
    % Get run 3
    file_name = sprintf('TS_%03d_2C.mat', subjID);
    try load(fullfile(raw_file_dir, file_name)); Agent.Run3 = params.user.log; catch; end
    % Get run 4
    file_name = sprintf('TS_%03d_2D.mat', subjID);
    try load(fullfile(raw_file_dir, file_name)); Agent.Run4 = params.user.log; catch; end
    % Save
    save(['TS_' num2str(subjID) '_Agent.mat'], 'Agent')
end
