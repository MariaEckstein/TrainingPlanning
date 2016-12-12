function Q = MF_update_Q2(frac, Q, reward, alpha)

    RPE = reward - Q(frac);   % reward prediction error: difference between actual and predicted reward
    Q(frac) = Q(frac) + alpha * RPE;   % classic RL value update