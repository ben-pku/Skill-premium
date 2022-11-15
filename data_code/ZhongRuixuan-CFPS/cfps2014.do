/*2014 CFPS*/
clear
clear matrix
clear mata
set memory 800m
set matsize 5000
set maxvar 32000
cd D:\Nutcore\我的坚果云\Destiny\课程\大三上\RA\助研\CFPS2014
use cfps2014famecon_201906.dta

// 与CFPS2010中的psu相匹配
rename fid10 fid
sort fid
merge m:m fid using "cfps2010psu"	
drop if _merge==2 

/*98个缺失值*/
replace psu=45 if countyid14==45 & psu==.
replace psu=79 if countyid14==79 & psu==.
replace psu=47 if countyid14==47 & psu==.
replace psu=51 if countyid14==51 & psu==.
replace psu=49 if countyid14==49 & psu==.
replace psu=48 if countyid14==48 & psu==.
replace psu=71 if countyid14==71 & psu==.
replace psu=74 if countyid14==74 & psu==.
replace psu=169 if countyid14==155 & psu==.
replace psu=162 if countyid14==148 & psu==.
replace psu=166 if countyid14==152 & psu==.
replace psu=171 if countyid14==157 & psu==.
replace psu=161 if countyid14==147 & psu==.
replace psu=87 if countyid14==85 & psu==.
replace psu=98 if countyid14==91 & psu==.
replace psu=107 if countyid14==95 & psu==.
replace psu=12 if countyid14==12 & psu==.
replace psu=10 if countyid14==10 & psu==.
replace psu=37 if countyid14==37 & psu==.
replace psu=2 if countyid14==2 & psu==.
replace psu=15 if countyid14==15 & psu==.
replace psu=13 if countyid14==13 & psu==.
replace psu=64 if countyid14==64 & psu==.
replace psu=113 if countyid14==99 & psu==.
replace psu=114 if countyid14==100 & psu==.
replace psu=117 if countyid14==103 & psu==.
replace psu=127 if countyid14==113 & psu==.
replace psu=116 if countyid14==102 & psu==.
replace psu=7 if countyid14==7 & psu==.
replace psu=9 if countyid14==9 & psu==.
replace psu=30 if countyid14==30 & psu==.
replace psu=130 if countyid14==116 & psu==.
replace psu=136 if countyid14==122 & psu==.
replace psu=131 if countyid14==117 & psu==.
replace psu=139 if countyid14==125 & psu==.
replace psu=133 if countyid14==119 & psu==.
replace psu=141 if countyid14==127 & psu==.
replace psu=129 if countyid14==115 & psu==.
replace psu=134 if countyid14==120 & psu==.
replace psu=140 if countyid14==126 & psu==.
replace psu=142 if countyid14==128 & psu==.
replace psu=143 if countyid14==129 & psu==.
replace psu=137 if countyid14==123 & psu==.
replace psu=19 if countyid14==19 & psu==.
replace psu=16 if countyid14==16 & psu==.
replace psu=76 if countyid14==76 & psu==.
replace psu=77 if countyid14==77 & psu==.
replace psu=159 if countyid14==145 & psu==.
replace psu=156 if countyid14==142 & psu==.
replace psu=148 if countyid14==134 & psu==.
replace psu=147 if countyid14==133 & psu==.
replace psu=157 if countyid14==143 & psu==.
replace psu=141 if countyid14==127 & psu==.
replace psu=148 if countyid14==134 & psu==.
replace psu=154 if countyid14==140 & psu==.
replace psu=151 if countyid14==137 & psu==.
replace psu=2 if countyid14==1081 & psu==.
replace psu=80 if countyid14==2364 & psu==.
replace psu=20 if countyid14==2261 & psu==.
replace psu=5 if countyid14==2149 & psu==.

replace psu=99 if  cid14==204200 & psu==.
replace psu=100 if  cid14==204400 & psu==.
replace psu=148 if  cid14==315578 & psu==.

// 保留CFPS中需要用到的变量：抽样相关变量、访谈相关变量、财富相关变量（土地价值 现住房市价 其他房产价值 总房贷 存款 股票 基金 别人欠自己家的钱 公司资产 家中其他资产 家中收藏品 非房贷的金融负债 家庭净财产）
drop house

