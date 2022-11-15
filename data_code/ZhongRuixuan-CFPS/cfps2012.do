/*2012 企业家*/
clear
clear matrix
clear mata
set memory 800m
set matsize 5000
set maxvar 32000
cd D:\Nutcore\我的坚果云\Destiny\课程\大三上\RA\助研\CFPS2012
use cfps2012famecon_201906.dta

gen hentrepreneur12 = .
replace hentrepreneur12 = 1 if fm1 == 1 /*企业家家庭*/
replace hentrepreneur12 = 0 if fm1 == 0 /*工人家庭*/

rename fid10 fid
sort fid
keep fid urban12 hentrepreneur12
save entrepreneur2012.dta,replace

/*2012 CFPS Family*/
clear
clear matrix
clear mata
set memory 800m
set matsize 5000
set maxvar 32000
cd D:\Nutcore\我的坚果云\Destiny\课程\大三上\RA\助研\CFPS2012
use cfps2012famecon_201906.dta

//保留所需要的的数据：抽样数据+财富数据（现住房价值 其它住房价值 土地价值 生产性固定资产 现住房房贷 其它房产贷款总价值 除房贷外的银行贷款 欠非金融机构的贷款 现金和存款总值 政府债券 其它金融产品 别人欠自己的钱 公司资产 股票 基金 金融衍生品）
keep fid12 fid10 provcd countyid cid urban12 cyear cmonth subpopulation subsample ///
     resivalue_new  otherhousevalue land_asset fixed_asset durables_asset ///
	 house1_debts houseother_debts bank_debts ind_debts ///
	 savings govbond  otherfinance debit_other company stock funds derivative ///
	 fm1 fq1 fswt_natcs12 fr1

// 与CFPS2010中的psu相匹配
rename fid10 fid
sort fid
merge m:m fid using "cfps2010psu"	
drop if _merge==2 

/*有79个psu缺失值*/

// 对CFPS2012中79个psu的缺失值进行补全（利用村居编码cid）

/*psu和countyid并非一一对应，countyid = 85 对应 psu = 86 和 87*/
/*每一个cid对应一个psu，但每一个psu对应不止一个cid，psu = */

replace psu=countyid if countyid<53 &countyid>0
replace psu=64 if countyid==64 & psu==.
replace psu=71 if countyid==71 & psu==.
replace psu=75 if countyid==75 & psu==.
replace psu=76 if countyid==76 & psu==.
replace psu=77 if countyid==77 & psu==.
replace psu=79 if countyid==79 & psu==.
replace psu=87 if countyid==85 & psu==.  
replace psu=91 if countyid==88 & psu==.
replace psu=96 if countyid==90 & psu==.

replace psu=113 if countyid==99 & psu==.
replace psu=114 if countyid==100 & psu==.
replace psu=116 if countyid==102 & psu==.
replace psu=125 if countyid==111 & psu==.
replace psu=127 if countyid==113 & psu==.
replace psu=133 if countyid==119 & psu==.
replace psu=134 if countyid==120 & psu==.
replace psu=136 if countyid==122 & psu==.
replace psu=137 if countyid==123 & psu==.
replace psu=139 if countyid==125 & psu==.
replace psu=140 if countyid==126 & psu==.
replace psu=142 if countyid==128 & psu==.
replace psu=156 if countyid==142 & psu==.
replace psu=157 if countyid==143 & psu==.
replace psu=159 if countyid==145 & psu==.
replace psu=162 if countyid==148 & psu==.
replace psu=166 if countyid==152 & psu==.
replace psu=169 if countyid==155 & psu==.
replace psu=171 if countyid==157 & psu==.
replace psu=80 if  countyid==2364 & psu==.

replace psu=98 if  cid==203400 & psu==.
replace psu=99 if  cid==204200 & psu==.
replace psu=100 if  cid==204400 & psu==.
replace psu=101 if  cid==204600 & psu==.
replace psu=107 if  cid==205300 & psu==.
replace psu=107 if  cid==205400 & psu==.
replace psu=117 if  cid==208100 & psu==.
replace psu=117 if  cid==208400 & psu==.
replace psu=131 if  cid==213700 & psu==.
replace psu=131 if  cid==213800 & psu==.
replace psu=143 if  cid==218500 & psu==.
replace psu=143 if  cid==218800 & psu==.
replace psu=147 if  cid==220100 & psu==.
replace psu=147 if  cid==220300 & psu==.
replace psu=148 if  cid==220700 & psu==.
replace psu=148 if  cid==220800 & psu==.
replace psu=154 if  cid==766015 & psu==.
replace psu=103 if  cid==203900 & psu==.
replace psu=148 if  cid==220600 & psu==.
replace psu=97 if psu==.

