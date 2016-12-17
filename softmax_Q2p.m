function prob_frac = softmax_Q2p(fractals, Q, beta, key, frac, k_par, p_par, epsilon)

%% Key repetition bonus
% Which fractal is selected by pressing the key that was pressed in the last trial?
keyrep_bon = fractals == key;   % Fractal at last-trial key gets a bonus

%% Fractal repetition bonus
% Which fractal was selected in the last trial?
fracrep_bon = fractals == frac;   % Fractal selected last time receives a bonus

%% Calculate softmax to transform Q-values (&stuff) into decision probabilities
% prob_frac_left = 1 / (1 + exp( beta * (Q(fractals(2)) - Q(fractals(1)))));
prob_frac_left = 1 / (1 + exp( ...
    beta * (Q(fractals(2)) - Q(fractals(1))) + ...
    k_par * (keyrep_bon(2) - keyrep_bon(1)) + ...
    p_par * (fracrep_bon(2) - fracrep_bon(1))));   % Softmax
prob_frac_left = (1 - epsilon) * prob_frac_left + epsilon / 2;   % Correct for eventual values of 0 or 1
prob_frac = [prob_frac_left, 1 - prob_frac_left];   % Add probs of right fractal
