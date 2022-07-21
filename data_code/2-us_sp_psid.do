* psid Skill Premium
* edited on 29 April, 2022 Zhuokai Huang

/* 2019
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2019,clear
gen year = 2019
rename ER72002 id 
rename ER73069 wage1
rename ER73424 wage2
rename ER72017 age1
rename ER72019 age2
rename ER72018 sex1
rename ER72020 sex2
rename ER72004 state
rename ER76964  ind1
rename ER76819  ind2
rename state state1
gen state2=state1
rename ER76897 race1
rename ER76752 race2
rename ER76916 hs1
rename ER76908 hs_s1
rename ER76924 college1
rename ER76771 hs2
rename ER76763 hs_s2
rename ER76779 college2
rename ER72180 beginy1
rename ER72182 endy1
rename ER72457 beginy2
rename ER72459 endy2

keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy*
reshape long wage age sex state ind hs hs_s college race beginy endy, i(id) j(m)
replace wage =. if wage==9999998|wage==9999999
replace age =. if age==999|age==0
/*gen experience=.
replace experience = age - (hs + 6)  if (hs~=0&hs~=99)
replace experience = age - 18 if(hs==0& (hs_s==1 |hs_s==2)  )
replace experience = age - 22 if(college==1|college==2)
replace experience = age - 24 if(college==3)
replace experience = age - 28 if(college==4|college==5|college==6|college==8)
*/
gen experience=.
replace experience = endy-beginy if (beginy>=1901&beginy<=2019 & endy>=1901&endy<=2019)
replace experience = year-beginy if (beginy>=1901&beginy<=2019 & (endy==0|endy==9999))
replace experience = 2018 - beginy if(beginy>=1901&beginy<=2019 & endy==9996)
replace experience = 2017 - beginy if(beginy>=1901&beginy<=2019 & endy==9997)
replace experience = year-2018 if (beginy==9996)
replace experience = max(year-2017, age-18) if(beginy==9997)
replace experience = age-18 if(beginy==9999|beginy==9998)

replace experience=0 if experience<0
gen experience2 = experience^2
gen skill = (college>=1 & college<=8)
gen industry = . if(ind==0|ind==9999)
replace industry = 1 if(ind>=170& ind<=290)
replace industry = 2 if (ind>=370&ind<=490)
replace industry = 3 if (ind>=570&ind<=690)
replace industry = 4 if (ind==770)
replace industry = 5 if (ind>=1070&ind<=3990)
replace industry = 6 if (ind>=4070&ind<=4590)
replace industry = 7 if (ind>=4670&ind<=5790)
replace industry = 8 if (ind>=6070&ind<=6390)
replace industry = 9 if (ind>=6470&ind<=6780)
replace industry = 10 if (ind>=6870&ind<=6990)
replace industry = 11 if (ind>=7070&ind<=7190)
replace industry = 12 if (ind>=7270&ind<=7490)
replace industry = 13 if (ind>=7570&ind<=7790)
replace industry = 14 if (ind>=7860&ind<=7890)
replace industry = 15 if (ind>=7970&ind<=8470)
replace industry = 16 if (ind>=8560&ind<=8590)
replace industry = 17 if (ind>=8660&ind<=8690)
replace industry = 18 if (ind>=8770&ind<=9290)
replace industry = 19 if (ind>=9370&ind<=9870)
replace race=. if race==9
gen lw = log(wage)
reghdfe lw skill experience experience2,absorb(sex race state industry)
*0.51
save psid_sp2019,replace  */

* 2019-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2019,clear
gen year = 2019
rename ER72002 id 
rename ER73069 wage
rename ER72017 age
rename ER72018 sex
rename ER72004 state
rename ER72998  ind
rename ER76897 race
rename ER76916 hs
rename ER76908 hs_s
rename ER76924 college
rename ER72180 beginy
rename ER72182 endy
rename ER72170 week
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week*
replace wage =. if wage==9999998|wage==9999999
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp2019,replace

