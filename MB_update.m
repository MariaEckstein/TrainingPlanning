function Qmb1 = MB_update(Qmf2, common)

% I should check if frac1_1 really leads to frac2_12 and frac1_2 leads to
% frac2_34
    Qmb1_frac1 = common * max(Qmf2(1:2)) + (1 - common) * max(Qmf2(3:4));
    Qmb1_frac2 = (1 - common) * max(Qmf2(1:2)) + common * max(Qmf2(3:4));
    Qmb1 = [Qmb1_frac1 Qmb1_frac2];