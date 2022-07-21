***************************************************************************
************************** US Skill intensity *****************************
***************************************************************************
* edited on 11 June, 2022 Zhuokai Huang

clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps"

use "cps_00008.dta", clear
gen high = (educ>=70 & educ~=999)
gen college = (educ>=80 & educ~=999)
gen bachelor = (educ>=111 & educ~=999)

* employment share
bysort year ind1990: egen emp = sum(asecwt)
bysort year ind1990: egen emp_h = sum(asecwt) if high==1
bysort year ind1990: egen emp_c = sum(asecwt) if college==1
bysort year ind1990: egen emp_b = sum(asecwt) if bachelor==1

gen emp_hs = emp_h/emp
gen emp_cs = emp_c/emp
gen emp_bs = emp_b/emp

preserve
collapse emp_hs emp_cs emp_bs,by(year ind1990)
save skill_intensity_d.dta,replace
restore

save cps,replace

use skill_intensity_d,clear
drop if ind1990==.
gsort year -emp_cs
 *generate order
by year: gen or=_n    
drop if ind1990==998 | ind1990==0

twoway (line emp_cs year),by(ind1990)

reshape wide emp* or, i(ind1990) j(year) //排名不是很稳定，我觉得可能需要把行业分类分得更粗一些, 依照Buera的分类方法来分

gen A=(ind1990<=32)
gen I = (ind1990>32 & ind1990<=392)
gen S = (ind1990>392)
preserve
keep if S==1
save S_or, replace
restore
preserve 
keep if A==1
save S_or, replace
restore
preserve 
keep if I==1
save S_or, replace
restore

save skill_intensity_d_wide,replace

* Service
clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps"

use "cps_00008.dta", clear
gen A=(ind1990<=32)
gen I = (ind1990>32 & ind1990<=392)
gen S = (ind1990>392)
bysort year: egen t_emp = sum(asecwt) if (empstat==10 | empstat==12)

keep if S==1
gen high = (educ>=70 & educ~=999)
gen college = (educ>=80 & educ~=999)
gen bachelor = (educ>=111 & educ~=999)
** category service sectors
gen ind_n =.
label variable ind_n "new ind"
replace ind_n=1 if ind1990>=400 & ind1990<=442
replace ind_n=2 if ((ind1990>=500 & ind1990<=691)| ind1990==762)
replace ind_n=3 if (( ind1990>=761 & ind1990<=791)& ind1990~=762)
replace ind_n=4 if (ind1990>=450 & ind1990<=472)
replace ind_n=5 if ((ind1990>=721 & ind1990<=760) | (ind1990>=700 & ind1990<=712) | ((ind1990>=812 & ind1990<=893)& ind1990~=832  & ind1990~=840 & ind1990~=860 & ind1990~=871) )
replace ind_n=6 if ( (ind1990>=900 & ind1990<=991)| ind1990==832|ind1990==840|ind1990==860|ind1990==871)
drop if ind1990==998 | ind1990==0|ind1990==.

* employment share
bysort year ind_n: egen emp = sum(asecwt)
bysort year ind_n: egen emp_c = sum(asecwt) if college==1

gen emp_cs = emp_c/emp
gen emp_s = emp/t_emp

collapse  emp_cs emp_s ,by(year ind_n)
label variable emp_s "employment share"
label variable emp_cs "skill intensity, college employment"

gsort year -emp_cs
 *generate order
drop if ind_n==.
by year: gen or=_n    

reshape wide emp_cs emp_s or,i(year) j(ind_n)
tabstat or*,stat(min mean max)
twoway (line emp_cs1 year if year>1979) (line emp_cs2 year if year>1979)(line emp_cs3 year if year>1979)(line emp_cs4 year if year>1979)(line emp_cs5 year if year>1979)(line emp_cs6 year if year>1979),graphregion(color(white)) title("Skill intensity of Service, the US") legend(label(1 "Transportation&Telecommunication") label(2 "Trade services") label(3 "Personal services") label(4 "Utilities") label(5 "Business services") label(6 "Government services"))

twoway (line emp_s1 year if year>1979) (line emp_s2 year if year>1979)(line emp_s3 year if year>1979)(line emp_s4 year if year>1979)(line emp_s5 year if year>1979)(line emp_s6 year if year>1979),graphregion(color(white)) title("Employment Share of Service, the US") legend(label(1 "Transportation&Telecommunication") label(2 "Trade services") label(3 "Personal services") label(4 "Utilities") label(5 "Business services") label(6 "Government services"))

