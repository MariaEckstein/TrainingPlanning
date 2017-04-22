
%% Switches for this script (would be function argument if this were a function)
location = 'home';   % Where is this code run? Can be 'home' or 'cluster'
data_year = '2016';
data_type = 'sim';   % Should the data be simulated ('sim') or loaded from disk ('load') or is the real dataset used ('real')?
sim_model = 'nopk';   % What model should be used for simulation / what data should be loaded? ('mb', 'mf', 'hyb')
fit_model = 'nopk';   % What model should be used for fitting? ('mf', 'mb', 'hyb', '1a1b' (Also needs changes in computeNLL!!))

%%% Additional stuff 
common = 0.7;   % Probability of the common transition
n_agents = 100;   % Number of simulated agents
n_trials = 201;   % Number of simulated trials
n_fmincon_iterations = 30;   % Number of iteractions when fitting parameters
genrec_file_name = name_genrec_file(sim_model, fit_model);
model_parameters = define_model_parameters;  % Which parameters are fitted (-1) versus fixed (values) in each model?
if strcmp(location, 'home')
    file_dir = ['C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata' data_year];   % Where is the original data stored? 
else
    parpool(12);
    file_dir = 'datafiles/test';   % equal portions of the files are in folders g1-g4
end

%% Simulate / Load Data
switch data_type
    case 'sim'
        
        sim_par = model_parameters(model_ID(sim_model),:);  % Which parameters will be fitted (-1) and which are fixed by me (values)?
        load('list1.mat');  % Reward probabilities for all fractals over time
        fractal_rewards = x(5:8,:);
        
        Data = simulate_task(n_agents, n_trials, sim_par, fractal_rewards, common);  % Run simulations
        save(['data_' sim_model '_agents.mat'], 'Data')
        
    case 'load'
        load(['data_' sim_model '_agents.mat'])
        
    case 'real'
        files = dir(file_dir);
        fileIndex = find(~[files.isdir]);
        n_agents = length(fileIndex);
end

%% Fit the parameters to the Data
fit_par = model_parameters(model_ID(fit_model),:);  % Which parameters will be fitted (-1) and which are fixed by me (values)?
n_fit = sum(fit_par == -1);   % number of parameters that are fitted (for BIC & AIC)
clear genrec  % Will hold generated and recovered parameters
genrec = zeros(n_agents, 23);
genrec_columns; 

for agent = 1:n_agents

    clear Agent  % Select data of one agent; save into Agent
    if strcmp(data_type, 'real')
        fileName = files(fileIndex(agent)).name;
        [Agent, agentID, runID] = get_real_data(file_dir, fileName);
    else
        data_columns;   % Find out which columns contain what
        agent_rows = Data(:, AgentID_c) == agent;
        Agent = Data(agent_rows, :);
        agentID = agent;
        runID = nan;
    end

    %%% Minimize the function
    fun = @(par)computeNLL(Agent, par, n_fit, 'NLL', common, data_type);   % minimize neg. log. lik. for data Agent, finding the right par; n_fit = number of parameters to be estimated; common = probability of common transition in the task (70% percent); sim_data = simulated or human data; fit_model = which model should be fitted ('mb', 'mf', 'hyb')
    [fit_params, ~] = minimize_NLL(fun, fit_par, n_fmincon_iterations);   % look at x-position and function value of found minimum
    NLLBICAIC = computeNLL(Agent, fit_params, n_fit, 'all', common, data_type);

    %%% Save generated (simulated) and recovered (fitted) values in genrec
    genrec(agent, [agentID_c run_c]) = [agentID runID];
    if ~strcmp(data_type, 'real')
        genrec(agent, gen_aabblwpk_c) = Agent(1, par_c);
    end
    genrec(agent, rec_aabblwpk_c) = fit_params;   % Save fitted parameters (x) into the genrec rec paramater columns (aabblwpk)
    genrec(agent, NLLBICAIC_c) = NLLBICAIC;   % Save NLL,a BIC, and AIC (NLLBICAIC) into the genrec NLLBICAIC columns (NLLBICAIC_c)

    %%% Save genrec to the disk; print agent number to the console to check where we are
    if mod(agent, 5) == 1
        save(genrec_file_name, 'genrec')
        agent
    end
end

%%% Save genrec after running the last agent
save(genrec_file_name, 'genrec')
agent

