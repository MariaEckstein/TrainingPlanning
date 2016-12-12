function NLL = computeNLL(par)

    %% Compute -LL of behavior, given parameters
    global Agent;   % contains frac1, frac2, and reward of one agent
    global Sim;
    
    %%% Parameter values at beginning of experiment
    alpha1 = par(1) / 2;
    alpha2 = par(2) / 2;
    beta1 = par(3) * 100;
    beta2 = par(4) * 100;
    lambda = 0.5 + par(5) / 2;
    w = par(6);
    
    epsilon = .00001;
    common = 0.8;
    Q1 = [.5 .5];   % initial values 2st-stage fractals
    Qmf1 = [.5 .5];
    Q2 = [.5 .5 .5 .5];   % initial values 2nd-stage fractals
    Qmf2 = [.5 .5 .5 .5];
    Sim.Q1(1, :) = Q1;
    Sim.Q2(1, :) = Q2;

    %%% Data: Participant behavior (= sequence of choices)
    n_trials = length(Agent.frac1);   % number of trials 
    LL = 0;   % initialize log likelihood

    %%% LL for each trial, given sequence of previous trials
    for t = 1:n_trials
        
        % Stage 1: Calculate likelihood of chosen actions
        frac1 = Agent.frac1(t);
        fractals1 = [1, 2];
        prob_frac1 = softmax_Q2p(fractals1, Q1, beta1, epsilon);   % 1 / (1 + e ** (beta * (Qa - Qb))
        
        % Stage 2: Calculate likelihood of chosen actions
        frac2 = Agent.frac2(t);
        if any(frac2 == [1, 2])
            fractals2 = [1, 2];
        else
            fractals2 = [3, 4];
        end
        prob_frac2 = softmax_Q2p(fractals2, Q2, beta2, epsilon);
        
        % Check outcome of trial and update values for next trial
        reward = Agent.reward(t);
        
        % Model-free
        Qmf2 = MF_update_Q2(frac2, Qmf2, reward, alpha2);
        Qmf1 = MF_update_Q1(frac1, Qmf1, reward, alpha1, lambda, Qmf2(frac2));

        % Model-based
        [Qmb1, Qmb2] = MB_update(Qmf2, common);

        % Combine model-free and model-based
        Q1 = (1 - w) * Qmf1 + w * Qmb1;
        Q2 = Qmf2;
        
        %%% Save trial data
        Sim.Q1(t+1, :) = Q1;
        Sim.Q2(t+1, :) = Q2;
        Sim.Qmb1(t+1, :) = Qmb1;
        Sim.Qmb2(t+1, :) = Qmb2;
        Sim.Qmf1(t+1, :) = Qmf1;
        Sim.Qmf2(t+1, :) = Qmf2;
        
        % Get log of likelihoods of both choices and sum up
        if any(frac2 == [1 3])
            f2_index = 1;
        else
            f2_index = 2;
        end
        LL = LL + log(prob_frac2(f2_index)) + log(prob_frac1(frac1));
        
    end
            
    % Take negative to get negative log likelihood
    NLL = -LL;
    
end
