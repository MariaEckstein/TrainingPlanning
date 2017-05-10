function fit_parameters_with_lik_rl1_cluster(full_file_path, n_par, mode)

%% Load participant file
[file_dir, file_name] = fileparts(full_file_path);
load_and_preprocess_data;

%% Minimize the log likelihood
if strcmp(mode, 'hier')    
    par0 = zeros(1,n_par);  % Define model parameters
    switch n_par
        case 4    %a1 a2  b1 b2 l  p w]
            pmin = [0     0       -5 0];
            pmax = [1   100        5 1];
            parMS(1,:) = [-1.0059    0.9557    1.7240    0.3170];   % mean of transformed parameters over all participants
            parMS(2,:) = [ 8.8279    8.1610    0.1795   12.6368];   % sd of ''
        case 6
            pmin = [0 0   0   0   -5 0];
            pmax = [1 1 100 100    5 1];
            parMS(1,:) = [-2.5941   -0.9978    2.4463    0.8749    1.7014   -2.3388];
            parMS(2,:) = [ 8.7882    5.9524    3.7123    6.0404    0.1701    8.9013];
        case 7
            pmin = [0 0   0   0 0 -5 0];
            pmax = [1 1 100 100 1  5 1];
            parMS(1,:) = [-1.6832   -1.0424    2.2861    0.9464   -0.6767    1.6934   -2.3390];
            parMS(2,:) = [ 7.9614    6.3095    3.3441    4.6339   12.1687    0.1677    8.5633];
    end
    object_fun = @(par)lik_rl1(Agent, par, parMS);  % Hierarchical fit
else
    object_fun = @(par)lik_rl1(Agent, par);
end
options = optimoptions(@fmincon, 'Algorithm', 'sqp');   % options for search
problem = createOptimProblem('fmincon', 'objective', object_fun, ...   % search problem
'x0', par0, 'lb', pmin, 'ub', pmax, 'options', options);
ms = MultiStart('UseParallel', false);   % we want multiple starts to find a global minimum % 'UseParallel', true
[fit_params, ~] = run(ms, problem, 100);   % look at x-position and function value of found minimum

%% Save results
% Get parameter estimates and bring in genrec form
[lik,X] = lik_rl1(Agent, fit_params);
a1 = 0; b1 = 0; l = 0; k = 0;
switch n_par
    case 4
        a2 = X.par(1);
        b2 = X.par(2);
        p = X.par(3);
        w = X.par(4);
    case 6
        a1 = X.par(1);
        a2 = X.par(2);
        b1 = X.par(3);
        b2 = X.par(4);
        p = X.par(5);
        w = X.par(6);
    case 7
        a1 = X.par(1);
        a2 = X.par(2);
        b1 = X.par(3);
        b2 = X.par(4);
        l = X.par(5);
        p = X.par(6);
        w = X.par(7);
end
% Get model, subjID, and runID
model = 103;   % 103 is Klaus; 112 is Maria
agentID = str2double(file_name(4:6));
runID = file_name(9);
switch runID
    case 'A'
        runID = 1;
    case 'B'
        runID = 2;
    case 'C'
        runID = 3;
    case 'D'
        runID = 4;
end

if strcmp(mode, 'hier')
    hier = 1;
else
    hier = 0;
end

% Save everything
genrec_columns;
genrec = zeros(1, 22);
genrec(1, rec_aabblwpk_c) = [a1 a2 b1 b2 l w p k];
genrec(1, NLLBICAIC_c) = [X.NLL X.BIC X.AIC];  % Model fit indicators
genrec(1, [2:4]) = [103 hier n_par];  % model n_par  
genrec(1, [agentID_c run_c]) = [agentID runID]

%% Save resulting parameters
genrec_filename = ['Results/' file_name '_' num2str(n_par) mode '_genrec1.mat']
save(genrec_filename, 'genrec')