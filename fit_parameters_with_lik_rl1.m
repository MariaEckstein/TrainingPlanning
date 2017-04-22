file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';
files = dir(file_dir);
file_index = find(~[files.isdir]);
number = length(file_index);
real_data_columns;   % Find out which columns contain what
pars = zeros(number, 4);
pars_filename = 'pars_bugfix2.mat';

for i_dataset = 1:number
    file_name = files(file_index(i_dataset)).name;
    load_and_preprocess_data;
    
    object_fun = @(par)lik_rl1(Agent, par);
    options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
    problem = createOptimProblem('fmincon', 'objective', object_fun, ...   % search problem
    'x0', zeros(1,4), 'lb', [0 0 -5 0], 'ub', [1 100 5 1], 'options', options);
    ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
    [fit_params, function_value] = run(ms, problem, 30);   % look at x-position and function value of found minimum
    
    [lik,X] = lik_rl1(Agent, fit_params);
    pars(i_dataset,:) = X.par;
    if mod(i_dataset, 5) == 1
        save(pars_filename, 'pars')
        i_dataset
    end
end
save(pars_filename, 'pars')