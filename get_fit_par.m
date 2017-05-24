function [n_fit, fit_par] = get_fit_par(fit_model)

%% In which columns are the parameters saved?
alpha1 = 1; alpha2 = 2; beta1 = 3; beta2 = 4; lambda = 5; w_par = 6; p_par = 7; k_par = 8;
w_par2 = 9; w_par3 = 10; % w_par4 = 11;

%% In which row is which model saved?
fit_par = -1 * ones(1, 10);  % -1 means that this parameter will be fitted
switch fit_model
    case 'mf'
        fit_par([w_par w_par2 w_par3]) = 0;
    case 'mb'
        fit_par([alpha1 beta1 lambda w_par w_par2 w_par3]) = [0 0 0 1 1 1];
    case 'nop'
        fit_par(p_par) = 0.5;
    case 'nok'
        fit_par(k_par) = 0.5;
    case 'nopk'
        fit_par([p_par k_par]) = [0.5 0.5];
    case 'a1b1'
        fit_par([alpha1 beta1]) = [0 0];
    case 'l0'
        fit_par(lambda) = 0;
    case 'l1'
        fit_par(lambda) = 1;
    case 'test'
        fit_par = [.1 .1 .01 .01 0 .5 -1 .5];
end

%% Get number of fitted parameters
n_fit = sum(fit_par == -1);
