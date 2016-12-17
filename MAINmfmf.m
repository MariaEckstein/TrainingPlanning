

%% Switches for this script (would be function argument if this were a function)
sim_data = false;   % Should the data be simulated (true) or loaded from disk (false)?
sim_model = 'mf';   % What model should be used for simulation / what data should be loaded?
fit_model = 'mb';   % What model should be used for fitting?
location = 'cluster';   % Where is this code run? Can be 'home' or 'cluster'

%%% Additional stuff
common = 0.7;   % Probability of the common transition
fit_data = true;   % Sould the data also be fitted? Or just simulated?
if isnan(fit_model)
    fit_data = false;
end


%% Prepare things
%%% Things on cluster and at home
if strcmp(location, 'home')
    n_agents = 15;
    n_fmincon_iterations = 3;
    n_trials = 150;
else
    parpool(12);   % Specify parallel processing stuff: Can only be 2 for my old laptop; should be <= 8 on the HWNI cluster
    n_agents = 200;
    n_fmincon_iterations = 80;
    n_trials = 201;
end
    
%%% Which parameters are free in the simulation (-1) and which are fixed (value)?
if strcmp(sim_model, 'mf')
    sim_par = [-1 -1 -1 -1 -1 0 -1 -1];   % a1 a2 b1 b2 l w p k
elseif strcmp(sim_model, 'mb')
    sim_par = [ 0 -1 -1 -1  0 1 -1 -1];   % a1 a2 b1 b2 l w p k
elseif strcmp(sim_model, 'hyb')
    sim_par = -1 * ones(1, 8);   % a1 a2 b1 b2 l w p k
end

%% Simulate / Load Data
if sim_data
    % Load reward probabilities for all fractals over time
    load('list1.mat');
    fractal_rewards = x(5:8,:);
    % Run simulations
    Data = simulate_task(n_agents, n_trials, sim_par, fractal_rewards, common);
    save(['data_' sim_model '_agents_new.mat'], 'Data')
else
    load(['data_' sim_model '_agents_new.mat'])
end

%% Fit the parameters to the Data
if fit_data
    %%% Which parameters will be fitted (-1) and which are fixed by me (values)?
    if strcmp(fit_model, 'mf')
        fit_par = [-1 -1 -1 -1 -1 0 -1 -1];   % a1 a2 b1 b2 l w p k
    elseif strcmp(fit_model, 'mb')
        fit_par = [ 0 -1 -1 -1  0 1 -1 -1];   % a1 a2 b1 b2 l w p k
    elseif strcmp(fit_model, 'hyb')
        fit_par = -1 * ones(1, 8);   % a1 a2 b1 b2 l w p k
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
    par0 = ones(1, length(pmin)) .* ((pmax - pmin) / 2);   % initial start values for fitting
    n_fit = sum(fit_par == -1);   % number of parameters that are fitted (for BIC & AIC)
    n_params = length(fit_par);   % number of parameters
    
    %%% General stuff
    data_columns;   % Find out which columns contain what

    %%% Create genrec, which will hold true and fitted parameters for each agent
    clear genrec
    genrec = zeros(n_agents, 10);
    for agent = 1:n_agents

        %%% Print agent number to check where we are
        if mod(agent, 10) == 1
            agent
        end

        %%% Select data of one agent; save into Agent
        clear Agent
        agent_rows = Data(:, AgentID_c) == agent;
        Agent = Data(agent_rows, :);

        %%% MultiStart
        options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
        problem = createOptimProblem('fmincon', 'objective',...   % search problem
        @(par)computeNLL(Agent, par, common), 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
        ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
        [x,f] = run(ms, problem, n_fmincon_iterations);   % look at x-position and function value of found minimum
        [NLL, BIC, AIC] = computeBIC(Agent, x, common, n_fit);

        %%% Save generated (simulated) and recovered (fitted) values in genrec
        genrec_columns;
        genrec(agent, 1) = agent;
        genrec(agent, gen_aabblwpk_c) = Agent(1, par_c);
        genrec(agent, rec_aabblwpk_c) = x;
        genrec(agent, 20:22) = [BIC AIC NLL];
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
