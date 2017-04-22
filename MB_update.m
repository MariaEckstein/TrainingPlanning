function [Qmb1, Qmb2] = MB_update(Qmf2, common)

Qmb2 = Qmf2;
Qmb1_frac1 = common * max(Qmb2(1:2)) + (1 - common) * max(Qmb2(3:4));
Qmb1_frac2 = (1 - common) * max(Qmb2(1:2)) + common * max(Qmb2(3:4));
Qmb1 = [Qmb1_frac1 Qmb1_frac2];