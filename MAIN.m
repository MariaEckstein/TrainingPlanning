
%% TDs
% Basic data cleaning (remove too fast trials; remove nans; remove trials
% where fract2 == -2; remove strokes with the same key more than x times

%% Switches for this script (would be function argument if this were a function)
sim_data = 'real';   % Should the data be simulated ('sim') or loaded from disk ('load') or is the real dataset used ('real')?
sim_model = 'real';   % What model should be used for simulation / what data should be loaded? ('mb', 'mf', 'hyb')
fit_model = '1a1b';   % What model should be used for fitting? ('mf', 'mb', 'hyb', '1a1b' (Also needs changes in computeNLL!!))
location = 'home';   % Where is this code run? Can be 'home' or 'cluster'

%%% Additional stuff
data_version = '_new';   % What simulations should be loaded? Can be '' (6 parameters) or '_new' (8 parameters)
% If you want to run the script on the old data (6 parameters only), you
% also need to change n_params, or whatever leads to it!
common = 0.7;   % Probability of the common transition
fit_data = true;   % Sould the data also be fitted? Or just simulated?
if isnan(fit_model)
    fit_data = false;
end


%% Prepare things
%%% Things on cluster and at home
if strcmp(location, 'home')
    n_agents = 5;
    n_fmincon_iterations = 3;
    n_trials = 150;
    file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';   % Where is the original data stored? 
else
    parpool(12);   % Specify parallel processing stuff: Can only be 2 for my old laptop; should be <= 8 on the HWNI cluster
    n_agents = 200;
    n_fmincon_iterations = 80;
    n_trials = 201;
    file_dir = 'datafiles/g2';   % equal portions of the files are in folders g1-g4
end
    
%%% Which parameters are free in the simulation (-1) and which are fixed (value)?
switch sim_model
    case 'mf'
        sim_par = [-1 -1 -1 -1 -1 0 -1 -1];   % a1 a2 b1 b2 l w p k
    case 'mb'
        sim_par = [ 0 -1 -1 -1  0 1 -1 -1];   % a1 a2 b1 b2 l w p k
    case 'hyb'
        sim_par = -1 * ones(1, 8);   % a1 a2 b1 b2 l w p k
end

%% Simulate / Load Data
switch sim_data
    case 'sim'
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
    switch fit_model
        case 'mf'
            fit_par = [-1 -1 -1 -1 -1  0 -1 -1];   % a1 a2 b1 b2 l w p k
        case 'mb'
            fit_par = [ 0 -1 -1 -1  0  1 -1 -1];   % a1 a2 b1 b2 l w p k
        case 'hyb'
            fit_par = -1 * ones(1, 8);   % a1 a2 b1 b2 l w p k
        case '1a1b'   % Also needs changes in computeNLL!!
            fit_par = [0 -1  0 -1 -1 -1 -1 -1];
        case 'ablw1pk'
            fit_par = [0 -1  0 -1 -1  1 -1 -1];
    end
    
    %%% Fmincon inputs
    pmin = fit_par;   % lower bound for fitting parameters
    pmin(fit_par == -1) = 0;
    pmax = fit_par;  % upper bound for fitting
    pmax(fit_par == -1) = 1;
    for p = [7 8]
        if fit_par(p) == 0
            pmin(p) = 0.5;
            pmax(p) = 0.5;
        end
    end
    par0 = ones(1, length(pmin)) .* (pmin + (pmax - pmin) / 2);   % initial start values for fitting
    n_fit = sum(fit_par == -1);   % number of parameters that are fitted (for BIC & AIC)
    n_params = length(fit_par);   % number of parameters
    
    %%% Create genrec, which will hold true and fitted parameters for each agent
    clear genrec
    genrec = zeros(n_agents, 2 * n_params + 7);
    for agent = 1:n_agents

        %%% Print agent number to check where we are
        if mod(agent, 10) == 1
            agent
        end

        %%% Select data of one agent; save into Agent
        clear Agent
        if strcmp(sim_data, 'real')
            real_data_columns;   % Find out which columns contain what
            fileName = files(fileIndex(agent)).name;
            load([file_dir '/' fileName]);
            Agent = params.user.log;
            Agent(:, frac2_c) = Agent(:, frac2_c) - 2;   % stage-2 fractals are numbered 3-6 in the real data, but need to be 1-4 for my analysis
            complete_data_rows = ~isnan(Agent(:, key1_c)) & ~isnan(Agent(:, key2_c)) & Agent(:, frac2_c) > 0;
            Agent = Agent(complete_data_rows,:);
            agentID =  fileName(length(fileName)-9:length(fileName)-7);
            runID = fileName(length(fileName)-5);
        else
            data_columns;   % Find out which columns contain what
            agent_rows = Data(:, AgentID_c) == agent;
            Agent = Data(agent_rows, :);
            agentID = agent;
            runID = nan;
        end

        %%% MultiStart
        options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
        problem = createOptimProblem('fmincon', 'objective',...   % search problem
        @(par)computeNLL1a1b(Agent, par, n_fit, 'NLL', common, sim_data), 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
        ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
        [x,f] = run(ms, problem, n_fmincon_iterations);   % look at x-position and function value of found minimum
        NLLBICAIC = computeNLL1a1b(Agent, x, n_fit, 'all', common, sim_data);

        %%% Save generated (simulated) and recovered (fitted) values in genrec
        genrec_columns;
        genrec(agent, agentID_c) = str2double(agentID);
        genrec(agent, run_c) = str2double(runID);
        if ~strcmp(sim_data, 'real')
            genrec(agent, gen_aabblwpk_c) = Agent(1, par_c);
        end
        genrec(agent, rec_aabblwpk_c) = x;
        genrec(agent, NLLBICAIC_c) = NLLBICAIC;
    end

    %% Save genrec and Data when running on the cluster
    if ~strcmp(location, 'home')
        today = date;
        now = clock;
        hour = num2str(now(4));
        minute = num2str(now(5));
        time = [hour '.' minute];
        genrec_file_name = ['genrec_' sim_model '_agents_' fit_model '_sim_' today '_' time '.mat'];
        save(genrec_file_name, 'genrec')
    end
end
