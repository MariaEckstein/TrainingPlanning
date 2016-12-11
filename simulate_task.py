
import pandas as pd
import numpy as np
import math
import RLFitFuns as fun
import matplotlib.pyplot as plt
from scipy.optimize import minimize, basinhopping


# Simulate some data
n_trials = 5
sim_par = np.array([.02, .02, .4, .4, .3, 1])
global Data
Data = fun.simulate_task(mode='simulate', n_agents=1, par=sim_par, fractal_rewards=[0, .3, .7, 1], n_trials=n_trials, common=0.8)

# Fit parameters to data
par_lb = np.zeros(len(sim_par))
par_ub = np.ones(len(sim_par))
par_start = (par_lb + par_ub) / 2
fun.simulate_task(par_start)
res = minimize(fun.simulate_task, par_start, bounds=list(zip(par_lb, par_ub)))


class MyBounds(object):
    def __init__(self, xmax=[1, 1, 1, 1, 1, 1], xmin=[0, 0, 0, 0, 0, 0] ):
        self.xmax = np.array(xmax)
        self.xmin = np.array(xmin)
    def __call__(self, **kwargs):
        x = kwargs["x_new"]
        tmax = bool(np.all(x <= self.xmax))
        tmin = bool(np.all(x >= self.xmin))
        return tmax and tmin

mybounds = MyBounds()

res = basinhopping(fun.simulate_task, par_start, niter=1, T=0.1, stepsize=0.1, accept_test=mybounds)

# Get fitted parameters or define other parameters for plotting
fit_par = res.x   # sim_par   # np.random.rand(len(sim_par))   # sim_par + 0.2
NLL = fun.simulate_task(mode='fit', par=fit_par)

# Look at one agent
Q1_cols = [''.join(['Q1_', str(i)]) for i in range(2)]
Q2_cols = [''.join(['Q2_', str(i)]) for i in range(4)]
fit_Q1_cols = [''.join(['fit_Q1_', str(i)]) for i in range(2)]
fit_Q2_cols = [''.join(['fit_Q2_', str(i)]) for i in range(4)]
Agent = Data.loc[Data['AgentID'] == 1, :]
fig1 = plt.figure()
fig1.suptitle(''.join(['True par: ', str(sim_par), '; Fit par (LL = ', str(round(NLL)), '):', str(np.round(fit_par, 2))]))
for value in Agent[Q1_cols]:
    y = np.array(Agent[value])
    ax1 = fig1.add_subplot(221)
    ax1.plot(range(len(y)), y)
    ax1.set_title('Stage 1 true values')
for value in Agent[Q2_cols]:
    y = np.array(Agent[value])
    ax2 = fig1.add_subplot(222)
    ax2.plot(range(len(y)), y)
    ax2.set_title('Stage 2 true values')
for value in Agent[fit_Q1_cols]:
    y = np.array(Agent[value])
    ax1 = fig1.add_subplot(223)
    ax1.plot(range(len(y)), y)
    ax1.set_title('Stage 1 fit values')
for value in Agent[fit_Q2_cols]:
    y = np.array(Agent[value])
    ax2 = fig1.add_subplot(224)
    ax2.plot(range(len(y)), y)
    ax2.set_title('Stage 2 fit values')

