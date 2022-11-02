****** CFPS 2010-2020*********
****** edited on 18 May，2020 Zhuokai Huang
clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS"

*2020
use cfps2020person_202112,clear
keep age gender provcd20 urban20 income cfps2020edu cfps2020eduy 
gen year=2020
rename provcd20 prov
replace prov=. if prov<0
rename urban20 urban
replace urban=. if urban<0
rename income wage
replace wage=. if wage<0
rename cfps2020edu educ
replace educ=. if educ<=0
rename cfps2020eduy edu
replace edu=. if edu<=0
replace edu=0 if edu==. & educ==1
replace edu=6 if edu==. &educ==2
replace edu=9 if edu==. &educ==3
replace edu=12 if edu==. &educ==4
replace edu=14.5 if edu==. &educ==5
replace edu=16 if edu==. &educ==6
replace edu=18 if edu==. &educ==7
replace edu=22 if edu==. &educ==8
label variable edu "教育年限"
gen experience =age-edu-6
replace experience = 0 if experience<0
gen college = (edu>12 & edu~=.)
gen ba = (edu>=16 & edu~=.)
gen high = (edu>=12 & edu~=.)
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen lw = log(wage)
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge~=3
drop _merge
gen low = 0
replace low=1 if wage < (206/12/2) & year<=2000
replace low=1 if wage < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/cpi < (2300/12/563.5/2) & year>2010
reghdfe lw college experience experience2 experience3 experience4 if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) ,absorb(prov gender)
gen sp2_c = _b[college]
reghdfe lw ba experience experience2 experience3 experience4  if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0), absorb(prov gender) 
gen sp2_b = _b[ba]
reghdfe lw high experience experience2 experience3 experience4  if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) , absorb(prov gender) 
gen sp2_h = _b[high]

save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS\sp_2020",replace

*2018
use cfps2018person_202012,clear
svyset psu [pweight=rswt_natcs18n],strata(subpopulation)
keep age gender provcd18 urban18 income cfps2018edu cfps2018eduy qg302code rswt_natcs18n psu subpopulation
gen year=2018
rename provcd18 prov
replace prov=. if prov<0
rename urban18 urban
replace urban=. if urban<0
rename income wage
replace wage=. if wage<0
rename cfps2018edu educ
replace educ=. if educ<=0
rename cfps2018eduy edu
replace edu=. if edu<=0
replace edu=0 if edu==. & educ==1
replace edu=6 if edu==. &educ==2
replace edu=9 if edu==. &educ==3
replace edu=12 if edu==. &educ==4
replace edu=14.5 if edu==. &educ==5
replace edu=16 if edu==. &educ==6
replace edu=18 if edu==. &educ==7
replace edu=22 if edu==. &educ==8
label variable edu "教育年限"
gen experience =age-edu-6
replace experience = 0 if experience<0
rename qg302code ind
replace ind = . if ind<0 | ind==99

gen college = (edu>12 & edu~=.)
gen ba = (edu>=16 & edu~=.)
gen high = (edu>=12 & edu~=.)
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen lw = log(wage)
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge~=3
drop _merge
gen low = 0
replace low=1 if wage < (206/12/2) & year<=2000
replace low=1 if wage < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/cpi < (2300/12/563.5/2) & year>2010
*reg 
svy: reg lw college experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0)
gen sp2_c = _b[college]
svy: reg lw ba experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0)
gen sp2_b = _b[ba]
svy: reg lw high experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0)
gen sp2_h = _b[high]

save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS\sp_2018",replace


