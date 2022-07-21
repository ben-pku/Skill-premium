*********************
**** structural change ************
* US
* output
clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\US_SC"
save "us_sc1947-2021.dta",replace
use "us_sc1947-2021.dta",clear
gen A_s = agri / all
gen I_s = second / all
gen S_s = tertiary / all
label variable A_s "Agri output share"
label variable I_s "Industry output share"
label variable S_s "Service output share"

twoway (line A_s year) (line I_s year) (line S_s year), graphregion(color(white)) title("The US Three Main Industries Output Share") ytitle("Output Share")

* Value added
save "us_va1947-2021.dta",replace
use "us_va1947-2021.dta",clear
gen A_s = agri/gross
gen I_s = (mining +utilities +construction +manufacturing )/gross
gen S_s = (wholesale +retailtrade +transportation + information +financeinsurance + professionalandbusi + educationalserviceshealth +artsentertainmentrecreationaccom +otherservices +government) / gross

label variable A_s "Agri VA share"
label variable I_s "Industry VA share"
label variable S_s "Service VA share"
twoway (line A_s year) (line I_s year) (line S_s year), graphregion(color(white)) title("The US Three Main Industries Value Added Share") ytitle("VA Share")
save "us_va1947-2021.dta",replace

* employment share
save "us_emp1929-2021.dta",replace
use "us_emp1929-2021.dta",clear
gen A_s = primary/full
gen I_s = secondary/full
gen S_s = tertiary/full
label variable A_s "Agri employment share"
label variable I_s "Industry employment share"
label variable S_s "Service employment share"
twoway (line A_s year) (line I_s year) (line S_s year), graphregion(color(white)) title("The US Three Main Industries Employment Share") ytitle("employment Share")
save "us_emp1929-2021.dta",replace


* China
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\cn_SC"
gen A_s = primary / gdp
gen I_s = secondary / gdp
gen S_s = service / gdp
label variable A_s "Agri VA share"
label variable I_s "Industry VA share"
label variable S_s "Service VA share"
save cn_sc1978-2020,replace
use cn_sc1978-2020,clear
twoway (line A_s year) (line I_s year) (line S_s year), graphregion(color(white)) title("China Three Main Industries Value Added Share") ytitle("VA Share")

* employment share
save cn_emp1952-2020,replace
twoway (lpoly A_s year) (lpoly I_s year) (lpoly S_s year), graphregion(color(white)) title("China Three Main Industries Employment Share") ytitle("Employment Share")


