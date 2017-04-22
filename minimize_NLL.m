function [fit_params, function_value] = minimizeNLL(fun, fit_par, n_fmincon_iterations)

[pmin, pmax, par0] = get_fmincon_stuff(fit_par);  % Optimizer input
options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
problem = createOptimProblem('fmincon', 'objective',...   % search problem
fun, 'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
[fit_params, function_value] = run(ms, problem, n_fmincon_iterations);