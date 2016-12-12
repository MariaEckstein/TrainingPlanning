
%% Simulate some data
n_agents = 100;
n_trials = 150;
sim_par = [0.1, 0.1, 0.3, 0.3, 0.4, 0.5];
fractal_rewards = [0 .3 .7 1];
Data = simulate_task(n_agents, n_trials, [], fractal_rewards);


 %% Find parameters that maximize the likelihood of the data
for agent = 1:n_agents
    
    %%% Select data of one agent; save into Agent
    clear Agent
    clear Sim
    global Agent;   % Behavior of one particular agent
    global Sim;   % Simulated values of this agent
    
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
    agent   % Check where we are
    Agent.par   % Check true parameters
    NLL = computeNLL(Agent.par)   % Show negative log likelihood of agent's true parameters

    %%% Create genrec, which will hold true and fitted parameters for each agent
    genrec.AgentID(agent) = agent;
    genrec.a1(agent, :) = true_par(1, 1);
    genrec.a2(agent, :) = true_par(1, 2);
    genrec.b1(agent, :) = true_par(1, 3);
    genrec.b2(agent, :) = true_par(1, 4);
    
    %%% Set up minimization problem
    n_params = length(sim_par);
    pmin = zeros(1, n_params);   % lower bound of params (all params should be on the same scale)
    pmax = ones(1, n_params);   % upper bound of params 
    par0 = ones(1, length(pmin)) .* ((pmax - pmin) / 2);   % initial start values for search 

    %%% MultiStart
%     options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
%     problem = createOptimProblem('fmincon', 'objective',...   % search problem
%     @computeNLL, 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
%     ms = MultiStart;   % we want multiple starts to find a global minimum
%     [x,f] = run(ms, problem, 50);   % look at x-position and function value of found minimum

    %%% GlobalSearch
    options = optimoptions(@fmincon,'Algorithm','sqp');   % options for search (interior-point)
    problem = createOptimProblem('fmincon','objective',...   % search problem
    @computeNLL, 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
    gs = GlobalSearch('Display', 'off');   % for debugging: 'iter'
    [x,f] = run(gs,problem);   % look at x-position and function value of found minimum

    genrec.fa1(agent, :) = x(1);
    genrec.fa2(agent, :) = x(2);
    genrec.fb1(agent, :) = x(3);
    genrec.fb2(agent, :) = x(4);
end

%% Look at difference between mb values, mf values, and combined values
figure
subplot(2, 3, 1)
plot(Agent.Q1)
title('Q1')
subplot(2, 3, 2)
plot(Agent.Qmf1)
title('Q1 (mf)')
subplot(2, 3, 3)
plot(Agent.Qmb1)
title('Q1 (mb)')
subplot(2, 3, 4)
plot(Agent.Q2)
title('Q2')
subplot(2, 3, 5)
plot(Agent.Qmf2)
title('Q2 (mf)')
subplot(2, 3, 6)
plot(Agent.Qmb2)
title('Q2 (mb)')


%% Check for one example agent that true and fitted values look alike
figure
subplot(2, 2, 1)
plot(Sim.Q1)
title('Sim Q1')
subplot(2, 2, 2)
plot(Sim.Q2)
title('Sim Q2')
subplot(2, 2, 3)
plot(Agent.Q1)
title('True Q1')
subplot(2, 2, 4)
plot(Agent.Q2)
title('True Q2')


%% Plot all true and fitted alphas and betas against each other
figure
subplot(2,2,1)
scatter(genrec.a1, genrec.fa1)
lsline
title('Alpha 1')
subplot(2,2,2)
scatter(genrec.a2, genrec.fa2)
lsline
title('Alpha 2')
subplot(2,2,3)
scatter(genrec.b1, genrec.fb1)
lsline
title('Beta 1')
subplot(2,2,4)
scatter(genrec.b2, genrec.fb2)
lsline
title('Beta 1')
    