/*2017
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2017,clear
gen year = 2017
rename ER66002 id 
rename ER67046 wage1
rename ER67401 wage2
rename ER66017 age1
rename ER66019 age2
rename ER66018 sex1
rename ER66020 sex2
rename ER66004 state
rename ER70946  ind1
rename ER70808  ind2
rename state state1
gen state2=state1
rename ER70882 race1
rename ER70744 race2
rename ER70901 hs1
rename ER70893 hs_s1
rename ER70909 college1
rename ER70763 hs2
rename ER70755 hs_s2
rename ER70771 college2
rename ER66180 beginy1
rename ER66182 endy1
rename ER66455 beginy2
rename ER66457 endy2

keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy*
reshape long wage age sex state ind hs hs_s college race beginy endy, i(id) j(m)
replace wage =. if wage==9999998|wage==9999999
replace age =. if age==999|age==0
/*gen experience=.
replace experience = age - (hs + 6)  if (hs~=0&hs~=99)
replace experience = age - 18 if(hs==0& (hs_s==1 |hs_s==2)  )
replace experience = age - 22 if(college==1|college==2)
replace experience = age - 24 if(college==3)
replace experience = age - 28 if(college==4|college==5|college==6|college==8)
*/
gen experience=.
replace experience = endy-beginy if (beginy>=1901&beginy<=2019 & endy>=1901&endy<=2019)
replace experience = year-beginy if (beginy>=1901&beginy<=2019 & (endy==0|endy==9999))
replace experience = 2017 - beginy if(beginy>=1901&beginy<=2019 & endy==9996)
replace experience = 2016 - beginy if(beginy>=1901&beginy<=2019 & endy==9997)
replace experience = year-2018 if (beginy==9996)
replace experience = max(year-2016, age-18) if(beginy==9997)
replace experience = age-18 if(beginy==9999|beginy==9998)

replace experience=0 if experience<0
gen experience2 = experience^2
gen skill = (college>=1 & college<=8)
gen industry = . if(ind==0|ind==9999)
replace industry = 1 if(ind>=170& ind<=290)
replace industry = 2 if (ind>=370&ind<=490)
replace industry = 3 if (ind>=570&ind<=690)
replace industry = 4 if (ind==770)
replace industry = 5 if (ind>=1070&ind<=3990)
replace industry = 6 if (ind>=4070&ind<=4590)
replace industry = 7 if (ind>=4670&ind<=5790)
replace industry = 8 if (ind>=6070&ind<=6390)
replace industry = 9 if (ind>=6470&ind<=6780)
replace industry = 10 if (ind>=6870&ind<=6990)
replace industry = 11 if (ind>=7070&ind<=7190)
replace industry = 12 if (ind>=7270&ind<=7490)
replace industry = 13 if (ind>=7570&ind<=7790)
replace industry = 14 if (ind>=7860&ind<=7890)
replace industry = 15 if (ind>=7970&ind<=8470)
replace industry = 16 if (ind>=8560&ind<=8590)
replace industry = 17 if (ind>=8660&ind<=8690)
replace industry = 18 if (ind>=8770&ind<=9290)
replace industry = 19 if (ind>=9370&ind<=9870)
replace race=. if race==9
gen lw = log(wage)
reghdfe lw skill experience experience2,absorb(sex race state industry)
*0.5376
save psid_sp2017,replace  */

*2017-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2017,clear
gen year = 2017
rename ER66002 id 
rename ER67046 wage
rename ER66017 age
rename ER66018 sex
rename ER66004 state
rename ER66975  ind
rename ER70882 race
rename ER70901 hs
rename ER70893 hs_s
rename ER70909 college
rename ER66180 beginy
rename ER66182 endy
rename ER66170 week
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week
replace wage =. if wage==9999998|wage==9999999
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp2017,replace


* 2015-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2015,clear
gen year = 2015
rename ER60002 id 
rename ER60994 wage
rename ER60017 age
rename ER60018 sex
rename ER60004 state
rename ER60923  ind
rename ER64810 race
rename ER64829 hs
rename ER64821 hs_s
rename ER64837 college
rename ER60179 beginy
rename ER60181 endy
rename ER60169 week
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week
replace wage =. if wage==9999998|wage==9999999
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp2015,replace

