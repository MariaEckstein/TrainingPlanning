function Qmb1 = MB_update(Qmf2, common)

Qmb1_frac1 = common * max(Qmf2(1:2)) + (1 - common) * max(Qmf2(3:4));
Qmb1_frac2 = (1 - common) * max(Qmf2(1:2)) + common * max(Qmf2(3:4));
Qmb1 = [Qmb1_frac1 Qmb1_frac2];