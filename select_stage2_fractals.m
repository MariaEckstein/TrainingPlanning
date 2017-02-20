function fractals2 = select_stage2_fractals(frac1, common)

    if frac1 == 1   % left 1st-stage fractal chosen
        if rand < common
            fractals2 = randsample([1 2], 2, false);   % 2nd-stage pair1 (fractal1 & fractal2)
        else
            fractals2 = randsample([3 4], 2, false);   % 2nd-stage pair2 (fractal3 & fractal4)
        end
    else   % right 1st-stage fractal chosen
        if rand < common
            fractals2 = randsample([3 4], 2, false);
        else
            fractals2 = randsample([1 2], 2, false);
        end
    end
        
        