//生成非金融资产
*土地价值
label var land_asset "NFA 1:Land"
rename land_asset land
*房产价值 = 现住房市价+其他住房价值
gen house=resivalue_new+otherhousevalue
label var house "NFA 2: House"
*其他资产价值 = 生产性固定资产
rename fixed_asset othernfn
label var othernfn "NFA 3: Other domestic capital"
*非金融资产 = 土地价值 + 房产价值 + 其它资产价值
replace durables_asset = 0 if durables_asset == .
gen nfnasset=land+house+othernfn+durables_asset
label var nfnasset "NFA: Non-financial Assets"


//生成金融资产
*金融资产 = 现金和存款总值 + 政府债券 + 其它金融产品 + 股票 + 基金 + 别人欠自己的钱 + 公司资产 + 金融衍生品
gen finasset=savings+govbond+otherfinance+stock+funds+debit_other+company+derivative
label var finasset "FA: Financial Assets"
*储蓄 = 现金和存款总值 + 别人欠自己家的钱 + 政府债券 +其它金融产品
gen deposit=savings+debit_other+govbond+otherfinance
label var deposit "FA 1: Deposit"
*股权 = 股票 + 基金 + 公司资产 + 金融衍生品
gen equity=stock+funds+company+derivative
label var equity "FA 2: Equity"

//生成负债与净财富
*负债 = 现房房贷 + 其它房产贷款总价值 + 非房贷的金融负债 + 欠非金融机构的贷款
gen debt=house1_debts+houseother_debts+bank_debts+ind_debts
label var debt "Debt"
*净财富 = 非金融资产 + 金融资产 - 负债
gen nwealth=nfnasset+finasset-debt
label var nwealth "Net Wealth"

// 生成净房产
gen nethouse = house - house1_debts - houseother_debts
label var nethouse "nethouse"

// 生成住房所有权
rename fq1 hsownership
gen hsown = 0
label var hsown "拥有自住房所有权"
replace hsown = 1 if hsownership == 1 
gen hsown1 = 0
label var hsown1 "拥有自住房所有权"
replace hsown1 = 1 if hsownership == 1 | fr1 == 1

//生成城乡变量
rename urban12 urban
gen rural=0
replace rural=1 if urban==0

//生成企业家变量
gen hentrepreneur = .
replace hentrepreneur = 1 if fm1 == 1 /*企业家家庭*/
replace hentrepreneur = 0 if fm1 == 0 /*工人家庭*/

rename fswt_natcs12 fswt_nat

drop if nwealth == .

//保留新生成变量，得到2012CFPSwealth.dta
keep fid12 provcd fswt_nat psu subpopulation urban rural hentrepreneur land house othernfn nfnasset finasset deposit equity debt nwealth nethouse hsown hsownership hsown1
order fid12 provcd fswt_nat psu subpopulation urban rural hentrepreneur land house othernfn nfnasset finasset deposit equity debt nwealth nethouse hsown hsownership hsown1
sort fid12 
save cfps2012wealth.dta,replace

/*加权分位数*/
_pctile nwealth [pweight=fswt_nat], n(10)
return list
/*获得加权后的全国排位*/
sort nwealth
gen nwid = _n
/*获得加权后的城市&农村排位*/
sort rural nwealth
bys rural: gen gid = _n

_pctile nwid [pweight=fswt_nat], n(100)
return list
_pctile gid if urban == 1 [pweight=fswt_nat], n(10)
return list
_pctile gid if rural == 1 [pweight=fswt_nat], n(10)
return list

/*gpinter sample*/

/*建立bracket，10000为一格*/
gen brck=.
local i=1
while `i'<51{
replace brck=`i' if nwealth>=(`i'-1)*10000 & nwealth<`i'*10000
local i=`i'+1
}

