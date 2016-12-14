%% TDs
% Feed actual, changing rewards
% Try MB on MF and MF on MB


location = 'home';   % Can be 'home' or 'cluster'

if strcmp(location, 'home')
    %% Simulate some data
    n_agents = 3;
    n_fmincon_iterations = 3;
    n_trials = 15;
else
    %% Specify parallel processing stuff
    parpool(8);   % Can only be 2 for my old laptop; should be <= 8 on the HWNI cluster
    %% Simulate some data
    n_agents = 100;
    n_fmincon_iterations = 80;
    n_trials = 150;
end
    
mf_par = [-1, -1, -1, -1, 1, 0];
mb_par = [-1, -1, -1, -1, 1, 1];
sim_par = -1 * ones(1, length(mf_par));   % mf_par;
load('list1.mat');
fractal_rewards = x(5:8,:);
Data = simulate_task(n_agents, n_trials, sim_par, fractal_rewards);

 %% Find parameters that maximize the likelihood of the data
clear genrec
for agent = 1:n_agents
    
    %%% Select data of one agent; save into Agent
    clear Agent
    agent_rows = Data.AgentID == agent;
    Agent.frac1 = Data.frac1(agent_rows);
    Agent.frac2 = Data.frac2(agent_rows);
    Agent.reward = Data.reward(agent_rows);
    true_par = Data.par(agent_rows, :);
    Agent.par = true_par(1, :);
    
    %%% Test computeNLL function
    if mod(agent, 10) == 1
        agent   % Check where we are
%         Agent.par   % Check true parameters
%         NLL = computeNLL(Agent, Agent.par)   % Show negative log likelihood of agent's true parameters
    end
    
    %%% Set up minimization problem
    n_params = length(sim_par);
    pmin = zeros(1, n_params);   % lower bound of params (all params should be on the same scale)
    pmax = ones(1, n_params);   % upper bound of params 
    par0 = ones(1, length(pmin)) .* ((pmax - pmin) / 2);   % initial start values for search
%     pmin = pmin(1:5);
%     pmax = pmax(1:5);
%     par0 = par0(1:5);

    %%% MultiStart
    options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
    problem = createOptimProblem('fmincon', 'objective',...   % search problem
    @(par)computeNLL(Agent, par, [], []), 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
    ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
    [x,f] = run(ms, problem, n_fmincon_iterations);   % look at x-position and function value of found minimum
    [NLL, BIC] = computeNLL(Agent, x, [], []);

    %%% Create genrec, which will hold true and fitted parameters for each agent
    % True parameters
    genrec.AgentID(agent) = agent;
    genrec.a1(agent, :) = true_par(1, 1);
    genrec.a2(agent, :) = true_par(1, 2);
    genrec.b1(agent, :) = true_par(1, 3);
    genrec.b2(agent, :) = true_par(1, 4);
    genrec.l(agent, :) = true_par(1, 5);
    genrec.w(agent, :) = true_par(1, 6);
    % Fitted parameters
    genrec.fa1(agent, :) = x(1);
    genrec.fa2(agent, :) = x(2);
    genrec.fb1(agent, :) = x(3);
    genrec.fb2(agent, :) = x(4);
    genrec.fl(agent, :) = x(5);
    genrec.fw(agent, :) = x(6);
    genrec.BIC(agent, :) = BIC;
end

%% Save genrec and Data
today = date;
now = clock;
label = 'free_agents_free_sim';
hour = num2str(now(4));
minute = num2str(now(5));
time = [hour '.' minute];
genrec_file_name = ['genrec_' label '_' today '_' time '.mat'];
save(genrec_file_name, 'genrec')

data_file_name = ['data_' label '_' today '_' time '.mat'];
save(data_file_name, 'Data')
