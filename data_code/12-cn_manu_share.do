* draw the industrial upgrading in manufacturing 


cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\skill_premium_sc\data\structural_change\cn_SC"

use cnmanu78-21, clear
twoway (scatter emp_s year if high==0& year>=1985, msize(small)  )  (scatter emp_s year if high==1& year>=1985,  msize(small)), graphregion(color(white)) legend( label(1 "low-skill")  label(2 "high-skill")) scheme(s1mono) xtitle("year") ytitle("emp. share in manu.")

reshape wide emp_s, i(year) j(high)
merge 1:1 year using cn_emp1978-2020
drop _merge
gen ih_s = i_s * emp_s1
gen il_s = i_s * emp_s0

twoway  (scatter il_s year, msize(small)) (scatter ih_s year, msize(small)), graphregion(color(white)) legend( label(1 "low-skill")  label(2 "high-skill")) scheme(s1mono) xtitle("year") ytitle("emp. share %")
save cnemp78-21, replace 
/*
reshape long emp, i(ind) j(year)
bysort year: egen t_emp = sum(emp)
label variable t_emp "total employment"
gen emp_s = emp/t_emp
label variable emp_s "employment share"
collapse (sum) emp emp_s, by(high year)

append using manu62-84
append using manu85-89
sort year high
label variable emp_s "employment share"
label variable emp "employment"




save manu1962-2021,replace

reshape long emp, i(ind) j(year)
bysort year: egen t_emp = sum(emp)
label variable t_emp "total employment"
gen emp_s = emp/t_emp
label variable emp_s "employment share"
append using cnmanu85-89
sort year high

* college level
preserve
gen high = (rankcollege<=15)
reshape long emp, i(ind*) j(year)
bysort year: egen t_emp = sum(emp)
label variable t_emp "total employment"
gen emp_s = emp/t_emp
label variable emp_s "employment share"
collapse (sum) emp emp_s, by(high year)
label variable emp_s "employment share"
label variable emp "employment"
twoway (scatter emp_s year if high==0& year>=1978, msize(small)  )  (scatter emp_s year if high==1& year>=1978,  msize(small)), graphregion(color(white)) legend( label(1 "low-skill")  label(2 "high-skill")) scheme(s1mono) title("College level")
restore

* high school level

gen high = (rankhigh<=15)
reshape long emp, i(ind*) j(year)
bysort year: egen t_emp = sum(emp)
label variable t_emp "total employment"
gen emp_s = emp/t_emp
label variable emp_s "employment share"
collapse (sum) emp emp_s, by(high year)
label variable emp_s "employment share"
label variable emp "employment"
drop emp
save "cnmanu90-21",replace

twoway (scatter emp_s year if high==0& year>=1978, msize(small)  )  (scatter emp_s year if high==1& year>=1978,  msize(small)), graphregion(color(white)) legend( label(1 "low-skill")  label(2 "high-skill")) scheme(s1mono) title("High school level")
restore*/