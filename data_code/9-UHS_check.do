**** UHS additional data
* edited on 8th May, 2022

* 2005 additional
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel"
use "2005sz", clear
sort dcode hcode d921
duplicates drop dcode hcode,force
merge 1:m dcode hcode using 2005fam
drop if _merge~=3
drop _merge
gen year=2005
tostring dcode,replace
gen prov = substr(dcode,1,2)
destring prov, replace
rename a1 rela
drop if rela==99
rename a6 sex
rename a7 age
rename a8 educ
rename a10 experience
gen work_be = year-experience
rename a13 ind
rename d921 hwage
gen workst = (a12<8)
label variable workst "工作状态 1-就业 0-不算就业"
bysort dcode hcode: egen famworkst = sum(workst)
bysort dcode hcode: gen wage = hwage/famworkst
gen college =(educ>=7)
gen ba = (educ>=8)
gen high = (educ>=5)
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen lw = log(wage)
label define prov 11 "北京" 14 "山西" 21 "辽宁" 23 "黑龙江" 31 "上海" 32 "江苏" 33 "浙江" 34 "安徽" 36 "江西" 37 "山东" 41 "河南" 42 "湖北" 44 "广东" 50 "重庆" 51 "四川" 53 "云南" 61 "陕西" 62 "甘肃",modify
label values prov prov
save 2005spa, replace


* 2006 additional
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel"
use "2006sz", clear
sort dcode hcode d921
duplicates drop dcode hcode,force
merge 1:m dcode hcode using 2006fam
drop if _merge~=3
drop _merge
gen year=2006
tostring dcode,replace
gen prov = substr(dcode,1,2)
destring prov, replace
rename a1 rela
drop if rela==99
rename a6 sex
rename a7 age
rename a8 educ
rename a10 experience
gen work_be = year-experience
rename a13 ind
rename d921 hwage
gen workst = (a12<8)
label variable workst "工作状态 1-就业 0-不算就业"
bysort dcode hcode: egen famworkst = sum(workst)
bysort dcode hcode: gen wage = hwage/famworkst

gen college =(educ>=7)
gen ba = (educ>=8)
gen high = (educ>=5)
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen lw = log(wage)
label define prov 11 "北京" 14 "山西" 21 "辽宁" 23 "黑龙江" 31 "上海" 32 "江苏" 33 "浙江" 34 "安徽" 36 "江西" 37 "山东" 41 "河南" 42 "湖北" 44 "广东" 50 "重庆" 51 "四川" 53 "云南" 61 "陕西" 62 "甘肃",modify
label values prov prov
save 2006spa, replace

* 2007 additional
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel"
use "2007fam", clear
sort dcode hcode
gen year=2007
tostring dcode,replace
gen prov = substr(dcode,1,2)
destring prov, replace
rename a1 rela
drop if rela==99
rename a6 sex
tostring a7,replace
gen birth = substr(a7,1,4)
destring birth, replace
gen age = year-birth
rename a8 educ
rename a10 work_be
gen experience = year-work_be
rename a13 ind
rename a151 wage
gen college =(educ>=7)
gen ba = (educ>=8)
gen high = (educ>=5)
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen lw = log(wage)
label define prov 11 "北京" 14 "山西" 21 "辽宁" 23 "黑龙江" 31 "上海" 32 "江苏" 33 "浙江" 34 "安徽" 36 "江西" 37 "山东" 41 "河南" 42 "湖北" 44 "广东" 50 "重庆" 51 "四川" 53 "云南" 61 "陕西" 62 "甘肃",modify
label values prov prov
save 2007spa, replace

* 2008 additional
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel"
use "2008fam", clear
sort dcode hcode
gen year=2008
tostring dcode,replace
gen prov = substr(dcode,1,2)
destring prov, replace
rename a1 rela
drop if rela==99
rename a6 sex
tostring a7,replace
gen birth = substr(a7,1,4)
destring birth, replace
gen age = year-birth
rename a8 educ
rename a10 work_be
gen experience = year-work_be
rename a13 ind
rename a151 wage
gen college =(educ>=7)
gen ba = (educ>=8)
gen high = (educ>=5)
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen lw = log(wage)
label define prov 11 "北京" 14 "山西" 21 "辽宁" 23 "黑龙江" 31 "上海" 32 "江苏" 33 "浙江" 34 "安徽" 36 "江西" 37 "山东" 41 "河南" 42 "湖北" 44 "广东" 50 "重庆" 51 "四川" 53 "云南" 61 "陕西" 62 "甘肃",modify
label values prov prov
save 2008spa, replace

* 2009 additional
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\cn_sp\UHS\sp_uhs_panel"
use "2009fam", clear
sort dcode hcode
gen year=2009
tostring dcode,replace
gen prov = substr(dcode,1,2)
destring prov, replace
rename a1 rela
drop if rela==99
rename a6 sex
tostring a7,replace
gen birth = substr(a7,1,4)
destring birth, replace
gen age = year-birth
rename a8 educ
rename a10 work_be
gen experience = year-work_be
rename a13 ind
rename a151 wage
gen college =(educ>=7)
gen ba = (educ>=8)
gen high = (educ>=5)
gen exclude =(ind==1 | (a12==6 |(a12>=8 & a12<=15) ))
keep hcode year college ba high experience sex prov wage age work_be educ ind exclude
gen lw = log(wage)
label define prov 11 "北京" 14 "山西" 21 "辽宁" 23 "黑龙江" 31 "上海" 32 "江苏" 33 "浙江" 34 "安徽" 36 "江西" 37 "山东" 41 "河南" 42 "湖北" 44 "广东" 50 "重庆" 51 "四川" 53 "云南" 61 "陕西" 62 "甘肃",modify
label values prov prov
save 2009spa, replace

use 2005spa,clear
forvalues y =2006(1)2009{
	append using `y'spa
}
replace wage = wage/12
keep if prov==61 |prov==33
save sxzj05-09,replace
