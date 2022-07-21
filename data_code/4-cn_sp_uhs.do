*****UHS
***edited May 8, 2022 Zhuokai Huang


*1986  0.0697804
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\16省86-09年\城调队数据16个省86年-01年\城调队数据16个省86年-99年"
use "fh86.dta" ,clear
rename x3 sex
replace sex =. if sex~=1 & sex~=2
rename x5 educ
label variable educ "1-university 2-college 3-highschool 4-middle 5-primary 6-illiteracy"
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=3)
rename x4 age
label variable age "age"
rename x9 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
rename x10 monthwage
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x6 ind
replace ind=. if ind==0|ind>15
keep code year college ba high experience sex prov wage age work_be educ ind 
gen exclude = (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1986.dta",replace

*1987  0.1053916
use "fh87.dta" ,clear
rename x3 sex
replace sex =. if sex~=1 & sex~=2
rename x5 educ
label variable educ "1-university 2-college 3-highschool 4-middle 5-primary 6-illiteracy"
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=3)
rename x4 age
label variable age "age"
rename x9 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
rename x10 monthwage
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x6 ind
replace ind=. if ind==0|ind>15
keep code year college ba high experience sex prov wage age work_be educ ind
gen exclude = (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1987",replace

*1988  0.0788514
use "fh88.dta" ,clear
rename x4 sex
replace sex =. if sex~=1 & sex~=2
rename x6 educ
label variable educ "1-university 2-college 3-highschool 4-middle 5-primary 6-illiteracy"
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=3)
rename x5 age
label variable age "age"
rename x10 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x7 ind
replace ind=. if ind==0|ind>15
keep code year college ba high experience sex prov wage age work_be educ ind
gen exclude = (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1988",replace

*1989 0.095094
use "fh89.dta" ,clear
rename x4 sex
replace sex =. if sex~=1 & sex~=2
rename x6 educ
label variable educ "1-university 2-college 3-highschool 4-middle 5-primary 6-illiteracy"
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=3)
rename x5 age
label variable age "age"
rename x10 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x7 ind
replace ind=. if ind==0|ind>15
keep code year college ba high experience sex prov wage age work_be educ ind
gen experience2 = experience^2
gen lw = log(wage)
gen exclude = (ind==1)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1989",replace

*1990 0.1275928
use "fh90.dta" ,clear
rename x4 sex
replace sex =. if sex~=1 & sex~=2
rename x6 educ
label variable educ "1-university 2-college 3-highschool 4-middle 5-primary 6-illiteracy"
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=3)
rename x5 age
label variable age "age"
rename x10 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x7 ind
replace ind=. if ind==0|ind>15
keep code year college ba  high experience sex prov wage age work_be educ ind
gen experience2 = experience^2
gen lw = log(wage)
gen exclude = (ind==1)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1990",replace

*1991
use "fh91.dta" ,clear
rename x4 sex
replace sex =. if sex~=1 & sex~=2
rename x6 educ
label variable educ "1-university 2-college 3-highschool 4-middle 5-primary 6-illiteracy"
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=3)
rename x5 age
label variable age "age"
rename x10 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x7 ind
replace ind=. if ind==0|ind>15
keep code year college ba high experience sex prov wage age work_be educ ind
gen experience2 = experience^2
gen lw = log(wage)
gen exclude = (ind==1)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1991", replace

*1992    .1721257 
use "fh92.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=3)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>13
gen exclude = (x9>=8 & x9<=15)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
replace exclude =1 if (ind==1)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1992", replace

*1993   .1977026 
use "fh93.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>13
gen exclude = (x9>=8 & x9<=15)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1993", replace

*1994    .236402 
use "fh94.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>13
gen exclude = (x9>=8 & x9<=15)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1994", replace

* 1995    .208693  
use "fh95.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>13
gen exclude = (x9>=8 & x9<=15)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1995", replace

* 1996    .2138245 
use "fh96.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x12+x22+x24+x25)/12
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>13
gen exclude = (x9>=8 & x9<=15)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1996", replace

cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\16省86-09年\城调队数据16个省86年-01年\城调队数据16个省86年-99年"
* 1997    .2290393
use "fh97.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x13+x22)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>16
gen exclude = ((x9>=8 & x9<=15)|x9==6)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1997",replace

 
* 1998   .2625087 
use "fh98.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x13+x22)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>16
gen exclude = ((x9>=8 & x9<=15)|x9==6)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1998",replace

* 1999   .3092714
use "fh99.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x13+x22)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>16
gen exclude = ((x9>=8 & x9<=15)|x9==6)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp1999",replace

