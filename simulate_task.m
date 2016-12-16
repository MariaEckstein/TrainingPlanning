function Data = simulate_task(n_agents, n_trials, sim_par, fractal_rewards, common)

%     n_agents = 5;
%     n_trials = 5;
%     par = [0.1, 0.1, 0.3, 0.3, 0.4, 0.5];
%     fractal_rewards = [0 .3 .7 1];

%% Initialize dataframe that will hold all agents' behavior
Data = zeros(n_agents * n_trials, 25);
n_params = length(sim_par);
data_columns;
epsilon = 0.000001;

%% Find out which parameters are given and which should be free in each agent
random_par = zeros(1, length(sim_par));   % random_par == 1 where elements of par need to be randomized
for r = 1:length(sim_par)
    if sim_par(r) == -1
        random_par(r) = 1;
    end
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
    r_pos = 1;
    for r = random_par   % random_par == 1 where elements of par need to be randomized
        if r
            sim_par(r_pos) = rand;
        end
        r_pos = r_pos + 1;
    end
    alpha1 = sim_par(1) / 2;
    alpha2 = sim_par(2) / 2;
    beta1 = sim_par(3) * 100;
    beta2 = sim_par(4) * 100;
    lambda = sim_par(5) ;
    w = sim_par(6);
    p_par = 0; % sim_par(7) / 2;
    k_par = 0; %sim_par(8);
    
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
        prob_frac1 = softmax_Q2p(fractals1, Q1, beta1, key1, frac1, k_par, p_par, epsilon);   % 1 / (1 + e ** (beta * (Qa - Qb))
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
        Data(a_t, par_c) = sim_par;

    end
end
