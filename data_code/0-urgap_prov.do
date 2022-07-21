cd"C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\to_be_determined\data\urban_rural\provincial"

save ur_prov78_20,replace

gen district = 0
label variable district "east=0 middle=1 west=2 northeast=3"
replace district =1 if(prov=="山西"|prov=="安徽"|prov=="江西"|prov=="河南"|prov=="湖北"|prov=="湖南")
replace district = 2 if(prov=="内蒙古"|prov=="广西"|prov=="重庆"|prov=="四川"|prov=="贵州"|prov=="云南"|prov=="西藏"|prov=="陕西"|prov=="甘肃"|prov=="青海"|prov=="宁夏"|prov=="新疆")
replace distric =3 if(prov=="辽宁"|prov=="吉林"|prov=="黑龙江")

save ur_prov78_20,replace


use ur_prov78_20

twoway (lpoly urgap year if(year >=1994)),by(prov) graphregion(color(white))

* by district
preserve
collapse urgap urbaninc ruralinc,by(year district)
twoway (lpoly urgap year if(year>=1992 & district==0)) (lpoly urgap year if(year>=1992 & district==1))(lpoly urgap year if(year>=1992 & district==2)) (lpoly urgap year if(year>=1992 & district==3)),graphregion(color(white)) legend(label(1 "east") label(2 "middle") label(3 "west") label(4 "northeast"))
restore

*