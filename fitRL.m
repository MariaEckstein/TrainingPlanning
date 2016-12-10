function x = fitRL(sa, sr)

    %% Fit model parameters to (simulated) data
    
    %%% Define data as global variable
    global D; D = [sa; sr];
    
    %%% Find parameter values, for which participant actions have the
    %%% highest likelihood (i.e., lowest negative log-likelihood)
    pmin = [0 0];   % lower bound of params (all params should be on the same scale)
    pmax = [1 1];   % upper bound of params 
    
    par0 = ones(1, length(pmin)) .* ((pmax - pmin) / 2);   % initial start values for search 
    options = optimoptions(@fmincon,'Algorithm','sqp');   % options for search
    problem = createOptimProblem('fmincon', 'objective',...   % search problem
     @computeNLL, 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
    ms = MultiStart;   % we want multiple starts to find a global minimum
    [x,f] = run(ms,problem,20);   % look at x-position and function value of found minimum
end
