
%% TDs
% Basic data cleaning (remove too fast trials; remove nans; remove trials
% where fract2 == -2; remove strokes with the same key more than x times)

%% Switches for this script (would be function argument if this were a function)
sim_data = 'real';   % Should the data be simulated ('sim') or loaded from disk ('load') or is the real dataset used ('real')?
sim_model = 'real';   % What model should be used for simulation / what data should be loaded? (e.g., 'mb', 'mf', 'hyb'; check in model_ID for all available models)
fit_model = 'a1b1_nok';   % What model should be used for fitting? ('mf', 'mb', 'hyb', '1a1b' (Also needs changes in computeNLL!!))
location = 'home';   % Where is this code run? Can be 'home' or 'cluster'
solver_algo = 'fmincon';   % Which method is used to solve? 'fmincon' (with n_fmincon_iterations different starts) or 'ga' (parallelization doesn't work) or 'particleswarm' (leads to worse results)?

%%% Additional stuff 
common = 0.7;   % Probability of the common transition
fit_data = true;   % Sould the data also be fitted? Or just simulated?
if isnan(fit_model)
    fit_data = false;
end

%% Prepare things
[n_agents, n_fmincon_iterations, n_trials, file_dir] = determine_location_specifics(location);
genrec_file_name = name_genrec_file(sim_model, fit_model);
model_parameters = define_model_parameters;   % Which parameters will be fitted (-1) versus fixed (values) in each model (used for sim_par and fit_par)

%% Simulate / Load Data
switch sim_data
    case 'sim'
        
        % Which parameters are free in the simulation (-1) and which are fixed (value)?
        sim_par = model_parameters(model_ID(sim_model),:);
        
        % Run simulations and save 
        Data = simulate_task(n_agents, n_trials, sim_par, fractal_rewards, common);
        save(['data_' sim_model '_agents.mat'], 'Data')
        
    case 'load'
        load(['data_' sim_model '_agents.mat'])
        
    case 'real'
        files = dir(file_dir);
        file_index = find(~[files.isdir]);
        n_agents = length(file_index);
end


%% Fit parameters to the Data
if fit_data
    
    %%% Which parameters will be fitted (-1) and which are fixed by me (values)?
    fit_par = model_parameters(model_ID(fit_model),:);
    
    %%% Optimizer inputs
    [pmin, pmax, par0, n_fit, n_params] = get_fmincon_stuff(fit_par);
    
    %%% Create genrec, which will hold (true and) fitted parameters for each agent
    clear genrec
    genrec = zeros(n_agents, 2 * n_params + 7);
    
    for agent = 1:n_agents

        %%% Select data of one agent (called "Agent")
        [Agent, agentID, runID] = get_agent_data(sim_data, agent, files, file_index, file_dir);

        %%% Find paramater values that minimize the negative log likelihood of agent data
        object_fun = @(par)computeNLL(Agent, par, n_fit, 'NLL', common, sim_data, fit_model);   % define function whose minimum will be found
        [fit_params, function_value] = find_params_that_minimize_NLL(object_fun, par0, pmin, pmax, n_fmincon_iterations, solver_algo);   % find function's minimum
        NLLBICAIC = computeNLL(Agent, fit_params, n_fit, 'all', common, sim_data, fit_model);   % calculate NLL, BIC, and AIC for the found parameter values

        %%% Save generated (simulated) and recovered (fitted) values in genrec
        genrec = save_results_to_genrec(agent, Agent, agentID, runID, fit_params, NLLBICAIC, sim_data, n_params);
        
        %%% Save genrec to disk; print agent number to the console to check where we are
        if mod(agent, 5) == 1
            save(genrec_file_name, 'genrec')
            agent
        end
    end
    
    %%% Save final version of genrec after running the last agent
    save(genrec_file_name, 'genrec')
end
