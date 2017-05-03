function fit_parameters_with_computeNLL2(full_file_path, n_fit)

%% Load participant file
[file_dir, file_name] = fileparts(full_file_path);
genrec_columns; 
load_and_preprocess_data;
common = 0.7;
sim_data = 'real';

%% Define model parameters
switch n_fit
    case 4
        fit_model = 'a1b1_l0_nok';
    case 6
        fit_model = 'nok_l0';
    case 7
        fit_model = 'nok';
end
model_parameters = define_model_parameters;  % Which parameters are fitted (-1) versus fixed (values) in each model?
fit_par = model_parameters(model_ID(fit_model),:);  % Which parameters will be fitted (-1) and which are fixed by me (values)?

%% Minimize the log likelihood
fun = @(par)computeNLL(Agent, par, n_fit, 'NLL', common, sim_data); 
[fit_params, ~] = minimize_NLL(fun, fit_par, 100)   % Set fmincon_iterations HERE
NLLBICAIC = computeNLL(Agent, fit_params, n_fit, 'all', common, sim_data);

%%% Save generated (simulated) and recovered (fitted) values in genrec
genrec(1, rec_aabblwpk_c) = fit_params;   % Save fitted parameters (x) into the genrec rec paramater columns (aabblwpk)
genrec(1, NLLBICAIC_c) = NLLBICAIC;   % Save NLL,a BIC, and AIC (NLLBICAIC) into the genrec NLLBICAIC columns (NLLBICAIC_c)

%% Save resulting parameters
genrec_filename = ['Results/' file_name '_' num2str(n_fit) '_genrec2.mat']
save(genrec_filename, 'genrec')