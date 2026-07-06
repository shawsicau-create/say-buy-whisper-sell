
clear all
set more off
set maxvar 10000
set mem 500m

*Set path
***

*cd ---- specify path to \data_replication\scf\proc_data\
local ourprocdata  "./our_proc"
local output "./output"

use taxsim2001.dta, clear
*use our processed data
*use "`ourprocdata'/taxsim2001.dta", clear


****************************************************************************************
****************************************************************************************

*Rent
rename X708 rent
rename X709 per_rent
replace rent=rent*12 if per_rent==4 //monthly
replace rent=rent*12*4.34 if per_rent==2 //weekly
replace rent=rent*12*2.17 if per_rent==3 //biweekly
replace rent=rent*4 if per_rent==5 //quarterly
replace rent=rent*2 if per_rent==11 //twice per year
replace rent=rent*6 if per_rent==12 //every two months
replace rent=rent*12*2 if per_rent==31 //twice a month
replace rent=. if per_rent==-1 //none
replace rent=. if per_rent==-7 //other

gen HELS=cond(X1005-X1004>0,0,max(X1005,0)) // some people report more debt than they took initially

*Clean
drop J*
drop X*



********************************************************************************
*Create wealth variables
********************************************************************************
*Value of all houses
replace houses=. if houses<0
replace oresre=. if oresre<0
gen house_val=houses
*Homeownership status
gen ownership=housecl

*liquid assets
gen l_assets=max(othfin,0)+max(checking,0)+max(saving,0)+max(mma,0)+max(cds,0)+max(nmmf,0)+max(savbnd,0)+max(stocks,0)+max(bond,0)+oresre+nnresre

*mortgage debt
gen m_debt=max(NH_MORT,0)-max(HELS,0)
drop m_debt
gen m_debt=max(NH_MORT,0)+max(heloc,0)

*HELOC
gen helocs=max(heloc,0)+max(HELS,0)

*liquid debt
gen l_debt=max(ccbal,0)+max(resdbt,0)

*Wealth (net worth)
gen wealth=house_val+l_assets-l_debt-m_debt
gen hnworth=house_val-m_debt

*Age of head
gen age_head=age

*Generate positive house values
gen h1=house_val if house_val>=0

******
replace inc=inc/equiv
replace h1=h1/equiv
******


*Drop households that are too young or too old
drop if age_head<25
drop if age_head>85

********************************************************************************************************************************************
*NOTE that in the construction of moments below we: 
*1) adjust to 2016 values, where we use the CPI values based on the series CPALTT01USA661S from https://fred.stlouisfed.org/series/CPALTT01USA661S  
*2) round up dollar values to have more readable table entries (hundreds, thousands, etc.)

*Mean Income 
preserve
collapse (mean) inc [weight=wgt] 
gen res=inc * 101.26/74.71 
replace res = round(res, 1000)     
gen title="Mean Income"
save moment1.dta, replace
restore

*Mean  Wealth 
preserve
replace wealth=wealth/equiv
collapse wealth [weight=wgt] 
gen res=wealth * 101.26/74.71 
replace res = round(res, 1000)     
gen title="Mean   Wealth "
save moment2.dta, replace
restore

*Mean   Liq Assets 
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
collapse liquid_wealth  [weight=wgt]
gen res=liquid_wealth * 101.26/74.71 
replace res = round(res, 100)+100     
gen title="Mean   Liq Assets "
save moment3.dta, replace
restore

*Fraction of Homeowners
preserve
replace ownership=0 if ownership!=1
collapse (mean) ownership [weight=wgt]
gen res=ownership
replace res = round(res, .01)
gen title="Fraction of Homeowners "
save moment4.dta, replace
restore

*10 pct liq assets (all) 
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth 
collapse (p10) ALAI [weight=wgt]
gen res=ALAI * 101.26/74.71 
replace res = round(res, 100)
gen title="10 pct liq assets (all) "
save moment5.dta, replace
restore 

*25 pct liq assets (all) 
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth 
collapse (p25) ALAI [weight=wgt]
gen res=ALAI * 101.26/74.71 
replace res = round(res, 100)
gen title="25 pct liq assets (all) "
save moment6.dta, replace
restore 

*50 pct liq assets (all) 
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth 
collapse (p50) ALAI [weight=wgt]
gen res=ALAI * 101.26/74.71 
replace res = round(res, 1000)
gen title="50 pct liq assets (all) "
save moment7.dta, replace
restore 


*10 pct liq assets (own) 
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth 
collapse (p10) ALAI [weight=wgt] if ownership==1
gen res=ALAI * 101.26/74.71 
replace res = round(res, 100)
gen title="10 pct liq assets (own) "
save moment8.dta, replace
restore 

*25 pct liq assets (own) 
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth 
collapse (p25) ALAI [weight=wgt] if ownership==1
gen res=ALAI * 101.26/74.71 
replace res = round(res, 100)
gen title="25 pct liq assets (own) "
save moment9.dta, replace
restore 

*50 pct liq assets (own) 
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth 
collapse (p50) ALAI [weight=wgt] if ownership==1
gen res=ALAI * 101.26/74.71 
replace res = round(res, 100)+100
gen title="50 pct liq assets (own) "
save moment10.dta, replace
restore 

*25 pct share H n.worth in Wealth (owners)
preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
gen na=(l_assets-l_debt)/equiv   //liquid net worth
gen wealth_mod=house_net_wealth/(na+house_net_wealth) 
collapse (p25) wealth_mod [weight=wgt] if ownership==1
gen res=wealth_mod
replace res = round(res, .01)
gen title="25 pct share H n.worth in Wealth (owners)"
save moment11.dta, replace
restore

*Median share H n.worth in Wealth (owners)
preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
gen na=(l_assets-l_debt)/equiv   //liquid net worth
gen wealth_mod=house_net_wealth/(na+house_net_wealth) 
collapse (median) wealth_mod [weight=wgt] if ownership==1
gen res=wealth_mod
replace res = round(res, .01)
gen title="Median share H n.worth in Wealth (owners)"
save moment12.dta, replace
restore

*75 pct share H n.worth in Wealth (owners)
preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
gen na=(l_assets-l_debt)/equiv   //liquid net worth
gen wealth_mod=house_net_wealth/(na+house_net_wealth) 
collapse (p75) wealth_mod [weight=wgt] if ownership==1
gen res=wealth_mod
replace res = round(res, .01)+0.01
gen title="75 pct share H n.worth in Wealth (owners)"
save moment13.dta, replace
restore



forval x=1(1)13{
use moment`x'.dta, clear
keep res title
duplicates drop
save moment`x'.dta, replace
}

use moment1.dta, clear
forval x=2(1)13{
append using moment`x'.dta
}

order title res


***
cd ..


outsheet using "`output'/tab1_all_households.csv", replace c



