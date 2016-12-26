
%% TODO
% Basic data cleaning (remove too fast trials; remove nans; remove trials
% where fract2 == -2; remove strokes with the same key more than x times)

%% Switches for this script (would be function argument if this were a function)
sim_data = 'real';   % Should the data be simulated ('sim') or loaded from disk ('load') or is the real dataset used ('real')?
sim_model = nan;   % What model should be used for simulation / what data should be loaded? (e.g., 'mb', 'mf', 'hyb'; check in model_ID for all available models)
fit_model = 'mf';   % What model should be used for fitting? ('mf', 'mb', 'hyb', '1a1b' (Also needs changes in computeNLL!!))
location = 'home';   % Where is this code run? Can be 'home' or 'cluster'
solver_algo = 'fmincon';   % Which method is used to solve? 'fmincon' (with n_fmincon_iterations different starts) or 'ga' (parallelization doesn't work) or 'particleswarm' (leads to worse results)?

%%% Additional stuff 
n_workers = 12;   % Number of workers on cluster
common = 0.7;   % Probability of the common transition
fit_data = true;   % Sould the data also be fitted? Or just simulated?
if isnan(fit_model)
    fit_data = false;
end

%% Prepare things
[n_datasets, n_fmincon_iterations, n_trials, file_dir] = determine_location_specifics(location, n_workers);

%% Simulate / Load Data
switch sim_data
    case 'sim'
        dataset = Simulated_data(sim_model, n_datasets, n_trials, common);
    case 'load'
        dataset = Simulated_data(sim_model);
    case 'real'
        dataset = Real_data(file_dir);
end

%% Fit parameters to the Data (if fit_data is true)
if fit_data
    
    %%% Create genrec, which will hold (true and) fitted parameters for each dataset
    genrec = Genrec(sim_model, fit_model, dataset.number, n_params);
    parameterFitting = ParameterFitting(fit_model, n_fmincon_iterations, solver_algo);
    
    for i_dataset = 1:dataset.number

        [Agent, agentID, runID] = dataset.get_data(i_dataset);

        %%% Find paramater values that minimize the negative log likelihood of agent data
        fit_params = parameterFitting.minimize_NLL(Agent, sim_data, common);
        NLLBICAIC = parameterFitting.compute_NLL(Agent, fit_params, sim_data, common);

        %%% Save generated (simulated) and recovered (fitted) values in genrec
        genrec.add_results(i_dataset, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data);
        
        %%% Save genrec to disk; print agent number to the console to check where we are
        if mod(i_dataset, 10) == 1
            genrec.save_data
            i_dataset
        end
    end
     
    %%% Save final version of genrec after running the last agent
    genrec.save_data
end
