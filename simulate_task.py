
import pandas as pd
import numpy as np
import math
import RLFitFuns as fun
import matplotlib.pyplot as plt


# Simulate some data
n_trials = 150
sim_par = [.02, .02, .4, .4, .3, 1]
Data = fun.simulate_task(mode='simulate', n_agents=5, par=sim_par, fractal_rewards=[0, .3, .7, 1], n_trials=n_trials, common=0.8)

# Fit the model to the data
fit_par = sim_par
fun.simulate_task(mode='fit', Data=Data, par=fit_par)

# Look at one agent
Q1_cols = [''.join(['Q1_', str(i)]) for i in range(2)]
Q2_cols = [''.join(['Q2_', str(i)]) for i in range(4)]
fit_Q1_cols = [''.join(['fit_Q1_', str(i)]) for i in range(2)]
fit_Q2_cols = [''.join(['fit_Q2_', str(i)]) for i in range(4)]
Agent = Data.loc[Data['AgentID'] == 1, :]
fig1 = plt.figure()
fig1.suptitle(''.join(['True par: ', str(sim_par), '; Fit par:', str(fit_par)]))
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
