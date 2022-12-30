*******-******* skill intensity *************************
*******-*************************************************
*******- China Census 1990, 2000 Data  ******************
*******- Edited on 12, June, 2022 Zhuokai Huang***********

clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\census_skill_intensity"

use ipumsi_00002.dta,clear
replace indgen = 114 if indgen>=130 & (ind==831|ind==832|ind==839)
gen A = (indgen==10)
gen I = (indgen==20 | indgen==30 | indgen==40 | indgen==50  )
gen S = (indgen==60 | indgen==70 | indgen==80 | indgen==90 | indgen==100 | indgen==110 | indgen==111 | indgen==112 | indgen==113 | indgen==114 | indgen==120)
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
save census90_00,replace

* three industries
* 2000
use census90_00,clear
keep if year==2000
replace dayswrk=. if (dayswrk==8| dayswrk==9)
gen secondary =.
gen ba =.
gen college =.
replace secondary = (edattain==3|edattain==4)
replace ba = (edattain==4)
replace college = (edattaind>=312 & edattaind~=999)
collapse secondary college ba [fweight=dayswrk], by(ind3)
collapse secondary college ba, by(ind3)

* 1990
use census90_00,clear
keep if year==1990
gen secondary =.
gen ba =.
gen college =.
replace secondary = (edattain==3|edattain==4)
replace ba = (edattain==4)
replace college = (edattaind>=312 & edattaind~=999)
collapse secondary college ba, by(ind3)

* all sub-industries
use census90_00,clear
keep if year == 2000
replace dayswrk=. if (dayswrk==8| dayswrk==9)
gen secondary =.
gen ba =.
gen college =.
replace secondary = (edattain==3|edattain==4)
replace ba = (edattain==4)
replace college = (edattaind>=312 & edattaind~=999)
collapse secondary college ba [fweight=dayswrk], by(indgen)

*************************************************************************
************************ CN Skill intensity *****************************
*************************************************************************
* industrial enterprise dataset 2004
use "C:\Users\Benjamin Hwang\Documents\undergraduate_research-2021-Zhengwen_Liu\data\工业企业面板数据\all_year\all_year_original\c2004.dta", clear

rename 企业匹配唯一标识码 id
rename 企业名称 name
rename 行业小类代码 ind4
rename 行业大类代码 ind2
rename 行业大类名称 ind2_name
rename 行业中类代码 ind3
rename 年末从业人员合计_男性人 male
rename 年末从业人员合计_女性人 female
rename 具有研究生及以上学历人员_男性人 grad_m
rename 具有研究生及以上学历人员_女性人 grad_f
rename 具有大学本科学历人员_男性人 ba_m
rename 具有大学本科学历人员_女性人 ba_f
rename 具有大专学历人员_男性人 college_m
rename 具有大专学历人员_女性人 college_f
rename 具有高中学历人员_男性人 high_m
rename 具有高中学历人员_女性人 high_f
rename 具有初中及以下学历人员_男性人 middle_m
rename 具有初中及以下学历人员_女性人 middle_f
rename 具有高级技术职称人员_男性人 highskill_m
rename 具有高级技术职称人员_女性人 highskill_f
rename 具有中级技术职称人员_男性人 midskill_m
rename 具有中级技术职称人员_女性人 midskill_f 
rename 具有初级技术职称人员_男性人 primskill_m
rename 具有初级技术职称人员_女性人 primskill_f
rename 高级技师_男性人 hightechnician_m
rename 高级技师_女性人 hightechnician_f
rename 技师_男性人 technician_m
rename 技师_女性人 technician_f
rename 高级工_男性人 highwk_m
rename 高级工_女性人 highwk_f
rename 中级工_男性人 midwk_m
rename 中级工_女性人 midwk_f

destring male female grad* ba* college* high* mid* pri* tech* ,replace

collapse (sum)male female college_m college_f high_m high_f middle_m middle_f ,by(ind2 ind2_name)
gen emp = male + female
label variable emp "total employment"
gen college_i = (college_f+college_m)/emp
gen high_i = (high_f + high_m)/emp
gen middle_i = (middle_f + middle_m)/emp

gsort -college_i

drop if ind2=="06"|ind2=="07"|ind2=="08"|ind2=="09"|ind2=="10"|ind2=="11"|ind2=="43"|ind2=="44"|ind2=="45"|ind2=="46"
sort ind2
gen rank = _n
order ind2 ind2_name rank college_i high_i middle_i 
gsort -high_i
gen rank_h = _n
order ind2 ind2_name rank_h rank college_i high_i middle_i 

/*
rename 企业匹配唯一标识码 id
rename 企业名称 name
rename 行业小类代码 ind4
rename 行业大类代码 ind2
rename 行业大类名称 ind2_name
rename 行业中类代码 ind3
rename 全部从业人员年平均人数人 emp
destring emp,replace
collapse (sum) emp, by(ind2_name ind2 )
egen t_emp = sum(emp)
sort ind2*/

//06 - 11,43-46 not manufacturing

*************************************************************************
************************ US Skill intensity *****************************
*************************************************************************

cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps"
use us_sp,clear
keep if year==2020
gen A = (ind1990>=10 & ind<=32)
gen I = (ind>=40 & ind<=392)
gen S = (ind>=400 & ind<=932)  // excluded Armed Forces
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
* employment share
mean ba [pweight =asecwt]
collapse college ba high [pweight=asecwt],by(ind3)

*---- above are employment share, the calculation might be wrong
*---- below is compensation
use us_sp,clear
keep if year==2020
gen A = (ind1990>=10 & ind<=32)
gen I = (ind>=40 & ind<=392)
gen S = (ind>=400 & ind<=932)  // excluded Armed Forces
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
* A
keep if A==1
egen sw = sum(asecwt)
gen ia = incwage*asecwt
egen t_wage = sum(ia) 
egen h_wage = sum(ia) if  high==1
egen c_wage = sum(ia) if college==1
egen b_wage = sum(ia) if ba == 1
gen h_share = h_wage/t_wage
gen c_share = c_wage/t_wage
gen b_share = b_wage/t_wage

* I
use us_sp,clear
keep if year==2020
gen A = (ind1990>=10 & ind<=32)
gen I = (ind>=40 & ind<=392)
gen S = (ind>=400 & ind<=932)  // excluded Armed Forces
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
keep if I==1
egen sw = sum(asecwt)
gen ia = incwage*asecwt
egen t_wage = sum(ia) 
egen h_wage = sum(ia) if  high==1
egen c_wage = sum(ia) if college==1
egen b_wage = sum(ia) if ba == 1
gen h_share = h_wage/t_wage
gen c_share = c_wage/t_wage
gen b_share = b_wage/t_wage


* S
use us_sp,clear
keep if year==2020
gen A = (ind1990>=10 & ind<=32)
gen I = (ind>=40 & ind<=392)
gen S = (ind>=400 & ind<=932)  // excluded Armed Forces
gen ind3 =.
replace ind3=1 if A==1
replace ind3=2 if I==1
replace ind3=3 if S==1
keep if S==1
egen sw = sum(asecwt)
gen ia = incwage*asecwt
egen t_wage = sum(ia) 
egen h_wage = sum(ia) if  high==1
egen c_wage = sum(ia) if college==1
egen b_wage = sum(ia) if ba == 1
gen h_share = h_wage/t_wage
gen c_share = c_wage/t_wage
gen b_share = b_wage/t_wage



