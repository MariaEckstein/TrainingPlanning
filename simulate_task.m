function Data = simulate_task(n_agents, n_trials, par, fractal_rewards)

    %%% Initialize big dataframe that will contain all agents' behavior
    global Data;
    epsilon = 0.000001;
    common = 0.8;
    random_par = 0;
    if isempty(par)
        random_par = 1
    end

    %%% Simulate a bunch of agents
    for agent = 1:n_agents
        a = (agent - 1) * n_trials + 1;   % get first row of this agent in Data
        Q1 = [.5 .5];   % initial values 2st-stage fractals
        Qmf1 = [.5 .5];
        Q2 = [.5 .5 .5 .5];   % initial values 2nd-stage fractals
        Qmf2 = [.5 .5 .5 .5];
        Data.Q1(a, :) = Q1;
        Data.Q2(a, :) = Q2;
        Data.AgentID(a:(a+n_trials-1)) = agent;
        
        % Create an individual agent
        if random_par
            par = rand([1, 6]);
        end
        alpha1 = par(1) / 2;
        alpha2 = par(2) / 2;
        beta1 = par(3) * 100;
        beta2 = par(4) * 100;
        lambda = 0.5 + par(5) / 2;
        w = par(6);
        
        % Let agent play the game
        for t = 1:n_trials
            a_t = a + t - 1;   % row for each trial in this agent's Data
            
            %%% Stage 1
            fractals1 = [1, 2];
            % Agent picks one of the two fractals
            prob_frac1 = softmax_Q2p(fractals1, Q1, beta1, epsilon);   % 1 / (1 + e ** (beta * (Qa - Qb))
            frac1 = choice(fractals1, prob_frac1);   % pick one action, according to probs
            
            %%% Stage 2
            fractals2 = select_stage2_fractals(frac1, common);
            % Agent picks one of the two fractals
            prob_frac2 = softmax_Q2p(fractals2, Q2, beta2, epsilon);   % 1 / (1 + e ** (beta * (Qa - Qb))
            frac2 = choice(fractals2, prob_frac2);   % pick one action, according to probs
            
            % Agent receives reward
            reward = rand < fractal_rewards(frac2);
            
            %%%  Agent updates 1st- and 2nd-stage values
            % Model-free
            Qmf2 = MF_update_Q2(frac2, Qmf2, reward, alpha2);
            Qmf1 = MF_update_Q1(frac1, Qmf1, reward, alpha1, lambda, Qmf2(frac2));
            
            % Model-based
            [Qmb1, Qmb2] = MB_update(Qmf2, common);
            
            % Combine model-free and model-based
            Q1 = (1 - w) * Qmf1 + w * Qmb1;
            Q2 = Qmf2;
            
            %%% Save trial data
            % Values
            Data.Q1(a_t+1, :) = Q1;
            Data.Q2(a_t+1, :) = Q2;
            Data.Qmb1(a_t+1, :) = Qmb1;
            Data.Qmb2(a_t+1, :) = Qmb2;
            Data.Qmf1(a_t+1, :) = Qmf1;
            Data.Qmf2(a_t+1, :) = Qmf2;
            % Actions & reward
            Data.frac1(a_t, :) = frac1;
            Data.frac2(a_t, :) = frac2;
            Data.reward(a_t, :) = reward;
            % Parameters
            Data.par(a_t, 1:length(par)) = par;
            
        end
    end
end