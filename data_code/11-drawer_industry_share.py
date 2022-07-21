# draw the industry share
import pandas as pd
import numpy as np
import matplotlib as mpt
import matplotlib.pyplot as plt
import seaborn as sns

# structural change of CN and US
cn_sc = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/structural_change/cn_SC/cn_emp1952-2020.dta')
us_sc = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/structural_change/US_SC/us_emp_detail.dta')

year = np.asarray(cn_sc['year'])
cn_a = np.asarray(cn_sc['A_s'])
cn_i = np.asarray(cn_sc['I_s'])
cn_s = np.asarray(cn_sc['S_s'])
cn_sl = np.asarray(cn_sc['serl_s'])
cn_sh = np.asarray(cn_sc['serh_s'])

year2 = np.asarray(us_sc['year'])
us_a = np.asarray(us_sc['A_s'])
us_i = np.asarray(us_sc['I_s'])
us_sl = np.asarray(us_sc['serl_s'])
us_sh = np.asarray(us_sc['serh_s'])

plt.rcParams['figure.figsize'] = (16, 4.8)
plt.rcParams['legend.loc'] = 'best'
fig, ax = plt.subplots(1, 2)
ax[0].plot(year2, us_a, label='Primary' )
ax[0].plot(year2, us_i, color='xkcd:tan', label='Secondary' )
ax[0].plot(year2, us_sl, color='xkcd:avocado',  label='Low skill service' )
ax[0].plot(year2, us_sh, color='xkcd:slate green',  label='high skill service' )
ax[0].set_title('The US')
ax[0].set_xlabel('year')
ax[0].set_ylabel('employment share')
ax[0].spines['top'].set_visible(False)
ax[0].spines['right'].set_visible(False)
ax[0].set_ylim((-0.025,0.9))
ax[0].legend()
ax[0].grid()

ax[1].plot(year, cn_a, label='Primary' )
ax[1].plot(year, cn_i, color='xkcd:tan', label='Secondary' )
ax[1].plot(year, cn_sl, color='xkcd:avocado',  label='Low skill service' )
ax[1].plot(year, cn_sh, color='xkcd:slate green',  label='High skill service' )
ax[1].set_title('China')
ax[1].set_xlabel('year')
ax[1].set_ylabel('employment share')
ax[1].spines['top'].set_visible(False)
ax[1].spines['right'].set_visible(False)
ax[1].set_ylim((-0.025,0.9))
ax[1].legend()
ax[1].grid()
plt.show()

# Manufacturing decline of the US
# 1 basical trend of manufacturing
us_mu = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/structural_change/US_SC/us_manu_emp_naics.dta')
year = np.asarray(us_mu['year'])