*reshape long emp_cs emp_s or,i(year) j(ind_n)
*twoway (line emp_s year if year>1979),by(ind_n) graphregion(color(white)) 
gen low_emp = emp_s1+emp_s2+emp_s3+emp_s4
gen high_emp = emp_s5+emp_s6
twoway (line low_emp year) (line high_emp year),graphregion(color(white)) title("Service Employment Share, the US") legend(label(1 "Low-skill") label(2 "High-skill"))
save "S_inten", replace

* Second industry: 
clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\skill_premium\us_sp\cps"

use "cps_00008.dta", clear
gen A=(ind1990<=32)
gen I = (ind1990>32 & ind1990<=392)
gen S = (ind1990>392)
bysort year: egen t_emp = sum(asecwt) if (empstat==10 | empstat==12)

keep if I==1
gen high = (educ>=70 & educ~=999)
gen college = (educ>=80 & educ~=999)
gen bachelor = (educ>=111 & educ~=999)
* category of Secondary-- Buera 2021 RES
gen klems = .
replace klems = 8 if (ind1990>=180& ind1990<=192)
replace klems = 13 if (ind1990==322 |(ind1990>=340 & ind1990<=350)|(ind1990>=371& ind<=381))
replace klems = 7 if (ind1990>=200 & ind1990<=201)
replace klems = 15 if (ind1990>=390 & ind1990<=392)
replace klems = 6 if (ind1990>=160 & ind1990<=172)
replace klems = 2 if (ind1990>=40 & ind1990<=50)
replace klems = 14 if (ind1990>=352 & ind1990<=370)
replace klems = 12 if (ind1990>=310 & ind1990<=332 & ind1990~=322)
replace klems = 3 if (ind1990>=100 & ind1990<=130)
replace klems = 9 if (ind1990>=210 & ind1990<=212)
replace klems = 10 if (ind1990>=250 & ind1990<=262)
replace klems = 18 if (ind1990==351)
replace klems = 11 if (ind1990>=270 & ind1990<=301)
replace klems = 4 if ((ind1990>=132 & ind1990<=152)|(ind1990>=220 & ind1990<=222))
replace klems = 17 if (ind1990==60)
replace klems = 5 if (ind1990>=230 & ind1990<=242)
drop if ind1990==998 | ind1990==0|ind1990==.
* employment share
bysort year klems: egen emp = sum(asecwt)
bysort year klems: egen emp_c = sum(asecwt) if college==1

gen emp_cs = emp_c/emp
gen emp_s = emp/t_emp
collapse  emp_cs emp_s ,by(year klems)
label variable emp_s "employment share"
label variable emp_cs "skill intensity, college employment"
gsort year -emp_cs
 *generate order
drop if klems==.
by year: gen or=_n   
* check the relatively stable order
reshape wide emp_cs emp_s or,i(year) j(klems)
tabstat or*,stat(min mean max)
* growth of skill intensity
reshape long emp_cs emp_s or,i(year) j(klems)
twoway (line emp_cs year),by(klems) graphregion(color(white))
* emp share change
gen skill_i = (klems==8|klems==13|klems==7|klems==6|klems==2|klems==14|klems==12|klems==18)
collapse (sum) emp_s, by(year skill_i)
reshape wide emp_s, i(year) j(skill_i)
twoway (line emp_s0 year) (line emp_s1 year),graphregion(color(white)) title("Manufacturing Employment Share, the US") legend(label(1 "Low-skill") label(2 "High-skill"))
save "I_inten", replace


*******- China Census 1990, 2000 Data  ******************
clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\census_skill_intensity"

use ipumsi_00002.dta,clear
append using ipumsi_00003