* 2013-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2013,clear
gen year = 2013
rename ER53002 id 
rename ER53935 wage
rename ER53017 age
rename ER53018 sex
rename ER53004 state
rename ER53864  ind
rename ER57659 race
rename ER57677 hs
rename ER57669 hs_s
rename ER57685 college
rename ER53164 beginy
rename ER53166 endy
rename ER53154 week
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week
replace wage =. if wage==9999998|wage==9999999
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp2013,replace

* 2011-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2011,clear
gen year = 2011
rename ER47302 id 
rename ER48241 wage
rename ER47317 age
rename ER47318 sex
rename ER47304 state
rename ER48170  ind
rename ER51904 race
rename ER51921 hs
rename ER51913 hs_s
rename ER51929 college
rename ER47464 beginy
rename ER47466 endy
rename ER47454 week
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week
replace wage =. if wage==9999998|wage==9999999
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp2011,replace

* 2009-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2009,clear
gen year = 2009
rename ER42002 id 
rename ER42919 wage
rename ER42017 age
rename ER42018 sex
rename ER42004 state
rename ER42848  ind
rename ER46543 race
rename ER46560 hs
rename ER46552 hs_s
rename ER46568 college
rename ER42152 beginy
rename ER42154 endy
rename ER42146 week 
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week
replace wage =. if wage==9999998|wage==9999999 
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp2009,replace

* 2007-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2007,clear
gen year = 2007
rename ER36002 id 
rename ER36928 wage
rename ER36017 age
rename ER36018 sex
rename ER36004 state
rename ER36857  ind
rename ER40565 race
rename ER40582 hs
rename ER40574 hs_s
rename ER40590 college
rename ER36117 beginy
rename ER36119 endy
rename ER36349 week
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp2007,replace

* 2005-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2005,clear
gen year = 2005
rename ER25002 id 
rename ER25910 wage
rename ER25017 age
rename ER25018 sex
rename ER25004 state
rename ER25839  ind
rename ER27393 race
rename ER27410 hs
rename ER27402 hs_s
rename ER27418 college
rename ER25112 beginy
rename ER25114 endy
rename ER25344 week
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace week = . if(week<1|week>52)
replace race=. if race==9
save psid_sp2005,replace

* 2003-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2003,clear
gen year = 2003
rename ER21002 id 
rename ER21929 wage
rename ER21017 age
rename ER21018 sex
rename ER21004 state
rename ER21858  ind
rename ER23426 race
rename ER23443 hs
rename ER23435 hs_s
rename ER23451 college
rename ER21130 beginy
rename ER21132 endy
rename ER21355 week
keep year id wage* age* sex* state* ind* hs* college* race* beginy* endy* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp2003,replace

* 2001-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam2001,clear
gen year = 2001
rename ER17002 id 
rename ER18561 wage
rename ER17013 age
rename ER17014 sex
rename ER17005 state
rename ER18490  ind
rename ER19989 race
rename ER20006 hs
rename ER19998 hs_s
rename ER20014 college
rename ER17673 week
keep year id wage* age* sex* state* ind* hs* college* race* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)

save psid_sp2001,replace

* 1999-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam1999,clear
gen year = 1999
rename ER13002 id 
rename ER14416 wage
rename ER13010 age
rename ER13011 sex
rename ER13005 state
rename ER14350  ind
rename ER15928 race
rename ER15945 hs
rename ER15937 hs_s
rename ER15953 college
rename ER13615 week
keep year id wage* age* sex* state* ind* hs* college* race* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)

save psid_sp1999,replace

* 1997-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam1997,clear
gen year = 1997
rename ER10002 id 
rename ER11150 wage
rename ER10009 age
rename ER10010 sex
rename ER10004  state
rename ER12147  ind
rename ER11848 race
rename ER11862 hs
rename ER11854  hs_s
rename ER11870 college
rename ER10470 week
keep year id wage* age* sex* state* ind* hs* college* race* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp1997,replace

