********** US skill premium***********
********** edited on April 20, 2022, Zhuokai Huang

*
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps"
use "cps_00005.dta" ,clear
/*set type double 
gen cpsidpc = string(cpsidp, "%25.0f")
order cpsidpc,before(cpsidp)  */

replace incwage=. if incwage==99999999|incwage==99999998
replace hourwage=. if hourwage==999.99
replace earnweek=. if earnweek==9999.99
gen lw1 = log(incwage)
gen lw2 = log(hourwage)
gen lw3 = log(earnweek)
gen eage = .
label variable eage "enter age"
replace eage = 12 if educ==2
replace eage = 9.5 if educ==10
replace eage = 8 if educ==11
replace eage = 9 if educ==12
replace eage = 10 if educ==13
replace eage = 11 if educ==14
replace eage = 12.5 if educ==20
replace eage = 12 if educ==21
replace eage = 13 if educ==22
replace eage = 14.5 if educ==30
replace eage = 14 if educ==31
replace eage = 15 if educ==32
replace eage = 16 if educ==40
replace eage = 17 if educ==50
replace eage = 18 if educ==60
replace eage = 19 if educ==70 |educ==72|educ==73
replace eage = 20 if educ==80 |educ==81
replace eage = 21 if educ==90 |educ==91 |educ==92
replace eage = 22 if educ==100
replace eage = 23 if educ==110|educ==111
replace eage = 24 if educ==121
replace eage = 25 if educ==122
replace eage = 26 if educ==123
replace eage = 26 if educ==124
replace eage = 27 if educ==125
replace eage = . if educ==999

gen experience = age-eage
gen experience2 = experience^2
gen skill = (eage>=19 & eage~=.)
save us_sp_old,replace

* skill_premium -- wage
use us_sp_old,clear
capture program drop regussp3
program define regussp3
	capture{
		reg lw1 skill experience experience2 
		gen sp3 = _b[skill]	
	}
end
runby regussp3,by(year)

capture program drop regussp2
program define regussp2
	capture{
		reghdfe lw1 skill experience experience2 ,absorb(sex race statefip)
		gen sp2 = _b[skill]	
	}
end
runby regussp2,by(year)

* control industry since 1968
capture program drop regussp
gen sp1 = .
program define regussp 
	if year>=1968{
		reghdfe lw1 skill experience experience2 ,absorb(sex race statefip ind1990)
		replace sp1 = _b[skill]
	}
	else{
		di "error"
	}
end
runby regussp ,by(year)

*skill premium -- hourwage

capture program drop regussp4
program define regussp4
	capture{
		reghdfe lw2 skill experience experience2 ,absorb(sex race statefip ind1990)
		gen sp4 = _b[skill]	
	}
end
runby regussp4,by(year)

capture program drop regussp5
program define regussp5
	capture{
		reghdfe lw3 skill experience experience2 ,absorb(sex race statefip ind1990)
		gen sp5 = _b[skill]	
	}
end
runby regussp5,by(year)

label variable sp1 "wageinc ctrl industry"
label variable sp2 "wageinc wlo ctrl industry"
label variable sp3 "wageinc no ctrl"
label variable sp4 "hourwage ctrl industry"
label variable sp5 "weekearn ctrl industry"
save us_sp,replace

collapse sp1 sp2 sp3 sp4 sp5 ,by(year)
twoway (line sp1 year if year>1988)(line sp2 year if year>1988) (line sp3 year if year>1988) (line sp4 year if year>1988)

twoway (lpolyci sp1 year if year>1967) (scatter sp1 year if year>1967, msize(small)) ,title("US skill premium with control of industry") legend(off) graphregion(color(white))
twoway (lpolyci sp4 year if year>1988) (scatter sp4 year if year>1988, msize(small)) ,title("US skill premium with control of industry") subtitle("hourwage") legend(off) graphregion(color(white))
twoway (lpolyci sp5 year if year>1988) (scatter sp5 year if year>1988, msize(small)) ,title("US skill premium with control of industry") subtitle("weekly earning") legend(off) graphregion(color(white))
save us_year_sp,replace
