function Q1 = MF_update_Q1(frac1, Q1, reward, alpha, lambda, Q2, frac2)

    VPE = Q2(frac2) - Q1(frac1);   % value prediction error: difference between actual and predicted value of 2nd fractal
    RPE = reward - Q2(frac2);   % reward prediction error: difference between actual and predicted reward
    Q1(frac1) = Q1(frac1) + alpha * (VPE + lambda * RPE);   % classic RL value update