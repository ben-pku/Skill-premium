******* Germany skill premium***********

***edited  May 5th, 2022 Zhuokai Huang
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\allbus_panel"
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\ZA5272_2018\ZA5272_v1-0-0_patched",clear
* 2018
gen year=2018
rename di01a wage
rename S01 edu
keep year wage educ edu age sex land
save g2018,replace

* 2016 
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\ZA5252_2016\ZA5252_v1-0-0_patched",clear
gen year =2016
rename di01a wage
rename S01 edu
keep year wage educ edu age sex land
save g2016,replace

* 2014
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\ZA5242_2014\ZA5242_v1-1-0_patched",clear
gen year =2014
rename V417 wage
rename V86 educ
rename V711 edu
rename V84 age
rename V81 sex
rename V868 land
keep year wage educ edu age sex land
save g2014,replace

* 2012
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\ZA4616_2012\ZA4616_v1-0-0", clear
gen year = 2012
rename v344 wage
rename v230 educ
rename v612 edu
rename v724 age
rename v217 sex
rename v749 land 
keep year wage educ edu age sex land
save g2012,replace

* 2010
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\ZA4612_2010\ZA4612_v1-0-1", clear
gen year = 2010
rename v614 wage
rename v327 educ
rename v917 edu
rename v301 age
rename v298 sex
rename v975 land 
keep year wage educ edu age sex land
save g2010,replace

*2008
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\ZA4602_2008\ZA4602_v1-0-1",clear
gen year = 2008
rename V388 wage
rename V173 educ
*edu
rename V154 age
rename V151 sex
rename V798 land 
keep year wage educ  age sex land
save g2008,replace

* 2006
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\2006\ZA4502_v1-0-0.dta", clear
gen year =2006
rename v381 wage
rename v175 educ
*edu
rename v27 age
rename v174 sex
rename v742 land 
keep year wage educ  age sex land
save g2006,replace

*2004
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\2004\ZA3764_v1-0-0", clear
gen year = 2004
rename v475 wage
rename v60 educ
*edu
rename v58 age
rename v55 sex
rename v893 land 
keep year wage educ  age sex land
save g2004,replace

*2002
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\2002\ZA3702_v1-0-0_patched", clear
gen year = 2002
rename v361 wage
rename v187 educ
*edu
rename v185 age
rename v182 sex
rename v721 land 
keep year wage educ  age sex land
save g2002,replace


*2000
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\2000\ZA3755_v1-0-0_patched", clear
gen year = 2000
rename v486 wage
rename v221 educ
*edu
rename v219 age
rename v216 sex
rename v839 land 
keep year wage educ  age sex land
save g2000,replace

* 1998
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\1998\ZA3753_v1-0-0_patched", clear
gen year = 1998
rename v320 wage
rename v195 educ
*edu
rename v308 age
rename v194 sex
rename v458 land 
keep year wage educ  age sex land
save g1998,replace

* 1996
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\1996\ZA3751_v1-0-0_patched",clear
gen year = 1996
rename v417 wage
rename v142 educ
*edu
rename v37 age
rename v141 sex
rename v353 land 
keep year wage educ  age sex land
save g1996,replace

*1994
**# Bookmark #1
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\1994\ZA2400_v2-0-0_patched",clear


******* skill premium*********** 
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Germany_sp\allbus\allbus_panel"
use g1996,clear
forvalues y = 1998(2)2018{
	append using g`y'
}
replace edu = 8.5 if educ==2 & edu==.
replace edu = 10 if educ==3 & edu==.
replace edu = 14 if educ==4 & edu==.
replace edu = 16 if educ==5 & edu==.
gen experience = age - edu -6
replace experience=0 if experience<0
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4

gen ba = (educ==5)
gen college = (educ==5 |educ==4)
replace wage=. if wage==99997 | wage==99999

gen lw = log(wage)

gen sp_b = .
gen sp_c = .
forvalues y = 1996(2)2018{
	reghdfe lw ba experience experience2 experience3 experience4 if( year==`y'), absorb(sex land)
	replace sp_b=_b[ba] if year==`y'
	reghdfe lw college experience experience2 experience3 experience4 if( year==`y'), absorb(sex land)
	replace sp_c=_b[college] if year==`y'
}
save g1996-2018,replace
collapse sp* , by(year)
label variable sp_b "Germany skill premium (bachelor), ALLBUS"
label variable sp_c "Germany skill premium (college), ALLBUS"

twoway (line sp_b year) (line sp_c year) , graphregion(color(white))  title("Germany Skill Premium") xtitle("year") ytitle("Skill premium (log wage)")
save g1996-2018_sp,replace