*2016
use cfps2016adult_201906,clear
merge m:m fid10 using psu2010
drop if _merge==2
replace psu=45 if countyid16==45 & psu==.
replace psu=79 if countyid16==79 & psu==.
replace psu=47 if countyid16==47 & psu==.
replace psu=49 if countyid16==49 & psu==.
replace psu=48 if countyid16==48 & psu==.
replace psu=71 if countyid16==71 & psu==.
replace psu=169 if countyid16==155 & psu==.
replace psu=162 if countyid16==148 & psu==.
replace psu=166 if countyid16==152 & psu==.
replace psu=171 if countyid16==157 & psu==.
replace psu=87 if countyid16==85 & psu==.
replace psu=98 if countyid16==91 & psu==.
replace psu=99 if countyid16==92 & psu==.
replace psu=107 if countyid16==95 & psu==.
replace psu=12 if countyid16==12 & psu==.
replace psu=10 if countyid16==10 & psu==.
replace psu=37 if countyid16==37 & psu==.
replace psu=2 if countyid16==2 & psu==.
replace psu=15 if countyid16==15 & psu==.
replace psu=64 if countyid16==64 & psu==.
replace psu=113 if countyid16==99 & psu==.
replace psu=114 if countyid16==100 & psu==.
replace psu=117 if countyid16==103 & psu==.
replace psu=127 if countyid16==113 & psu==.
replace psu=125 if countyid16==111 & psu==.
replace psu=116 if countyid16==102 & psu==.
replace psu=7 if countyid16==7 & psu==.
replace psu=9 if countyid16==9 & psu==.
replace psu=30 if countyid16==30 & psu==.
replace psu=33 if countyid16==33 & psu==.
replace psu=130 if countyid16==116 & psu==.
replace psu=136 if countyid16==122 & psu==.
replace psu=131 if countyid16==117 & psu==.
replace psu=139 if countyid16==125 & psu==.
replace psu=141 if countyid16==127 & psu==.
replace psu=129 if countyid16==115 & psu==.
replace psu=134 if countyid16==120 & psu==.
replace psu=140 if countyid16==126 & psu==.
replace psu=142 if countyid16==128 & psu==.
replace psu=143 if countyid16==129 & psu==.
replace psu=137 if countyid16==123 & psu==.
replace psu=19 if countyid16==19 & psu==.
replace psu=16 if countyid16==16 & psu==.
replace psu=76 if countyid16==76 & psu==.
replace psu=77 if countyid16==77 & psu==.
replace psu=159 if countyid16==145 & psu==.
replace psu=156 if countyid16==142 & psu==.
replace psu=151 if countyid16==137 & psu==.
replace psu=148 if countyid16==134 & psu==.
replace psu=147 if countyid16==133 & psu==.
replace psu=157 if countyid16==143 & psu==.
replace psu=154 if countyid16==140 & psu==.
replace psu=80 if countyid16==2364 & psu==.

replace psu=5 if  cid16==796126 & psu==.
replace psu=20 if  cid16==354091 & psu==.
replace psu=15 if  cid16==243233 & psu==.
replace psu=112 if  cid16==797650 & psu==.

replace psu=79 if fid16==116953 & psu==.


svyset psu [pweight=rswt_natcs16],strata(subpopulation)
keep cfps_age cfps_gender provcd16 urban16 income cfps2016edu cfps2016eduy qg302code psu rswt_natcs16 subpopulation
gen year=2016
rename provcd16 prov
replace prov=. if prov<0
rename urban16 urban
replace urban=. if urban<0
rename income wage
replace wage=. if wage<0
rename cfps2016edu educ
replace educ=. if educ<=0
rename cfps2016eduy edu
replace edu=. if edu<=0
replace edu=0 if edu==. & educ==1
replace edu=6 if edu==. &educ==2
replace edu=9 if edu==. &educ==3
replace edu=12 if edu==. &educ==4
replace edu=14.5 if edu==. &educ==5
replace edu=16 if edu==. &educ==6
replace edu=18 if edu==. &educ==7
replace edu=22 if edu==. &educ==8
label variable edu "教育年限"
rename cfps_age age
rename cfps_gender gender
gen experience =age-edu-6
replace experience = 0 if experience<0
rename qg302code ind
replace ind = . if ind<0 | ind==99

gen college = (edu>12 & edu~=.)
gen ba = (edu>=16 & edu~=.)
gen high = (edu>=12 & edu~=.)
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen lw = log(wage)
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge~=3
drop _merge
gen low = 0
replace low=1 if wage < (206/12/2) & year<=2000
replace low=1 if wage < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/cpi < (2300/12/563.5/2) & year>2010
drop if gender<0
svy: reg lw college experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_c = _b[college]
svy: reg lw ba experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_b = _b[ba]
svy: reg lw high experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_h = _b[high]

save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS\sp_2016",replace

