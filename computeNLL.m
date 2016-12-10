function NLL = computeNLL(par)

    %% Compute -LL of parameters, given data
    
    %%% Parameter values at beginning of experiment
    Q = [.5 .5];   % values of each outcome
    alpha = par(1);
    beta = 100 * par(2);
    epsilon = .00001;

    %%% Data: Participant behavior (= sequence of choices)
    global D;
    sa = D(1, :);
    sr = D(2, :);
    ntrials = length(sa);
    NLL = 0;

    %%% LL for each trial, given sequence of previous trials
    for t = 1:ntrials
        
        % Likelihood of chosen action, given previous history: e^Qa / (e^Qa + e^Qb)
        a = sa(t);
        pr = 1/(exp(beta*(Q(1)-Q(a)))+exp(beta*(Q(2)-Q(a))));   %  same as: exp(beta*Q(a))/(exp(beta*(Q(1)))+exp(beta*(Q(2))));
        pr = (1-epsilon)*pr + epsilon/2;  % take care of Inf, resulting from computer being inaccurate

        % Update value of chosen action for next trial
        r = sr(t);
        Q(a) = Q(a)+alpha*(r-Q(a));

        % Get log of likelihood
        NLL = NLL+ log(pr);
    end
    NLL = -NLL;
    
end
