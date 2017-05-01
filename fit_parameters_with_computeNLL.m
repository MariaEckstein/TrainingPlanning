function fit_parameters_with_computeNLL(full_file_path, n_fit)

%% Load participant file
[file_dir, file_name] = fileparts(full_file_path);
real_data_columns;   % Find out which columns contain what
load_and_preprocess_data;
common = 0.7;
sim_data = 'real';

%% Define model parameters
par0 = zeros(1,n_fit);
switch n_fit
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
object_fun = @(par)computeNLL(Agent, par, n_fit, 'NLL', common, sim_data); 
options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
problem = createOptimProblem('fmincon', 'objective', object_fun, ...   % search problem
'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
ms = MultiStart('UseParallel', false);   % we want multiple starts to find a global minimum % 'UseParallel', true
[fit_params, ~] = run(ms, problem, 100);   % look at x-position and function value of found minimum

%% Save resulting parameters
[lik,X] = lik_rl1(Agent, fit_params);
pars = X.par
pars_filename = ['Results/' file_name '_' num2str(n_fit) '_genrec1.mat']
save(pars_filename, 'genrec')