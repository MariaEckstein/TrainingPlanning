function result = computeNLL(Agent, par, n_fit, output, common, data_type)

%% Compute -LL of behavior, given parameters
initialize_par;   % Get initial values; parameters; and last trial's keys

%%% Data: Participant behavior (= sequence of choices)
if strcmp(data_type, 'real')
    real_data_columns;
else
    data_columns;   % Find out which columns contain what
end
[n_trials, ~] = size(Agent);   % number of trials
LL = 0;   % initialize log likelihood


%%% LL for each trial, given sequence of previous trials
for t = 1:n_trials

    % Stage 1: Calculate likelihood of chosen actions
    fractals1 = Agent(t, frac1_p);   % Which fractal is on the left, which is on the right?
    prob_frac1 = softmax_Q2p(fractals1, Q1, beta1, key1, frac1, k_par, p_par, epsilon);   % Prob of choosing frac on left and frac on right: 1 / (1 + e ** (beta * (Qb - Qa))
    frac1 = Agent(t, frac1_c);   % Name of fractal chosen (1 or 2)
    key1 = Agent(t, key1_c);   % Key used to choose fractal (1 = left; 2 = right)

    % Stage 2: Calculate likelihood of chosen actions
    fractals2 = Agent(t, frac2_p);
    prob_frac2 = softmax_Q2p(fractals2, Q2, beta2, key2, frac2, k_par, p_par, epsilon);
    frac2 = Agent(t, frac2_c);   % Name of fractal chosen (1 2 3 or 4)
    key2 = Agent(t, key2_c);   % Key used to choose fractal (1 = left; 2 = right)

    % Check outcome of trial and update values for next trial
    reward = Agent(t, reward_c);   % 1 = reward; 0 = no reward

    % Model-free
    Qmf1 = MF_update_Q1(frac1, Qmf1, reward, alpha1, lambda, Qmf2, frac2);   % [Value frac1; value frac2] Model-free values of first-stage fractals
    Qmf2 = MF_update_Q2(frac2, Qmf2, reward, alpha2);   % [Value frac1; value frac2; value frac3; value frac4]

    % Model-based
    Qmb1 = MB_update(Qmf2, common);

    % Combine model-free and model-based
    Q1 = (1 - w) * Qmf1 + w * Qmb1;
    Q2 = Qmf2;

    % Get log of likelihoods of both choices and sum up
    LL = LL + log(prob_frac2(key2)) + log(prob_frac1(key1));

end

% Take negative of LL to get negative log likelihood; calculate BIC and AIC
NLL = -LL;
BIC = 2 * NLL + n_fit * log(2 * n_trials);
AIC = 2 * NLL + 2 * n_fit;

if strcmp(output, 'NLL')
    result = NLL;
else
    result = [NLL, BIC, AIC];
end

