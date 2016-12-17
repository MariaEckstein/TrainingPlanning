function Data = simulate_task(n_agents, n_trials, par, fractal_rewards, common)

%     n_agents = 5;
%     n_trials = 5;
%     par = [0.1, 0.4, 0.3, 0.3, 0.4, 0.5, 0.7, 0.2];
%     load('list1.mat');
%     fractal_rewards = x(5:8,:);
%     common = 0.7;

%% Initialize dataframe that will hold all agents' behavior
Data = zeros(n_agents * n_trials, 25);
n_params = length(par);
data_columns;
epsilon = 0.000001;

%%% Find out which parameters are given and which should be free in each agent
rand_par = par == -1;   % check which parameters should vary between agents
if par(7) == 0
    p_par = 0;
else
    p_par = rand;
end
if par(8) == 0
    k_par = 0;
else
    k_par = rand;
end

%% Simulate a bunch of agents
for agent = 1:n_agents
    a = (agent - 1) * n_trials + 1;   % get first row of this agent in Data
    Q1 = [.5 .5];   % initial values 2st-stage fractals
    Qmf1 = [.5 .5];
    Q2 = [.5 .5 .5 .5];   % initial values 2nd-stage fractals
    Qmf2 = [.5 .5 .5 .5];
    Data(a, Q1_c) = Q1;
    Data(a, Q2_c) = Q2;
    Data(a:(a+n_trials-1), AgentID_c) = agent;

    % Create an individual agent
    par(rand_par) = rand(1, sum(rand_par));   % draw random numbers for these parameters
    alpha1 = par(1) ;
    alpha2 = par(2) ;
    beta1 = par(3) * 100;
    beta2 = par(4) * 100;
    lambda = par(5) ;
    w = par(6);
    if ~(p_par == 0)
        p_par = par(7) * 10 - 5;
    end
    if ~ (k_par == 0)
        k_par = par(8) * 10 - 5;
    end
    
    % Initialize non-existent last keys and last fractals, so that no fractal gets a bonus in the first trial
    key1 = 123;
    key2 = 123;
    frac1 = 123;
    frac2 = 123;

    % Let agent play the game
    for t = 1:n_trials
        a_t = a + t - 1;   % row for each trial in this agent's Data

        %%% Stage 1
        fractals1 = [1, 2];
        keys1 = randsample([1 2], 2, false);   % randomly determine which key is associated with each fractal
        % Agent picks one of the two fractals
        prob_frac1 = softmax_Q2p(fractals1, Q1, beta1, key1, frac1, k_par, p_par, epsilon);   % 1 / (1 + e ** ((beta * (Qb - Qa) + k * (kbonb - keybona) + p * (pbonb = pbona)))
        frac1 = choice(fractals1, prob_frac1);   % pick one action, according to probs
        key1 = keys1(frac1);   % record which key corresponds to the selected fractal

        %%% Stage 2
        fractals2 = select_stage2_fractals(frac1, common);
        keys2 = randsample([1 2], 2, false);   % randomly determine which key is associated with each fractal
        keys2 = [keys2 keys2];   % repeat, so that frac2==3 works like frac2==1 and frac2==4 works like frac2==2
        % Agent picks one of the two fractals
        prob_frac2 = softmax_Q2p(fractals2, Q2, beta2, key2, frac2, k_par, p_par, epsilon);   % 1 / (1 + e ** (beta * (Qa - Qb))
        frac2 = choice(fractals2, prob_frac2);   % pick one action, according to probs
        key2 = keys2(frac2);   % record which key corresponds to the selected fractal

        % Agent receives reward
        reward = rand < fractal_rewards(frac2, t);

        %%%  Agent updates 1st- and 2nd-stage values
        % Model-free
        Qmf1 = MF_update_Q1(frac1, Qmf1, reward, alpha1, lambda, Qmf2, frac2);
        Qmf2 = MF_update_Q2(frac2, Qmf2, reward, alpha2);

        % Model-based
        [Qmb1, Qmb2] = MB_update(Qmf2, common);

        % Combine model-free and model-based
        Q1 = (1 - w) * Qmf1 + w * Qmb1;
        Q2 = Qmf2;

        %% Save trial data
        % Values
        Data(a_t+1, [Q1_c Q2_c]) = [Q1 Q2];
        Data(a_t+1, [Qmf1_c Qmf2_c]) = [Qmf1 Qmf2];
        Data(a_t+1, [Qmb1_c Qmb2_c]) = [Qmb1 Qmb2];
        % Actions & reward
        Data(a_t, [frac1_c frac2_c]) = [frac1 frac2];
        Data(a_t, [key1_c key2_c]) = [key1 key2];
        Data(a_t, reward_c) = reward;
        % Parameters
        Data(a_t, par_c) = par;

    end
end
