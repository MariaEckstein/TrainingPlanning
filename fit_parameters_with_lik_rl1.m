file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';
files = dir(file_dir);
file_index = find(~[files.isdir]);
number = length(file_index);
real_data_columns;   % Find out which columns contain what

n_pars = 4;  % Which model should be fitted (4, 6, or 7 parameters)?
pars = zeros(number, n_pars);
pars_filename = ['pars_' num2str(n_pars) '6.mat'];
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

for i_dataset = 1:number
    file_name = files(file_index(i_dataset)).name;
    load_and_preprocess_data;
    
    object_fun = @(par)lik_rl1(Agent, par);    
    options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
    problem = createOptimProblem('fmincon', 'objective', object_fun, ...   % search problem
    'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
    ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
    [fit_params, function_value] = run(ms, problem, 10);   % look at x-position and function value of found minimum
    
    [lik,X] = lik_rl1(Agent, fit_params);
    pars(i_dataset,:) = X.par;
    if mod(i_dataset, 10) == 1
        save(pars_filename, 'pars')
        i_dataset
    end
end
save(pars_filename, 'pars')