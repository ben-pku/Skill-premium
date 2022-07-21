/***** SC data in CN and US **************/ //--------------------------
*** edited on June 17, 2022 Zhuokai Huang ---------------------------

****US NIPA industry structure*********
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\US_SC"
use us_emp_detail.dta, clear
save us_emp_detail.dta,replace
sort year
merge 1:1 year using us_emp1929-2021
save us_emp_detail.dta,replace
drop _merge fulltimeequivalentemployees0

xtset year
*--------------------------------------------------------------
* examine the between sector force

* service
** high skill service
gen educ_s = education/full  //0.5-2.4
gen finance_s = financeandinsurance/full  //2-4.8
gen health_s = health/full  //1.2-13.8
gen reale_s =reale/full  //0.8-1.6
gen legal_s = legalservices/fulltime

gen gov_s = government/full
gen infor_s = information/full //



** low skill
gen acc_food_s = accommodationandfoodservices / full  //since 1998: 6.1-8.2
gen whole_s = wholesale /full //1998年之后 略微下降
gen retail_s = retailtrade / full //since 1998 11-9 下降


twoway  ,graphregion(color(white)) title("The US Service Employment Share (skill intensive sector)") 
twoway (line acc_food_s year ) (line whole_s year) (line retail_s year ), graphregion(color(white)) title("The US Service Employment Share skill-low") 

twoway (line S_s year) (line health_s year) (line legal_s year) (line finance_s year) (line educ_s year),graphregion(color(white)) title("The US Service Employment Share") 
  
 (line infor_s year)
twoway (line gov_s year),graphregion(color(white)) title("The US Government Employment Share") 


* manufacturing -- between sector force is too weak
gen manu_s = manufacturing/fulltime
gen durable_s = durable/full
gen wood_s = woodproducts/fulltimeequivalentemployees
gen furniture_s = furnitureandrelatedproducts/full
gen nonmetallic_s = nonmetallic/fulltime
gen primary_metal_s = primary/fulltime
gen fabri_s = fabricated/fulltime
gen machi_s = machinery/fulltime
gen computer_manu_s = computerandelectronicproducts/full
gen motor_s = motor/full
gen other_trans_s = othertrans/full
gen miscell_manu_s = miscellaneousmanufacturing/full
gen nondurable_s = nondurable/full
gen food_s = foodand/full
gen textile_s = textile/full
gen apparel_s = apparel/full
gen paper_s = paper/full
gen printing_s = printing/full
gen chem_s = chemical/full  //1.6 - 0.6--down
gen petrol_s = petrol/fulltime
gen plastic_s = plastic/full
save us_emp_detail.dta,replace



twoway (line manu_s year) (line nondurable_s year) (line durable_s year) (line motor_s year), title("The US Manufacturing Employment Share") graphregion(color(white))
twoway (line wood_s year) (line motor_s year) (line computer_manu_s year), graphregion(color(white))

twoway (lpoly computer_manu_s year) (lpoly machi_s year) (lpoly motor_s year) (line finance_s year),graphregion(color(white))

keep if year==1978| year==2019

foreach var of varlist _all{
	
	drop if `var'>1
}

*** above is useless
** below is construction and mining
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\US_SC"
use us_emp_detail.dta,clear
gen mining_s = mining/full
gen construction_s = construction/full
twoway (line construction_s year) (line mining_s year),  graphregion(color(white)) title("Construction and Mining Employment Share, The US") legend(label(1 "Construction") label(2 "Mining")) xtitle("year") ytitle("employment share")

* high-skill and low-skill service
gen ser1 = transportation
gen ser2 = wholesaletrade + retailtrade + accommodationandfoodservices
gen ser3 = artsentertainmentandrecreation + otherservicesexceptgovernment
gen ser4 = utilities
gen ser5 = financeandinsurance + realestateandrentalandleasing + information + professionalscientificandtechnic+ legalservices + computersystem 

replace administrativeandwastemanagement = 0 if administrativeandwastemanagement==.
gen ser6 = managementofcompaniesandenterpri + administrativeandwastemanagement + educationalservices +healthcareandsocialassistance + government
replace administrativeandwastemanagement =. if administrativeandwastemanagement==0
gen serh =ser5+ser6
gen serl =ser1 + ser2 + ser3 + ser4
gen serh_s = serh/fulltime
gen serl_s = serl/fulltime
label variable serl_s "Low skill service emp share"
label variable serh_s "High skill service emp share"

twoway (line A_s year)(line I_s year) (line serl_s year)(line serh_s year)
save us_emp_detail.dta, replace



*************************** China ****************************
*************************** SC    ****************************

cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\cn_SC"
gen A_s = primary / gdp
gen I_s = secondary / gdp
gen S_s = service / gdp
label variable A_s "Agri VA share"
label variable I_s "Industry VA share"
label variable S_s "Service VA share"
save cn_sc1978-2020,replace
use cn_emp1952-2020,clear

* merge 
use cn_laboryearbook78-20, clear
keep year serh_s serl_s
rename serh_s serh
rename serl_s serl
merge 1:1 year using cn_emp1952-2020
sort year
replace serh = 0.1771765 if serh==.
replace serl = 0.2228656 if serl==.
capture drop serh_s serl_s
gen serh_s = serh/(serh+serl)*S_s
gen serl_s = serl/(serh+serl)*S_s
drop _merge

sort year
save cn_emp1952-2020,replace

* employment share
twoway (line A_s year) (line I_s year) (line serh_s year) (line serl_s year), graphregion(color(white)) title("China Three Main Industries Value Added Share") ytitle("Employment Share")
twoway (lpoly A_s year) (lpoly I_s year) (lpoly serh_s year) (lpoly serl_s year), graphregion(color(white)) title("China Three Main Industries Employment Share") ytitle("Employment Share")