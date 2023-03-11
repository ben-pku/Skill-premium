*******************************************************
********** NBER CES data --- US manufacturing *********
** edited on 14， June 2022   Zhuokai Huang

clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\US_SC"
use "nberces5818v1_n2012", clear

merge m:1 year using ".\NIPA_raw\t_empnum_nipa.dta"
keep if _merge==3
drop _merge 
label variable t_emp "total employment in the US, in thousand" 
* emp share of 6-digit manufacturing
gen emp_s = emp/t_emp
label variable emp_s "emp share of the manufacturing sector wrt the whole US"

twoway (scatter emp_s year, msize(vtiny)),graphregion(color(white))
* animal food
twoway (line emp_s year if(naics== 311111 )) (line emp_s year if(naics== 311119 )),graphregion(color(white))

* flour 
twoway (line emp_s year if(naics== 311211 )) (line emp_s year if(naics== 311212 )) (line emp_s year if(naics== 311213 )),graphregion(color(white))

* Starch and Vegetable Fats and Oils Manufacturing
twoway (line emp_s year if(naics== 311221)) (line emp_s year if(naics== 311224 )) (line emp_s year if(naics== 311225 )),graphregion(color(white))

* Breakfast Cereal Manufacturing
twoway (line emp_s year if(naics== 311230)), graphregion(color(white))

* Sugar and Confectionery Product Manufacturing
twoway (line emp_s year if(naics== 311313)) (line emp_s year if(naics== 311314)), graphregion(color(white))

* Nonchocolate Confectionery Manufacturing  ---   Chocolate and Confectionery Manufacturing
twoway (line emp_s year if(naics== 311340)) (line emp_s year if(naics== 311351))  (line emp_s year if(naics== 311352)), graphregion(color(white))

