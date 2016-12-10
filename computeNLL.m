function NLL = computeNLL(par)

    %% Compute -LL of behavior, given parameters
    global Agent;   % contains Q1, Q2, frac1, frac2, reward
    
    %%% Parameter values at beginning of experiment
%     alpha1 = par.alpha1;
%     alpha2 = par.alpha2;
%     beta1 = par.beta1;
%     beta2 = par.beta2;
%     lambda = par.lambda;
%     w = par.w;
    alpha1 = par(1);
    alpha2 = par(2);
    beta1 = par(3);
    beta2 = par(4);
    lambda = par(5);
    w = par(6);
    epsilon = .00001;

    %%% Data: Participant behavior (= sequence of choices)
    ntrials = length(Agent.frac1);   % number of trials 
    LL = 0;   % initialize log likelihood

    %%% LL for each trial, given sequence of previous trials
    for t = 1:ntrials
        
        % Calculate likelihood of chosen actions: e^Qx / (e^Qa + e^Qb)
        Q1 = Agent.Q1(t, :);
        frac1 = Agent.frac1(t);
        prob_frac1 = 1 / (exp( beta1 * (Q1(1) - Q1(frac1)) + exp( beta1 * Q1(2) - Q1(frac1))));   % e^Qx / (e^Qa + e^Qb) = 1 / (e^(Qa-Qx) + e^(Qb-Qx))
        prob_frac1 = (1 - epsilon) * prob_frac1 + epsilon * 0.5;   % combination of calculated prob and randon; reason: take care of Inf, resulting from computer being inaccurate
        
        Q2 = Agent.Q2(t, :);
        frac2 = Agent.frac2(t);
        prob_frac2 = 1 / (exp( beta2 * (Q2(1) - Q2(frac2)) + exp( beta2 * Q2(2) - Q2(frac2))));
        prob_frac2 = (1 - epsilon) * prob_frac2 + epsilon * 0.5;
        
        % Check outcome of trial and update values for next trial
        reward = Agent.reward(t);
        
        % Model-free
        RPE2 = reward - Q2(frac2);   % reward prediction error: difference between actual and predicted reward
        Q2(frac2) = Q2(frac2) + alpha2 .* RPE2;   % 2nd-stage values
        RPE1 = lambda * (reward - Q1(frac1));
        VPE1 = (1 - lambda) * Q2(frac2) - Q1(frac1);   % value prediction error: difference between actual and predicted value of 2nd fractal
        Q1(frac1) = Q1(frac1) + alpha1 .* (RPE1 + VPE1);   % 1st-stage values
        
        % Model-based
        
        
        % Get log of likelihoods of both choices and sum up
        LL = LL+ log(prob_frac1) + log(prob_frac2);
        
    end
    
    % Take negative to get negative log likelihood
    NLL = -LL;
    
end
