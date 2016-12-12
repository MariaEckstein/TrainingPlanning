function fractals2 = select_stage2_fractals(frac1, common)

    if frac1 == 1   % left 1st-stage fractal chosen
        if rand < common
            fractals2 = [1 2];   % 2nd-stage pair1 (fractal0 & fractal1)
        else
            fractals2 = [3 4];   % 2nd-stage pair2 (fractal2 & fractal3)
        end
    else   % right 1st-stage fractal chosen
        if rand < common
            fractals2 = [3 4];
        else
            fractals2 = [1 2];
        end
    end
        
        