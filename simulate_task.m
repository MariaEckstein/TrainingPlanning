function genrec = simulate_task(n_agents)

    %% Simulate behavior
    
    %%% Determine parameter and task values
    beta = 8;
    ntrials = 100;
    p = [0.25 .75];

    %%% Simulate a bunch of agents
    for repetition = 1:n_agents
        repetition   % display to see where we are
        alpha = .5*rand;   % alphas varis among agents
        Q = [.5 .5];   % initial values for each choice
        
        % Let agent play the game
        for t = 1:ntrials
            pr = 1 / (1 + exp( beta * (Q(1) - Q(2))));   % probablity of chosing action 1 over action 2
            a = 1 + (rand < pr);   % agent selects action
            r = rand < p(a);   % agent obtains reward
            Q(a) = Q(a) + alpha * (r - Q(a));   % agent updates action values
            
            % save agent's trial data
            sa(t) = a;
            sr(t) = r;
            sQ(t, :) = Q;
        end
        
        %% Estimate parameters for simulated data, and save alongside real parameter values
        params = fitRL(sa, sr);
        params(2) = params(2) * 100;

        genrec(repetition, :) = [alpha, params];
    end
end