replace brck=0 if nwealth<0
replace brck=51 if nwealth>=500000 & nwealth<600000
replace brck=52 if nwealth>=600000 & nwealth<700000
replace brck=53 if nwealth>=700000 & nwealth<800000
replace brck=54 if nwealth>=800000 & nwealth<900000
replace brck=55 if nwealth>=900000 & nwealth<1000000
replace brck=56 if nwealth>=1000000 & nwealth<2000000
replace brck=57 if nwealth>=2000000 & nwealth<3000000
replace brck=58 if nwealth>=3000000 & nwealth<4000000
replace brck=59 if nwealth>=4000000 & nwealth<5000000
replace brck=60 if nwealth>=5000000 & nwealth<10000000
replace brck=61 if nwealth>=10000000 

gen Urban=0
replace Urban=1 if urban==1
gen Rural=0
replace Rural=1 if urban==0

/*声明抽样方式*/
svyset psu [pweight=fswt_nat],strata (subpopulation) 

svy: proportion brck
svy, subpop(Urban): proportion brck
svy, subpop(Rural): proportion brck

svy: mean nwealth, over (brck)
svy, subpop(Urban): mean nwealth, over (brck)
svy, subpop(Rural): mean nwealth, over (brck)

svy: mean nwealth

/*前10%财富占比*/
total nwealth if nwid >= 11445 [pweight=fswt_nat]  /*全国*/
total nwealth if urban == 1 & gid >= 5175 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & gid >= 6208 [pweight=fswt_nat]  /*农村*/
total nwealth [pweight=fswt_nat]
total nwealth if urban == 1 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 [pweight=fswt_nat]  /*农村*/

/*medium 40% 财富占比*/
total nwealth if nwid >= 6479 &  nwid < 11445 [pweight=fswt_nat]  /*全国*/
total nwealth if urban == 1 & gid >= 2815 &  gid < 5175 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & gid >= 3413 &  gid < 6208 [pweight=fswt_nat]  /*农村*/

/*bottom 50% 财富占比*/
total nwealth if nwid < 6479 [pweight=fswt_nat]  /*全国*/
total nwealth if urban == 1 & gid < 2815 [pweight=fswt_nat] /*城市*/
total nwealth if rural == 1 & gid < 3413 [pweight=fswt_nat] /*农村*/

/*净财富平均数*/
mean nwealth [pweight=fswt_nat]  /*全国*/
mean nwealth if urban == 1 [pweight=fswt_nat]  /*城市*/
mean nwealth if rural == 1 [pweight=fswt_nat]  /*农村*/
mean nwealth if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
mean nwealth if hentrepreneur == 0 [pweight=fswt_nat]  /*非企业家*/

/*金融资产平均数*/
mean finasset [pweight=fswt_nat]  /*全国*/
mean finasset if urban == 1 [pweight=fswt_nat]  /*城市*/
mean finasset if rural == 1 [pweight=fswt_nat]  /*农村*/
mean finasset if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
mean finasset if hentrepreneur == 0 [pweight=fswt_nat]  /*非企业家*/

/*非金融资产平均数*/
mean nfnasset [pweight=fswt_nat]  /*全国*/
mean nfnasset if urban == 1 [pweight=fswt_nat]  /*城市*/
mean nfnasset if rural == 1 [pweight=fswt_nat]  /*农村*/
mean nfnasset if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
mean nfnasset if hentrepreneur == 0 [pweight=fswt_nat]  /*非企业家*/

/*负债平均数*/
mean debt [pweight=fswt_nat]  /*全国*/
mean debt if urban == 1 [pweight=fswt_nat]  /*城市*/
mean debt if rural == 1 [pweight=fswt_nat]  /*农村*/
mean debt if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
mean debt if hentrepreneur == 0 [pweight=fswt_nat]  /*非企业家*/

/*住房价值平均数*/
mean house [pweight=fswt_nat]  /*全国*/
mean house if urban == 1 [pweight=fswt_nat]  /*城市*/
mean house if rural == 1 [pweight=fswt_nat]  /*农村*/
mean house if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
mean house if hentrepreneur == 0 [pweight=fswt_nat]  /*非企业家*/

/*土地价值平均数*/
mean land [pweight=fswt_nat]  /*全国*/
mean land if urban == 1 [pweight=fswt_nat]  /*城市*/
mean land if rural == 1 [pweight=fswt_nat]  /*农村*/
mean land if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
mean land if hentrepreneur == 0 [pweight=fswt_nat]  /*非企业家*/