*2014
use cfps2014adult_201906,clear
merge m:m fid10 using psu2010
drop if _merge==2
rename subpopulation10 subpopulation
replace psu=45 if countyid14==45 & psu==.
replace psu=79 if countyid14==79 & psu==.
replace psu=47 if countyid14==47 & psu==.
replace psu=51 if countyid14==51 & psu==.
replace psu=49 if countyid14==49 & psu==.
replace psu=48 if countyid14==48 & psu==.
replace psu=71 if countyid14==71 & psu==.
replace psu=74 if countyid14==74 & psu==.
replace psu=169 if countyid14==155 & psu==.
replace psu=162 if countyid14==148 & psu==.
replace psu=166 if countyid14==152 & psu==.
replace psu=171 if countyid14==157 & psu==.
replace psu=161 if countyid14==147 & psu==.
replace psu=87 if countyid14==85 & psu==.
replace psu=98 if countyid14==91 & psu==.
replace psu=107 if countyid14==95 & psu==.
replace psu=12 if countyid14==12 & psu==.
replace psu=10 if countyid14==10 & psu==.
replace psu=37 if countyid14==37 & psu==.
replace psu=2 if countyid14==2 & psu==.
replace psu=15 if countyid14==15 & psu==.
replace psu=13 if countyid14==13 & psu==.
replace psu=64 if countyid14==64 & psu==.
replace psu=113 if countyid14==99 & psu==.
replace psu=114 if countyid14==100 & psu==.
replace psu=117 if countyid14==103 & psu==.
replace psu=127 if countyid14==113 & psu==.
replace psu=116 if countyid14==102 & psu==.
replace psu=7 if countyid14==7 & psu==.
replace psu=9 if countyid14==9 & psu==.
replace psu=30 if countyid14==30 & psu==.
replace psu=130 if countyid14==116 & psu==.
replace psu=136 if countyid14==122 & psu==.
replace psu=131 if countyid14==117 & psu==.
replace psu=139 if countyid14==125 & psu==.
replace psu=133 if countyid14==119 & psu==.
replace psu=141 if countyid14==127 & psu==.
replace psu=129 if countyid14==115 & psu==.
replace psu=134 if countyid14==120 & psu==.
replace psu=140 if countyid14==126 & psu==.
replace psu=142 if countyid14==128 & psu==.
replace psu=143 if countyid14==129 & psu==.
replace psu=137 if countyid14==123 & psu==.
replace psu=19 if countyid14==19 & psu==.
replace psu=16 if countyid14==16 & psu==.
replace psu=76 if countyid14==76 & psu==.
replace psu=77 if countyid14==77 & psu==.
replace psu=159 if countyid14==145 & psu==.
replace psu=156 if countyid14==142 & psu==.
replace psu=148 if countyid14==134 & psu==.
replace psu=147 if countyid14==133 & psu==.
replace psu=157 if countyid14==143 & psu==.
replace psu=141 if countyid14==127 & psu==.
replace psu=148 if countyid14==134 & psu==.
replace psu=154 if countyid14==140 & psu==.
replace psu=151 if countyid14==137 & psu==.
replace psu=2 if countyid14==1081 & psu==.
replace psu=80 if countyid14==2364 & psu==.
replace psu=20 if countyid14==2261 & psu==.
replace psu=5 if countyid14==2149 & psu==.

replace psu=99 if  cid14==204200 & psu==.
replace psu=100 if  cid14==204400 & psu==.
replace psu=148 if  cid14==315578 & psu==.

svyset psu [pweight=rswt_natcs14],strata(subpopulation)
keep cfps2014_age cfps_gender provcd14 urban14 income cfps2014edu cfps2014eduy qg302code psu rswt_natcs14 subpopulation

gen year=2014
rename provcd14 prov
replace prov=. if prov<0
rename urban14 urban
replace urban=. if urban<0
rename income wage
replace wage=. if wage<0
rename cfps2014edu educ
replace educ=. if educ<=0
rename cfps2014eduy edu
replace edu=. if edu<=0
replace edu=0 if edu==. & educ==1 
replace edu=6 if edu==. &educ==2
replace edu=9 if edu==. &educ==3
replace edu=12 if edu==. &educ==4
replace edu=14.5 if edu==. &educ==5
replace edu=16 if edu==. &educ==6
replace edu=18 if edu==. &educ==7
replace edu=22 if edu==. &educ==8
replace edu=0 if edu==. & educ==9
label variable edu "教育年限"
rename cfps2014_age age
rename cfps_gender gender
gen experience =age-edu-6
replace experience = 0 if experience<0
rename qg302code ind
replace ind = . if ind<0 | ind==99

