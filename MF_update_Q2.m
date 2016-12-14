function Q2 = MF_update_Q2(frac2, Q2, reward, alpha2)

    RPE = reward - Q2(frac2);   % reward prediction error: difference between actual and predicted reward
    Q2(frac2) = Q2(frac2) + alpha2 * RPE;   % classic RL value update