/*净财富中位数*/
_pctile nwealth [pweight=fswt_nat],n(2)  /*全国*/
return list
_pctile nwealth if urban == 1 [pweight=fswt_nat],n(2)  /*城市*/
return list
_pctile nwealth if rural == 1 [pweight=fswt_nat],n(2)  /*农村*/
return list
_pctile nwealth if hentrepreneur == 1 [pweight=fswt_nat],n(2)  /*企业家*/
return list
_pctile nwealth if hentrepreneur == 0 [pweight=fswt_nat],n(2)  /*非企业家*/
return list

/*金融资产中位数*/
_pctile finasset [pweight=fswt_nat],n(2)  /*全国*/
return list
_pctile finasset if urban == 1 [pweight=fswt_nat],n(2)  /*城市*/
return list
_pctile finasset if rural == 1 [pweight=fswt_nat],n(2)  /*农村*/
return list
_pctile finasset if hentrepreneur == 1 [pweight=fswt_nat],n(2)  /*企业家*/
return list
_pctile finasset if hentrepreneur == 0 [pweight=fswt_nat],n(2)  /*非企业家*/
return list

/*非金融资产中位数*/
_pctile nfnasset [pweight=fswt_nat],n(2)  /*全国*/
return list
_pctile nfnasset if urban == 1 [pweight=fswt_nat],n(2)  /*城市*/
return list
_pctile nfnasset if rural == 1 [pweight=fswt_nat],n(2)  /*农村*/
return list
_pctile nfnasset if hentrepreneur == 1 [pweight=fswt_nat],n(2)  /*企业家*/
return list
_pctile nfnasset if hentrepreneur == 0 [pweight=fswt_nat],n(2)  /*非企业家*/
return list

/*负债中位数*/
_pctile debt [pweight=fswt_nat],n(2)  /*全国*/
return list
_pctile debt if urban == 1 [pweight=fswt_nat],n(2)  /*城市*/
return list
_pctile debt if rural == 1 [pweight=fswt_nat],n(2)  /*农村*/
return list
_pctile debt if hentrepreneur == 1 [pweight=fswt_nat],n(2)  /*企业家*/
return list
_pctile debt if hentrepreneur == 0 [pweight=fswt_nat],n(2)  /*非企业家*/
return list

/*住房价值中位数*/
_pctile house [pweight=fswt_nat],n(2)  /*全国*/
return list
_pctile house if urban == 1 [pweight=fswt_nat],n(2)  /*城市*/
return list
_pctile house if rural == 1 [pweight=fswt_nat],n(2)  /*农村*/
return list
_pctile house if hentrepreneur == 1 [pweight=fswt_nat],n(2)  /*企业家*/
return list
_pctile house if hentrepreneur == 0 [pweight=fswt_nat],n(2)  /*非企业家*/
return list

/*土地价值中位数*/
_pctile land [pweight=fswt_nat],n(2)  /*全国*/
return list
_pctile land if urban == 1 [pweight=fswt_nat],n(2)  /*城市*/
return list
_pctile land if rural == 1 [pweight=fswt_nat],n(2)  /*农村*/
return list
_pctile land if hentrepreneur == 1 [pweight=fswt_nat],n(2)  /*企业家*/
return list
_pctile land if hentrepreneur == 0 [pweight=fswt_nat],n(2)  /*非企业家*/
return list

/*企业家人数占比*/
/*100%*/
mean hentrepreneur [pweight=fswt_nat] /*企业家(窄定义)*/
mean hentrepreneur if urban == 1 [pweight=fswt_nat]  /*城市*/
mean hentrepreneur if rural == 1 [pweight=fswt_nat]  /*农村*/
/*10%*/
mean hentrepreneur if nwid >= 11445 [pweight=fswt_nat] /*企业家(窄定义)*/
mean hentrepreneur if urban == 1 & nwid >= 11445 [pweight=fswt_nat]  /*城市*/
mean hentrepreneur if rural == 1 & nwid >= 11445 [pweight=fswt_nat]  /*农村*/
/*5%*/
mean hentrepreneur if nwid >= 12120 [pweight=fswt_nat] /*企业家(窄定义)*/
mean hentrepreneur if urban == 1 & nwid >= 12120 [pweight=fswt_nat]  /*城市*/
mean hentrepreneur if rural == 1 & nwid >= 12120 [pweight=fswt_nat]  /*农村*/
/*1%*/
mean hentrepreneur if nwid >= 12775 [pweight=fswt_nat] /*企业家(窄定义)*/
mean hentrepreneur if urban == 1 & nwid >= 12775 [pweight=fswt_nat]  /*城市*/
mean hentrepreneur if rural == 1 & nwid >= 12775 [pweight=fswt_nat]  /*农村*/