* 1996-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam1996,clear
gen year = 1996
rename ER7002 id 
rename ER8256 wage
rename ER7006 age
rename ER7007  sex
rename ER9248  state
rename ER9170  ind
rename ER9060 race
rename ER9072 hs
rename ER9064  hs_s
rename ER9080 college
rename ER7564 week
keep year id wage* age* sex* state* ind* hs* college* race* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp1996,replace


* 1995-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam1995,clear
gen year = 1995
rename ER5002 id 
rename ER6139 wage
rename ER5006 age
rename ER5007  sex
rename ER6997  state
rename ER6919  ind
rename ER6814 race
rename ER6826 hs
rename ER6818  hs_s
rename ER6834 college
rename ER5468 week 
keep year id wage* age* sex* state* ind* hs* college* race* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)
save psid_sp1995,replace

* 1994-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam1994,clear
gen year = 1994
rename ER2002 id 
rename ER3139 wage
rename ER2007 age
rename ER2008  sex
rename ER4157  state
rename ER4079  ind
rename ER3944 race
rename ER3956 hs
rename ER3948  hs_s
rename ER3964 college
rename ER2469 week
keep year id wage* age* sex* state* ind* hs* college* race* week
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
replace race=. if race==9
replace week = . if(week<1|week>52)

save psid_sp1994,replace


** panel
use psid_sp1994,clear
forvalues y = 1995(1)1997{
	append using psid_sp`y'
}
forvalues y = 1999(2)2019{
	append using psid_sp`y'
}
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps\us_pce.dta"
drop if _merge==2
drop _merge
replace wage = wage/pce

gen edu = .
label variable edu "education years"
replace edu= 1 if(hs==1)
replace edu= 2 if(hs==2)
replace edu= 3 if(hs==3)
replace edu= 4 if(hs==4)
replace edu= 5 if(hs==5)
replace edu= 6 if(hs==6)
replace edu= 7 if(hs==7)
replace edu= 8 if(hs==8)
replace edu= 9 if(hs==9)
replace edu= 10 if(hs==10)
replace edu= 11 if(hs==11)
replace edu= 12 if(hs_s==1|hs_s==2|hs_s==4)
replace edu= 14 if(college==1)
replace edu= 16 if(college==2|college==6)
replace edu= 18 if(college==3)
replace edu= 21.5 if(college==4|college==8)
replace edu= 15.5 if(college==5)

gen experience = age - edu - 6
replace experience=0 if experience<0
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4

gen white = (race==1)
replace white= 2 if white==0
gen gender = (sex==1)*3
replace gender = 9 if gender==0
gen white_gender = white*gender

drop if wage/week<136/94.35

gen lw = log(wage/week)
gen skill = (edu>=14)
capture program drop sp
program define sp
	capture{
		reghdfe lw skill experience experience2 experience3  experience4 if(age>=25 & age<65), absorb(white gender white_gender state )
		gen sp3 = _b[skill]
		
	}
end
runby sp,by(year)
save psid_sp1994-2019,replace

use psid_sp1994-2019,clear
collapse sp3 ,by(year)
twoway (line sp3 year if(year>2000)) (scatter sp3 year if(year>2000)),title("US Skill Premium")  subtitle("PSID") graphregion(color(white)) legend(off)
save psid_sp2001-2019,replace


/* 1993-2
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\psid\family_panel"
use fam1993,clear
gen year = 1993
rename ER2002 id 
rename ER3139 wage
rename ER2007 age
rename ER2008  sex
rename ER4157  state
rename ER4079  ind
rename ER3944 race
rename ER3956 hs
rename ER3948  hs_s
rename ER3964 college
keep year id wage* age* sex* state* ind* hs* college* race* 
replace wage =. if wage==9999998|wage==9999999|wage<0
replace age =. if age==999|age==0
gen experience=.
gen experience2 = experience^2
gen skill = (college>=1 & college<=8)
replace race=. if race==9
gen lw = log(wage)
save psid_sp1993,replace  */
