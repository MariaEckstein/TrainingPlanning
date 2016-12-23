function [n_agents, n_fmincon_iterations, n_trials, file_dir] = determine_location_specifics(location, n_workers)

if strcmp(location, 'home')
    n_agents = 100;
    n_fmincon_iterations = 3;
    n_trials = 150;
    file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';   % Where is the original data stored? 
else
    parpool(n_workers);   % Specify parallel processing stuff: Can only be 2 for my old laptop; should be <= 8 on the HWNI cluster
    n_agents = 100;
    n_fmincon_iterations = 30;
    n_trials = 201;
    file_dir = 'datafiles';   % Where the participant data is stored on the cluster
end