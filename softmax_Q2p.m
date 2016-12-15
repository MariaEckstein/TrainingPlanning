
function prob_frac = softmax_Q2p(fractals, Q, beta, key, frac, k_par, p_par, epsilon)


%% Key repetition bonus
% Which fractal is selected by pressing the key that was pressed in the last trial?
keyrep_bon = fractals == key;   % Fractal at last-trial key gets a bonus

%% Fractal repetition bonus
% Which fractal was selected in the last trial?
fracrep_bon = fractals == frac;   % Fractal selected last time receives a bonus

%% Add Q-values, key repetition bonus, and fractal repetition bonus together
fractal1 = Q(fractals(1)) + k_par * keyrep_bon(1) + p_par * fracrep_bon(1);
fractal2 = Q(fractals(2)) + k_par * keyrep_bon(2) + p_par * fracrep_bon(2);

%% Calculate softmax to transform Q-values (&stuff) into decision probabilities
prob_frac_left = 1 / (1 + exp( beta * (fractal2 - fractal1)));
prob_frac_left = (1 - epsilon) * prob_frac_left + epsilon / 2;
prob_frac = [prob_frac_left, 1 - prob_frac_left];
