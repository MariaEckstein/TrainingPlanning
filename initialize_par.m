
epsilon = .00001;

% Initial values
Q1 = [.5 .5];   % Initial values 2st-stage fractals. [frac1 frac2] (according to fractal NAMES, not positions!!!)
Qmf1 = [.5 .5];
Q2 = [.5 .5 .5 .5];   % initial values 2nd-stage fractals. [frac1 frac2 frac3 frac4]
Qmf2 = [.5 .5 .5 .5];

% Parameters
alpha1 = par(1);
alpha2 = par(2);
beta1 = par(3) * 100;
beta2 = par(4) * 100;
lambda = par(5);
w = par(6);
p_par = par(7) * 10 - 5;
k_par = par(8) * 10 - 5;

% Initial last trial's keys and last trial's fractals
key1 = 123;
key2 = 123;
frac1 = 123;
frac2 = 123;