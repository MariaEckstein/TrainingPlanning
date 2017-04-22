function Data = simulate_task(n_agents, n_trials, par, common)

%% Initialize dataframe that will hold all agents' behavior
Data = zeros(n_agents * n_trials, 25);
n_params = length(par);
data_columns;

%%% Find out which parameters are given and which should be free in each agent
rand_par = par == -1;   % check which parameters should vary between agents

%%% Load reward probabilities for all fractals over time
load('list1.mat');
fractal_rewards = x(5:8,:);        

%% Simulate a bunch of agents
for agent = 1:n_agents
    initialize_par;   % Get initial values; parameters; and last trial's keys
    
    a = (agent - 1) * n_trials + 1;   % get first row of this agent in Data
    Data(a, Q1_c) = Q1;
    Data(a, Q2_c) = Q2;
    Data(a:(a+n_trials-1), AgentID_c) = agent;   % agentID

    % Create an individual agent
    par(rand_par) = rand(1, sum(rand_par));   % draw random numbers for these parameters
    
    % Name the keys (1 = left; 2 = right)
    keys1 = [1 2];
    keys2 = [1 2 1 2];   % repeat, so that all 4 2nd-stage fractals can be accessed

    % Let agent play the game
    for t = 1:n_trials
        a_t = a + t - 1;   % row for each trial in this agent's Data

        %%% Stage 1
        fractals1 = randsample([1 2], 2, false);   % randomly determine which fractal will be presented where
        % Agent picks one of the two fractals
        prob_frac1 = softmax_Q2p(fractals1, Q1, beta1, key1, frac1, k_par, p_par, epsilon);   % 1 / (1 + e ** ((beta * (Qb - Qa) + k * (kbonb - keybona) + p * (pbonb = pbona)))
        frac1 = choice(fractals1, prob_frac1);   % pick one action, according to probs
        key1 = keys1(fractals1 == frac1);   % record which key corresponds to the selected fractal

        %%% Stage 2
        fractals2 = select_stage2_fractals(frac1, common);   % Pick 2nd-stage fractals and shuffle order
        % Agent picks one of the two fractals
        prob_frac2 = softmax_Q2p(fractals2, Q2, beta2, key2, frac2, k_par, p_par, epsilon);   % 1 / (1 + e ** (beta * (Qa - Qb))
        frac2 = choice(fractals2, prob_frac2);   % pick one action, according to probs
        key2 = keys2(fractals2 == frac2);   % record which key corresponds to the selected fractal

        % Agent receives reward
        reward = rand < fractal_rewards(frac2, t);

        %%%  Agent updates 1st- and 2nd-stage values
        % Model-free
        Qmf1 = MF_update_Q1(frac1, Qmf1, reward, alpha1, lambda, Qmf2, frac2);
        Qmf2 = MF_update_Q2(frac2, Qmf2, reward, alpha2);
%         VPE = Qmf2(frac2) - Qmf1(frac1);   % value prediction error: difference between actual and predicted value of 2nd fractal
%         RPE = reward - Qmf2(frac2);   % reward prediction error: difference between actual and predicted reward
%         Qmf1(frac1) = Qmf1(frac1) + alpha1 * (VPE + lambda * RPE);   % 1st-stage RL value update, including eligibility trace
%         Qmf2(frac2) = Qmf2(frac2) + alpha2 * RPE;   % 2nd-stage simple RL value update

        % Model-based
        Qmb1 = MB_update(Qmf2, common);
%         Qmb1_frac1 = common * max(Qmf2(1:2)) + (1 - common) * max(Qmf2(3:4));
%         Qmb1_frac2 = (1 - common) * max(Qmf2(1:2)) + common * max(Qmf2(3:4));
%         Qmb1 = [Qmb1_frac1 Qmb1_frac2];

        % Combine model-free and model-based
        Q1 = (1 - w) * Qmf1 + w * Qmb1;
        Q2 = Qmf2;

        %% Save trial data
        % Values
        Data(a_t+1, [Q1_c Q2_c]) = [Q1 Q2];
        Data(a_t+1, [Qmf1_c Qmf2_c]) = [Qmf1 Qmf2];
        Data(a_t+1, [Qmb1_c Qmb2_c]) = [Qmb1 Qmf2];
        % Actions & reward
        Data(a_t, [frac1_c frac2_c]) = [frac1 frac2];
        Data(a_t, [key1_c key2_c]) = [key1 key2];
        Data(a_t, [frac1_p frac2_p]) = [fractals1 fractals2];
        Data(a_t, reward_c) = reward;
        % Parameters
        Data(a_t, par_c) = par;

    end
end