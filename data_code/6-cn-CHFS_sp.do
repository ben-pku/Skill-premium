********* CHFS panel 2011-2019****************
********* edited on May 1,2022 Zhuokai Huang

clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\CHFS_panel"

* 2011
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2011CHFS\CHFS数据-2011\2011年中国家庭金融调查数据dta格式-stata14以上版本\chfs2011_ind_20191120_version14",clear
merge m:1 hhid using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2011CHFS\CHFS数据-2011\2011年中国家庭金融调查数据dta格式-stata14以上版本\chfs2011_master_202203"
gen year=2011
rename a2003 sex
gen age = year-a2005
rename a2012 educ
rename a3007 experience
rename a3006 ind
rename a3011 month
rename a3020 wage 
replace wage = 2500 if(a3020it==1 & wage==.)
replace wage = 7500 if(a3020it==2 & wage==.)
replace wage = 15000 if(a3020it==3 & wage==.)
replace wage = 25000 if(a3020it==4 & wage==.)
replace wage = 40000 if(a3020it==5 & wage==.)
replace wage = 75000 if(a3020it==6 & wage==.)
replace wage = 150000 if(a3020it==7 & wage==.)
replace wage = 350000 if(a3020it==8 & wage==.)
replace wage = 750000 if(a3020it==9 & wage==.)
replace wage = 1500000 if(a3020it==10 & wage==.)
rename a2022 census
keep hhid pline year sex age educ  experience ind province month wage swgt census
save chfs2011,replace

*2013
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2013CHFS\CHFS数据-2013\2013年中国家庭金融调查数据dta格式-stata14以上版本\chfs2013_ind_20191120_version14",clear
merge m:1 hhid_2013 using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2013CHFS\CHFS数据-2013\2013年中国家庭金融调查数据dta格式-stata14以上版本\chfs2013_master_202203"
gen year = 2013
rename a2003 sex
gen age = year-a2005
rename a2012 educ
rename a3007 experience
rename a3006 ind
rename a3011 month
rename a3020 wage 
replace wage = 2500 if(a3020it==1 & wage==.)
replace wage = 7500 if(a3020it==2 & wage==.)
replace wage = 15000 if(a3020it==3 & wage==.)
replace wage = 25000 if(a3020it==4 & wage==.)
replace wage = 40000 if(a3020it==5 & wage==.)
replace wage = 75000 if(a3020it==6 & wage==.)
replace wage = 150000 if(a3020it==7 & wage==.)
replace wage = 350000 if(a3020it==8 & wage==.)
replace wage = 750000 if(a3020it==9 & wage==.)
replace wage = 1500000 if(a3020it==10 & wage==.)
rename a2022 census
keep hhid pline year sex age educ experience ind province month wage swgt census
save chfs2013,replace

*2015
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2015CHFS\CHFS数据-2015\2015年中国家庭金融调查数据dta格式-stata14以上版本\chfs2015_ind_20191120_version14",clear
merge m:1 hhid using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2015CHFS\CHFS数据-2015\2015年中国家庭金融调查数据dta格式-stata14以上版本\chfs2015_master_202203"
gen year = 2015
rename a2003 sex
gen age = year-a2005
rename a2012 educ
gen experience = year -a3005a
rename a3006a ind
rename a3011 month
rename a3020 wage 
replace wage = 5000 if(a3020it==1 & wage==.)
replace wage = 15000 if(a3020it==2 & wage==.)
replace wage = 35000 if(a3020it==3 & wage==.)
replace wage = 75000 if(a3020it==4 & wage==.)
replace wage = 150000 if(a3020it==5 & wage==.)
replace wage = 250000 if(a3020it==6 & wage==.)
replace wage = 400000 if(a3020it==7 & wage==.)
replace wage = 750000 if(a3020it==8 & wage==.)
replace wage = 1500000 if(a3020it==9 & wage==.)
replace wage = 3500000 if(a3020it==10 & wage==.)
replace wage = 7500000 if(a3020it==11 & wage==.)
rename a2022 census

keep hhid pline year sex age educ experience ind province month wage swgt census
save chfs2015,replace

