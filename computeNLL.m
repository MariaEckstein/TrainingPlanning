function [NLL] = computeNLL(Agent, par, common)

%% Switches
keep_simulated_values = false;   % If true, this produce a struct Sim, which holds the simulated values of each trial
% If I want to get Sim out of this function, I need to declare it global or make it an output argument of the function

%% Compute -LL of behavior, given parameters
%%% Parameters at beginning of experiment
n_params = length(par);
alpha1 = par(1);
alpha2 = par(2);
beta1 = par(3) * 100;
beta2 = par(4) * 100;
lambda = par(5);
w = par(6);
p_par = par(7) * 10 - 5;
k_par = par(8) * 10 - 5;

%%% Initial fractal values
epsilon = .00001;
Q1 = [.5 .5];   % initial values 2st-stage fractals
Qmf1 = [.5 .5];
Q2 = [.5 .5 .5 .5];   % initial values 2nd-stage fractals
Qmf2 = [.5 .5 .5 .5];

%%% Data: Participant behavior (= sequence of choices)
data_columns;   % Find out which columns contain what
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

% Take negative to get negative log likelihood
NLL = -LL;

end
