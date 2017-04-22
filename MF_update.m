function [Qmf1 Qmf2] = MF_update(frac1, Qmf1, reward, alpha1, lambda, Q2, frac2)

    VPE = Qmf2(frac2) - Qmf1(frac1);   % value prediction error: difference between actual and predicted value of 2nd fractal
    RPE = reward - Qmf2(frac2);   % reward prediction error: difference between actual and predicted reward
    Qmf1(frac1) = Qmf1(frac1) + alpha1 * (VPE + lambda * RPE);   % 1st-stage RL value update, including eligibility trace
    Qmf2(frac2) = Qmf2(frac2) + alpha2 * RPE;   % 2nd-stage simple RL value update
