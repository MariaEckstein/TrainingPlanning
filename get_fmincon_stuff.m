function [pmin, pmax, par0, n_fit, n_params] = get_fmincon_stuff(fit_par)

pmin = fit_par;   % lower bound for fitting parameters
pmin(fit_par == -1) = 0;
pmax = fit_par;  % upper bound for fitting
pmax(fit_par == -1) = 1;
for p = [7 8]
    if fit_par(p) == 0
        pmin(p) = 0.5;
        pmax(p) = 0.5;
    end
end
par0 = ones(1, length(pmin)) .* (pmin + (pmax - pmin) / 2);   % initial start values for fitting
n_fit = sum(fit_par == -1);   % number of parameters that are fitted (for BIC & AIC)
n_params = length(fit_par);   % number of parameters