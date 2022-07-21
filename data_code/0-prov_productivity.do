****** productivity of ag se and te ********
clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\to_be_determined\data\urban_rural\productivity"

use prov_em_product_panel78-20.dta,clear

egen provid = group(prov)
xtset provid year
* productivity
gen g_p = gdp/employ
gen ag_p = ag/agem
gen se_p = se/seem
gen te_p = te/teem
gen nonag_p = (se+te)/(seem+teem)
label variable g_p "gdp labor productivity"
label variable ag_p "agri labor productivity"
label variable se_p "secondary labor productivity"
label variable te_p "tertiary labor productivity"
label variable nonag_p "nonagri labor productivity"

* growth rate of productivity
foreach x of varlist g_p ag_p se_p te_p nonag_p{
	gen `x'l = l.`x'
	gen `x'gr = `x'/`x'l - 1
	label variable `x'gr "growth rate of `x' "
}


