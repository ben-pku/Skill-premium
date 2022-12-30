********** CN employment share *******************
* edited on 11 July, 2022 Zhuokai Huang

cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\cn_SC"
clear

*** CN labor statistic yearbook ****
** only non-private firms ****
** -- again ser -- CN Labor statistic yearbook
egen serh = rowtotal(finance realestate  health educ gov  pubmanage geo_water sci it tenancy_business ) 
gen serh_s = serh/total
egen serl = rowtotal(utility trans saletrade  accommodation_rest cul_enter resident_ser ) 
gen serl_s = serl/total
twoway (line serh year) (line serl year), graphregion(color(white)) title("Service Employment, China") legend(label(1 "high skill") label(2 "low skill")) //
twoway (line serh_s year) (line serl_s year), graphregion(color(white)) title("Service Employment Share, China") legend(label(1 "high skill") label(2 "low skill")) //

foreach y of varlist finance realestate  health educ gov  pubmanage geo_water sci it tenancy_business utility trans saletrade  accommodation_rest cul_enter resident_ser {
    gen `y'_s = `y'/total
	
}

twoway (line finance_s year) (line realestate_s year) (line health_s year) (line educ_s year) (line gov_s year) (line pubmanage_s year) (line geo_water_s year ) (line sci_s year) (line it_s year) (line tenancy_business_s year), graphregion(color(white))
save cn_laboryearbook78-20, replace

/*
gen ser1 = transport
gen ser2 = saletrade+ accommo
gen ser3 = resident + cul_enter
gen ser4 = utility
gen ser5 = tenancy_business + finance + realestate + education + health + it + sci
gen ser6 = public + manage

save cn_laboryearbook,replace

gen ser1 = trans
gen ser2 = saletrade
gen ser3 = other+ social_ser
replace ser3 = social_ser if ser3==.
gen ser4 = utility + finance + realestate
gen ser5 = geo_water + sci 
gen ser6 = health + educ_culture + gov
save cn_laboryearbook78-02,replace

use cn_laboryearbook78-02,clear
append using cn_laboryearbook
*keep year total agri manufacturing mining construction ser*
gen agri_s = agri / total
gen min_s = mining / total
gen manu_s = manufacturing / total
gen con_s = construction/total
***
gen uti_s = utility/total
gen geo_water_s = geo_water/total 
gen trans_s = trans/total
gen saletrade_s = saletrade/total
gen finance_s = finance/total
gen realstate_s = realestate / total
gen social_ser_s = social_ser/ total
gen health_s = health/ total
gen educ_culture_s = educ_culture/ total
gen sci_s = sci/ total
gen gov_s = gov/ total
***

gen ser_s1 = ser1/total
gen ser_s2 = ser2/total
gen ser_s3 = ser3/total
gen ser_s4 = ser4/total
gen ser_s5 = ser5/total
gen ser_s6 = ser6/total

gen serh = ser_s5+ser_s6 
gen serl = ser_s1 + ser_s2+ser_s3+ser_s4
* service high-skill vs low-skill
twoway (line serh year) (line serl year), graphregion(color(white)) title("Service Employment Share, China") legend(label(1 "high skill") label(2 "low skill")) //
*/
twoway (line manu_s year) (line agri_s year) (line con_s year ) // 这个结果不是很对，农业人口占比没有这么低
save cn_service78-20, replace
* construction and mining sector trend:
use cn_service78-20,clear
gen min_s = mining / total
gen con_s = construction / total
twoway (line con_s year) (line min_s year), graphregion(color(white)) title("Construction and Mining Employment Share, China") legend(label(1 "Construction") label(2 "Mining")) xtitle("year") ytitle("employment share")

*-- analyze the weird trend of service sectors
use cn_service78-20, clear
twoway (line ser_s1 year) (line ser_s2 year) (line ser_s3 year) (line ser_s4 year) (line ser_s5 year) (line ser_s6 year)    









