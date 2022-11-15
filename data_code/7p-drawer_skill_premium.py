# 8-drawer skill premium
# edited on 12th May, 2022, Zhuokai Huang
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns

# My estimation
plt.rcParams['figure.figsize'] = (15, 4.8)
cn_sp = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/skill_premium/cn_sp/cn-sp-1986-2020.dta')
year2 = np.asarray(cn_sp['year']) # UHS
cn_sp_b = np.asarray(cn_sp['sp_b'])
cn_sp_c = np.asarray(cn_sp['sp_c'])
cn_sp_h = np.asarray(cn_sp['sp_h'])
c2 = cn_sp[['year','sp2_b']]
c2 = c2.dropna(axis=0)
year_2 = np.asarray(c2['year'])
cn_sp2_b =np.asarray(c2['sp2_b']) # CFPS
b = np.polyfit(year_2,cn_sp2_b,1)
sp2_b = np.poly1d(b)
sp2_b = sp2_b(year_2)

fig, an = plt.subplots()
an.plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, label='UHS')
an.plot(year_2, cn_sp2_b, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:tan', label='CFPS')
an.plot(year_2,sp2_b, ls='--', color='xkcd:medium blue',label='linear fit')
an.set_xlabel('year')
an.set_ylabel('Skill premium (log wage)')
an.spines['top'].set_visible(False)
an.spines['right'].set_visible(False)
an.set_title('China Skill Premium 1986-2020')
an.legend()
plt.show()

# my estimation and adjustment with CFPS
plt.rcParams['figure.figsize'] = (15, 4.8)
c3 = cn_sp[['year','sp2_ba','sp2_ca','sp2_ha']]
c3 = c3.dropna(axis=0)
year_3 = np.asarray(c3['year'])
sp2_ba = np.asarray(c3['sp2_ba'])
sp2_ca = np.asarray(c3['sp2_ca'])
sp2_ha = np.asarray(c3['sp2_ha'])

fig, an1 = plt.subplots()
an1.plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:azure', label='Bachelor, UHS')
an1.plot(year_3, sp2_ba, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:azure', label='Bachelor, CFPS adjusted')
an1.plot(year2, cn_sp_c, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:grass green', label='College, UHS')
an1.plot(year_3, sp2_ca, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:grass green', label='College, CFPS adjusted')
an1.plot(year2, cn_sp_h, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:tan', label='High school, UHS')
an1.plot(year_3, sp2_ha, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:tan', label='High school, CFPS adjusted')

an1.set_xlabel('year')
an1.set_ylabel('Skill premium (log wage)')
an1.spines['top'].set_visible(False)
an1.spines['right'].set_visible(False)
an1.set_title('China Skill Premium 1986-2020')
an1.legend()
plt.show()

# my estimation and adjustment with CFPS, College level
plt.rcParams['figure.figsize'] = (15, 4.8)
c = np.polyfit(year_3,sp2_ca,1)
sp2_cafit = np.poly1d(c)
sp2_cafit = sp2_cafit(year_3)
fig, an2 = plt.subplots()
an2.plot(year2, cn_sp_c, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:grey', label='UHS')
an2.plot(year_3, sp2_ca, marker='^',linewidth=1.5, markersize=5.5, color='xkcd:grey', label='CFPS')
#an2.plot(year_3, sp2_cafit, ls='--', color='xkcd:medium blue',label='linear fit')
an2.set_xlabel('year')
an2.set_ylabel('Skill premium (log wage)')
an2.spines['top'].set_visible(False)
an2.spines['right'].set_visible(False)
an2.grid(False)
an2.set_title('China Skill Premium 1986-2020')
an2.legend()
plt.show()

'''
## review the plot of Chong'en Bai
bai_sp = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/skill_premium/cn_sp/UHS/sp_uhs_panel/BaiJDE-ZhangJIE.dta')
year = np.asarray(bai_sp['year']) # all year UHS
sph = np.asarray(bai_sp['sph'])
spc = np.asarray(bai_sp['spc'])
'''
'''
fig, ax = plt.subplots()
ax.plot(year, spc, marker='o',linewidth=1.5, markersize=5.5, label='College')
ax.plot(year, sph, marker='o',linewidth=1.5, markersize=5.5, c='xkcd:sky blue', label='High School')
ax.set_ylabel('Skill Premium')
ax.set_xlabel('Year')
plt.legend()
plt.grid()
plt.show() 
'''

'''
bai_sp1 = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/skill_premium/cn_sp/UHS/sp_uhs_panel/BaiJDE00-12.dta')
year1 = np.asarray(bai_sp1['year'])  # 2000-2012
sph1 = np.asarray(bai_sp1['sph'])
spc1 = np.asarray(bai_sp1['spc']) 

plt.rcParams['figure.figsize'] = (15, 4.8)

fig, ax = plt.subplots(1,2)
ax[0].plot(year, spc, marker='o',linewidth=1.5, markersize=5.5, label='College')
ax[0].plot(year, sph, marker='o',linewidth=1.5, markersize=5.5, c='xkcd:sky blue', label='High School')
ax[0].set_ylabel('Skill Premium')
ax[0].set_xlabel('Year')
ax[0].spines['top'].set_visible(False)
ax[0].spines['right'].set_visible(False)
ax[0].legend()
ax[0].grid()
ax[1].plot(year1, spc1, marker='o',linewidth=1.5, markersize=5.5, label='College')
ax[1].plot(year1, sph1, marker='o',linewidth=1.5, markersize=5.5, c='xkcd:sky blue', label='High School')
ax[1].set_ylabel('Skill Premium')
ax[1].set_xlabel('Year')
ax[1].spines['top'].set_visible(False)
ax[1].spines['right'].set_visible(False)
ax[1].legend()
ax[1].grid()
plt.show() 

# My estimation
plt.rcParams['figure.figsize'] = (15, 4.8)
cn_sp = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/skill_premium/cn_sp/cn-sp-1986-2020.dta')
year2 = np.asarray(cn_sp['year']) # UHS
cn_sp_b = np.asarray(cn_sp['sp_b'])
cn_sp_c = np.asarray(cn_sp['sp_c'])
cn_sp_h = np.asarray(cn_sp['sp_h'])
c2 = cn_sp[['year','sp2_b']]
c2 = c2.dropna(axis=0)
year_2 = np.asarray(c2['year'])
cn_sp2_b =np.asarray(c2['sp2_b']) # CFPS
b = np.polyfit(year_2,cn_sp2_b,1)
sp2_b = np.poly1d(b)
sp2_b = sp2_b(year_2)

fig, an = plt.subplots()
an.plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, label='UHS')
an.plot(year_2, cn_sp2_b, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:tan', label='CFPS')
an.plot(year_2,sp2_b, ls='--', color='xkcd:medium blue',label='linear fit')
an.set_xlabel('year')
an.set_ylabel('Skill premium (log wage)')
an.spines['top'].set_visible(False)
an.spines['right'].set_visible(False)
an.set_title('China Skill Premium 1986-2020')
an.grid()
an.legend()
plt.show()

# my estimation and adjustment with CFPS
plt.rcParams['figure.figsize'] = (15, 4.8)
c3 = cn_sp[['year','sp2_ba','sp2_ca','sp2_ha']]
c3 = c3.dropna(axis=0)
year_3 = np.asarray(c3['year'])
sp2_ba = np.asarray(c3['sp2_ba'])
sp2_ca = np.asarray(c3['sp2_ca'])
sp2_ha = np.asarray(c3['sp2_ha'])

fig, an1 = plt.subplots()
an1.plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:azure', label='Bachelor, UHS')
an1.plot(year_3, sp2_ba, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:azure', label='Bachelor, CFPS adjusted')
an1.plot(year2, cn_sp_c, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:grass green', label='College, UHS')
an1.plot(year_3, sp2_ca, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:grass green', label='College, CFPS adjusted')
an1.plot(year2, cn_sp_h, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:tan', label='High school, UHS')
an1.plot(year_3, sp2_ha, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:tan', label='High school, CFPS adjusted')

an1.set_xlabel('year')
an1.set_ylabel('Skill premium (log wage)')
an1.spines['top'].set_visible(False)
an1.spines['right'].set_visible(False)
an1.set_title('China Skill Premium 1986-2020')
an1.grid()
an1.legend()
plt.show()

# my estimation and adjustment with CFPS, College level
plt.rcParams['figure.figsize'] = (15, 4.8)
c = np.polyfit(year_3,sp2_ca,1)
sp2_cafit = np.poly1d(c)
sp2_cafit = sp2_cafit(year_3)
fig, an2 = plt.subplots()
an2.plot(year2, cn_sp_c, marker='o',linewidth=1.5, markersize=5.5, label='College, UHS')
an2.plot(year_3, sp2_ca, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:grass green', label='College, CFPS adjusted')
an2.plot(year_3, sp2_cafit, ls='--', color='xkcd:medium blue',label='linear fit')
an2.set_xlabel('year')
an2.set_ylabel('Skill premium (log wage)')
an2.spines['top'].set_visible(False)
an2.spines['right'].set_visible(False)
an2.set_title('China Skill Premium 1986-2020')
an2.grid()
an2.legend()
plt.show()


# contrast the skill premuim of Bai's method and my estimation
cn_sp_c = np.asarray(cn_sp['sp_c'])
fig, con = plt.subplots()
con.plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, label='Bachelor')
con.plot(year2, cn_sp_c, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:avocado', label='College')
con.plot(year, spc, marker='o',linewidth=1.0, markersize=3.5,color='xkcd:sky blue', label='College, Bai')
con.spines['top'].set_visible(False)
con.spines['right'].set_visible(False)
con.set_title('China Skill Premium Contrast')
con.set_xlabel('year')
con.set_ylabel('Skill premium (log wage)')
con.grid()
con.legend()
plt.show()
# contrast the skill premuim of Zhang's method and my estimation
cn_sp_h = np.asarray(cn_sp['sp_h'])
Zhang_h = np.asarray(bai_sp['sphz'])
Zhang_c = np.asarray(bai_sp['spcz'])
fig, co = plt.subplots()
co.plot(year2, cn_sp_b, marker='o',linewidth=1.5, markersize=5.5, label='Bachelor')
co.plot(year2, cn_sp_c, marker='o',linewidth=1.5, markersize=5.5, color='xkcd:avocado', label='High School')
co.plot(year, Zhang_h, marker='o',linewidth=1.0, markersize=3.5, color='xkcd:sky blue', label='High School, Zhang')
co.set_title('China Skill Premium Contrast')
co.set_xlabel('year')
co.set_ylabel('Skill premium (log wage)')
co.spines['top'].set_visible(False)
co.spines['right'].set_visible(False)
co.grid()
co.legend()
plt.show()

'''