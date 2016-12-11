function x = fitRL

    %% Fit model parameters to (simulated) data

    
    %%% Find parameter values, for which participant actions have the
    %%% highest likelihood (i.e., lowest negative log-likelihood)
    n_params = 6;
    pmin = [0 0 0 0 0 1]; %zeros(1, n_params);   % lower bound of params (all params should be on the same scale)
    pmax = ones(1, n_params);   % upper bound of params 
    
    par0 = ones(1, length(pmin)) .* ((pmax - pmin) / 2);   % initial start values for search 
    
%     options = optimset('display','off');
%     for iter = 1:20
%         iter
%         par0 = pmin + rand(1, length(pmin)) .* (pmax - pmin);
%         [X,FVAL,EXITFLAG,OUTPUT] =fmincon(@computeNLL,par0,[],[],[],[],pmin,pmax,[],options);
%         results(iter,:)=[X FVAL];
%     end
%     params = results;
%     
%     options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
%     problem = createOptimProblem('fmincon', 'objective',...   % search problem
%     @computeNLL, 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
%     ms = MultiStart;   % we want multiple starts to find a global minimum
%     [x,f] = run(ms, problem, 1000);   % look at x-position and function value of found minimum
    
    options = optimoptions(@fmincon,'Algorithm','interior-point');   % options for search
    problem = createOptimProblem('fmincon','objective',...   % search problem
    @computeNLL, 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
    gs = GlobalSearch('Display', 'off');   % for debugging: 'iter'
    [x,f] = run(gs,problem);   % look at x-position and function value of found minimum
end
