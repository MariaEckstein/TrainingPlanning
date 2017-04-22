
%% ADJUST THESE THINGS BEFORE RUNNING
location = 'home';   % Where is this code run? Can be 'home' or 'cluster'
data_year = '2016';   % Can be '2015' (data collected in Munich) or '2016' (data collected in XLab)
sim_data = 'sim';   % Should the data be simulated ('sim') or loaded from disk ('load') or is the real dataset used ('real')?
sim_model = 'a1b1_l0_nok';   % What model should be used for simulation / what data should be loaded? (e.g., 'mb', 'mf', 'hyb'; check in model_ID for all available models)
fit_model = 'a1b1_l0_nok';   % What model should be used for fitting? ('mf', 'mb', 'hyb', 'a1b1') - check in functions model_ID and define_model_parameters

%% Prepare things
n_workers = 12;   % Number of workers when on cluster
common = 0.7;   % Probability of the common transition
[n_fmincon_iterations, n_trials, file_dir] = determine_location_specifics(location, n_workers, data_year);

%% Simulate / Load Data
% Create Simulated_data or Real_data object, with info about simulated / real data
switch sim_data
    case 'sim'
        dataset = Simulated_data(sim_model, n_trials, common);
    case 'load'
        dataset = Simulated_data(sim_model);
    case 'real'
        dataset = Real_data(file_dir, data_year);
end

%% Fit parameters to the Data (if fit_data is true)
if ~isnan(fit_model)
    
    % Create a Genrec object, which will hold (true and) fitted parameters
    genrec = Genrec(sim_data, fit_model, dataset.number);
    % Create a ParameterFitting object, which will take care of parameter fitting
    parameterFitting = ParameterFitting(fit_model, n_fmincon_iterations);
    
    for i_dataset = 1:dataset.number

        % Get Agent (behavioral data), agentID, and runID
        [Agent, agentID, runID] = dataset.get_data(i_dataset);

        % Find paramater values that minimize the negative log likelihood
        % of agent data, given the model selected in fit_model
        fit_params = parameterFitting.minimize_NLL(Agent, sim_data, common);
        fit_params
        NLLBICAIC = parameterFitting.compute_NLL(Agent, fit_params, sim_data, common);

        % Save generated (simulated) and recovered (fitted) values in genrec
        genrec.add_results(i_dataset, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data, parameterFitting.n_fit);
        
        % Save genrec to disk; print agent number to the console to check where we are
        if mod(i_dataset, 10) == 1
            genrec.save_data
            i_dataset
        end
    end
    
    %%% Save final version of genrec after running the last agent
    genrec.save_data
end
