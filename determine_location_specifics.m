function [n_fmincon_iterations, n_trials, file_dir] = determine_location_specifics(location, n_workers, data_year)

if strcmp(location, 'home')
    file_dir = ['C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata', num2str(data_year)];   % Where is the original data stored? 
else
    parpool(n_workers);   % Specify parallel processing stuff: Can only be 2 for my old laptop; should be <= 8 on the HWNI cluster
    file_dir = ['datafiles/d', num2str(data_year)];   % Where the participant data is stored on the cluster
end
n_fmincon_iterations = 10;
n_trials = 200;