*2017
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2017CHFS\CHFS数据-2017\CHFS2017年调查数据-stata14版本\chfs2017_ind_202104",clear
merge m:1 hhid pline using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2017CHFS\CHFS数据-2017\CHFS2017年调查数据-stata14版本\chfs2017_master_202104"
gen year = 2017
rename a2003 sex
gen age = year-a2005
rename a2012 educ
gen experience = year -a3105
rename a3110 ind
rename a3132 month
rename a3136 wage 
replace wage = 5000 if(a3136it==1 & wage==.)
replace wage = 15000 if(a3136it==2 & wage==.)
replace wage = 35000 if(a3136it==3 & wage==.)
replace wage = 75000 if(a3136it==4 & wage==.)
replace wage = 150000 if(a3136it==5 & wage==.)
replace wage = 250000 if(a3136it==6 & wage==.)
replace wage = 400000 if(a3136it==7 & wage==.)
replace wage = 750000 if(a3136it==8 & wage==.)
replace wage = 1500000 if(a3136it==9 & wage==.)
replace wage = 3500000 if(a3136it==10 & wage==.)
replace wage = 7500000 if(a3136it==11 & wage==.)
rename prov_code province
rename weight_ind swgt
rename a2022 census

keep hhid pline year sex age educ experience ind province month wage swgt census
save chfs2017,replace

* 2019
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2019CHFS\CHFS2019年调查数据-stata14版本\chfs2019_ind_202112",clear
merge m:1 hhid pline using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\2019CHFS\CHFS2019年调查数据-stata14版本\chfs2019_master_202112"
gen year = 2019
rename a2003 sex
gen age = year-a2005
rename a2012 educ
gen edu=.
replace edu = 0 if(educ==1)
replace edu = 6 if(educ==2)
replace edu = 9 if(educ==3)
replace edu = 12 if(educ==4)
replace edu = 12 if(educ==5)
replace edu = 15 if(educ==6)
replace edu = 16 if(educ==7)
replace edu = 18 if(educ==8)
replace edu = 22 if(educ==9)
gen experience = year -edu -6
rename a3132f ind
rename a3132 month
rename a3136 wage 
replace wage = 5000 if(a3136it==1 & wage==.)
replace wage = 15000 if(a3136it==2 & wage==.)
replace wage = 35000 if(a3136it==3 & wage==.)
replace wage = 75000 if(a3136it==4 & wage==.)
replace wage = 150000 if(a3136it==5 & wage==.)
replace wage = 250000 if(a3136it==6 & wage==.)
replace wage = 400000 if(a3136it==7 & wage==.)
replace wage = 750000 if(a3136it==8 & wage==.)
replace wage = 1500000 if(a3136it==9 & wage==.)
replace wage = 3500000 if(a3136it==10 & wage==.)
replace wage = 7500000 if(a3136it==11 & wage==.)
rename prov_code province
rename weight_ind swgt
destring province,replace
rename a2022 census
keep hhid pline year sex age educ experience ind province month wage swgt census
save chfs2019,replace

use chfs2011,clear
append using chfs2013
append using chfs2015
append using chfs2017
append using chfs2019

merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge==2
drop _merge
gen low=0
replace low=1 if wage/month < (206/12/2) & year<=2000
replace low=1 if wage/month < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/month/cpi < (2300/12/563.5/2) & year>2010

gen lw = log(wage/month)
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen sp3_c =.
gen sp3_b =.
gen sp3_h =.
gen college =(educ>=6)
gen ba = (educ>=7)
gen high = (educ>=12)

forvalues y = 2011(2)2018{
    reghdfe lw college experience experience2 experience3 experience4 if(year==`y' & ((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & (census==2|census==3) & low==0 ) [pweight= swgt], absorb(sex province)
	replace sp3_c = _b[college] if(year==`y')
	reghdfe lw ba experience experience2 experience3 experience4 if(year==`y' & ((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & (census==2|census==3) & low==0 ) [pweight= swgt], absorb(sex province)
	replace sp3_b = _b[ba] if(year==`y')
	reghdfe lw high experience experience2 experience3 experience4 if(year==`y' & ((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & (census==2|census==3) & low==0 ) [pweight= swgt], absorb(sex province)
	replace sp3_h = _b[high] if(year==`y')

}

save chfs_sp2011-2019,replace
* Due to the collinarity of data in 2019, the skill premium is not right
collapse sp3* ,by(year)

twoway (line sp3_c year) (line sp3_h year) (line sp3_b year) 
label variable sp3_c "skill premium (college), CHFS"
label variable sp3_b "skill premium (bachelor), CHFS"
label variable sp3_h "skill premium (high), CHFS"

save cn_sp_chfs2011-2019y,replace