* 2000    .3377981 
	use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\16省86-09年\城调队数据16个省86年-01年\城调队数据16个省86年-99年\fh00.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x13+x22)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>16
gen exclude = ((x9>=8 & x9<=15)|x9==6)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2000",replace

*2001   .3233729
	use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\16省86-09年\城调队数据16个省86年-01年\城调队数据16个省86年-99年\fh01.dta" ,clear
rename x5 sex
replace sex =. if sex~=1 & sex~=2
rename x7 educ
label variable educ "1-university 2-college 3-junior college 4-highschool 5-middle 6-primary 7-illiteracy" 
replace educ=. if (educ>6 | educ<1)
gen college = (educ<=2)
gen ba = (educ==1)
gen high = (edu<=4)
rename x6 age
label variable age "age"
rename x11 work_be
replace work_be=. if work_be==0 
gen experience = year-work_be
gen monthwage = (x13+x22)/12
label variable monthwage "monthly wage"
gen wage = monthwage
replace wage=. if wage==0
rename x8 ind
replace ind=. if ind==0|ind>16
gen exclude = ((x9>=8 & x9<=15)|x9==6)
keep code year college ba high experience sex prov wage age work_be educ ind exclude
replace exclude =1 if (ind==1)
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2001",replace

*2002   .5858323
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\16省86-09年\城调队数据16个省02年-09年"
use "2002p.dta",clear
drop if a1==99
rename a6 sex
replace sex =. if sex~=1 & sex~=2
rename a8 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate" 
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename a7 age
label variable age "age"
rename a10 experience
label variable experience "工龄" 
*gen experience = year-work_be
gen work_be = year - experience
rename a151 yearwage
label variable yearwage "yearly wage"
gen wage = yearwage/12
replace wage=. if wage==0
rename a13 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2002", replace

*2003    .6186516
use "2003p.dta",clear
drop if a1==99
rename a6 sex
replace sex =. if sex~=1 & sex~=2
rename a8 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate" 
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename a7 age
label variable age "age"
rename a10 experience
label variable experience "工龄" 
*gen experience = year-work_be
gen work_be = year - experience
rename a151 yearwage
label variable yearwage "yearly wage"
gen wage = yearwage/12
replace wage=. if wage==0
rename a13 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2003", replace

*2004   .6090465 
use "2004p.dta",clear
drop if a1==99
rename a6 sex
replace sex =. if sex~=1 & sex~=2
rename a8 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate" 
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename a7 age
label variable age "age"
rename a10 experience
label variable experience "工龄" 
*gen experience = year-work_be
gen work_be = year - experience
rename a151 yearwage
label variable yearwage "yearly wage"
gen wage = yearwage/12
replace wage=. if wage==0
rename a13 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2004", replace

*2005   .6568795
use "2005p.dta",clear
drop if a1==99
rename a6 sex
replace sex =. if sex~=1 & sex~=2
rename a8 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate" 
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename a7 age
label variable age "age"
rename a10 experience
label variable experience "工龄" 
*gen experience = year-work_be
gen work_be = year - experience
rename a151 yearwage
label variable yearwage "yearly wage"
gen wage = yearwage/12
replace wage=. if wage==0
rename a13 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2005", replace

*2006   .6366817
use "2006p.dta",clear
drop if a1==99
rename a6 sex
replace sex =. if sex~=1 & sex~=2
rename a8 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate" 
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename a7 age
label variable age "age"
rename a10 experience
label variable experience "工龄" 
*gen experience = year-work_be
gen work_be = year - experience
rename a151 yearwage
label variable yearwage "yearly wage"
gen wage = yearwage/12
replace wage=. if wage==0
rename a13 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2006", replace

*2007   .5614887
use "2007p.dta",clear
drop if a1==99
rename a6 sex
replace sex =. if sex~=1 & sex~=2
rename a8 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate" 
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename a7 birth
label variable birth "出生年月"
gen age = year-(birth-mod(birth,100))/100
rename a10 work_be
label variable work_be "开始工作年份" 
gen experience = year-work_be
rename a151 yearwage
label variable yearwage "yearly wage"
gen wage = yearwage/12
replace wage=. if wage==0
rename a13 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2007", replace

