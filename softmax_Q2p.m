function prob_frac = softmax_Q2p(fractals, Q, beta, key, frac, k_par, p_par, epsilon)


%% Key repetition bonus
% Which fractal should get a bonus because it's at the side of the last key press?
if key == 1
    keyrep_bon = [1 0];   % Left key -> left fractal
elseif key == 2
    keyrep_bon = [0 1];   % Right key -> right fractal
else
    keyrep_bon = [0 0];
end

%% Fractal repetition bonus
% Which fractal should get a bonus because it was selected in the last trial?
fracrep_bon = fractals == frac;  % if fractals = [2 1] and frac = 2 -> [1 0]; etc.

%% Calculate softmax to transform Q-values (&stuff) into decision probabilities
prob_frac_left = 1 / (1 + exp( ...
    beta * (Q(fractals(2)) - Q(fractals(1))) + ...   % value right fractal - value left fractal
    k_par * (keyrep_bon(2) - keyrep_bon(1)) + ...   % key_bon right - key_bon left
    p_par * (fracrep_bon(2) - fracrep_bon(1))));   % frac-bon right - frac_bon left
prob_frac_left = (1 - epsilon) * prob_frac_left + epsilon / 2;   % Correct for eventual values of 0 or 1
prob_frac = [prob_frac_left, 1 - prob_frac_left];   % Add probs of right fractal

