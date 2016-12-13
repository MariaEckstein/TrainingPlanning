%% TDs
% Feed actual, changing rewards
% Try MB on MF and MF on MB


%% Specify parallel processing stuff
parpool(6);   % Can only be 2 for my old laptop; should be <= 8 on the HWNI cluster

%% Simulate some data
n_agents = 300;
n_fmincon_iterations = 80;
n_trials = 150;
sim_par = [0.1, 0.1, 0.3, 0.3, 0.4, 0.5];
fractal_rewards = [0 .3 .7 1];
Data = simulate_task(n_agents, n_trials, [], fractal_rewards);

 %% Find parameters that maximize the likelihood of the data
clear genrec
for agent = 1:n_agents
    
    %%% Select data of one agent; save into Agent
    clear Agent
    agent_rows = Data.AgentID == agent;
    Agent.frac1 = Data.frac1(agent_rows);
    Agent.frac2 = Data.frac2(agent_rows);
    Agent.Q1 = Data.Q1(agent_rows, :);
    Agent.Q2 = Data.Q2(agent_rows, :);
    Agent.Qmb1 = Data.Qmb1(agent_rows, :);
    Agent.Qmb2 = Data.Qmb2(agent_rows, :);
    Agent.Qmf1 = Data.Qmf1(agent_rows, :);
    Agent.Qmf2 = Data.Qmf2(agent_rows, :);
    Agent.reward = Data.reward(agent_rows);
    true_par = Data.par(agent_rows, :);
    Agent.par = true_par(1, :);
    
    %%% Test computeNLL function
    if mod(agent, 10) == 1
        agent   % Check where we are
        Agent.par   % Check true parameters
        NLL = computeNLL(Agent.par)   % Show negative log likelihood of agent's true parameters
    end
    
    %%% Set up minimization problem
    n_params = length(sim_par);
    pmin = zeros(1, n_params);   % lower bound of params (all params should be on the same scale)
    pmax = ones(1, n_params);   % upper bound of params 
    par0 = ones(1, length(pmin)) .* ((pmax - pmin) / 2);   % initial start values for search 

    %%% MultiStart
    options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
    problem = createOptimProblem('fmincon', 'objective',...   % search problem
    @(par)computeNLL(Agent, par), 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
    ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
%     ms.UseParallel = true;
    [x,f] = run(ms, problem, n_fmincon_iterations);   % look at x-position and function value of found minimum

    %%% Create genrec, which will hold true and fitted parameters for each agent
    genrec.AgentID(agent) = agent;
    genrec.a1(agent, :) = true_par(1, 1);
    genrec.a2(agent, :) = true_par(1, 2);
    genrec.b1(agent, :) = true_par(1, 3);
    genrec.b2(agent, :) = true_par(1, 4);
    genrec.l(agent, :) = true_par(1, 5);
    genrec.w(agent, :) = true_par(1, 6);
    genrec.fa1(agent, :) = x(1);
    genrec.fa2(agent, :) = x(2);
    genrec.fb1(agent, :) = x(3);
    genrec.fb2(agent, :) = x(4);
    genrec.fl(agent, :) = x(5);
    genrec.fw(agent, :) = x(6);
end

today = date;
now = clock;
hour = num2str(now(4));
minute = num2str(now(5));
time = [hour '.' minute];
file_name = ['genrec_' today '_' time '.mat'];
save(file_name, 'genrec')