*2008  .5860492 
use "2008p.dta",clear
drop if a1==99
rename a6 sex
replace sex =. if sex~=1 & sex~=2
rename a8 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate" 
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename a7 birth
label variable birth "出生年月"
gen age = year-(birth-mod(birth,100))/100
rename a10 work_be
label variable work_be "开始工作年份" 
gen experience = year-work_be
rename a151 yearwage
label variable yearwage "yearly wage"
gen wage = yearwage/12
replace wage=. if wage==0
rename a13 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2008", replace

*2009   .5587336
use "2009p.dta",clear
drop if a1==99
rename a6 sex
replace sex =. if sex~=1 & sex~=2
rename a8 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate" 
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename a7 birth
label variable birth "出生年月"
gen age = year-(birth-mod(birth,100))/100
rename a10 work_be
label variable work_be "开始工作年份" 
gen experience = year-work_be
rename a151 yearwage
label variable yearwage "yearly wage"
gen wage = yearwage/12
replace wage=. if wage==0
rename a13 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2009", replace

*2010-2012  辽宁 上海 广东 四川   .5459442   .5572857   .5103041  
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\城调队家庭成员收支情况表10-12补充\f1\f1.dta",clear
drop if 家庭成员代号==99
rename 年份 year
rename 户编码 hcode
destring hcode,force replace
drop if year==.
rename 性别 sex
replace sex =. if sex~=1 & sex~=2
rename 文化程度 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate"
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename 出生年月 birth
gen age = year-(birth-mod(birth,100))/100
rename 开始参加工作 work_be
label variable work_be "开始工作年份" 
gen experience = year-work_be
rename 工资性收入 monthwage
gen wage = monthwage
replace wage=. if wage==0
destring prov , replace
rename 行业 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (就业情况==6 |(就业情况>=8 & 就业情况<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2010-2012.dta",replace

*2013-2014  辽宁 上海 广东 四川   .5211559   .520993 
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\上海广东辽宁四川13、14\4prov13_14.dta",clear
drop if 家庭成员代号==99
rename 年份 year
rename 户编码 hcode
destring hcode,force replace
rename 性别 sex
replace sex =. if sex~=1 & sex~=2
rename 文化程度 educ
label variable educ "1-未上学 2-扫盲班 3-primary 4-middle 5-highschool 6-junior college 7-college 8-undergraduate 9-graduate"
replace educ=. if (educ>9 | educ<1)
gen college = (educ>=7)  
gen ba = (educ>=8)
gen high = (edu>=5)
rename 出生年月 birth
gen age = year-(birth-mod(birth,100))/100
rename 开始参加工作 work_be
label variable work_be "开始工作年份" 
gen experience = year-work_be
rename 工资性收入 monthwage
gen wage = monthwage
replace wage=. if wage==0
destring prov , replace
rename 行业 ind
replace ind=. if ind==0
gen exclude =(ind==1 | (就业情况==6 |(就业情况>=8 & 就业情况<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen experience2 = experience^2
gen lw = log(wage)
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\sp2013-2014.dta",replace

*** 1986 - 2014 panel
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel"
use sp1986,clear
forvalues y = 1987(1)2009{
	append using sp`y'
}
append using sp2010-2012.dta
append using sp2013-2014.dta
append using sxzj05-09.dta
save cn_sp_uhs1986-2014.dta,replace

* adjust the top income




cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel"
use cn_sp_uhs1986-2014.dta,clear
replace experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge==2
drop _merge
gen low = 0
replace low=1 if wage < (206/12/2) & year<=2000
replace low=1 if wage < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/cpi < (2300/12/563.5/2) & year>2010
label define prov 11 "北京" 14 "山西" 21 "辽宁" 23 "黑龙江" 31 "上海" 32 "江苏" 33 "浙江" 34 "安徽" 36 "江西" 37 "山东" 41 "河南" 42 "湖北" 44 "广东" 50 "重庆" 51 "四川" 53 "云南" 61 "陕西" 62 "甘肃",modify
label values prov prov
***
gen sph = .
gen spc = .

forvalues y=1986(1)2014{
    * 白重恩
	reghdfe lw high experience experience2 if( ((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & year==`y' & low==0 & exclude==0), absorb(sex prov)
	replace sph = _b[high] if year==`y'
	reghdfe lw college experience experience2 if( ((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & year==`y' & low==0 & exclude==0 ), absorb(sex prov)
	replace spc = _b[college] if year==`y'

}
*** 张俊森计算方法的尝试-- 得不到他的结果
gen sphz = .
gen spcz=.


forvalues y=1986(1)2014{
	reghdfe lw high experience experience2  if(((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) &year==`y' & low==0 & exclude==0), absorb(sex) 
	replace sphz = _b[high] if year==`y'
	reghdfe lw college experience experience2 if(((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) &year==`y' & low==0 & exclude==0), absorb(sex)
	replace spcz = _b[college] if year==`y'
	/*reghdfe lw ba experience experience2 experience3 experience4 if(((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) &year==`y'), absorb(sex)
	replace spb = _b[ba] if year==`y'	*/	
}

collapse sp* ,by(year)
twoway (line sph year)(scatter sph year) (line spc year )(scatter spc year)
keep year sp*
save BaiJDE-ZhangJIE,replace


collapse sp* ,by(year)
twoway (line sph year if year<=2008) (line spc year if year<=2008)
	/* Junsen Zhang
	reghdfe lw high experience experience2 if(((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) &year==`y'),absorb(sex)
	replace spzh = _b[high] if year==`y'
	reghdfe lw college experience experience2 if(((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) &year==`y'),absorb(sex)
	replace spzc = _b[college] if year==`y'
	reghdfe lw ba experience experience2 if(((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & year==`y'),absorb(sex)
	replace spzb = _b[ba] if year==`y' */
	

***
***** My calculate method *****

cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel"
use cn_sp_uhs1986-2014.dta,clear
replace experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge==2
drop _merge
gen low = 0
replace low=1 if wage < (206/12/2) & year<=2000
replace low=1 if wage < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/cpi < (2300/12/563.5/2) & year>2010
label define prov 11 "北京" 14 "山西" 21 "辽宁" 23 "黑龙江" 31 "上海" 32 "江苏" 33 "浙江" 34 "安徽" 36 "江西" 37 "山东" 41 "河南" 42 "湖北" 44 "广东" 50 "重庆" 51 "四川" 53 "云南" 61 "陕西" 62 "甘肃",modify
label values prov prov

capture program drop yearsp
program define yearsp
	capture{
		reghdfe lw high experience experience2 experience3 experience4 if( ((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & low==0 & exclude==0 ), absorb(prov sex)
		gen sp_h =  _b[high]	
		reghdfe lw college experience experience2 experience3 experience4 if(((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & low==0 & exclude==0), absorb(prov sex)
		gen sp_c =  _b[college]
		reghdfe lw ba experience experience2 experience3 experience4 if( ((age>=16&age<=55& sex==2)|(age>=16&age<=60& sex==1)) & low==0 & exclude==0 ), absorb(prov sex)
		gen sp_b =  _b[ba]	
	}

end
runby yearsp, by(year)
collapse sp*, by(year)
label variable sp_c "skill premium (college), UHS"
label variable sp_b "skill premium (bachelor), UHS"
label variable sp_h "skill premium (high), UHS"
save cn_sp_uhs1986-2014year.dta,replace
*(lpoly sp_c year)(scatter sp_c year,msize(small))  (lpoly sp_b year)(scatter sp_b year,msize(small))
twoway (line sp_b year)(scatter sp_b year,msize(small)) ///
	(line sp_h year)(scatter sp_h year,msize(small)) ///
	 ///
	, ///
	 title("Skill Premium in China")  graphregion(color(white))
twoway (lpoly sp_b year)(scatter sp_b year,msize(small)), title("Skill Premium in China") legend(off) graphregion(color(white))

****** merge UHS, CFPS, CHFS to obtain the estimate of skill premium in China ******
use "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel\cn_sp_uhs1986-2014year.dta",clear
merge 1:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS\sp2010-2020"
drop _merge
merge 1:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CHFS\CHFS_panel\cn_sp_chfs2011-2019y"
sort year
twoway (line sp_b year) (line sp2_ba year)  (line sp_h year) (line sp2_ha year)  (line sp_c year) (line sp2_ca year) 
twoway (scatter sp_h year) (scatter sp2_ha year) (scatter sp3_h year)
twoway (scatter sp_c year) (scatter sp2_ca year) (scatter sp3_c year)
twoway (scatter sp_b year if year<2010) (scatter sp2_b year)
replace sp_c =. if year>=2010
replace sp_b =. if year>=2010
replace sp_h =. if year>=2010
gen sp2_ha = 0.45247877/0.2867347 * sp2_h if (sp_h==.)
gen sp2_ca = 0.52072233/0.43472543 * sp2_c if(sp_c==.)
gen sp2_ba = 0.54469675/0.4901799 * sp2_b if(sp_b==.)

save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn-sp-1986-2020.dta",replace

****** skill is defined as higher than college-- skill premium
****** double check data

