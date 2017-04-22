
%% TDs
% Basic data cleaning (remove too fast trials; remove nans; remove trials
% where fract2 == -2; remove strokes with the same key more than x times)

%% Switches for this script (would be function argument if this were a function)
sim_data = 'sim';   % Should the data be simulated ('sim') or loaded from disk ('load') or is the real dataset used ('real')?
sim_model = 'nopk';   % What model should be used for simulation / what data should be loaded? ('mb', 'mf', 'hyb')
fit_model = 'nopk';   % What model should be used for fitting? ('mf', 'mb', 'hyb', '1a1b' (Also needs changes in computeNLL!!))
location = 'home';   % Where is this code run? Can be 'home' or 'cluster'
solver_algo = 'fmincon';   % Which method is used to solve? 'fmincon' (with n_fmincon_iterations different starts) or 'ga' (parallelization doesn't work) or 'particleswarm' (leads to worse results)?

%%% Additional stuff 
data_version = '';   % What simulations should be loaded? Can be '' (6 parameters) or '_new' (8 parameters)
% If you want to run the script on the old data (6 parameters only), you
% also need to change n_params, or whatever leads to it!
common = 0.7;   % Probability of the common transition
fit_data = true;   % Sould the data also be fitted? Or just simulated?
if isnan(fit_model)
    fit_data = false; 
end
%%% To name genrec file on disk
today = date;
now = clock;
hour = num2str(now(4));
minute = num2str(now(5));
time = [hour '.' minute];
genrec_file_name = ['genrec_' sim_model '_agents_' fit_model '_sim_' today '_' time '.mat'];

%% Prepare things
%%% Things on cluster and at home
if strcmp(location, 'home')
    n_agents = 150;
    n_fmincon_iterations = 3;
    n_trials = 150;
    file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';   % Where is the original data stored? 
else
    parpool(12);   % Specify parallel processing stuff: Can only be 2 for my old laptop; should be <= 8 on the HWNI cluster
    n_agents = 100;
    n_fmincon_iterations = 30;
    n_trials = 201;
    file_dir = 'datafiles/test';   % equal portions of the files are in folders g1-g4
end

%%% Prepare the models, i.e., determine which parameters will be fitted (-1)
%%% versus fixed (values) in each model; used for sim_par and fit_par
model_parameters = define_model_parameters;

%% Simulate / Load Data
switch sim_data
    case 'sim'
        
        % Which parameters are free in the simulation (-1) and which are fixed (value)?
        sim_par = model_parameters(model_ID(sim_model),:);
        
        % Load reward probabilities for all fractals over time
        load('list1.mat');
        fractal_rewards = x(5:8,:);
        
        % Run simulations
        Data = simulate_task(n_agents, n_trials, sim_par, fractal_rewards, common);
        save(['data_' sim_model '_agents' data_version '.mat'], 'Data')
        
    case 'load'
        load(['data_' sim_model '_agents' data_version '.mat'])
        
    case 'real'
        files = dir(file_dir);
        fileIndex = find(~[files.isdir]);
        n_agents = length(fileIndex);
end


%% Fit the parameters to the Data
if fit_data
    %%% Which parameters will be fitted (-1) and which are fixed by me (values)?
    fit_par = model_parameters(model_ID(fit_model),:);
    
    %%% Optimizer inputs
    [pmin, pmax, par0, n_fit, n_params] = get_fmincon_stuff(fit_par);
    
    %%% Create genrec, which will hold (true and) fitted parameters for each agent
    clear genrec
    genrec = zeros(n_agents, 2 * n_params + 7);
    for agent = 1:n_agents

        %%% Select data of one agent; save into Agent
        clear Agent
        if strcmp(sim_data, 'real')
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
        fun = @(par)computeNLL(Agent, par, n_fit, 'NLL', common, sim_data, fit_model);   % minimize neg. log. lik. for data Agent, finding the right par; n_fit = number of parameters to be estimated; common = probability of common transition in the task (70% percent); sim_data = simulated or human data; fit_model = which model should be fitted ('mb', 'mf', 'hyb')
        switch solver_algo
            case 'fmincon'   % fmincon MultiStart
                options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
                problem = createOptimProblem('fmincon', 'objective',...   % search problem
                fun, 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
                ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
                [x,f] = run(ms, problem, n_fmincon_iterations);   % look at x-position and function value of found minimum
            case 'ga'   % Genetic algorithm
%                 options = optimoptions('ga', 'UseParallel', true, 'UseVectorized', false);
                [x, f] = ga(fun, n_fit, [], [], [], [], pmin, pmax, [], options);
            case 'particleswarm'   % Particleswarm
                options = optimoptions('particleswarm', 'UseParallel', true, 'HybridFcn', @fmincon);
                [x, f] = particleswarm(fun, n_params, pmin, pmax, options);
        end
        NLLBICAIC = computeNLL(Agent, x, n_fit, 'all', common, sim_data, fit_model);

        %%% Save generated (simulated) and recovered (fitted) values in genrec
        genrec_columns; 
        genrec(agent, [agentID_c run_c]) = [agentID runID];
        if ~strcmp(sim_data, 'real')
            genrec(agent, gen_aabblwpk_c) = Agent(1, par_c);
        end
        genrec(agent, rec_aabblwpk_c) = x;   % Save fitted parameters (x) into the genrec rec paramater columns (aabblwpk)
        genrec(agent, NLLBICAIC_c) = NLLBICAIC;   % Save NLL, BIC, and AIC (NLLBICAIC) into the genrec NLLBICAIC columns (NLLBICAIC_c)

        %%% Save genrec to the disk; print agent number to the console to check where we are
        if mod(agent, 5) == 1
            save(genrec_file_name, 'genrec')
            agent
        end
    end
    
    %%% Save genrec after running the last agent
    save(genrec_file_name, 'genrec')
    agent
end
