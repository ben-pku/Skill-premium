* 探究农业与非农业的劳动生产率的差异**
clear
cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\to_be_determined\data\urban_rural\productivity"

replace tflag = (year >2009)
replace at = agflag * tflag
label variable agflag "agri labor productivity"
label variable pgr "labor productivity"
label variable tflag "year >2009"
label variable at "agflag * tflag"

reg pgr agflag tflag at if(year>1996)
save ag_nonag_laborproductivity,replace