/*企业家财富占比*/
/*100%*/
total nwealth [pweight=fswt_nat]
total nwealth if urban == 1 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 [pweight=fswt_nat]  /*农村*/
total nwealth if hentrepreneur == 1 & urban == 1 [pweight=fswt_nat]  /*城市企业家*/
total nwealth if hentrepreneur == 1 & rural == 1 [pweight=fswt_nat]  /*农村企业家*/
/*10%*/
total nwealth if nwid >= 11445 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 11445 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & nwid >= 11445 [pweight=fswt_nat]  /*农村*/
total nwealth if hentrepreneur == 1 & urban == 1 & nwid >= 11445 [pweight=fswt_nat]  /*城市企业家*/
total nwealth if hentrepreneur == 1 & rural == 1 & nwid >= 11445 [pweight=fswt_nat]  /*农村企业家*/
/*5%*/
total nwealth if nwid >= 12120 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 12120 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & nwid >= 12120 [pweight=fswt_nat]  /*农村*/
total nwealth if hentrepreneur == 1 & urban == 1 & nwid >= 12120 [pweight=fswt_nat]  /*城市企业家*/
total nwealth if hentrepreneur == 1 & rural == 1 & nwid >= 12120 [pweight=fswt_nat]  /*农村企业家*/
/*1%*/
total nwealth if nwid >= 12775 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 12775 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & nwid >= 12775 [pweight=fswt_nat]  /*农村*/
total nwealth if hentrepreneur == 1 & urban == 1 & nwid >= 12775 [pweight=fswt_nat]  /*城市企业家*/
total nwealth if hentrepreneur == 1 & rural == 1 & nwid >= 12775 [pweight=fswt_nat]  /*农村企业家*/

/*住房财富比*/
/*100%*/
ratio nethouse/nwealth [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & urban == 0 [pweight=fswt_nat]  
/*0-25*/
ratio nethouse/nwealth if nwid < 3137 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid < 3137 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid < 3137 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 3137 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 3137 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 3137 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 3137 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 3137 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 3137 & urban == 0 [pweight=fswt_nat]  
/*25-75*/
ratio nethouse/nwealth if nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 3137 & nwid < 9640 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 3137 & nwid < 9640 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 3137 & nwid < 9640 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 3137 & nwid < 9640 & urban == 0 [pweight=fswt_nat]  
/*75-100*/
ratio nethouse/nwealth if nwid >= 9640 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 9640 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 9640 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 9640 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 9640 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 9640 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 9640 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 9640 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 9640 & urban == 0 [pweight=fswt_nat]  
/*10%*/
ratio nethouse/nwealth if nwid >= 11445 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 11445 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 11445 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 11445 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 11445 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 11445 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 11445 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 11445 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 11445 & urban == 0 [pweight=fswt_nat]  
/*5%*/
ratio nethouse/nwealth if nwid >= 12120 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 12120 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 12120 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12120 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12120 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12120 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12120 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12120 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12120 & urban == 0 [pweight=fswt_nat]  
/*1%*/
ratio nethouse/nwealth if nwid >= 12775 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 12775 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 12775 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12775 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12775 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12775 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12775 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12775 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12775 & urban == 0 [pweight=fswt_nat]  
/*50-90*/
ratio nethouse/nwealth if nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 6479 & nwid < 11445 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 6479 & nwid < 11445 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 6479 & nwid < 11445 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 6479 & nwid < 11445 & urban == 0 [pweight=fswt_nat] 
/*0-50*/
ratio nethouse/nwealth if nwid < 6479 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid < 6479 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid < 6479 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 6479 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 6479 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 6479 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 6479 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 6479 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 6479 & urban == 0 [pweight=fswt_nat] 
*0-100
total nethouse if urban == 1 [pweight=fswt_nat]
total nwealth if urban == 1 [pweight=fswt_nat]
*0-50
total nethouse if urban == 1 & nwid < 6479 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid < 6479 [pweight=fswt_nat]
*50-90
total nethouse if urban == 1 & nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]
*90-100
total nethouse if urban == 1 & nwid >= 11445 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 11445 [pweight=fswt_nat]

