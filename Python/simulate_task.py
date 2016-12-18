
import pandas as pd
import numpy as np
import math
import RLFitFuns as fun
import matplotlib.pyplot as plt
from scipy.optimize import minimize, basinhopping


# Simulate some data
n_trials = 150
sim_par = np.array([.02, .02, .4, .4, .3, 1])
Data = fun.simulate_data(n_agents=1, par=sim_par, fractal_rewards=[0, .3, .7, 1], n_trials=n_trials, common=0.8)

# Fit parameters to data
# Get n_trials and n_agents
n_trials = max(Data['TrialID']) + 1
n_agents = max(Data['AgentID']) + 1

# Loop through agents and fit parameters for each one
fit_par = sim_par #+ 0.2
for agent in range(n_agents):
    global Agent
    Agent = Data.loc[Data['AgentID'] == agent, :]

    # Basinhopping

    par_lb = np.zeros(len(sim_par))
    par_ub = np.ones(len(sim_par))
    par_start = (par_lb + par_ub) / 2

    class MyBounds(object):
        def __init__(self, xmax=[1, 1, 1, 1, 1, 1], xmin=[0, 0, 0, 0, 0, 0]):
            self.xmax = np.array(xmax)
            self.xmin = np.array(xmin)

        def __call__(self, **kwargs):
            x = kwargs["x_new"]
            tmax = bool(np.all(x <= self.xmax))
            tmin = bool(np.all(x >= self.xmin))
            return tmax and tmin


    mybounds = MyBounds()
    res = basinhopping(fit_data, par_start, niter=10, T=0.5, stepsize=0.5, accept_test=mybounds, niter_success=5,
                       minimizer_kwargs={'method': 'Nelder-Mead'})
    print(res)

    n_iter = 5
    values = np.zeros([n_iter, (2 * len(sim_par) + 1)])
    for iter in range(n_iter):
        print(iter)
        par_start = np.random.rand(len(sim_par))
        # res = minimize(fit_data, par_start, bounds=list(zip(par_lb, par_ub)), method='L-BFGS-B', tol=0.1)
        # res = minimize(fit_data, par_start, method='Nelder-Mead', options={'disp': True, 'fatol': 0.01, 'xatol': 0.01})
        res = minimize(fit_data, par_start, method='BFGS', options={'gtol': 0.5})
        values[iter, :] = list(res.x) + list(par_start) + [res.fun]
    print(values)
    lowest_f_values = values[:,6] == max(values[:,6])
    best_x = values[lowest_f_values][0]


fit_data(par=fit_par)


def fit_data(par, n_trials=150, fractal_rewards=[0, .3, .7, 1], common=0.8):

    # Get Agent Data
    # global Agent

    # Name to-be-optimized parameters
    alpha1 = par[0] / 2
    alpha2 = par[1] / 2
    beta1 = par[2] * 10
    beta2 = par[3] * 10
    lambd = par[4] / 2 + 0.5
    w = par[5]

    # Initialize fractal values
    Q1 = 0.5 * np.ones(2)   # Stage 1 values
    Q2 = 0.5 * np.ones(4)   # Stage 2 values

    Q1_values = []
    Q2_values = []

    # Get likelihood of the agent's choices in each trial
    LL = 0
    for t in range(n_trials):

        # Stage-1 fractals
        fractals1 = [0, 1]

        # Agent's probability of choosing each fractal, gives agent's fractal values
        prob_frac1 = fun.softmax_Q2p(fractals1, Q1, beta1)   # P(fraca) = 1 / (1 + e ** (beta * (Qb - Qa))

        # Look up which stage-1 fractal was picked
        frac1 = Agent.loc[t, 'frac1']

        # Check which stage-2 fractal pair was shown
        if Agent.loc[t, 'frac2'] in [0, 1]:
            fractals2 = [0, 1]
        else:
            fractals2 = [2, 3]

        # Agent's probability of choosing each fractal, gives agent's fractal values
        prob_frac2 = fun.softmax_Q2p(fractals2, Q2, beta2)

        # Look up which stage-2 fractal was picked
        frac2 = Agent.loc[t, 'frac2']

        # Check if agent got a reward
        reward = Agent.loc[t, 'reward']

        # Simulate agent's updating of 1st- and 2nd-stage values, given input parameters par
        Q2 = fun.MF_update_Q2(frac2, Q2, reward, alpha2)   # Q2 = Q2 + alpha * (reward - Q2)
        Q1 = fun.MF_update_Q1(frac1, Q1, reward, alpha1, lambd, Q2[frac2])   # Q1 = Q1 + alpha * (Q2 - Q1 + lambd * (reward - Q1))

        # Get log likelihood
        LL += math.log(prob_frac1[frac1]) + math.log(prob_frac2[frac2-2])

        # Save trial data
        Q1_values = Q1_values + [Q1.copy()]
        Q2_values = Q2_values + [Q2.copy()]

    print(-LL)
    return (-LL)



# Get fitted parameters or define other parameters for plotting
fit_par = best_x   # sim_par   # np.random.rand(len(sim_par))   # sim_par + 0.2
NLL = fun.fit_data(par=fit_par)

# Look at one agent
Q1_cols = [''.join(['Q1_', str(i)]) for i in range(2)]
Q2_cols = [''.join(['Q2_', str(i)]) for i in range(4)]
fit_Q1_cols = [''.join(['fit_Q1_', str(i)]) for i in range(2)]
fit_Q2_cols = [''.join(['fit_Q2_', str(i)]) for i in range(4)]
Agent = Data.loc[Data['AgentID'] == 0, :]
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

