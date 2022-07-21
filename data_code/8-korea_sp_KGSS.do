************ KGSS ********************

* edited 6th May, 2022  Zhuokai Huang

use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\Korea_sp\KGSS\kgss2003-2018.dta" ,clear

gen wage = .
replace wage=0 if RINCOME==0
replace wage=250000 if RINCOME==1
replace wage=745000 if RINCOME==2
replace wage=1245000 if RINCOME==3
replace wage=1745000 if RINCOME==4
replace wage=2245000 if RINCOME==5
replace wage=2745000 if RINCOME==6
replace wage=3245000 if RINCOME==7
replace wage=3745000 if RINCOME==8
replace wage=4245000 if RINCOME==9
replace wage=4745000 if RINCOME==10
replace wage=5245000 if RINCOME==11
replace wage=5745000 if RINCOME==12
replace wage=6245000 if RINCOME==13
replace wage=6745000 if RINCOME==14
replace wage=7245000 if RINCOME==15
replace wage=7745000 if RINCOME==16
replace wage=8245000 if RINCOME==17
replace wage=8745000 if RINCOME==18
replace wage=9245000 if RINCOME==19
replace wage=9745000 if RINCOME==20
replace wage=1.5e7 if RINCOME==21

gen edu=.
replace edu=0 if EDUC==0
replace edu=6 if EDUC==1
replace edu=9 if EDUC==2
replace edu=12 if EDUC==3
replace edu=14.5 if EDUC==4
replace edu=16 if EDUC==5
replace edu=18 if EDUC==6
replace edu=21.5 if EDUC==7
gen experience = AGE-edu-6
replace experience=0 if experience<0
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4

gen college =(edu>12)
gen ba = (edu>=16)
gen lw = log(wage) 
gen sp_b=.
gen sp_c=.

forvalues y = 2003(1)2018{
	if `y'~=2015 & `y'~=2017{
		reghdfe lw ba experience experience2 experience3 experience4 if (YEAR==`y') [pw=FINALWT], absorb(REGION SEX)
		replace sp_b=_b[ba] if YEAR==`y'
		reghdfe lw college experience experience2 experience3 experience4 if (YEAR==`y') [pw=FINALWT], absorb(REGION SEX)
		replace sp_c=_b[college] if YEAR==`y'				
	}
	else{
		continue
	}
}

collapse sp* wage ,by(YEAR)
save KGSS2003-2018sp,replace
twoway (scatter sp_b YEAR) (lfit sp_b YEAR), graphregion(color(white)) title("South Korea Skill Premium") xtitle("year") ytitle("skill premium (log wage)") legend(off)