/*企业家*/
gen hentrepreneur = .
replace hentrepreneur = 1 if fm1 == 1 /*企业家家庭*/
replace hentrepreneur = 0 if fm1 == 0 /*工人家庭*/

// 生成住房所有权
rename fq2 hsownership
gen hsown = 0
label var hsown "拥有自住房所有权"
replace hsown = 1 if hsownership == 1
gen hsown1 = 0
label var hsown1 "拥有自住房所有权"
replace hsown1 = 1 if hsownership == 1 | fr1 == 1

// 生成非金融资产=土地+房产+其它资产    
*土地价值
label var land_asset "NFA 1:Land"
rename land_asset land
*房产价值 = 现住房市价+其他房产价值
gen house=houseasset_gross
label var house "NFA 2: House"
*其他资产 = 生产性固定资产
rename fixed_asset othernfn
label var othernfn "NFA 3: Other domestic capital"
*非金融资产 = 土地价值 + 房产价值 + 其它资产
replace durables_asset = 0 if durables_asset == .
gen nfnasset=land+house+othernfn+durables_asset
label var nfnasset "NFA: Non-financial Assets"


// 生成金融资产 = 储蓄 + 股权
replace ft201 = 0 if ft201 == -1 | ft201 == -2 | ft201 == -8
gen finasset=savings+debit_other+ft201
label var finasset "FA: Financial Assets"
*储蓄 = 存款 + 别人欠自家的钱
gen deposit=savings+debit_other
label var deposit "FA 1: Deposit"
*股权 = 金融产品总价
gen equity= ft201
label var equity "FA 2: Equity"

// 生成负债
*负债 = 总房贷 + 非房贷的金融负债
gen debt=house_debts+nonhousing_debts 
label var debt "Debt"

// 生成净财富
*净财富 = 非金融资产 + 金融资产 - 负债
gen nwealth=nfnasset+finasset-debt
label var nwealth "Net Wealth"

// 生成净房产
gen nethouse = houseasset_net
label var nethouse "nethouse"

//生成城乡变量
gen rural=0
replace rural=1 if urban14==0
gen urban=0
replace urban=1 if urban14==1

rename fswt_natcs14 fswt_nat

drop if nwealth == .

// 保留新生成的变量，得到2014CFPSwealth.dta
keep fid14 provcd fswt_nat psu subpopulation urban rural hentrepreneur land house othernfn nfnasset finasset deposit equity debt nwealth nethouse hsown hsownership hsown1
order fid14 provcd fswt_nat psu subpopulation urban rural hentrepreneur land house othernfn nfnasset finasset deposit equity debt nwealth nethouse hsown hsownership hsown1
sort fid 
save cfps2014wealth.dta,replace

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
total nwealth if nwid >= 11736 [pweight=fswt_nat]  /*全国*/
total nwealth if urban == 1 & gid >= 5673 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & gid >= 6037 [pweight=fswt_nat]  /*农村*/
total nwealth [pweight=fswt_nat]
total nwealth if urban == 1 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 [pweight=fswt_nat]  /*农村*/

/*medium 40% 财富占比*/
total nwealth if nwid >= 6691 &  nwid < 11736 [pweight=fswt_nat]  /*全国*/
total nwealth if urban == 1 & gid >= 3166 &  gid < 5673 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & gid >= 3330 &  gid < 6037 [pweight=fswt_nat]  /*农村*/

/*bottom 50% 财富占比*/
total nwealth if nwid < 6691 [pweight=fswt_nat]  /*全国*/
total nwealth if urban == 1 & gid < 3166 [pweight=fswt_nat] /*城市*/
total nwealth if rural == 1 & gid < 3330 [pweight=fswt_nat] /*农村*/

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
mean hentrepreneur if nwid >= 11736 [pweight=fswt_nat] /*企业家(窄定义)*/
mean hentrepreneur if urban == 1 & nwid >= 11736 [pweight=fswt_nat]  /*城市*/
mean hentrepreneur if rural == 1 & nwid >= 11736 [pweight=fswt_nat]  /*农村*/
/*5%*/
mean hentrepreneur if nwid >= 12369 [pweight=fswt_nat] /*企业家(窄定义)*/
mean hentrepreneur if urban == 1 & nwid >= 12369 [pweight=fswt_nat]  /*城市*/
mean hentrepreneur if rural == 1 & nwid >= 12369 [pweight=fswt_nat]  /*农村*/
/*1%*/
mean hentrepreneur if nwid >= 13022 [pweight=fswt_nat] /*企业家(窄定义)*/
mean hentrepreneur if urban == 1 & nwid >= 13022 [pweight=fswt_nat]  /*城市*/
mean hentrepreneur if rural == 1 & nwid >= 13022 [pweight=fswt_nat]  /*农村*/

