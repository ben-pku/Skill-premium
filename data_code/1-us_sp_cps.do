********** US skill premium ***********
********** edited on May 19th, 2022, Zhuokai Huang

*
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps"
use "cps_00008.dta" ,clear
/*set type double 
gen cpsidpc = string(cpsidp, "%25.0f")
order cpsidpc,before(cpsidp)  */
merge m:1 year using cpi99
drop if _merge == 2
drop _merge

*top-coding
replace incwage = 1.5* 99999 if (year>=1962 & year<=1975 & incwage==99999)
replace incwage = 1.5* 50000 if (year>=1976 & year<=1981 & incwage==50000)
replace incwage = 1.5* 75000 if (year>=1982 & year<=1984 & incwage==75000)
replace incwage = 1.5* 99999 if (year>=1985 & year<=1987 & incwage==99999)
replace incwage = 1.5* 199998 if (year>=1988 & year<=1995 & incwage==199998)

replace incwage=. if incwage==99999999|incwage==99999998
replace hourwage=. if hourwage==999.99


replace incwage= incwage*cpi99
*replace hourwage=hourwage*cpi99

replace wkswork1 = 7 if(wkswork2==1&wkswork1==.)
replace wkswork1 = 20 if(wkswork2==2&wkswork1==.)
replace wkswork1 = 33 if(wkswork2==3&wkswork1==.)
replace wkswork1 = 43.5 if(wkswork2==4&wkswork1==.)
replace wkswork1 = 48.5 if(wkswork2==5&wkswork1==.)
replace wkswork1 = 51 if(wkswork2==6&wkswork1==.)
gen wkwage = incwage/wkswork1
gen low =0
replace low=1 if wkwage<136/0.774

gen lw1 = log(wkwage)
gen lw2 = log(hourwage)

gen edu=.
replace edu = 0 if educ==2
replace edu = 2.5 if educ==10
replace edu = 1 if educ ==11
replace edu = 2 if educ ==12
replace edu = 3 if educ ==13
replace edu = 4 if educ ==14
replace edu = 5 if educ ==21
replace edu = 5.5 if educ ==20
replace edu = 6 if educ ==22
replace edu = 7 if educ ==31
replace edu =7.5 if educ ==30
replace edu = 8 if educ ==32
replace edu = 9 if educ ==40
replace edu = 10 if educ==50
replace edu = 11 if educ==60
replace edu = 12 if educ==70|educ==71|educ==72|educ==73
replace edu = 13 if educ==80
replace edu = 13.5 if educ==81
replace edu = 14 if educ==90|educ==91|educ==92
replace edu = 15 if educ==100
replace edu = 16 if educ==110|educ==111
replace edu = 17 if educ==121
replace edu = 18 if educ==120
replace edu = 18 if educ==122|educ==123|educ==124
replace edu = 21.5 if educ==125
gen experience = age-edu -6 
replace experience = 0 if experience<0
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen high  = (edu>=12 & edu~=.)  // no less than high school
gen college = (edu>12 & edu~=.) // no less than college school
gen ba = (edu>=16 & edu~=.)  // no less than Bachelor's degree
gen white = (race==100)
replace white= 2 if white==0
gen gender = (sex==1)*3
replace gender = 9 if gender==0
gen white_gender = white*gender
save us_sp,replace

* skill_premium -- wage
**# Bookmark #2
use us_sp,clear
/*capture program drop regussp3
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
		reghdfe lw1 skill experience experience2,absorb(sex race statefip)
		gen sp2 = _b[skill]	
	}
end
runby regussp2,by(year)

* control industry since 1968
capture program drop regussp
gen sp1 = .
program define regussp 
	if year>=1968{
		reghdfe lw1 skill experience experience2,absorb(sex race statefip ind1990)
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

capture program drop regussp6
program define regussp6
	capture{
		reghdfe lw2 skill experience experience2 edu,absorb(sex race statefip ind1990)
		gen sp6 = _b[skill]	
	}
end
runby regussp6,by(year)*/
drop if asecwt<0
gen sp1_c =.
gen sp1_b =.
gen sp1_h =.
forvalues y = 1964(1)2021{
		reghdfe lw1 high experience experience2 experience3 experience4 if(age>=25 & age<65)&(ind~=0)&low==0& year==`y' [pweight=asecwt],absorb(gender white white_gender statefip )
		replace sp1_h = _b[high] if year==`y'
		
		reghdfe lw1 college experience experience2 experience3 experience4 if(age>=25 & age<65)&(ind~=0)&low==0 & year==`y' [pweight=asecwt],absorb(gender white white_gender statefip )
		replace sp1_c = _b[college] if year==`y'
		
		reghdfe lw1 ba experience experience2 experience3 experience4 if(age>=25 & age<65)&(ind~=0)&low==0& year==`y' [pweight=asecwt],absorb(gender white white_gender statefip )
		replace sp1_b = _b[ba] if year==`y'

}


save us_sp,replace

use us_sp,clear
collapse sp*,by(year)
label variable sp1_c "skill premium (college), CPS"
label variable sp1_b "skill premium (bachelor), CPS"
label variable sp1_h "skill premium (high school), CPS"
save us_year_sp_new,replace

twoway (scatter sp1_b year) (scatter sp1_b1 year),xtitle("year") ytitle("log skill premium (log wage)") title("US skill premium-- contrast1") graphregion(color(white))
twoway (line sp1_c year) (line sp1_c1 year)
twoway (scatter sp1_c year) (scatter sp1_b year) ,xtitle("year") ytitle("log skill premium (log wage)") title("US skill premium-- contrast2") graphregion(color(white))

twoway (line sp1_b year if(year>=1964),lcolor(eltblue)) (scatter sp1_b year if(year>=1964), mcolor(ebblue ) msize(small)) ,xtitle("year") ytitle("log skill premium (log wage)") title("US skill premium") subtitle("Weekly Earning") legend(off) graphregion(color(white)) xlabel(1965(5)2020) 

twoway  (line sp1_b year if(year>=1964),lcolor(olive)) (scatter sp1_b year if(year>=1964), mcolor(olive ) msize(small)) ///
 (line sp1_c year if(year>=1964),lcolor(bluishgray)) (scatter sp1_c year if(year>=1964), mcolor(bluishgray) msize(small)) ///
 (line sp1_h year if(year>=1964),lcolor(eltblue)) (scatter sp1_h year if(year>=1964), mcolor(ebblue ) msize(small)) ,xtitle("year") ytitle("log skill premium (log wage)") title("US (high school) skill premium") subtitle("Weekly Earning")  graphregion(color(white)) xlabel(1965(5)2020) 

cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp"
use ".\cps\us_year_sp_new",clear
merge 1:1 year using ".\psid\family_panel\psid_sp2001-2019"
drop _merge
merge 1:1 year using ".\usa_census\usacensus_sp1980-2020"
label variable sp3 "skill premium, psid"
drop _merge

replace sp3=. if sp3<0.24
replace sp3=. if sp3>0.7
drop if year<=1963
save "us_sp_all",replace

twoway (line sp1 year if(year>=1964),lcolor(eltblue)) (scatter sp1 year if(year>=1964), mcolor(ebblue ) msize(small)) ///
	(line sp2 year if(year>=1964)) (scatter sp2 year if(year>=1964), msize(small)) ///
	 (line sp3 year if(year~=1996& year~=1997 & year~=1999 &year>=1964)) (scatter sp3 year if(year~=1996& year~=1997 & year~=1999 & year>=1964), msize(small)) ///
	 ,xtitle("year") ytitle("log skill premium (log wage)") title("US skill premium") subtitle("Weekly Earning") graphregion(color(white))