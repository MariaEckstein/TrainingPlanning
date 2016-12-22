function model_parameters = define_model_parameters

%% In which columns are the parameters saved?
alpha1 = 1; alpha2 = 2; beta1 = 3; beta2 = 4; lambda = 5; w_par = 6; p_par = 7; k_par = 8;

%% Create model_parameters, a matrix that contains the initial parameter values for each model
model_parameters = -1 * ones(10, 8);
%%% Fill each row of model_parameters with one model
model_parameters(model_ID('mf'), w_par) = 0;
model_parameters(model_ID('mb'), [alpha1, beta1, w_par]) = [0 0 1];
model_parameters(model_ID('nop'), p_par) = 0.5;
model_parameters(model_ID('nok'), k_par) = 0.5;
model_parameters(model_ID('nopk'), [p_par k_par]) = [0.5 0.5];
model_parameters(model_ID('a1b1'), [alpha1, beta1]) = [0 0];
model_parameters(model_ID('l0'), lambda) = 0;
model_parameters(model_ID('l1'), lambda) = 1;