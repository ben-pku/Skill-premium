# Draw the plot of skill premium
import pandas as pd 
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns
plt.rcParams['figure.figsize'] = (15, 4.8)

us_sp = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/skill_premium/us_sp/us_sp_all.dta')

year1 = np.asarray(us_sp['year'])
us_sp1_b = np.asarray(us_sp['sp1_b']) # cps
us_sp1_c = np.asarray(us_sp['sp1_c']) # cps
us_sp1_h = np.asarray(us_sp['sp1_h']) # cps

us_sp2 = np.asarray(us_sp['sp2']) # census
us_sp3 = np.asarray(us_sp['sp3']) # psid


fig, ax = plt.subplots()

ax.plot(year1, us_sp1_c, marker='o',linewidth=1.5, markersize=5.5, label='CPS, college')
#ax.scatter(year1, us_sp2, s=14, color='xkcd:tan' ,label='US Census')
#ax.scatter(year1, us_sp3, s=14, color='xkcd:sky blue', label='PSID')
ax.set_xlabel('year')
ax.set_ylabel('Skill premium (log wage)')
ax.set_title('US Skill Premium 1964-2021')
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.legend()
ax.grid()
plt.show()

# US CPS Skill premium Data, High-college-bachelor
plt.rcParams['figure.figsize'] = (15, 4.8)
fig, a3 = plt.subplots()
a3.plot(year1, us_sp1_b, marker='o',linewidth=1.5, markersize=5.5, label='bachelor')
a3.plot(year1, us_sp1_c, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:tan', label='college')
a3.plot(year1, us_sp1_h, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:avocado', label='high school')
a3.set_xlabel('year')
a3.set_ylabel('Skill premium (log wage)')
a3.set_title('US Skill Premium 1964-2021')
a3.spines['top'].set_visible(False)
a3.spines['right'].set_visible(False)
a3.legend()
a3.grid()
plt.show()

# US CPS Data contrast
plt.rcParams['figure.figsize'] = (15, 9.6)
fig, axs = plt.subplots(2,1)
axs[0].plot(year1, us_sp1_b, marker='o', lw =1.5, markersize=5.5,label='CPS Bachelor')
axs[0].plot(year1, us_sp1_c, marker='o', lw =1.5, markersize=5.5, color='xkcd:avocado' , label='CPS College' )

axs[1].plot(year1, us_sp1_b, marker='o', lw =1.5, markersize=5.5,label='CPS without lower income')
axs[1].plot(year1, us_sp1_b1, marker='o', lw =1.5, markersize=5.5, color='xkcd:avocado' , label='CPS with lower income' )

axs[0].set_xlabel('year')
axs[0].set_ylabel('Skill premium (log wage)')
axs[0].set_title('US Skill Premium contrast -- College vs Bachelor')
axs[0].spines['top'].set_visible(False)
axs[0].spines['right'].set_visible(False)
axs[0].legend()
axs[0].grid()

axs[1].set_xlabel('year')
axs[1].set_ylabel('Skill premium (log wage)')
axs[1].set_title('US Skill Premium contrast -- whether to drop the lower income')
axs[1].spines['top'].set_visible(False)
axs[1].spines['right'].set_visible(False)
axs[1].legend()
axs[1].grid()
plt.subplots_adjust(hspace=0.4)
plt.show()

'''
cn_sp = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/skill_premium/cn_sp/cn-sp-1986-2020.dta')
year2 = np.asarray(cn_sp['year'])
cn_sp_c =np.asarray(cn_sp['sp_c']) # UHS
cn_sp_b =np.asarray(cn_sp['sp_b']) # UHS


c2 = cn_sp[['year','sp2_b','sp2_c']]
c2 = c2.dropna(axis=0)
year_2 = np.asarray(c2['year'])
cn_sp2_b =np.asarray(c2['sp2_b']) # CFPS
cn_sp2_c = np.asarray(c2['sp2_c']) # CFPS


c3 = cn_sp[['year','sp3_b']]
c3 = c3.dropna(axis=0)
year_3 = np.asarray(c3['year'])
cn_sp3_b =np.asarray(c3['sp3_b']) # CHFS

plt.rcParams['figure.figsize'] = (15, 4.8)
fig, an = plt.subplots()
an.plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, label='UHS')
an.plot(year_2, cn_sp2_b, marker='o',lw=1.4,ms=5, color='xkcd:tan', label='CFPS')
an.scatter(year_3, cn_sp3_b, s=14, color='xkcd:sky blue',label='CHFS')
an.set_xlabel('year')
an.set_ylabel('Skill premium (log wage)')
an.spines['top'].set_visible(False)
an.spines['right'].set_visible(False)
an.set_title('China Skill Premium 1986-2020')
an.grid()
an.legend()
plt.show() '''

''' # CN UHS Data contrast
plt.rcParams['figure.figsize'] = (15, 9.6)
fig, cnc = plt.subplots(2,1)
cnc[0].plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, label='UHS Bachelor')
cnc[0].plot(year_2, cn_sp2_b, marker='o',linewidth=1.5, markersize=5.5,color='xkcd:azure', label='CFPS Bachelor')
cnc[0].plot(year2, cn_sp_c, marker='o',linewidth=1.0, markersize=3, color='xkcd:avocado', label='UHS College')
cnc[0].plot(year_2, cn_sp2_c, marker='o',linewidth=1.0, markersize=3, color='xkcd:algae', label='CFPS College')

cnc[1].plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, label='UHS without lower income')
cnc[1].plot(year_2, cn_sp2_b, marker='o',linewidth=1.5, markersize=5.5,color='xkcd:azure', label='CFPS without lower income')
cnc[1].plot(year2, cn_sp_b1, marker='o',linewidth=1.0, markersize=3, color='xkcd:avocado', label='UHS with lower income')
cnc[1].plot(year_2, cn_sp2_b, marker='o',linewidth=1.0, markersize=3,color='xkcd:algae', label='CFPS with lower income')

cnc[0].set_xlabel('year')
cnc[0].set_ylabel('Skill premium (log wage)')
cnc[0].set_title('Chinese Skill Premium contrast -- College vs Bachelor')
cnc[0].spines['top'].set_visible(False)
cnc[0].spines['right'].set_visible(False)
cnc[0].legend()
cnc[0].grid()

cnc[1].set_xlabel('year')
cnc[1].set_ylabel('Skill premium (log wage)')
cnc[1].set_title('Chinese Skill Premium contrast -- whether to drop the lower income')
cnc[1].spines['top'].set_visible(False)
cnc[1].spines['right'].set_visible(False)
cnc[1].legend()
cnc[1].grid()
plt.subplots_adjust(hspace=0.4)
plt.show() '''
