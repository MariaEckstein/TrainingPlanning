function model_parameters = define_model_parameters

%% In which columns are the parameters saved?
alpha1 = 1; alpha2 = 2; beta1 = 3; beta2 = 4; lambda = 5; w_par = 6; p_par = 7; k_par = 8;

%% Create model_parameters, a matrix that contains the initial parameter values for each model
model_parameters = -1 * ones(30, 8);  % -1 means that this parameter will be fitted
%%% Fill each row of model_parameters with one model
% Models cut by one parameter
model_parameters(model_ID('mf'), w_par) = 0;
model_parameters(model_ID('mb'), [alpha1 beta1 lambda w_par]) = [0 0 0 1];
model_parameters(model_ID('nop'), p_par) = 0.5;
model_parameters(model_ID('nok'), k_par) = 0.5;
model_parameters(model_ID('nopk'), [p_par k_par]) = [0.5 0.5];
model_parameters(model_ID('a1b1'), [alpha1 beta1]) = [0 0];
model_parameters(model_ID('l0'), lambda) = 0;
model_parameters(model_ID('l1'), lambda) = 1;
% Models cut by two or more parameters
model_parameters(model_ID('nok_l1'), [k_par lambda]) = [0.5 1];
model_parameters(model_ID('nok_l0'), [k_par lambda]) = [0.5 0];
model_parameters(model_ID('nok_mf'), [k_par w_par]) = [0.5 0];
model_parameters(model_ID('nok_mb'), [k_par alpha1 beta1 lambda w_par]) = [0.5 0 0 0 1];
model_parameters(model_ID('a1b1_nok'), [k_par alpha1 beta1]) = [0.5 0 0];
model_parameters(model_ID('a1b1_l0_nopk'), [alpha1 beta1 lambda k_par p_par]) = [0 0 0 0.5 0.5];
model_parameters(model_ID('a1b1_l0_nok'), [alpha1 beta1 lambda k_par]) = [0 0 0 0.5];
model_parameters(model_ID('test'), :) = [.1 .1 .01 .01 0 .5 -1 .5];
