file_dir = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\rawdata2016';
files = dir(file_dir);
file_index = find(~[files.isdir]);
number = length(file_index);
real_data_columns;   % Find out which columns contain what
pars = zeros(number, 4);

for i_dataset = 1:number
    file_name = files(file_index(i_dataset)).name;
    load([file_dir '/' file_name]);
    Agent = params.user.log;
    complete_data_rows = ~isnan(Agent(:, key1_c)) & ~isnan(Agent(:, key2_c)) & Agent(:, frac2_c) > 0;
    remove_first_20 = [zeros(20,1); ones(length(Agent)-20,1)];
    Agent = Agent(complete_data_rows & remove_first_20,:);
    
    object_fun = @(par)lik_rl1(Agent, par);    
    options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
    problem = createOptimProblem('fmincon', 'objective', object_fun, ...   % search problem
    'x0', zeros(1,4), 'lb', [0 0 -5 0], 'ub', [1 100 5 1], 'options', options);
    ms = MultiStart('UseParallel', true);   % we want multiple starts to find a global minimum % 'UseParallel', true
    [fit_params, function_value] = run(ms, problem, 30);   % look at x-position and function value of found minimum
    
    [lik,X] = lik_rl1(Agent, fit_params);
    pars(i_dataset,:) = X.par;
    if mod(i_dataset, 10) == 1
        save('pars_bugfix.mat', 'pars')
        i_dataset
    end
end
save('pars_bugfix.mat', 'pars')