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

P = 0.5 * ones(n_trials,6);
V = zeros(n_trials,6);
M = zeros(n_trials,2);
Q = zeros(n_trials,2);

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

    % Get log of likelihoods of both choices and sum up
    LL = LL + log(prob_frac2(key2)) + log(prob_frac1(key1));    

    % Check outcome of trial and update values for next trial
    reward = Agent(t, reward_c);   % 1 = reward; 0 = no reward

    % Model-free
    VPE = Qmf2(frac2) - Qmf1(frac1);   % value prediction error: difference between actual and predicted value of 2nd fractal
    RPE = reward - Qmf2(frac2);   % reward prediction error: difference between actual and predicted reward
    Qmf1(frac1) = Qmf1(frac1) + alpha1 * (VPE + lambda * RPE);   % 1st-stage RL value update, including eligibility trace
    Qmf2(frac2) = Qmf2(frac2) + alpha2 * RPE;   % 2nd-stage simple RL value update

    % Model-based
    Qmb1_frac1 = common * max(Qmf2(1:2)) + (1 - common) * max(Qmf2(3:4));
    Qmb1_frac2 = (1 - common) * max(Qmf2(1:2)) + common * max(Qmf2(3:4));
    Qmb1 = [Qmb1_frac1 Qmb1_frac2];

    % Combine model-free and model-based
    Q1 = (1 - w) * Qmf1 + w * Qmb1;
    Q2 = Qmf2;
    
    % Store values in table
    V(t,1:2) = Qmf1;
    V(t,3:6) = Qmf2;
    M(t,1:2) = [Qmb1_frac1, Qmb1_frac2];
    Q(t,1:2) = Q1;
    
    P(t,fractals1) = prob_frac1;
    if t > 1
        P(t,3:6) = P(t-1,3:6);
    end
    P(t,(fractals2+2)) = prob_frac2;

end

% Take negative of LL to get negative log likelihood; calculate BIC and AIC
NLL = -LL;
BIC = 2 * NLL + n_fit * log(2 * n_trials);   % {BIC} ={\ln(n)k-2\ln({\hat {L}})}.\ }
AIC = 2 * NLL + n_fit * 2;  % {AIC} =2k-2\ln({\hat {L}})}

if strcmp(output, 'NLL')
    result = NLL;
else
    result = [NLL, BIC, AIC];
end

