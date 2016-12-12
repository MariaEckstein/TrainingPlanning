function Q1 = MF_update_Q1(frac1, Q1, reward, alpha, lambda, Q2_upd)

    RPE = reward - Q1(frac1);   % reward prediction error: difference between actual and predicted reward
    VPE = Q2_upd - Q1(frac1);   % value prediction error: difference between actual and predicted value of 2nd fractal
    Q1(frac1) = Q1(frac1) + alpha * (VPE + lambda * alpha * RPE);   % classic RL value update