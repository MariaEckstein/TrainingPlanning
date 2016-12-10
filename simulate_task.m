function genrec = simulate_task(n_agents)

    %% Simulate behavior
    global Data
    global Agent
    
    %%% Determine parameter and task values
    ntrials = 100;
    common = 0.8;
    fractal_rewards = [.1 .3 .5 .7];
    alpha1 = 0.3;
    alpha2 = 0.5;
    beta1 = 10;
    beta2 = 10;
    lambda = 0.8;
    w = 0.5;

    %%% Simulate a bunch of agents
    for agent = 1:n_agents
        agent   % display to see where we are
        Q1 = [.5 .5];   % initial values 2st-stage fractals
        Q2 = [.5 .5 .5 .5];   % initial values 2nd-stage fractals
        
        % Create an individual agent
        alpha1 = rand;
%         alpha2 = rand;
%         beta1 = 10 * rand;
%         beta2 = 10 * rand;
%         lambda = rand;
%         w = 0.5;
        
        % Let agent play the game
        for t = 1:ntrials
            
            %%% Stage 1
            % Agent picks one of the two fractals
            prob_frac1 = 1 / (1 + exp(beta1 * (Q1(2) - Q1(1))));   % softmax: e^Qa / (e^Qa + e^Qb) = 1 / (1 + e^(Qb - Qa))
            frac1 = (rand > prob_frac1) + 1;   % if rand < p, action1 is picked; if rand > p, action2 is picked
            
            %%% Stage 2
            % Fractals are displayed
            if frac1 == 1   % action_s1 == 1 usually leads to frac1 & frac2
                frac2 = 2 * (rand > common) + 1;
            else   % action_s1 == 2 usually leads to frac3 & frac4
                frac2 = 2 * (rand < common) + 1;
            end
            
            % Agent picks one of the two fractals
            prob_frac2 = 1 / (1 + exp(beta2 * (Q2(frac2 + 1) - Q2(frac2))));   % softmax: e^Qa / (e^Qa + e^Qb) = 1 / (1 + e^(Qb - Qa))
            frac2 = (rand > prob_frac2) + frac2;   % if rand < p, action1 is picked; if rand > p, action2 is picked
            
            % Agent receives reward
            reward = rand < fractal_rewards(frac2);
            
            %%%  Agent updates 1st- and 2nd-stage values
            % Model-free
            RPE2 = reward - Q2(frac2);   % reward prediction error: difference between actual and predicted reward
            Q2(frac2) = Q2(frac2) + alpha2 .* RPE2;   % 2nd-stage values
            RPE1 = lambda * (reward - Q1(frac1));
            VPE1 = (1 - lambda) * Q2(frac2) - Q1(frac1);   % value prediction error: difference between actual and predicted value of 2nd fractal
            Q1(frac1) = Q1(frac1) + alpha1 .* (RPE1 + VPE1);   % 1st-stage values
            
            % Model-based
            
            
            %%% Save trial data
            Agent.Q1(t, :) = Q1;
            Agent.Q2(t, :) = Q2;
            Agent.frac1(t) = frac1;
            Agent.frac2(t) = frac2;
            Agent.reward(t) = reward;

        end
        
%         Data(:, :) = Agent;
        %% Estimate parameters for simulated data, and save alongside real parameter values
        params = fitRL;
        params(3:4) = params(3:4) * 100;

        genrec(agent, :) = [alpha1, alpha2, beta1, beta2, lambda, w, params];
    end
    
    % Plot true alphas and betas against inferred alphas and betas
    figure
    subplot(2,2,1)
    scatter(genrec(:,1),genrec(:,7))
    lsline

    subplot(2,2,2)
    scatter(genrec(:,2),genrec(:,8))
    lsline
    
    subplot(2,2,3)
    scatter(genrec(:,3),genrec(:,9))
    lsline

    subplot(2,2,4)
    scatter(genrec(:,4),genrec(:,10))
    lsline
    
end