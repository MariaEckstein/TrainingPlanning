import pandas as pd
import numpy as np
import math


def softmax_Q2p(fractals, Q, beta, epsilon=.000001):

    prob_frac_left = 1 / (1 + math.e ** (beta * (Q[fractals[1]] - Q[fractals[0]])))
    prob_frac_left = (1 - epsilon) * prob_frac_left + epsilon / 2
    prob_frac = np.array([prob_frac_left, 1 - prob_frac_left])

    return prob_frac


def MF_update_Q2(fractals2, Q2, reward, alpha):

    Q2_new = Q2.copy()
    RPE2 = reward - Q2_new[fractals2]
    Q2_new[fractals2] = Q2_new[fractals2] + alpha * RPE2

    return Q2_new


def MF_update_Q1(fractals1, Q1, reward, alpha, lambd, Q2_upd):

    Q1_new = Q1.copy()
    RPE1 = lambd * (reward - Q1_new[fractals1])
    VPE1 = Q2_upd - Q1_new[fractals1]
    Q1_new[fractals1] = Q1_new[fractals1] + alpha * (VPE1 + RPE1)

    return Q1_new


def select_stage2_fractals(frac1, common=0.8):

    if frac1 == 0:   # left 1st-stage fractal chosen
        if np.random.rand() < common:
            fractals2 = [0, 1]   # 2nd-stage pair1 (fractal0 & fractal1)
        else:
            fractals2 = [2, 3]   # 2nd-stage pair2 (fractal2 & fractal3)
    else:    # right 1st-stage fractal chosen
        if np.random.rand() < common:
            fractals2 = [2, 3]
        else:
            fractals2 = [0, 1]

    return fractals2


# def simulate_task(n_agents, fractal_rewards=[0, .3, .7, 1], n_trials=100, common=0.8):
#
#     # Set up big DataFrame that will hold all the simulated agents' data
#     colnames = ['AgentID', 'Q1_0', 'Q1_1', 'Q2_0', 'Q2_1', 'Q2_2', 'Q2_3', 'frac1', 'frac2', 'reward']
#     agent_length = n_trials + 1
#     Data = pd.DataFrame(columns=colnames, index=range(n_agents * agent_length))
#
#     # Loop through agents and generate data for each one
#     for agent in range(n_agents):
#
#         # Initialize DataFrame for agent's behavior
#         agent_rows = agent * agent_length + np.array(range(agent_length))
#         Data.set_value(agent_rows, 'AgentID', agent)   # initial 1st-stage fractals
#         # Agent = pd.DataFrame(columns=colnames, index=range(n_trials + 1))
#         # Agent['AgentID'] = agent   # initial 1st-stage fractals
#
#         # Initial values for fractals
#         Q1_cols = [''.join(['Q1_', str(i)]) for i in range(2)]
#         Q2_cols = [''.join(['Q2_', str(i)]) for i in range(4)]
#         Data.set_value(agent_rows[0], Q1_cols, .5 * np.ones(2))   # initial 1st-stage fractals
#         Data.set_value(agent_rows[0], Q2_cols, .5 * np.ones(4))   # initial 2nd-stage fractals
#         # Agent.set_value(0, 'Q1', .5 * np.ones(2))   # initial 1st-stage fractals
#         # Agent.set_value(0, 'Q2', .5 * np.ones(4))   # initial 2nd-stage fractals
#
#         # Individual behavioral parameters
#         par = np.random.rand(6)
#         alpha1 = par[0] / 2
#         alpha2 = par[1] / 2
#         beta1 = par[2] * 10
#         beta2 = par[3] * 10
#         lambd = par[4] / 2 + 0.5
#         w = par[5]
#
#         # Let agent play the game
#         for t in range(n_trials):
#
#             # Get the right row in Data for this agent in this trial
#             a_t = agent_rows[0] + t
#
#             # STAGE 1
#             # Display fractals
#             fractals1 = [0, 1]
#
#             # Agent's probability of choosing each fractal, gives their values
#             prob_frac1 = softmax_Q2p(fractals1, Data.loc[a_t, Q1_cols], beta1)   # 1 / (1 + e ** (beta * (Qa - Qb))
#
#             # Agent picks one of the two fractals based on their probability
#             frac1 = np.random.choice(fractals1, p=prob_frac1)
#
#             # STAGE 2
#             # Display fractals
#             fractals2 = select_stage2_fractals(frac1)   # frac1 == 0 => usually [0, 1]; frac1 == 1 => usually [2, 3]
#
#             # Agent picks a fractal like in 1st stage
#             prob_frac2 = softmax_Q2p(fractals2, Data.loc[a_t, Q2_cols], beta2)
#             frac2 = np.random.choice(fractals2, p=prob_frac2)
#
#             # Agent receives reward and updates 1st- and 2nd-stage values
#             reward = np.random.choice([0, 1], p=[1 - fractal_rewards[frac2], fractal_rewards[frac2]])
#
#             # Model-free
#             Q2_new = MF_update_Q2(frac2, Data.loc[a_t, Q2_cols], reward, alpha2)   # Q2 = Q2 + alpha * (reward - Q2)
#             Q1_new = MF_update_Q1(frac1, Data.loc[a_t, Q1_cols], reward, alpha1,
#                                   lambd, Q2_new[frac2])   # Q1 = Q1 + alpha * (Q2 - Q1 + lambd * (reward - Q1))
#
#             # Save trial data
#             Data.set_value(a_t + 1, Q1_cols, Q1_new.copy())
#             Data.set_value(a_t + 1, Q2_cols, Q2_new.copy())
#             Data.set_value(a_t, 'frac1', frac1.copy())
#             Data.set_value(a_t, 'frac2', frac2.copy())
#             Data.set_value(a_t, 'reward', reward.copy())
#
#     return Data


