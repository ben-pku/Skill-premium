# draw the industry share
import pandas as pd
import numpy as np
import matplotlib as mpt
import matplotlib.pyplot as plt
import seaborn as sns

# structural change of CN 
cn_sc = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/structural_change/cn_SC/cn_emp1978-2020.dta')
us_sc = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/structural_change/US_SC/us_emp_detail.dta')

year = np.asarray(cn_sc['year'])
cn_a = np.asarray(cn_sc['a_s'])
cn_i = np.asarray(cn_sc['i_s'])
cn_s = np.asarray(cn_sc['s_s'])
cn_sl = np.asarray(cn_sc['serl_s'])
cn_sh = np.asarray(cn_sc['serh_s'])

year2 = np.asarray(us_sc['year'])
us_a = np.asarray(us_sc['A_s'])
us_i = np.asarray(us_sc['I_s'])
us_sl = np.asarray(us_sc['serl_s'])
us_sh = np.asarray(us_sc['serh_s'])

plt.rcParams['figure.figsize'] = (15, 4.8)
plt.rcParams['legend.loc'] = 'best'
fig, ax = plt.subplots()
ax.plot(year, cn_a, marker='o',markersize=4, color='xkcd:almost black', label='Agriculture' )
ax.plot(year, cn_i, marker='s',markersize=4, color='xkcd:almost black', label='Industry' )
ax.plot(year, cn_sl, marker='^',markersize=4, color='xkcd:grey', label='Low Skill Service' )
ax.plot(year, cn_sh, marker='v',markersize=4, color='xkcd:grey', label='High Skill Service' )
ax.set_title('Employment Share in China')
ax.set_xlabel('year')
ax.set_ylabel('employment share %')
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.legend()
plt.show()




'''
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
'''

# Service share in CN 劳动年鉴
cn_s = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/structural_change/cn_SC/cn_laboryearbook78-20.dta')
year = np.asarray(cn_s['year'])
serl_s = np.asarray(cn_s['serl_s'])
serh_s = np.asarray(cn_s['serh_s'])
plt.rcParams['figure.figsize'] = (15, 4.8)
plt.rcParams['legend.loc'] = 'best'
fig, ax = plt.subplots()
ax.plot(year, serl_s, marker='o',markersize=4, color='xkcd:grey', label='Low Skill Service' )
ax.plot(year, serh_s, marker='s',markersize=4, color='xkcd:grey', label='High Skill Service' )

ax.set_title('Service Industry in China')
ax.set_xlabel('year')
ax.set_ylabel('employment share')
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.legend()
plt.show()

# census
cn_s = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/structural_change/cn_SC/ser_emp_census82-18d.dta')
year = np.asarray(cn_s['year'])
serl_s = np.asarray(cn_s['emp_s0'])
serh_s = np.asarray(cn_s['emp_s1'])
fig, ax = plt.subplots()
ax.plot(year, serl_s, marker='o',markersize=4, color='xkcd:grey', label='Low Skill Service' )
ax.plot(year, serh_s, marker='s',markersize=4, color='xkcd:grey', label='High Skill Service' )

ax.set_title('Service Industry in China (Census)')
ax.set_xlabel('year')
ax.set_ylabel('employment share')
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.legend()
plt.show()

# construction and mining
cn_s = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/structural_change/cn_SC/cn_service78-20.dta')
year = np.asarray(cn_s['year'])
min = np.asarray(cn_s['min_s'])
con = np.asarray(cn_s['con_s'])
fig, ax = plt.subplots()
ax.plot(year, min, marker='o',markersize=4, color='xkcd:grey', label='Mining' )
ax.plot(year, con, marker='s',markersize=4, color='xkcd:grey', label='Construction' )

ax.set_title('Mining and Construction in China')
ax.set_xlabel('year')
ax.set_ylabel('employment share') 
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.legend()
plt.show()