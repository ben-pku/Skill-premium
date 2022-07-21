*******-******* skill intensity *************************
*******-*************************************************
*******- China Census 1990, 2000 Data  ******************
*******- Edited on 12, June, 2022 Zhuokai Huang***********

clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\census_skill_intensity"

use ipumsi_00002.dta,clear
replace indgen = 114 if indgen>=130 & (ind==831|ind==832|ind==839)
gen A = (indgen==10)
gen I = (indgen==20 | indgen==30 | indgen==40 | indgen==50  )
gen S = (indgen==60 | indgen==70 | indgen==80 | indgen==90 | indgen==100 | indgen==110 | indgen==111 | indgen==112 | indgen==113 | indgen==114 | indgen==120)
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
save census90_00,replace

* three industries
* 2000
use census90_00,clear
keep if year==2000
replace dayswrk=. if (dayswrk==8| dayswrk==9)
gen secondary =.
gen ba =.
gen college =.
replace secondary = (edattain==3|edattain==4)
replace ba = (edattain==4)
replace college = (edattaind>=312 & edattaind~=999)
collapse secondary college ba [fweight=dayswrk], by(ind3)
collapse secondary college ba, by(ind3)

* 1990
use census90_00,clear
keep if year==1990
gen secondary =.
gen ba =.
gen college =.
replace secondary = (edattain==3|edattain==4)
replace ba = (edattain==4)
replace college = (edattaind>=312 & edattaind~=999)
collapse secondary college ba, by(ind3)

* all sub-industries
use census90_00,clear
keep if year == 2000
replace dayswrk=. if (dayswrk==8| dayswrk==9)
gen secondary =.
gen ba =.
gen college =.
replace secondary = (edattain==3|edattain==4)
replace ba = (edattain==4)
replace college = (edattaind>=312 & edattaind~=999)
collapse secondary college ba [fweight=dayswrk], by(indgen)


*************************************************************************
************************ US Skill intensity *****************************
*************************************************************************

cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps"
use us_sp,clear
keep if year==2020
gen A = (ind1990>=10 & ind<=32)
gen I = (ind>=40 & ind<=392)
gen S = (ind>=400 & ind<=932)  // excluded Armed Forces
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
* employment share
mean ba [pweight =asecwt]
collapse college ba high [pweight=asecwt],by(ind3)

*---- above are employment share, the calculation might be wrong
*---- below is compensation
use us_sp,clear
keep if year==2020
gen A = (ind1990>=10 & ind<=32)
gen I = (ind>=40 & ind<=392)
gen S = (ind>=400 & ind<=932)  // excluded Armed Forces
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
* A
keep if A==1
egen sw = sum(asecwt)
gen ia = incwage*asecwt
egen t_wage = sum(ia) 
egen h_wage = sum(ia) if  high==1
egen c_wage = sum(ia) if college==1
egen b_wage = sum(ia) if ba == 1
gen h_share = h_wage/t_wage
gen c_share = c_wage/t_wage
gen b_share = b_wage/t_wage

* I
use us_sp,clear
keep if year==2020
gen A = (ind1990>=10 & ind<=32)
gen I = (ind>=40 & ind<=392)
gen S = (ind>=400 & ind<=932)  // excluded Armed Forces
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
keep if I==1
egen sw = sum(asecwt)
gen ia = incwage*asecwt
egen t_wage = sum(ia) 
egen h_wage = sum(ia) if  high==1
egen c_wage = sum(ia) if college==1
egen b_wage = sum(ia) if ba == 1
gen h_share = h_wage/t_wage
gen c_share = c_wage/t_wage
gen b_share = b_wage/t_wage


* S
use us_sp,clear
keep if year==2020
gen A = (ind1990>=10 & ind<=32)
gen I = (ind>=40 & ind<=392)
gen S = (ind>=400 & ind<=932)  // excluded Armed Forces
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
keep if S==1
egen sw = sum(asecwt)
gen ia = incwage*asecwt
egen t_wage = sum(ia) 
egen h_wage = sum(ia) if  high==1
egen c_wage = sum(ia) if college==1
egen b_wage = sum(ia) if ba == 1
gen h_share = h_wage/t_wage
gen c_share = c_wage/t_wage
gen b_share = b_wage/t_wage
