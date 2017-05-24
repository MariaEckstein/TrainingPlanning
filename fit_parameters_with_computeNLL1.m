function fit_parameters_with_computeNLL1(full_file_path, fit_model, hier, complete)

%% Debugging
% full_file_path = 'C:\Users\maria\MEGAsync\TrainingPlanningProject\TwoStepTask\Results\complete_Agents\TS_101_Agent.mat';
% fit_model = 'hyb';
% hier = 'flat';

%% Load participant file
[file_dir, file_name] = fileparts(full_file_path);
load(full_file_path);
sim_data = 'real';

%% Define model parameters
[n_fit, fit_par] = get_fit_par(fit_model);  % Which parameters will be fitted (-1) and which are fixed by me (values)?

%% Minimize the log likelihood
fun = @(par)computeNLLseveralRuns(Agent, par, n_fit, 'NLL', sim_data, hier, complete);
[fit_params, ~] = minimize_NLL(fun, fit_par, 100)   % Set fmincon_iterations HERE
NLLBICAIC = [888 888 888];  % computeNLL(Agent, fit_params, n_fit, 'all', sim_data, hier);
agentID = str2double(file_name(4:6));
runID = num2str(file_name(9));

%%% Save fitted parameters
genrec_columns;
genrec = zeros(1, 22);
genrec(rec_aabblwpk_c) = fit_params(1:8);   % Save fitted parameters
genrec(rec_w2w3) = fit_params(9:10);  % Save w2 (w in run 2) and w3 (w in run 3)
genrec(NLLBICAIC_c) = NLLBICAIC;   % Save NLL,a BIC, and AIC (NLLBICAIC) into the genrec NLLBICAIC columns (NLLBICAIC_c)
if strcmp(hier, 'hier'); h = 1; else h = 0; end
genrec(2:4) = [112 h n_fit];  % model n_fit
genrec([agentID_c run_c]) = [agentID runID]

%% Save resulting parameters
genrec_filename = ['Results/' file_name '_' fit_model hier 'M_genrec.mat']
save(genrec_filename, 'genrec')