function result = computeNLL(Agent, run, par, n_fit, output, data_type, hier)

% Agent = params.user.log;
% par = [.1 .1 .01 .01 1 .5 .5 .5];
% data_type = 'real';
common = 0.7;
preprocess_Agent;

%% Compute -LL of behavior, given parameters
%%% Parameters at beginning of experiment
n_params = length(par);
initialize_par;  % w depends on run

%% Data: Participant behavior (= sequence of choices)
if strcmp(data_type, 'real')
    real_data_columns;   % Which columns contain what
    Agent(:,frac2_p) = Agent(:,frac2_p) - 2;
    Agent(:,frac2_c) = Agent(:,frac2_c) - 2;
else
    data_columns;
end
[n_trials, ~] = size(Agent);   % number of trials

%% Keep track of results trial-by-trial
P = 0.5 * ones(n_trials,6);
V = zeros(n_trials,6);
M = zeros(n_trials,2);
Q = zeros(n_trials,2);
LL = zeros(n_trials,2);

%% LL for each trial, given sequence of previous trials
for t = 1:n_trials

    % Stage 1: Calculate likelihood of chosen actions
    fractals1 = Agent(t, frac1_p);   % Which fractal is on the left, which is on the right?
    prob_frac1 = softmax_Q2p(fractals1, Q1, beta1, key1, frac1, k_par, p_par, epsilon);   % 1 / (1 + e ** (beta * (Qb - Qa))
    frac1 = Agent(t, frac1_c);
    key1 = Agent(t, key1_c);

    % Stage 2: Calculate likelihood of chosen actions
    fractals2 = Agent(t, frac2_p);
    prob_frac2 = softmax_Q2p(fractals2, Q2, beta2, key2, frac2, k_par, p_par, epsilon);
    frac2 = Agent(t, frac2_c);
    key2 = Agent(t, key2_c);

    % Perceive trial outcome and update values for next trial
    reward = Agent(t, reward_c);

    % Model-free
    Qmf1 = MF_update_Q1(frac1, Qmf1, reward, alpha1, lambda, Qmf2, frac2);
    Qmf2 = MF_update_Q2(frac2, Qmf2, reward, alpha2);

    % Model-based
    [Qmb1, Qmb2] = MB_update(Qmf2, common);

    % Combine model-free and model-based
    Q1 = (1 - w) * Qmf1 + w * Qmb1;
    Q2 = Qmf2;

    % Get log of likelihoods of both choices and sum up
    LL(t,:) = [log(prob_frac1(key1)) log(prob_frac2(key2))];

    % Store values in table (just for plotting)
    V(t,1:2) = Qmf1;
    V(t,3:6) = Qmf2;
    M(t,1:2) = Qmb1;
    Q(t,1:2) = Q1;
    P(t,fractals1) = prob_frac1;
    if t > 1
        P(t,3:6) = P(t-1,3:6);
    end
    P(t,(fractals2+2)) = prob_frac2;

end

%% Take negative of LL to get negative log likelihood; calculate BIC and AIC
NLL = -sum(sum(LL));
BIC = 2 * NLL + n_fit * log(2 * n_trials);
AIC = 2 * NLL + 2 * n_fit;

%% Compute hierarchical fits
if strcmp(hier, 'hier')
    % Get population priors of 'flat' parameters
    load('flat_par.mat')
    flat_par(flat_par < epsilon) = epsilon;  % adjust values of 0 and 1
    flat_par(flat_par > 1 - epsilon) = 1 - epsilon;
    flat_par_n = -log(1./flat_par - 1);  % Transform to -inf to inf space
    M = mean(flat_par_n);  % mean of each parameter
    S = cov(flat_par_n);  % covariance: diagonal = variance; off-diagonal = covariance
    % Calculate 'hierarchical' parameters using population priors
    par(par < epsilon) = epsilon;
    par(par > 1 - epsilon) = 1 - epsilon;
    par_n = -log(1./par - 1);  % Same transform because all parameters lie between 0 and 1
    pd_par = mvnpdf(par_n, M, S);  % probability density at this spot, given population
    if pd_par < epsilon
        pd_par = epsilon;
    end
    NLprior = -sum(log(pd_par));  % negative log prior: the larger, the smaller the prior probability
    NLL = NLL + NLprior;  % NLPosterior = NLLikelihood + NLprior
end

%% Return results
if strcmp(output, 'NLL')
    result = NLL;
else
    result = [NLL, BIC, AIC];
end

