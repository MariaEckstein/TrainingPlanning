
function prob_frac = softmax_Q2p(fractals, Q, beta, epsilon)

    prob_frac_left = 1 / (1 + exp( beta * (Q(fractals(2)) - Q(fractals(1)))));
    prob_frac_left = (1 - epsilon) * prob_frac_left + epsilon / 2;
    prob_frac = [prob_frac_left, 1 - prob_frac_left];

end