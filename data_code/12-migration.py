import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns

# draw CN urbanization rate
plt.rcParams['figure.figsize'] = (15, 4.8)
ur = pd.read_stata('C:/Users/Benjamin Hwang/Documents/大三_下/LijunZhu-project-2022/skill_premium_sc/data/migration/cn-urbanrate78-20.dta')

year = np.asarray(ur['year'])
urban = np.asarray(ur['urban'])

fig, an = plt.subplots()
an.plot(year, urban, marker='o',linewidth=1.5, color='xkcd:grey', markersize=4)
an.set_xlabel('year')
an.set_ylabel('urbanization rate/%')
an.spines['top'].set_visible(False)
an.spines['right'].set_visible(False)
an.grid(False)
an.set_title('Urbanization Rate in China')
plt.show()