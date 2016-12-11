function NLL = computeNLL(par)

    %% Compute -LL of behavior, given parameters
    global Agent;   % contains Q1, Q2, frac1, frac2, reward
    global Sim;
    
    %%% Parameter values at beginning of experiment
    alpha1 = par(1) / 2;
    alpha2 = par(2) / 2;
    beta1 = par(3) * 100;
    beta2 = par(4) * 100;
    lambda = 0.5 + par(5) / 2;
    w = par(6);
    
    epsilon = .00001;
    Q1 = [.5 .5];
    Q2 = [.5 .5 .5 .5];
    Sim.Q1(1, :) = Q1;
    Sim.Q2(1, :) = Q2;

    %%% Data: Participant behavior (= sequence of choices)
    ntrials = length(Agent.frac1);   % number of trials 
    LL = 0;   % initialize log likelihood

    %%% LL for each trial, given sequence of previous trials
    for t = 1:ntrials
        
        % Calculate likelihood of chosen actions: e^Qx / (e^Qa + e^Qb)
        frac1 = Agent.frac1(t);
        prob_frac1 = 1 / (exp( beta1 * (Q1(1) - Q1(frac1))) + exp( beta1 * (Q1(2) - Q1(frac1))));   % e^bQx / (e^bQa + e^bQb) = 1 / (e^b(Qa-Qx) + e^b(Qb-Qx))
        prob_frac1 = (1 - epsilon) * prob_frac1 + epsilon * 0.5;   % combination of calculated prob and randon; reason: take care of Inf, resulting from computer being inaccurate
        
        frac2 = Agent.frac2(t);
        if any(frac2 == [1 2])
            frac2o = 1;
        else
            frac2o = 3;
        end
        prob_frac2 = 1 / (exp( beta2 * (Q2(frac2o) - Q2(frac2))) + exp( beta2 * (Q2(frac2o + 1) - Q2(frac2))));
        prob_frac2 = (1 - epsilon) * prob_frac2 + epsilon * 0.5;
        
        % Check outcome of trial and update values for next trial
        reward = Agent.reward(t);
        
        % Model-free
        RPE2 = reward - Q2(frac2);   % reward prediction error: difference between actual and predicted reward
        Q2(frac2) = Q2(frac2) + alpha2 * RPE2;   % 2nd-stage values
        VPE1 = Q2(frac2) - Q1(frac1);   % value prediction error: difference between actual and predicted value of 2nd fractal
        RPE1 = 0;%lambda * (reward - Q1(frac1));
        Q1(frac1) = Q1(frac1) + alpha1 * (VPE1 + RPE1);   % 1st-stage values
            
        
        % Model-based
        
        
        %%% Save trial data
        Sim.Q1(t+1, :) = Q1;
        Sim.Q2(t+1, :) = Q2;
        Sim.frac1(t, :) = frac1;
        Sim.frac2(t, :) = frac2;
        Sim.reward(t, :) = reward;
        
        % Get log of likelihoods of both choices and sum up
        LL = LL + log(prob_frac2);%+ log(prob_frac1);
        
    end
            
    % Take negative to get negative log likelihood
    NLL = -LL;
    
end
