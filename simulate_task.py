
import pandas as pd
import numpy as np
import math
import RLFitFuns as fun
import matplotlib.pyplot as plt


# Simulate some data
n_trials = 100
Data = fun.simulate_task(n_agents=2, fractal_rewards=[0, .3, .7, 1], n_trials=n_trials, common=0.8)
Q1_cols = [''.join(['Q1_', str(i)]) for i in range(2)]
Q2_cols = [''.join(['Q2_', str(i)]) for i in range(4)]

# Look at one agent
Agent = Data.loc[Data['AgentID'] == 0, :]
fig1 = plt.figure()
for value in Agent[Q1_cols]:
    y = np.array(Agent[value])
    ax1 = fig1.add_subplot(121)
    ax1.plot(range(len(y)), y)
    ax1.set_title('Stage 1 fractal values')
for value in Agent[Q2_cols]:
    y = np.array(Agent[value])
    ax2 = fig1.add_subplot(122)
    ax2.plot(range(len(y)), y)
    ax2.set_title('Stage 2 fractal values')

# Fit the model to the data
for t in range(n_trials):