gen college = (edu>12 & edu~=.)
gen ba = (edu>=16 & edu~=.)
gen high = (edu>=12 & edu~=.)
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen lw = log(wage)
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge~=3
drop _merge
gen low = 0
replace low=1 if wage < (206/12/2) & year<=2000
replace low=1 if wage < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/cpi < (2300/12/563.5/2) & year>2010
drop if gender<0
svy: reg lw college experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0)
gen sp2_c = _b[college]
svy: reg lw ba experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0)
gen sp2_b = _b[ba]
svy: reg lw high experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0)
gen sp2_h = _b[high]

save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS\sp_2014",replace

*2012
use cfps2012adult_201906,clear
merge m:m fid10 using psu2010
drop if _merge==2
replace psu=countyid if countyid<53 &countyid>0
replace psu=64 if countyid==64 & psu==.
replace psu=71 if countyid==71 & psu==.
replace psu=75 if countyid==75 & psu==.
replace psu=76 if countyid==76 & psu==.
replace psu=77 if countyid==77 & psu==.
replace psu=79 if countyid==79 & psu==.
replace psu=87 if countyid==85 & psu==.
replace psu=91 if countyid==88 & psu==.
replace psu=96 if countyid==90 & psu==.

replace psu=113 if countyid==99 & psu==.
replace psu=114 if countyid==100 & psu==.
replace psu=116 if countyid==102 & psu==.
replace psu=125 if countyid==111 & psu==.
replace psu=127 if countyid==113 & psu==.
replace psu=133 if countyid==119 & psu==.
replace psu=134 if countyid==120 & psu==.
replace psu=136 if countyid==122 & psu==.
replace psu=137 if countyid==123 & psu==.
replace psu=139 if countyid==125 & psu==.
replace psu=140 if countyid==126 & psu==.
replace psu=142 if countyid==128 & psu==.
replace psu=156 if countyid==142 & psu==.
replace psu=157 if countyid==143 & psu==.
replace psu=159 if countyid==145 & psu==.
replace psu=162 if countyid==148 & psu==.
replace psu=166 if countyid==152 & psu==.
replace psu=169 if countyid==155 & psu==.
replace psu=171 if countyid==157 & psu==.
replace psu=80 if  countyid==2364 & psu==.

replace psu=98 if  cid==203400 & psu==.
replace psu=99 if  cid==204200 & psu==.
replace psu=100 if  cid==204400 & psu==.
replace psu=101 if  cid==204600 & psu==.
replace psu=107 if  cid==205300 & psu==.
replace psu=107 if  cid==205400 & psu==.
replace psu=117 if  cid==208100 & psu==.
replace psu=117 if  cid==208400 & psu==.
replace psu=131 if  cid==213700 & psu==.
replace psu=131 if  cid==213800 & psu==.
replace psu=143 if  cid==218500 & psu==.
replace psu=143 if  cid==218800 & psu==.
replace psu=147 if  cid==220100 & psu==.
replace psu=147 if  cid==220300 & psu==.
replace psu=148 if  cid==220700 & psu==.
replace psu=148 if  cid==220800 & psu==.
replace psu=154 if  cid==766015 & psu==.
replace psu=103 if  cid==203900 & psu==.
replace psu=148 if  cid==220600 & psu==.
replace psu=97 if psu==.

svyset psu [pweight=rswt_natcs12],strata(subpopulation)
keep cfps2012_age cfps2012_gender_best provcd urban12 income edu2012 eduy2012 qg410code_a_1 rswt_natcs12 psu subpopulation
gen year=2012
rename provcd prov
replace prov=. if prov<0
rename urban12 urban
replace urban=. if urban<0
rename income wage
replace wage = wage/12
replace wage=. if wage<0
rename edu2012 educ
replace educ=. if educ<=0
rename eduy2012 edu
replace edu=. if edu<=0
replace edu=0 if edu==. & educ==1 
replace edu=6 if edu==. &educ==2
replace edu=9 if edu==. &educ==3
replace edu=12 if edu==. &educ==4
replace edu=14.5 if edu==. &educ==5
replace edu=16 if edu==. &educ==6
replace edu=18 if edu==. &educ==7
replace edu=22 if edu==. &educ==8
label variable edu "教育年限"
rename cfps2012_age age
rename cfps2012_gender gender
gen experience =age-edu-6
replace experience = 0 if experience<0
rename qg410code_a_1 ind
replace ind = . if ind<0 | ind==99

