	clear //在转码之前需要将STATA内存中的数据清空
	cd "C:\Users\Benjamin Hwang\Documents\大三_下\LijunZhu-project-2022\to_be_determined\data\firm" 
	unicode encoding set gb18030  //将文本编码设置为中文
	unicode analyze E08.dta
	unicode translate E08.dta, invalid
	//unicode retranslate taxdata_2009.dta, transutf8 replace
	