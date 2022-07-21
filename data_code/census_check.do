cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\usa_census"
use usa_00002.dta,clear



***** US Census Data
***** edited 26/4,2022 Zhuokai Huang
replace incwage =. if incwage==999999 | incwage==999998
gen lw = log(incwage)
gen eage = .
replace eage = 12 if educd==2 | educd==10 | educd==11 | educd==12 |educd==13|educd==14|educd==15|educd==16|educd==17|educd==20|educd==21 |educd ==22 |educd==23
replace eage = 13.5 if educd ==24
replace eage = 13 if educd ==25
replace eage = 14 if educd ==26
replace eage = 15 if educd ==30
replace eage = 16 if educd ==40
replace eage = 17 if educd ==50
replace eage = 18 if educd ==60 | educd==61|educd==62|educd==63|educ==64|educd ==65
replace eage = 19 if educd==70|educd==71
replace eage = 20 if educd==80|educd==81|educd==82|educd==83
replace eage = 21 if educd==90
replace eage = 22 if educd==100 | educd==101 
replace eage = 23 if educd==110 
replace eage = 24 if educd==111
replace eage = 25 if educd==112 | educd==114 |educd==115
replace eage = 26 if educd==113
replace eage = 29 if educd==116
gen experience = age-eage
replace experience = 0 if experience<0
gen experience2 = experience^2
gen skill = (eage>=18 & eage~=.)
/*
gen edu = eage-6
label variable edu "education years"
*/

* skill premium

capture program drop census
program define census
	capture{
		reghdfe lw skill experience experience2 [fweight=perwt],absorb(sex race pwstate2 ind)
		gen sp1 = _b[skill]
		*reghdfe lw skill experience experience2 edu,absorb(sex race pwstate2 ind)
		*gen sp2 = _b[skill]
	}
end
runby census, by(year)
collapse sp1,by(year)
scatter sp1 year
