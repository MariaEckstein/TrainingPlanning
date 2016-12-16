%% TDs
% Create BIC confusion table

%% Prepare some things
%%% General
location = 'home';   % Can be 'home' or 'cluster'
common = 0.7;   % Probability of the common transition
%%% Which parameters should be estimated (-1) and which fixed (value)?
label = 'given_mb_agents_hyb_sim';
a1 = -1;
a2 = -1;
b1 = -1;
b2 = -1;
l = -1;
w = -1;

%% Function inputs
sim_par = [a1 a2 b1 b2 l w]; % parameters for simulated data
pmin = sim_par;   % lower bound for fitting parameters
pmin(sim_par == -1) = 0;
pmax = sim_par;  % upper bound for fitting
pmax(sim_par == -1) = 1;
par0 = ones(1, length(pmin)) .* ((pmax - pmin) / 2);   % initial start values for fitting
n_fit = sum(sim_par == -1);   % number of parameters that are fitted (for BIC & AIC)
n_params = length(sim_par);   % number of parameters

if strcmp(location, 'home')
    n_agents = 3;
    n_fmincon_iterations = 5;
    n_trials = 50;
else
    parpool(12);   % Specify parallel processing stuff: Can only be 2 for my old laptop; should be <= 8 on the HWNI cluster
    n_agents = 200;
    n_fmincon_iterations = 80;
    n_trials = 201;
end
    
%% Simulate some data
% Get reward probabilities
load('list1.mat');
fractal_rewards = x(5:8,:);
% Run simulations
% Data = simulate_task(n_agents, n_trials, sim_par, fractal_rewards, common);
load('data_mb_agents_mb_sim_15-Dec-2016_14.45.mat')
data_columns;   % Find out which columns contain what

 %% Find parameters that maximize the likelihood of the data
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
    @(par)computeNLL(Agent, par, common, w), 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
    ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
    [x,f] = run(ms, problem, n_fmincon_iterations);   % look at x-position and function value of found minimum
    [NLL, BIC, AIC] = computeBIC(Agent, x, common, w, n_fit);

    %%% Save generated (simulated) and recovered (fitted) values in genrec
    genrec_columns;
    genrec(agent, 1) = agent;
    genrec(agent, gen_aabblwpk_c) = Agent(1, par_c);
    genrec(agent, rec_aabblwpk_c) = x;
    genrec(agent, 20:21) = [BIC AIC];
end

%% Save genrec and Data when running on the cluster
if ~strcmp(location, 'home')
    today = date;
    now = clock;
    hour = num2str(now(4));
    minute = num2str(now(5));
    time = [hour '.' minute];
    genrec_file_name = ['genrec_' label '_' today '_' time '.mat'];
    save(genrec_file_name, 'genrec')

    data_file_name = ['data_' label '_' today '_' time '.mat'];
    save(data_file_name, 'Data')
end
