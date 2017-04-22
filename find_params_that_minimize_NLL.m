function [fit_params, function_value] = find_params_that_minimize_NLL(object_fun, par0, pmin, pmax, n_fmincon_iterations)

% switch solver_algo
%     case 'fmincon'   % fmincon MultiStart
        options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
        problem = createOptimProblem('fmincon', 'objective',...   % search problem
        object_fun, 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
        ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
        [fit_params,function_value] = run(ms, problem, n_fmincon_iterations);   % look at x-position and function value of found minimum
%     case 'ga'   % Genetic algorithm
% %                 options = optimoptions('ga', 'UseParallel', true, 'UseVectorized', false);
%         [fit_params, function_value] = ga(object_fun, n_fit, [], [], [], [], pmin, pmax, []);%, options
%     case 'particleswarm'   % Particleswarm
%         options = optimoptions('particleswarm', 'UseParallel', true, 'HybridFcn', @fmincon);
%         [fit_params, function_value] = particleswarm(object_fun, n_params, pmin, pmax, options);
% end