*** manufacturing UNIDO
clear
* import excel
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\cn_SC"
replace value="." if value=="..."
destring value,replace
destring isic, replace
keep year isic value
reshape wide value, i(year) j(isic) string
reshape long value, i(year) j(isic) string
merge m:1 year using cn_emp1952-2020
replace employ = 40152*40152/41024 if year==1977
keep year isic value employ
rename value emp
rename employ t_emp
label variable emp "industry employment"
label variable t_emp "total employment in China"

gen emp_s = emp/t_emp/10000
label var emp_s "industry employment share"

use cn_manu77-20, clear
drop if isic=="D"
//drop if year < 1990
twoway (line emp_s year if isic~="D"), by(isic, yrescale ) ylabel(none) scheme(s1mono)

replace increase = (isic=="23"|isic=="24"|isic=="25"|isic=="26"|isic=="27"|isic=="28"|isic=="29"| isic=="30"| isic=="31"| isic=="32"| isic=="33"| isic=="34"|isic=="35"| isic=="36"| isic=="37")
label var increase "increase index--high skill"
bysort year: egen m_emp = sum(emp)
label var m_emp "total employment in manu"
gen emp_sm = emp/m_emp
label var emp_sm "employment share in manu"
* figure
twoway (line emp_s year if isic~="D"& increase==0), by(isic, yrescale) ylabel(none)
twoway (line emp_s year if isic~="D"& increase==1), by(isic, yrescale) scheme(s1mono)



collapse (sum) emp (mean) t_emp m_emp, by(year increase)
gen emp_sm = emp/m_emp
label var emp_sm "employment share in manu"
twoway (line emp_sm year if increase==1& year>1990) (line emp_sm year if increase==0& year>1990), legend(label(1 "increase") label(2 "de"))



****** 中国经济普查年鉴 2004 2008 2013 2018
* focus on service
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\cn_SC"
gen ser = 0
replace ser=1 if industry=="G"
replace ser=2 if ind=="F"|ind=="H"
replace ser=3 if ind=="O"|ind=="R"
replace ser=4 if ind=="D"
replace ser=5 if ind=="I"|ind=="J"|ind=="K"|ind=="L"|ind=="M"
replace ser=6 if ind=="N"|ind=="P"|ind=="Q"|ind=="S"
save "econ_yearbook.dta", replace

use econ_yearbook,clear
reshape wide emp ser, i(year) j(industry) string

gen emp_s0 = 1
gen emp_sA = empA/emp0
gen emp_sB = empB /emp0
gen emp_sC = empC /emp0
gen emp_sD = empD /emp0
gen emp_sE = empE /emp0
gen emp_sF = empF /emp0
gen emp_sG = empG /emp0
gen emp_sH = empH /emp0
gen emp_sI = empI /emp0
gen emp_sJ = empJ /emp0
gen emp_sK = empK /emp0
gen emp_sL = empL /emp0
gen emp_sM = empM /emp0
gen emp_sN = empN /emp0
gen emp_sO = empO /emp0
gen emp_sP = empP /emp0
gen emp_sQ = empQ /emp0
gen emp_sR = empR /emp0
gen emp_sS = empS /emp0
reshape long emp emp_s ser,i(year) j(industry) string
gen serh = 1 if ser==5 | ser==6
replace serh = 0 if serh==.
replace serh = -1 if ser==0
drop if ind=="0"
collapse (sum) emp emp_s,by(year serh)
twoway (line emp_s year if serh==0) (line emp_s year if serh==1), title("Employment Share of Service Sectors, China") subtitle("Economic Census") legend(label(1 "Low skill") label(2 "High skill")) graphregion(color(white)) ytitle("employment share") xtitle("year")
//应该是对的

append using "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\census_skill_intensity\cn-census-service-emp"
sort year serh
replace emp = emp*100 if year<=2000

twoway (line emp_s year if serh==0) (line emp_s year if serh==1), title("Employment Share of Service Sectors, China") legend(label(1 "Low skill") label(2 "High skill")) graphregion(color(white)) ytitle("employment share") xtitle("year")

save "ser_emp_census82-18.dta",replace
drop if serh==-1
reshape wide emp emp_s ,i(year) j(serh)
save "ser_emp_census82-18d.dta", replace