gen klems = .   //secondary
gen ind_n = .  //service
* secondary
replace klems = 8 if ( ( ( ind>=311&ind<=334   )&year==1982)|( (  ind>=361&ind<=413   )&year==1990)|(  (  ind>=26&ind<=28   )&year==2000) )
replace klems = 13 if ( ( ( (ind>=441&ind<=459 )|ind==483|ind==484|ind==486|ind==487|ind==489|ind==490   )&year==1982)|( (  ind>=588&ind<=639  )&year==1990)|(  ( ind==40|ind==41   )&year==2000) )
replace klems = 7 if ( ( (  ind>=361&ind<=369  )&year==1982)|( (  ind>=331&ind<=353&ind~=333  )&year==1990)|(  ( ind==25   )&year==2000) )
replace klems = 15 if ( ( (  (ind>=291&ind<=293)|ind==481|ind==482|ind==485|ind==488|(ind>=491& ind<=500)  )&year==1982)|( (  (ind>=301&ind<=315)|ind==319|(ind>=513&ind<=516)|(ind>=661&ind<=662)  )&year==1990)|(  ( ind==24|ind==39   )&year==2000) )
replace klems = 6 if ( ( ( (ind>=281&ind<=283)|ind==294   )&year==1982)|( (  ind>=281&ind<=290  )&year==1990)|(  ( ind>=21&ind<=23   )&year==2000) )
replace klems = 2 if ( ( (ind==60|ind==70|(ind>=81&ind<=84)    )&year==1982)|( ( (  ind>=81&ind<=93)|(ind>=101&ind<=116)   )&year==1990)|(  (  ind>=6&ind<=11  )&year==2000) )
replace klems = 14 if ( ( ( ind>=471&ind<=479&ind~=472   )&year==1982)|( ( (ind>=564&ind<=567)|ind==561|ind==581   )&year==1990)|(  ( ind==37   )&year==2000) )
replace klems = 12 if ( ( (  ind>=421&ind<=439  )&year==1982)|( ((  ind>=517&ind<=559  )|( ind>=582&ind<=587  )    )&year==1990)|(  ( (ind>=35&ind<=36)|(ind>=42&ind<=43)   )&year==2000) )
replace klems = 3 if ( ( ( ind>=181&ind<=210   )&year==1982)|( (  ind>=171&ind<=219  )&year==1990)|(  (  ind>=13&ind<=16  )&year==2000) )
replace klems = 9 if ( ( (  ind>=341&ind<=342  )&year==1982)|( (ind==275|(ind>=414&ind<=449)    )&year==1990)|(  ( ind>=29&ind<=30   )&year==2000) )
replace klems = 10 if ( ( ( (ind>=91&ind<=99)|(ind>=371&ind<=379)   )&year==1982)|( ( (ind>=121&ind<=140 )|( ind>=451&ind<=469)   )&year==1990)|(  ( ind==31   )&year==2000) )
replace klems = 18 if ( ( (  ind==472  )&year==1982)|( (  ind>=562&ind<=563  )&year==1990) )
replace klems = 11 if ( ( (  ind>=391&ind<=419  )&year==1982)|( (ind==274 |(ind>=481&ind<=512)   )&year==1990)|(  (  ind>=32&ind<=34  )&year==2000) )
replace klems = 4 if ( ( (  ind>=231&ind<=259  )&year==1982)|( ( (ind>=221&ind<=245)|(ind>=251&ind<=254)|(ind>=316&ind<=318)   )&year==1990)|(  ( ind>=17&ind<=19   )&year==2000) )
replace klems = 17 if ( ( ( ind>=520&ind<=550   )&year==1982)|( ( ind>=691&ind<=710   )&year==1990)|(  (  ind>=47&ind<=49  )&year==2000) )
replace klems = 5 if ( ( (  (ind>=261&ind<=263)|ind==30|ind==120|ind==270  )&year==1982)|( (  (ind>=151&ind<=152)|(ind>=261&ind<=273)|ind==30|ind==279  )&year==1990)|(  ( ind==2|ind==12|ind==20|ind==21  )&year==2000) )

