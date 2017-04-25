function fit_parameters_with_lik_rl1_cluster(full_file_path, n_pars)

%% Load participant file
[file_dir, file_name] = fileparts(full_file_path);
real_data_columns;   % Find out which columns contain what
load_and_preprocess_data;

%% Define model parameters
par0 = zeros(1,n_pars);
switch n_pars
    case 7    %a1 a2  b1 b2 l  p w]
        pmin = [0 0   0   0 0 -5 0];
        pmax = [1 1 100 100 1  5 1];
    case 6
        pmin = [0 0   0   0   -5 0];
        pmax = [1 1 100 100    5 1];
    case 4
        pmin = [0     0       -5 0];
        pmax = [1   100        5 1];
end

%% Minimize the log likelihood
object_fun = @(par)lik_rl1(Agent, par);    
options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
problem = createOptimProblem('fmincon', 'objective', object_fun, ...   % search problem
'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
ms = MultiStart('UseParallel', false);   % we want multiple starts to find a global minimum % 'UseParallel', true
[fit_params, ~] = run(ms, problem, 50);   % look at x-position and function value of found minimum

%% Save resulting parameters
[lik,X] = lik_rl1(Agent, fit_params);
pars = X.par
pars_filename = ['Results/' file_name '_pars.mat']
save(pars_filename, 'pars')