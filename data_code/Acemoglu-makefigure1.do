***********************************************************
*Creates Figure 1: Relative Supply of College Skills and College Premium
***********************************************************
clear
capture log close
version 4
cd G:\daron\technical_change
log using makefigure1, replace

/*Data Files Used
	caselli
	
*Data Files Created as Final Product
	none
	
*Data Files Created as Intermediate Product
	none*/
	
use caselli, clear


gr bc0_w akkrsw year, rescale c(ll) s(OT) xlabel(39, 49, 59, 69, 79, 89, 96) ylabel rlabel b1title(Relative Supply of College Skills and College Premium)

log close