gen college = (edu>12 & edu~=.)
gen ba = (edu>=16 & edu~=.)
gen high = (edu>=12 & edu~=.)
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen lw = log(wage)
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge~=3
drop _merge
gen low = 0
replace low=1 if wage < (206/12/2) & year<=2000
replace low=1 if wage < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/cpi < (2300/12/563.5/2) & year>2010
drop if gender<0
svy: reg lw college experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_c = _b[college]
svy: reg lw ba experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_b = _b[ba]
svy: reg lw high experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_h = _b[high]

save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS\sp_2012",replace

*2011  （年龄只有15-18）
/*	clear //在转码之前需要将STATA内存中的数据清空
	cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS" 
	unicode encoding set gb18030  //将文本编码设置为中文
	unicode analyze cfps2011adult_202202.dta
	unicode translate cfps2011adult_202202.dta, invalid
	//unicode retranslate cfps2011adult_202202.dta, transutf8 replace

use cfps2011adult_202202,clear
keep qa1age cfps2012_gender_best provcd urban12 sg417 edu2012 eduy2012
gen year=2012
rename provcd prov
replace prov=. if prov<0
rename urban12 urban
replace urban=. if urban<0
rename sg417 wage
replace wage=. if wage<0
rename edu2012 educ
replace educ=. if educ<=0
rename eduy2012 edu
replace edu=. if edu<=0
replace edu=0 if edu==. & educ==1 
replace edu=6 if edu==. &educ==2
replace edu=9 if edu==. &educ==3
replace edu=12 if edu==. &educ==4
replace edu=14.5 if edu==. &educ==5
replace edu=16 if edu==. &educ==6
replace edu=18 if edu==. &educ==7
replace edu=22 if edu==. &educ==8
label variable edu "教育年限"
rename cfps2012_age age
rename cfps2012_gender gender
gen experience =age-edu-6
replace experience = 0 if experience<0
save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS\sp_2012",replace*/

*2010
use cfps2010adult_202008,clear
svyset psu [pweight=rswt_nat],strata(subpopulation)

keep qa1age gender provcd urban qk101 cfps2010edu_best cfps2010eduy_best qg308code psu rswt_nat subpopulation

gen year=2010
rename provcd prov
replace prov=. if prov<0
replace urban=. if urban<0
rename qk101 wage

replace wage=. if wage<0
rename cfps2010edu_best educ
replace educ=. if educ<=0
rename cfps2010eduy_best edu
replace edu=. if edu<=0
replace edu=0 if edu==. & educ==1 
replace edu=6 if edu==. &educ==2
replace edu=9 if edu==. &educ==3
replace edu=12 if edu==. &educ==4
replace edu=14.5 if edu==. &educ==5
replace edu=16 if edu==. &educ==6
replace edu=18 if edu==. &educ==7
replace edu=22 if edu==. &educ==8
replace edu=0 if edu==. & educ==9
label variable edu "教育年限"
rename qa1age age
gen experience =age-edu-6
replace experience = 0 if experience<0
rename qg308code ind
replace ind = . if ind<0 | ind==99

gen college = (edu>12 & edu~=.)
gen ba = (edu>=16 & edu~=.)
gen high = (edu>=12 & edu~=.)
gen experience2 = experience^2
gen experience3 = experience^3
gen experience4 = experience^4
gen lw = log(wage)
merge m:1 year using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\cn_cpi.dta"
drop if _merge~=3
drop _merge
gen low = 0
replace low=1 if wage < (206/12/2) & year<=2000
replace low=1 if wage < (865/12/2 ) & year<=2010 & year >2000
replace low=1 if wage/cpi < (2300/12/563.5/2) & year>2010
drop if gender<0
svy: reg lw college experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_c = _b[college]
svy: reg lw ba experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_b = _b[ba]
svy: reg lw high experience experience2 experience3 experience4 i.prov i.gender if( ((age>=16&age<=55& gender==0)|(age>=16&age<=60& gender==1))& urban==1 & low==0) 
gen sp2_h = _b[high]

save "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS\sp_2010",replace

****2010-2020
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\CFPS\skillpremium_CFPS"
use sp_2010,clear
append using sp_2012
append using sp_2014
append using sp_2016
append using sp_2018
append using sp_2020

collapse sp2* ,by(year)
label variable sp2_c "skill premium (college), CFPS"
label variable sp2_b "skill premium (bachelor), CFPS"
label variable sp2_h "skill premium (high), CFPS"

twoway (line sp2_c year) (line sp2_b year) (line sp2_h year) 
save sp2010-2020,replace