* services
replace ind_n = 1 if ( ( ( (ind>=581&ind<=593)|ind==630   )&year==1982)|( ( (ind>=731&ind<=743)|ind==790|ind==811   )&year==1990)|(  ( ind>=52&ind<=60   )&year==2000) )
replace ind_n = 2 if ( ( ( (ind>=601&ind<=620)|ind==661   )&year==1982)|( ( (ind>=751&ind<=755)|ind==249|ind==780   )&year==1990)|(  ( ind>=61&ind<=65   )&year==2000) )
replace ind_n = 3 if ( ( (  (ind>=662&ind<=669)|(ind>=761&ind<=779)  )&year==1982)|( ( (ind>=568&ind<=569)|(ind>=814&ind<=815)|(ind>=821&ind<=839)|ind==770   )&year==1990)|(  ( ind==67|ind==78|(ind>=80 & ind<=81)   )&year==2000) )
replace ind_n = 4 if ( ( (  ind>=141&ind<=160  )&year==1982)|( ( ind==60|ind==160   )&year==1990)|(  (  ind>=44&ind<=46  )&year==2000) )
replace ind_n = 5 if ( ( (  (ind>=511&ind<=518)|(ind>=801&ind<=850)|ind==640  )&year==1982)|( ( (ind>=671&ind<=678)|(ind>=881&ind<=890)|(ind>=930&ind<=941)|ind==800   )&year==1990)|(  ( (ind>=50&ind<=51)|(ind>=68&ind<=74)|ind==79   )&year==2000) )
replace ind_n = 6 if ( ( ( (ind>=651&ind<=659)|(ind>=691&ind<=759)|(ind>=880&ind<=910)   )&year==1982)|( ( (ind>=812&ind<=813)|(ind>=841&ind<=879)|(ind>=901&ind<=919)|(ind>=950&ind<=980)|ind==819   )&year==1990)|(  ( (ind>=75&ind<=76)|(ind>=82&ind<=97)   )&year==2000) )
save "cn_census82-00",replace

*service
use "cn_census82-00",clear
gen emp = 1 if(ind~=0) 
bysort year: egen t_emp = sum(emp) //total employment
drop if ind_n==.
gen college =.
replace college = (edattaind>=312 & edattaind~=999)
*keep year college edattaind ind_n college t_emp emp

collapse college t_emp (sum) emp ,by(year ind_n)
gen emp_s = emp/t_emp
label variable emp_s "employment share"
label variable college "skill intensity, college"
gsort year -college
by year: gen or=_n

reshape wide college or emp_s emp , i(year) j(ind_n)
* skill intensity
twoway (line college1 year if year>1979) (line college2 year if year>1979)(line college3 year if year>1979)(line college4 year if year>1979)(line college5 year if year>1979)(line college6 year if year>1979),graphregion(color(white)) title("Skill intensity of Service, China") legend(label(1 "Transportation&Telecommunication") label(2 "Trade services") label(3 "Personal services") label(4 "Utilities") label(5 "Business services") label(6 "Government services"))
* employment share
twoway (line emp_s1 year if year>1979) (line emp_s2 year if year>1979)(line emp_s3 year if year>1979)(line emp_s4 year if year>1979)(line emp_s5 year if year>1979)(line emp_s6 year if year>1979),graphregion(color(white)) title("Employment Share of Service, China") legend(label(1 "Transportation&Telecommunication") label(2 "Trade services") label(3 "Personal services") label(4 "Utilities") label(5 "Business services") label(6 "Government services"))

gen low_emp = emp_s1+emp_s2+emp_s3+emp_s4
gen high_emp = emp_s5+emp_s6
twoway (line low_emp year) (line high_emp year),graphregion(color(white)) title("Service Employment Share, China") subtitle("Census") legend(label(1 "Low-skill") label(2 "High-skill"))

* to merge DATA from Economic Census 
gen emp_num0 =emp1+emp2+emp3+emp4
gen emp_num1 = emp5+emp6 
keep year low_emp high_emp emp_num*
rename low_emp emp_s0
rename high_emp emp_s1
rename emp_num0 emp0
rename emp_num1 emp1
reshape long emp_s emp, i(year) j(serh)
save "cn-census-service-emp",replace


* Secondary
use "cn_census82-00",clear
gen emp = 1
bysort year: egen t_emp = sum(emp) //total employment
drop if klems==.
gen college =.
replace college = (edattaind>=312 & edattaind~=999)
collapse college t_emp (sum) emp ,by(year klems)
gen emp_s = emp/t_emp
label variable emp_s "employment share"
label variable college "skill intensity, college"
gsort year -college
by year: gen or=_n
* si change
twoway (line college year), by(klems) graphregion(color(white))
* emp share change
gen skill_i = (klems==8|klems==13|klems==7|klems==6|klems==2|klems==14|klems==12|klems==18)
collapse  (sum) emp_s, by(year skill_i)
reshape wide emp_s,i(year) j(skill_i)
twoway (line emp_s0 year) (line emp_s1 year),graphregion(color(white)) title("Secondary Employment Share, China") legend(label(1 "Low-skill") label(2 "High-skill"))