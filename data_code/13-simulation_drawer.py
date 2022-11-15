import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns

# draw the simulation path
d0 = pd.read_csv('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/code/Trade_code/KLR_GSGE/three_sector-two_labor/v6-1.csv')
t = np.asarray(d0['t'])
k1 = np.asarray(d0['k1'])
k2 = np.asarray(d0['k2'])
sp = np.asarray(d0['sp'])
L1 = np.asarray(d0['L1'])
L2 = np.asarray(d0['L2'])

plt.rcParams['figure.figsize'] = (15, 4.8)
fig, an = plt.subplots()
an.plot(t, sp, marker='o',linewidth=1.5, color='xkcd:grey', markersize=4)
an.set_xlabel('year')
an.set_ylabel('skill premium')
an.spines['top'].set_visible(False)
an.spines['right'].set_visible(False)
an.grid(False)
an.set_title('Skill Premium in Model')
plt.show()

plt.rcParams['figure.figsize'] = (15, 4.8)
fig, an = plt.subplots()
an.plot(t, L1, marker='o',linewidth=1.5, color='xkcd:grey', markersize=4, label='Rural')
an.plot(t, L2, marker='s',linewidth=1.5, color='xkcd:grey', markersize=4, label='Urban')
an.set_xlabel('year')
an.set_ylabel('unskilled labor')
an.spines['top'].set_visible(False)
an.spines['right'].set_visible(False)
an.grid(False)
an.legend()
an.set_title('Unskilled Labor\'s Migration in Model')
plt.show()

plt.rcParams['figure.figsize'] = (15, 4.8)
fig, an = plt.subplots()
an.plot(t, k1, marker='o',linewidth=1.5, color='xkcd:grey', markersize=4, label='Rural')
an.plot(t, k2, marker='s',linewidth=1.5, color='xkcd:grey', markersize=4, label='Urban')
an.set_xlabel('year')
an.set_ylabel('capital stock')
an.spines['top'].set_visible(False)
an.spines['right'].set_visible(False)
an.grid(False)
an.legend()
an.set_title('Capital Stock Dynamics in Model')
plt.show()