*0-100
total nethouse if hentrepreneur == 1 & urban == 1 [pweight=fswt_nat]
total nwealth if hentrepreneur == 1 & urban == 1 [pweight=fswt_nat]

*0-50
total nethouse if urban == 1 & nwid < 6479 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid < 6479 [pweight=fswt_nat]
*50-90
total nethouse if urban == 1 & nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 6479 & nwid < 11445 [pweight=fswt_nat]
*90-100
total nethouse if urban == 1 & nwid >= 11445 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 11445 [pweight=fswt_nat]

/*拥有不同所有权的比例*/
gen hsownership1 = 0
gen hsownership2 = 0
gen hsownership3 = 0
gen hsownership4 = 0
gen hsownership5 = 0
gen hsownership6 = 0
gen hsownership7 = 0
gen hsownership8 = 0
replace hsownership1 = 1 if hsownership == 1
replace hsownership2 = 1 if hsownership == 2
replace hsownership3 = 1 if hsownership == 3
replace hsownership4 = 1 if hsownership == 4
replace hsownership5 = 1 if hsownership == 5
replace hsownership6 = 1 if hsownership == 6
replace hsownership7 = 1 if hsownership == 7
replace hsownership8 = 1 if hsownership == 77
mean hsownership1 [pweight=fswt_nat]
mean hsownership2 [pweight=fswt_nat]
mean hsownership3 [pweight=fswt_nat]
mean hsownership4 [pweight=fswt_nat]
mean hsownership5 [pweight=fswt_nat]
mean hsownership6 [pweight=fswt_nat]
mean hsownership7 [pweight=fswt_nat]
mean hsownership8 [pweight=fswt_nat]

/*拥有自住房所有权的比例*/ 
/*100%*/
mean hsown [pweight=fswt_nat]
mean hsown if urban == 1 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 [pweight=fswt_nat]  /*企业家*/
/*0-25*/
mean hsown if nwid < 3137 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid < 3137 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid < 3137 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid < 3137 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid < 3137 [pweight=fswt_nat]  /*企业家*/  
/*25-75*/
mean hsown if nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*企业家*/
/*75-100*/
mean hsown if nwid >= 9640 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 9640 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 9640 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 9640 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 9640 [pweight=fswt_nat]  /*企业家*/
/*10%*/
mean hsown if nwid >= 11445 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 11445 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 11445 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 11445 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 11445 [pweight=fswt_nat]  /*企业家*/
/*5%*/
mean hsown if nwid >= 12120 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 12120 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 12120 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 12120 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 12120 [pweight=fswt_nat]  /*企业家*/
/*1%*/
mean hsown if nwid >= 12775 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 12775 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 12775 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 12775 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 12775 [pweight=fswt_nat]  /*企业家*/

/*拥有自有住房的比例*/ 
/*拥有自住房所有权的比例*/ 
/*100%*/
mean hsown1 [pweight=fswt_nat]
mean hsown1 if urban == 1 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*0-25*/
mean hsown1 if nwid < 3137 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid < 3137 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid < 3137 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid < 3137 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid < 3137 [pweight=fswt_nat]  /*企业家*/  
mean hsown1 if hentrepreneur == 1 & nwid < 3137 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid < 3137 & urban == 1 [pweight=fswt_nat]  /*企业家*/  
mean hsown1 if hentrepreneur == 1 & nwid < 3137 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid < 3137 & urban == 0 [pweight=fswt_nat]  /*企业家*/  
/*25-75*/
mean hsown1 if nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 3137 & nwid < 9640 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 3137 & nwid < 9640 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 3137 & nwid < 9640 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 3137 & nwid < 9640 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 3137 & nwid < 9640 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*75-100*/
mean hsown1 if nwid >= 9640 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 9640 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 9640 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 9640 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 9640 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 9640 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 9640 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 9640 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 9640 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*10%*/
mean hsown1 if nwid >= 11445 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 11445 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 11445 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 11445 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 11445 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 11445 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 11445 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 11445 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 11445 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*5%*/
mean hsown1 if nwid >= 12120 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 12120 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 12120 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12120 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12120 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12120 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12120 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12120 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12120 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*1%*/
mean hsown1 if nwid >= 12775 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 12775 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 12775 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12775 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12775 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12775 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12775 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12775 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12775 & urban == 0 [pweight=fswt_nat]  /*企业家*/
