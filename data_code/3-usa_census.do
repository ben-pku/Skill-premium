***** US CENSUS data **************
***** robustness test for the trend of 2014-2019
***** edited May 1，2022 by Zhuokai Huang

** **** all census years
*1940--1990
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\usa_census"
use usa_00006.dta,clear
drop if year<1940
replace incwage =. if incwage==999999 | incwage==999998
gen edu = .
replace edu = 0 if educd==0|educd==1|educd==2| educd==10 | educd==11 | educd==12 
replace edu = 2.5 if  educd==13
replace edu = 1 if educd==14
replace edu = 2 if educd==15
replace edu = 3 if educd==16
replace edu = 4 if educd==17
replace edu = 6.5 if educd==20
replace edu = 5.5 if educd==21 
replace edu = 5 if educd==22 
replace edu = 6 if educd==23
replace edu = 7.5 if educd ==24
replace edu = 7 if educd ==25
replace edu = 8 if educd ==26
replace edu = 9 if educd ==30
replace edu = 10 if educd ==40
replace edu = 11 if educd ==50
replace edu = 12 if educd ==60 | educd==61|educd==62|educd==63|educ==64|educd ==65
replace edu = 13 if educd==70|educd==71
replace edu = 14 if educd==80|educd==81|educd==82|educd==83
replace edu = 15 if educd==90
replace edu = 16 if educd==100 | educd==101 
replace edu = 17 if educd==110 
replace edu = 18 if educd==111| educd==114
replace edu = 19 if educd==112  |educd==115
replace edu = 20 if educd==113
replace edu = 21.5 if educd==116
gen experience = age-edu-6
replace experience = 0 if experience<0
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen college = (edu>12)
gen bachelor = (edu>=16)
gen high = (edu>=12)
label variable edu "education years"

gen white = (race==1)
replace white= 2 if white==0
gen gender = (sex==1)*3
replace gender = 9 if gender==0
gen white_gender = white*gender

replace wkswork1 = 7 if(wkswork1==. & wkswork2==1)
replace wkswork1 = 20 if(wkswork1==. & wkswork2==2)
replace wkswork1 = 33 if(wkswork1==. & wkswork2==3)
replace wkswork1 = 43.5 if(wkswork1==. & wkswork2==4)
replace wkswork1 = 48.5 if(wkswork1==. & wkswork2==5)
replace wkswork1 = 51 if(wkswork1==. & wkswork2==6)
gen lw=log(incwage/wkswork1)
save usa1940-1990,replace


* skill premium
use usa1940-1990,clear
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps\us_pce.dta"
drop if _merge==2
drop _merge
replace lw = log(incwage/wkswork1/pce)
drop if incwage/wkswork1/pce < 136/94.35
gen sp2=.

forvalues y = 1940(10)1990{
	capture{
		reghdfe lw skill experience experience2 experience3 experience4 if(age>=25 & age<=65 & year=='y') [fweight=perwt],absorb(white white_gender pwstate2 )
		replace sp2 = _b[skill] if year==`y'
	}
	
}

save usa1940-1990,replace

collapse sp2,by(year)
keep if sp2~=.
save census_sp,replace
twoway (lpolyci sp1 year) (scatter sp1 year), graphregion(color(white)) legend(off) title("2000-2020 US Skill Premium") subtitle("US Census")

* 2000-2021
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\usa_census"
use usa_00005,clear
replace incwage =. if incwage==999999 | incwage==999998
gen edu = .
replace edu = 0 if educd==0|educd==1|educd==2| educd==10 | educd==11 | educd==12 
replace edu = 2.5 if  educd==13
replace edu = 1 if educd==14
replace edu = 2 if educd==15
replace edu = 3 if educd==16
replace edu = 4 if educd==17
replace edu = 6.5 if educd==20
replace edu = 5.5 if educd==21 
replace edu = 5 if educd==22 
replace edu = 6 if educd==23
replace edu = 7.5 if educd ==24
replace edu = 7 if educd ==25
replace edu = 8 if educd ==26
replace edu = 9 if educd ==30
replace edu = 10 if educd ==40
replace edu = 11 if educd ==50
replace edu = 12 if educd ==60 | educd==61|educd==62|educd==63|educ==64|educd ==65
replace edu = 13 if educd==70|educd==71
replace edu = 14 if educd==80|educd==81|educd==82|educd==83
replace edu = 15 if educd==90
replace edu = 16 if educd==100 | educd==101 
replace edu = 17 if educd==110 
replace edu = 18 if educd==111| educd==114
replace edu = 19 if educd==112  |educd==115
replace edu = 20 if educd==113
replace edu = 21.5 if educd==116
gen experience = age-edu-6
replace experience = 0 if experience<0
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen college = (edu>12)
gen bachelor = (edu>=16)
gen high = (edu>=12)
label variable edu "education years"
gen white = (race==1)
replace white= 2 if white==0
gen gender = (sex==1)*3
replace gender = 9 if gender==0
gen white_gender = white*gender
replace wkswork1 = 7 if(wkswork1==. & wkswork2==1)
replace wkswork1 = 20 if(wkswork1==. & wkswork2==2)
replace wkswork1 = 33 if(wkswork1==. & wkswork2==3)
replace wkswork1 = 43.5 if(wkswork1==. & wkswork2==4)
replace wkswork1 = 48.5 if(wkswork1==. & wkswork2==5)
replace wkswork1 = 51 if(wkswork1==. & wkswork2==6)
gen lw=log(incwage/wkswork1)
save usa2000-2020,replace
*---------------------------
use usa2000-2020,clear
gen college = (edu>12)
gen bachelor = (edu>=16)
gen high = (edu>=12)
save usa2000-2020,replace


************
** 目前尚未计算census的high、college水平的skill premium
use usa2000-2020,clear
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps\us_pce.dta"
drop if _merge==2
drop _merge
drop if incwage/wkswork1/pce < 136/94.35
replace lw = log(incwage/wkswork1/pce)
gen sp2=.
forvalues y = 2000(1)2020{
    	reghdfe lw skill experience experience2 experience3 experience4 if(age>=25 & age<=65 & year==`y') [fweight=perwt],absorb(white white_gender pwstate2 )
		replace sp2 = _b[skill] if year==`y'

}
save usa2000-2020,replace

collapse sp2,by(year)
*scatter sp2 year
append using census_sp
sort year
twoway (line sp year if(year>=1980),lcolor(eltblue)) (scatter sp year if(year>=1980), mcolor(ebblue ) msize(small)) ,xtitle("year") ytitle("skill premium (log wage)") title("US skill premium") subtitle("Weekly Earning") legend(off) graphregion(color(white)) xlabel(1980(5)2020) 
label variable sp2 "skill premium, census"
save usacensus_sp1980-2020,replace