/*企业家财富占比*/
/*100%*/
total nwealth [pweight=fswt_nat]
total nwealth if urban == 1 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 [pweight=fswt_nat]  /*农村*/
total nwealth if hentrepreneur == 1 & urban == 1 [pweight=fswt_nat]  /*城市企业家*/
total nwealth if hentrepreneur == 1 & rural == 1 [pweight=fswt_nat]  /*农村企业家*/
/*10%*/
total nwealth if nwid >= 11736 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 11736 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & nwid >= 11736 [pweight=fswt_nat]  /*农村*/
total nwealth if hentrepreneur == 1 & urban == 1 & nwid >= 11736 [pweight=fswt_nat]  /*城市企业家*/
total nwealth if hentrepreneur == 1 & rural == 1 & nwid >= 11736 [pweight=fswt_nat]  /*农村企业家*/
/*5%*/
total nwealth if nwid >= 12369 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 12369 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & nwid >= 12369 [pweight=fswt_nat]  /*农村*/
total nwealth if hentrepreneur == 1 & urban == 1 & nwid >= 12369 [pweight=fswt_nat]  /*城市企业家*/
total nwealth if hentrepreneur == 1 & rural == 1 & nwid >= 12369 [pweight=fswt_nat]  /*农村企业家*/
/*1%*/
total nwealth if nwid >= 13022 [pweight=fswt_nat]
total nwealth if urban == 1 & nwid >= 13022 [pweight=fswt_nat]  /*城市*/
total nwealth if rural == 1 & nwid >= 13022 [pweight=fswt_nat]  /*农村*/
total nwealth if hentrepreneur == 1 & urban == 1 & nwid >= 13022 [pweight=fswt_nat]  /*城市企业家*/
total nwealth if hentrepreneur == 1 & rural == 1 & nwid >= 13022 [pweight=fswt_nat]  /*农村企业家*/

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
ratio nethouse/nwealth if nwid < 3238 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid < 3238 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid < 3238 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 3238 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 3238 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 3238 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 3238 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 3238 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 3238 & urban == 0 [pweight=fswt_nat]  
/*25-75*/
ratio nethouse/nwealth if nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 3238 & nwid < 9917 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 3238 & nwid < 9917 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 3238 & nwid < 9917 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 3238 & nwid < 9917 & urban == 0 [pweight=fswt_nat]  
/*75-100*/
ratio nethouse/nwealth if nwid >= 9917 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 9917 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 9917 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 9917 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 9917 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 9917 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 9917 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 9917 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 9917 & urban == 0 [pweight=fswt_nat]  
/*10%*/
ratio nethouse/nwealth if nwid >= 11736 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 11736 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 11736 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 11736 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 11736 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 11736 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 11736 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 11736 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 11736 & urban == 0 [pweight=fswt_nat]  
/*5%*/
ratio nethouse/nwealth if nwid >= 12369 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 12369 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 12369 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12369 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12369 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12369 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12369 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 12369 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 12369 & urban == 0 [pweight=fswt_nat]  
/*1%*/
ratio nethouse/nwealth if nwid >= 13022 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 13022 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 13022 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 13022 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 13022 [pweight=fswt_nat] 
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 13022 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 13022 & urban == 1 [pweight=fswt_nat] 
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 13022 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 13022 & urban == 0 [pweight=fswt_nat] 
/*50-90*/
ratio nethouse/nwealth if nwid >= 6691 & nwid < 11736 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid >= 6691 & nwid < 11736 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid >= 6691 & nwid < 11736 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 6691 & nwid < 11736 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 6691 & nwid < 11736 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 6691 & nwid < 11736 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 6691 & nwid < 11736 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid >= 6691 & nwid < 11736 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid >= 6691 & nwid < 11736 & urban == 0 [pweight=fswt_nat] 
/*0-50*/
ratio nethouse/nwealth if nwid < 6691 [pweight=fswt_nat]
ratio nethouse/nwealth if urban == 1 & nwid < 6691 [pweight=fswt_nat]  /*城市*/
ratio nethouse/nwealth if rural == 1 & nwid < 6691 [pweight=fswt_nat]  /*农村*/
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 6691 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 6691 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 6691 & urban == 1 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 6691 & urban == 1 [pweight=fswt_nat]  
ratio nethouse/nwealth if hentrepreneur == 1 & nwid < 6691 & urban == 0 [pweight=fswt_nat]  /*企业家*/
ratio nethouse/nwealth if hentrepreneur == 0 & nwid < 6691 & urban == 0 [pweight=fswt_nat] 

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
mean hsown if nwid < 3238 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid < 3238 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid < 3238 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid < 3238 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid < 3238 [pweight=fswt_nat]  /*企业家*/  
/*25-75*/
mean hsown if nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*企业家*/
/*75-100*/
mean hsown if nwid >= 9917 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 9917 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 9917 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 9917 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 9917 [pweight=fswt_nat]  /*企业家*/
/*10%*/
mean hsown if nwid >= 11736 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 11736 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 11736 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 11736 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 11736 [pweight=fswt_nat]  /*企业家*/
/*5%*/
mean hsown if nwid >= 12369 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 12369 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 12369 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 12369 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 12369 [pweight=fswt_nat]  /*企业家*/
/*1%*/
mean hsown if nwid >= 13022 [pweight=fswt_nat]
mean hsown if urban == 1 & nwid >= 13022 [pweight=fswt_nat]  /*城市*/
mean hsown if rural == 1 & nwid >= 13022 [pweight=fswt_nat]  /*农村*/
mean hsown if hentrepreneur == 1 & nwid >= 13022 [pweight=fswt_nat]  /*企业家*/
mean hsown if hentrepreneur == 0 & nwid >= 13022 [pweight=fswt_nat]  /*企业家*/

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
mean hsown1 if nwid < 3238 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid < 3238 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid < 3238 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid < 3238 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid < 3238 [pweight=fswt_nat]  /*企业家*/ 
mean hsown1 if hentrepreneur == 1 & nwid < 3238 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid < 3238 & urban == 1 [pweight=fswt_nat]  /*企业家*/ 
mean hsown1 if hentrepreneur == 1 & nwid < 3238 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid < 3238 & urban == 0 [pweight=fswt_nat]  /*企业家*/  
/*25-75*/
mean hsown1 if nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 3238 & nwid < 9917 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 3238 & nwid < 9917 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 3238 & nwid < 9917 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 3238 & nwid < 9917 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 3238 & nwid < 9917 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*75-100*/
mean hsown1 if nwid >= 9917 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 9917 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 9917 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 9917 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 9917 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 9917 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 9917 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 9917 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 9917 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*10%*/
mean hsown1 if nwid >= 11736 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 11736 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 11736 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 11736 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 11736 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 11736 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 11736 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 11736 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 11736 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*5%*/
mean hsown1 if nwid >= 12369 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 12369 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 12369 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12369 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12369 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12369 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12369 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 12369 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 12369 & urban == 0 [pweight=fswt_nat]  /*企业家*/
/*1%*/
mean hsown1 if nwid >= 13022 [pweight=fswt_nat]
mean hsown1 if urban == 1 & nwid >= 13022 [pweight=fswt_nat]  /*城市*/
mean hsown1 if rural == 1 & nwid >= 13022 [pweight=fswt_nat]  /*农村*/
mean hsown1 if hentrepreneur == 1 & nwid >= 13022 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 13022 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 13022 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 13022 & urban == 1 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 1 & nwid >= 13022 & urban == 0 [pweight=fswt_nat]  /*企业家*/
mean hsown1 if hentrepreneur == 0 & nwid >= 13022 & urban == 0 [pweight=fswt_nat]  /*企业家*/