function result = computeNLL(Agent, par, n_fit, output, common, data_type, a1b1)

%% Compute -LL of behavior, given parameters
%%% Parameters at beginning of experiment
n_params = length(par);
if length(a1b1) >= 4
    if strcmp(a1b1(1:4), '1a1b')
        alpha1 = par(2);
        beta1 = par(4) * 100;
    end
else
    alpha1 = par(1);
    beta1 = par(3) * 100;
end
alpha2 = par(2);
beta2 = par(4) * 100;
lambda = par(5);
w = par(6);
p_par = par(7) * 2 - 1;
p_par = beta2 * p_par;   % p_par & k_par should be on the same scale as beta
k_par = par(8) * 2 - 1;
k_par = beta2 * k_par;

%%% Initial fractal values
epsilon = .00001;
Q1 = [.5 .5];   % initial values 2st-stage fractals
Qmf1 = [.5 .5];
Q2 = [.5 .5 .5 .5];   % initial values 2nd-stage fractals
Qmf2 = [.5 .5 .5 .5];

%%% Data: Participant behavior (= sequence of choices)
if strcmp(data_type, 'real')
    real_data_columns;
else
    data_columns;   % Find out which columns contain what
end
[n_trials, ~] = size(Agent);   % number of trials
LL = 0;   % initialize log likelihood

key1 = 123;
key2 = 123;
frac1 = 123;
frac2 = 123;

%%% LL for each trial, given sequence of previous trials
for t = 1:n_trials

    % Stage 1: Calculate likelihood of chosen actions
    fractals1 = [1, 2];
    prob_frac1 = softmax_Q2p(fractals1, Q1, beta1, key1, frac1, k_par, p_par, epsilon);   % 1 / (1 + e ** (beta * (Qb - Qa))
    frac1 = Agent(t, frac1_c);
    key1 = Agent(t, key1_c);

    % Stage 2: Calculate likelihood of chosen actions
    if any(Agent(t, frac2_c) == [1, 2])
        fractals2 = [1, 2];
    else
        fractals2 = [3, 4];
    end
    prob_frac2 = softmax_Q2p(fractals2, Q2, beta2, key2, frac2, k_par, p_par, epsilon);
    frac2 = Agent(t, frac2_c);
    key2 = Agent(t, key2_c);

    % Check outcome of trial and update values for next trial
    reward = Agent(t, reward_c);

    % Model-free
    Qmf1 = MF_update_Q1(frac1, Qmf1, reward, alpha1, lambda, Qmf2, frac2);
    Qmf2 = MF_update_Q2(frac2, Qmf2, reward, alpha2);

    % Model-based
    [Qmb1, Qmb2] = MB_update(Qmf2, common);

    % Combine model-free and model-based
    Q1 = (1 - w) * Qmf1 + w * Qmb1;   % CHECK IF USUALLY COMBINED HERE OR AT PROBABILITIES!
    Q2 = Qmf2;

    % Get log of likelihoods of both choices and sum up
    if any(frac2 == [1 3])
        f2_index = 1;
    else
        f2_index = 2;
    end
    LL = LL + log(prob_frac2(f2_index)) + log(prob_frac1(frac1));

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