* Fruit and Vegetable Preserving and Specialty Food Manufacturing  311412--Frozen Specialty Food Manufacturing 
twoway (line emp_s year if(naics== 311411)) (line emp_s year if(naics== 311412)), graphregion(color(white))
twoway (line emp_s year if(naics== 311421)) (line emp_s year if(naics== 311422)) (line emp_s year if(naics== 311423)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3"))

* Dairy Product Manufacturing
twoway (line emp_s year if(naics== 311511)) (line emp_s year if(naics== 311512)) (line emp_s year if(naics== 311513)) (line emp_s year if(naics== 311514)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4"))
*  311513
line emp_s year if(naics== 311520)

* Animal Slaughtering and Processing
twoway (line emp_s year if(naics== 311611)) (line emp_s year if(naics== 311612)) (line emp_s year if(naics== 311613)) (line emp_s year if(naics== 311615)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4"))
* 311615 Poultry Processing 

* Seafood Product Preparation and Packaging
line emp_s year if(naics==311710)

* Bakeries and Tortilla Manufacturing
twoway (line emp_s year if(naics== 311811)) (line emp_s year if(naics== 311812)) (line emp_s year if(naics== 311813)) (line emp_s year if(naics== 311821)) (line emp_s year if(naics== 311824)) (line emp_s year if(naics== 311830)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
* -311811 -311813 Frozen Cakes, Pies, and Other Pastries Manufacturing  -311830 Tortilla Manufacturing

* Other Food Manufacturing
twoway (line emp_s year if(naics== 311911)) (line emp_s year if(naics== 311919)) (line emp_s year if(naics== 311920)) (line emp_s year if(naics== 311930)) (line emp_s year if(naics== 311941)) (line emp_s year if(naics== 311942)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
line emp_s year if(naics== 311991) //311991 Perishable Prepared Food Manufacturing ,increasing
line emp_s year if(naics== 311999)

*3121	Beverage Manufacturing
twoway (line emp_s year if(naics== 312111)) (line emp_s year if(naics== 312112)) (line emp_s year if(naics== 312113)) (line emp_s year if(naics== 312120)) (line emp_s year if(naics== 312130)) (line emp_s year if(naics== 312140)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
* 312130  Wineries 

* 3122	Tobacco Manufacturing
line emp_s year if(naics== 312230)

* 313	Textile Mills
twoway (line emp_s year if(naics== 313110)) (line emp_s year if(naics== 313210)) (line emp_s year if(naics== 313220)) (line emp_s year if(naics== 313230)) (line emp_s year if(naics== 313240)) (line emp_s year if(naics== 313310)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
line emp_s year if naics==313320

*314	Textile Product Mills
twoway (line emp_s year if(naics== 314110)) (line emp_s year if(naics== 314120)) (line emp_s year if(naics== 314910)) (line emp_s year if(naics== 314994)) (line emp_s year if(naics== 314999)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* 315	Apparel Manufacturing
twoway (line emp_s year if(naics== 315110)) (line emp_s year if(naics== 315190)) (line emp_s year if(naics== 315210)) (line emp_s year if(naics== 315220)) (line emp_s year if(naics== 315240)) (line emp_s year if(naics== 315280)) (line emp_s year if(naics== 315990)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* 316	Leather and Allied Product Manufacturing
twoway (line emp_s year if(naics== 316110)) (line emp_s year if(naics== 316210)) (line emp_s year if(naics== 316992)) (line emp_s year if(naics== 316998)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* 321	Wood Product Manufacturing
twoway (line emp_s year if(naics== 321113)) (line emp_s year if(naics== 321114)) (line emp_s year if(naics== 321211)) (line emp_s year if(naics== 321212)) (line emp_s year if(naics== 321213)) (line emp_s year if(naics== 321214)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
*321213	Engineered Wood Member (except Truss) Manufacturing 
*321214	Truss Manufacturing 
twoway (line emp_s year if(naics== 321219)) (line emp_s year if(naics== 321911)) (line emp_s year if(naics== 321912)) (line emp_s year if(naics== 321918)) (line emp_s year if(naics== 321920)) (line emp_s year if(naics== 321991)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

line emp_s year if naics==321992 
line emp_s year if naics==321999

* 322	Paper Manufacturing
twoway (line emp_s year if(naics== 322110)) (line emp_s year if(naics== 322121)) (line emp_s year if(naics== 322122)) (line emp_s year if(naics== 322130)) (line emp_s year if(naics== 322211)) (line emp_s year if(naics== 322212)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
twoway (line emp_s year if(naics== 322219)) (line emp_s year if(naics== 322220)) (line emp_s year if(naics== 322230)) (line emp_s year if(naics== 322291)) (line emp_s year if(naics== 322299)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* 323	Printing and Related Support Activities
twoway (line emp_s year if(naics== 323111)) (line emp_s year if(naics== 323113)) (line emp_s year if(naics== 323117)) (line emp_s year if(naics== 323120)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* 324	Petroleum and Coal Products Manufacturing
twoway (line emp_s year if(naics== 324110))  (line emp_s year if(naics== 324121)) (line emp_s year if(naics== 324122)) (line emp_s year if(naics== 324191)) (line emp_s year if(naics== 324199)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

*325	Chemical Manufacturing
twoway  (line emp_s year if(naics== 325120)) (line emp_s year if(naics== 325130)) (line emp_s year if(naics== 325180)) (line emp_s year if(naics== 325193)) (line emp_s year if(naics== 325194))(line emp_s year if(naics== 325199)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
(line emp_s year if(naics== 325110))
* 325193 Ethyl Alcohol Manufacturing 

twoway  (line emp_s year if(naics== 325211)) (line emp_s year if(naics== 325212)) (line emp_s year if(naics== 325220)) (line emp_s year if(naics== 325311)) (line emp_s year if(naics== 325312))(line emp_s year if(naics== 325314)) (line emp_s year if(naics== 325320)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* !!!3254	Pharmaceutical and Medicine Manufacturing
twoway (line emp_s year if(naics== 325411)) (line emp_s year if(naics== 325412))  (line emp_s year if(naics== 325413)) (line emp_s year if(naics== 325414)) , graphregion(color(white)) legend(label(1 "Medicinal and Botanical") label(2 "Pharmaceutical Preparation") label(3 "In-Vitro Diagnostic Substance") label(4 "Biological Product (except Diagnostic)") label(5 "5") label(6 "6")) title("Pharmaceutical and Medicine Manufacturing, US") ytitle("emp share") xtitle("year")
*325411	Medicinal and Botanical Manufacturing 
*325412	Pharmaceutical Preparation Manufacturing 
*325413	In-Vitro Diagnostic Substance Manufacturing 
*325414	Biological Product (except Diagnostic) Manufacturing 

*3255	Paint, Coating, and Adhesive Manufacturing
twoway  (line emp_s year if(naics== 325510)) (line emp_s year if(naics== 325520)) (line emp_s year if(naics== 325611)) (line emp_s year if(naics== 325612)) (line emp_s year if(naics== 325613))(line emp_s year if(naics== 325620)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

twoway  (line emp_s year if(naics== 325910)) (line emp_s year if(naics== 325920)) (line emp_s year if(naics== 325991)) (line emp_s year if(naics== 325992)) (line emp_s year if(naics== 325998)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* 325991	Custom Compounding of Purchased Resins 

* 326	Plastics and Rubber Products Manufacturing
twoway  (line emp_s year if(naics== 326111)) (line emp_s year if(naics== 326112)) (line emp_s year if(naics== 326113)) (line emp_s year if(naics== 326121)) (line emp_s year if(naics== 326122))(line emp_s year if(naics== 326130)) (line emp_s year if(naics== 326140)) (line emp_s year if(naics== 326150)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
*326112	Plastics Packaging Film and Sheet (including Laminated) Manufacturing 
*326122	Plastics Pipe and Pipe Fitting Manufacturing 

*327	Nonmetallic Mineral Product Manufacturing
twoway  (line emp_s year if(naics== 327110)) (line emp_s year if(naics== 327120)) (line emp_s year if(naics== 327211)) (line emp_s year if(naics== 327212)) (line emp_s year if(naics== 327213))(line emp_s year if(naics== 327215)) (line emp_s year if(naics== 327310)) (line emp_s year if(naics== 327320)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

twoway (line emp_s year if(naics==327331))(line emp_s year if(naics== 327332)) (line emp_s year if(naics== 327390)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

twoway  (line emp_s year if(naics== 327410)) (line emp_s year if(naics== 327420)) (line emp_s year if(naics== 327910)) (line emp_s year if(naics== 327991)) (line emp_s year if(naics== 327992))(line emp_s year if(naics== 327993)) (line emp_s year if(naics== 327999)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* 331	Primary Metal Manufacturing
twoway   (line emp_s year if(naics== 331210)) (line emp_s year if(naics== 331221)) (line emp_s year if(naics== 331222)) (line emp_s year if(naics== 331313))(line emp_s year if(naics== 331314)) (line emp_s year if(naics== 331315)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )
(line emp_s year if(naics== 331110))

twoway   (line emp_s year if(naics== 331318)) (line emp_s year if(naics== 331410)) (line emp_s year if(naics== 331420)) (line emp_s year if(naics== 331491))(line emp_s year if(naics== 331492)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )


* 332	Fabricated Metal Product Manufacturing
twoway   (line emp_s year if(naics== 332111)) (line emp_s year if(naics== 332112)) (line emp_s year if(naics== 332114)) (line emp_s year if(naics== 332117))(line emp_s year if(naics== 332119)) (line emp_s year if(naics== 332215)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

twoway   (line emp_s year if(naics== 332216)) (line emp_s year if(naics== 332112)) (line emp_s year if(naics== 332114)) (line emp_s year if(naics== 332117))(line emp_s year if(naics== 332119)) (line emp_s year if(naics== 332215)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

* 333	Machinery Manufacturing
twoway   (line emp_s year if(naics== 333111)) (line emp_s year if(naics== 333112)) (line emp_s year if(naics== 333120)) (line emp_s year if(naics== 333132)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

twoway   (line emp_s year if(naics== 333241)) (line emp_s year if(naics== 333242)) (line emp_s year if(naics== 333243)) (line emp_s year if(naics== 333244))(line emp_s year if(naics== 333249))  , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

twoway   (line emp_s year if(naics== 333314)) (line emp_s year if(naics== 333316)) (line emp_s year if(naics== 333318))  , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

twoway   (line emp_s year if(naics== 333413)) (line emp_s year if(naics== 333414)) (line emp_s year if(naics== 333415))  , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

twoway   (line emp_s year if(naics== 333511)) (line emp_s year if(naics== 333514)) (line emp_s year if(naics== 333515)) (line emp_s year if(naics== 333517)) (line emp_s year if(naics== 333519)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

twoway   (line emp_s year if(naics== 333611)) (line emp_s year if(naics== 333612)) (line emp_s year if(naics== 333613)) (line emp_s year if(naics== 333618)) (line emp_s year if(naics== 333911))(line emp_s year if(naics== 333912))(line emp_s year if(naics== 333913)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )
line emp_s year if(naics== 333611) //--- not good increasing just after 2000

twoway   (line emp_s year if(naics== 333921)) (line emp_s year if(naics== 333922)) (line emp_s year if(naics== 333923)) (line emp_s year if(naics== 333924)) (line emp_s year if(naics== 333991))(line emp_s year if(naics== 333992))(line emp_s year if(naics== 333993)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

twoway   (line emp_s year if(naics== 333994)) (line emp_s year if(naics== 333995)) (line emp_s year if(naics== 333996)) (line emp_s year if(naics== 333997)) (line emp_s year if(naics== 333999)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

*334	Computer and Electronic Product Manufacturing
twoway   (line emp_s year if(naics== 334111)) (line emp_s year if(naics== 334112)) (line emp_s year if(naics== 334118)) (line emp_s year if(naics== 334210)) (line emp_s year if(naics== 334220))(line emp_s year if(naics== 334290))(line emp_s year if(naics== 334310)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )
line emp_s year if(naics== 334111) // falling after 2000

twoway   (line emp_s year if(naics== 334412)) (line emp_s year if(naics== 334413)) (line emp_s year if(naics== 334416)) (line emp_s year if(naics== 334417)) (line emp_s year if(naics== 334418))(line emp_s year if(naics== 334419))(line emp_s year if(naics== 334310)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )


twoway   (line emp_s year if(naics== 334510))  (line emp_s year if(naics== 334512)) (line emp_s year if(naics== 334513)) (line emp_s year if(naics== 334514))(line emp_s year if(naics== 334515))(line emp_s year if(naics== 334516)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )
(line emp_s year if(naics== 334511))

*334512	Automatic Environmental Control Manufacturing for Residential, Commercial, and Appliance Use 
*334515	Instrument Manufacturing for Measuring and Testing Electricity and Electrical Signals 

twoway   (line emp_s year if(naics== 334517))  (line emp_s year if(naics== 334519)) (line emp_s year if(naics== 334613)) (line emp_s year if(naics== 334614))(line emp_s year if(naics== 334515))(line emp_s year if(naics== 334516)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") )

*334517	Irradiation Apparatus Manufacturing 

*335	Electrical Equipment, Appliance, and Component Manufacturing
twoway  (line emp_s year if(naics== 335110)) (line emp_s year if(naics== 335121)) (line emp_s year if(naics== 335122)) (line emp_s year if(naics== 335129)) (line emp_s year if(naics== 335210))(line emp_s year if(naics== 335221)) (line emp_s year if(naics== 335222)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

twoway  (line emp_s year if(naics== 335224)) (line emp_s year if(naics== 335228)) (line emp_s year if(naics== 335311)) (line emp_s year if(naics== 335312)) (line emp_s year if(naics== 335313))(line emp_s year if(naics== 335314)) (line emp_s year if(naics== 335911)) (line emp_s year if(naics== 335912)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

twoway  (line emp_s year if(naics== 335224)) (line emp_s year if(naics== 335228)) (line emp_s year if(naics== 335311)) (line emp_s year if(naics== 335312)) (line emp_s year if(naics== 335313))(line emp_s year if(naics== 335314)) (line emp_s year if(naics== 335911)) (line emp_s year if(naics== 335912)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

twoway  (line emp_s year if(naics== 335921)) (line emp_s year if(naics== 335929)) (line emp_s year if(naics== 335931)) (line emp_s year if(naics== 335932)) (line emp_s year if(naics== 335991))(line emp_s year if(naics== 335999)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

*336	Transportation Equipment Manufacturing

twoway  (line emp_s year if(naics== 335224)) (line emp_s year if(naics== 335228)) (line emp_s year if(naics== 335311)) (line emp_s year if(naics== 335312)) (line emp_s year if(naics== 335313))(line emp_s year if(naics== 335314)) (line emp_s year if(naics== 335911)) (line emp_s year if(naics== 335912)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

twoway  (line emp_s year if(naics== 336111)) (line emp_s year if(naics== 336112)) (line emp_s year if(naics== 336120)) (line emp_s year if(naics== 336211)) (line emp_s year if(naics== 336212))(line emp_s year if(naics== 336213)) (line emp_s year if(naics== 336214)) (line emp_s year if(naics== 336310)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

*336211	Motor Vehicle Body Manufacturing 
*336214	Travel Trailer and Camper Manufacturing 

twoway  (line emp_s year if(naics== 336320)) (line emp_s year if(naics== 336330)) (line emp_s year if(naics== 336340)) (line emp_s year if(naics== 336350)) (line emp_s year if(naics== 336360)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

(line emp_s year if(naics== 336370)) (line emp_s year if(naics== 336390)) (line emp_s year if(naics== 336411))

*336360	Motor Vehicle Seating and Interior Trim Manufacturing

twoway  (line emp_s year if(naics== 336412)) (line emp_s year if(naics== 336413)) (line emp_s year if(naics== 336414)) (line emp_s year if(naics== 336415)) (line emp_s year if(naics== 336419)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

twoway  (line emp_s year if(naics== 336510)) (line emp_s year if(naics== 336611)) (line emp_s year if(naics== 336612)) (line emp_s year if(naics== 336991)) (line emp_s year if(naics== 336992))(line emp_s year if(naics== 336999)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))
*336999	All Other Transportation Equipment Manufacturing 



*337	Furniture and Related Product Manufacturing
twoway  (line emp_s year if(naics== 337110)) (line emp_s year if(naics== 337121)) (line emp_s year if(naics== 337122)) (line emp_s year if(naics== 337124)) (line emp_s year if(naics== 337125))(line emp_s year if(naics== 337127)) (line emp_s year if(naics== 337211)) (line emp_s year if(naics== 337212)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

* 337212	Custom Architectural Woodwork and Millwork Manufacturing 

twoway  (line emp_s year if(naics== 337214)) (line emp_s year if(naics== 337215)) (line emp_s year if(naics== 337910)) (line emp_s year if(naics== 337920)) , graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))


*339	Miscellaneous Manufacturing
twoway  (line emp_s year if(naics== 339112)) (line emp_s year if(naics== 339113)) (line emp_s year if(naics== 339114)) (line emp_s year if(naics== 339115)) (line emp_s year if(naics== 339116))(line emp_s year if(naics== 339910)) (line emp_s year if(naics== 339920)) (line emp_s year if(naics== 339930)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

*339112	Surgical and Medical Instrument Manufacturing  -- reasonable
twoway  (line emp_s year if(naics== 339940)) (line emp_s year if(naics== 339950)) (line emp_s year if(naics== 339991)) (line emp_s year if(naics== 339992)) (line emp_s year if(naics== 339993))(line emp_s year if(naics== 339994)) (line emp_s year if(naics== 339995)) (line emp_s year if(naics== 339999)), graphregion(color(white)) legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6"))

*-- the whole manu share
bysort year: egen t_s = sum(emp_s)
label variable t_s "The US Manufacturing Employment Share"
twoway (line t_s year if(naics==311412)),  graphregion(color(white))  ytitle("employment share") xtitle("year") title("The US Manufacturing Employment Share") 

*-- increasing manu sectors
** 1 increasing trend
twoway (line emp_s year if(naics==311615 |naics==311813|naics==311830|naics==312130|naics==311412 |naics== 321213 ///
	|naics==321214|naics==325193|naics==325411|naics==325413|naics==325414|naics==325991|naics==326112|naics== 326122 ///
	|naics==334517|naics==336211|naics==336360|naics==336999|naics==337212 ///
	|naics ==333611 |naics ==334111)&(naics~=333611&naics~=334111)), by(naics, yrescale graphregion(color(white)))  ylabel(none) ytitle("employment share") xtitle("year") 

** 2 increasing total emp share in the US  --- minority
bysort year: egen inc_s = sum(emp_s) if (naics==311615 |naics==311813|naics==311830|naics==312130|naics==311412 |naics== 321213 ///
	|naics==321214|naics==325193|naics==325411|naics==325413|naics==325414|naics==325991|naics==326112|naics== 326122 ///
	|naics==334517|naics==336211|naics==336360|naics==336999|naics==337212 ///
	|naics ==333611 |naics ==334111)&(naics~=333611&naics~=334111)
label variable inc_s "Increasing Manufacturing Employment Share"	
twoway (line inc_s year if(naics==311412)) (line t_s year if(naics==311412)),  graphregion(color(white))  ytitle("employment share") xtitle("year") title("The US Manufacturing Employment Share") legend(label(1 "increasing") label(2 "Total manufacturing"))

*-- biological 4 sectors
*325411	Medicinal and Botanical Manufacturing 
*325412	Pharmaceutical Preparation Manufacturing 
*325413	In-Vitro Diagnostic Substance Manufacturing 
*325414	Biological Product (except Diagnostic) Manufacturing 
bysort year: egen bio_s = sum(emp_s) if( naics==325411| naics == 325412 | naics == 325413 | naics == 325414)
label variable bio_s "biological sector emp share"
twoway (line bio_s year if(naics==325411)), graphregion(color(white)) ytitle("employment share") xtitle("year") title("Biological Employment Share")

*-- typical two manu:
twoway (line emp_s year if(naics==333611|naics==334111)), by(naics,yrescale graphregion(color(white)))  plotregion(color(white)) ytitle("employment share") xtitle("year") 


save us_manu_emp_naics,replace
/*keep if  naics==311615 |naics==311813|naics==311830|naics==312130|naics==311412 |naics== 321213 ///
	|naics==321214|naics==325193|naics==325411|naics==325413|naics==325414|naics==325991|naics==326112|naics== 326122 ///
	|naics==334517|naics==336211|naics==336360|naics==336999|naics==337212 ///
	|naics ==333611 |naics ==334111         */

	
***** generate data files to draw figures by python
*-- increasing manu sectors
** 1 increasing trend
use us_manu_emp_naics,clear
keep if (naics==311615 |naics==311813|naics==311830|naics==312130|naics==311412 |naics== 321213 ///
	|naics==321214|naics==325193|naics==325411|naics==325413|naics==325414|naics==325991|naics==326112|naics== 326122 ///
	|naics==334517|naics==336211|naics==336360|naics==336999|naics==337212 ///
	|naics ==333611 |naics ==334111)&(naics~=333611&naics~=334111)
keep year emp_s naics
reshape wide emp_s,i(year) j(naics)
save us_manu_incdetail,replace

** 2 increasing total emp share in the US  --- minority
use us_manu_emp_naics,clear
keep year inc_s t_s
keep if inc_s ~=.
collapse inc_s t_s,by(year)
save us_manu_t_inc,replace

*-- biological 4 sectors
*325411	Medicinal and Botanical Manufacturing 
*325412	Pharmaceutical Preparation Manufacturing 
*325413	In-Vitro Diagnostic Substance Manufacturing 
*325414	Biological Product (except Diagnostic) Manufacturing 
use us_manu_emp_naics,clear
keep year bio_s
keep if bio_s~=.
collapse bio_s ,by(year)
save us_biomanu,replace

*-- typical two manu:
use us_manu_emp_naics,clear
keep if(naics==333611|naics==334111)
keep year naics emp_s
reshape wide emp_s, i(year) j(naics)
save us_typical_manu,replace


*******
keep naics year emp_s
reshape wide emp_s, i(year) j(naics)
sort year


reshape long emp_s, i(year) j(naics)



clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\US_SC"
use "nberces5818v1_n2012", clear

tostring naics, replace
gen naics3 = substr(naics, 1,3)
collapse (sum) emp , by(naics3 year)

bysort year: egen t_emp  = sum(emp)
gen emp_s = emp/t_emp
sort year naics3
destring naics3, replace
gen high = (naics3==312 | naics3==323 | naics3==324|naics3==325|naics3==331|naics3==333|naics3==334|naics3==335|naics3==336)

collapse t_emp (sum) emp emp_s, by(year high)
twoway (scatter emp_s year if high==0, msize(small)  )  (scatter emp_s year if high==1,  msize(small)), graphregion(color(white)) legend( label(1 "low-skill")  label(2 "high-skill")) scheme(s1mono) xtitle("year") ytitle("emp. share in manu.")
save highlow-manu-us,replace