def simulate_task(mode, Data=pd.DataFrame(), par=[], n_agents=50, fractal_rewards=[0, .3, .7, 1], n_trials=100, common=0.8):

    Q1_cols = [''.join(['Q1_', str(i)]) for i in range(2)]
    Q2_cols = [''.join(['Q2_', str(i)]) for i in range(4)]

    # Set up big DataFrame that will hold all the simulated agents' data
    if mode == 'simulate':
        colnames = ['AgentID', 'TrialID', 'Q1_0', 'Q1_1', 'Q2_0', 'Q2_1', 'Q2_2', 'Q2_3', 'frac1', 'frac2', 'reward']
        Data = pd.DataFrame(columns=colnames, index=range(n_agents * n_trials))
    elif mode == 'fit':
        n_trials = max(Data['TrialID']) + 1
        n_agents = max(Data['AgentID']) + 1
        fit_Q1_cols = [''.join(['fit_Q1_', str(i)]) for i in range(2)]
        fit_Q2_cols = [''.join(['fit_Q2_', str(i)]) for i in range(4)]
        for col in fit_Q1_cols + fit_Q2_cols:
            Data[col] = 'NaN'

    # Loop through agents and generate data for each one
    for agent in range(n_agents):

        agent_rows = agent * n_trials + np.array(range(n_trials))
        if mode == 'simulate':
            # Initialize DataFrame for agent's behavior
            Data.set_value(agent_rows, 'AgentID', agent)   # initial 1st-stage fractals
            # Initial values for fractals
            Data.set_value(agent_rows[0], Q1_cols, .5 * np.ones(2))   # initial 1st-stage fractals
            Data.set_value(agent_rows[0], Q2_cols, .5 * np.ones(4))   # initial 2nd-stage fractals
        elif mode == 'fit':
            # Initial fitted values for fractals
            Data.set_value(agent_rows[0], fit_Q1_cols, .5 * np.ones(2))   # initial 1st-stage fractals
            Data.set_value(agent_rows[0], fit_Q2_cols, .5 * np.ones(4))   # initial 2nd-stage fractals

        # Get agent's parameters
        if (mode == 'simulate') and len(par) == 0:
            par = np.random.rand(6)

        # Name the parameters
        alpha1 = par[0] / 2
        alpha2 = par[1] / 2
        beta1 = par[2] * 10
        beta2 = par[3] * 10
        lambd = par[4] / 2 + 0.5
        w = par[5]

        # Let agent play the game
        for t in range(n_trials):

            # Get the right row in Data for this agent in this trial
            a_t = agent_rows[0] + t

            # Display stage-1 fractals
            fractals1 = [0, 1]

            # Agent's probability of choosing each fractal, gives their values
            prob_frac1 = softmax_Q2p(fractals1, Data.loc[a_t, Q1_cols], beta1)   # 1 / (1 + e ** (beta * (Qa - Qb))

            # Agent picks one of the two fractals based on their probability and stage-2 fractals are shown
            if mode == 'simulate':
                # Agent picks one fractal
                frac1 = np.random.choice(fractals1, p=prob_frac1)
                # Stage-2 fractals are shown
                fractals2 = select_stage2_fractals(frac1)   # frac1 == 0 => usually [0, 1]; frac1 == 1 => usually [2, 3]
            elif mode == 'fit':
                # Look up which fractal was picked
                frac1 = Data.loc[a_t, 'frac1']
                # Check which stage-2 fractal pair was shown
                if Data.loc[a_t, 'frac2'] in [0, 1]:
                    fractals2 = [0, 1]
                else:
                    fractals2 = [2, 3]

            # Agent picks a stage-2 fractal (same as in stage 1) and receives a reward
            prob_frac2 = softmax_Q2p(fractals2, Data.loc[a_t, Q2_cols], beta2)
            if mode == 'simulate':
                # Agent picks a fractal
                frac2 = np.random.choice(fractals2, p=prob_frac2)
                # Agent potentially receives a reward, depending on reward probabilities of chosen fractal
                reward = np.random.choice([0, 1], p=[1 - fractal_rewards[frac2], fractal_rewards[frac2]])
            elif mode == 'fit':
                # Look up which fractal the agent picked
                frac2 = Data.loc[a_t, 'frac2']
                # Check if agent got a reward
                reward = Data.loc[a_t, 'reward']

            # Agent updates 1st- and 2nd-stage values
            Q2_new = MF_update_Q2(frac2, Data.loc[a_t, Q2_cols], reward, alpha2)   # Q2 = Q2 + alpha * (reward - Q2)
            Q1_new = MF_update_Q1(frac1, Data.loc[a_t, Q1_cols], reward, alpha1,
                                  lambd, Q2_new[frac2])   # Q1 = Q1 + alpha * (Q2 - Q1 + lambd * (reward - Q1))

            # Save trial data
            if mode == 'simulate':
                Data.set_value(a_t, 'frac1', frac1.copy())
                Data.set_value(a_t, 'frac2', frac2.copy())
                Data.set_value(a_t, 'reward', reward.copy())
                Data.set_value(a_t, 'TrialID', t)
                if t < (n_trials - 1):
                    Data.set_value(a_t + 1, Q1_cols, Q1_new.copy())
                    Data.set_value(a_t + 1, Q2_cols, Q2_new.copy())
            elif mode == 'fit':
                if t < (n_trials - 1):
                    Data.set_value(a_t + 1, fit_Q1_cols, list(Q1_new.copy()))
                    Data.set_value(a_t + 1, fit_Q2_cols, list(Q2_new.copy()))

    return Data
