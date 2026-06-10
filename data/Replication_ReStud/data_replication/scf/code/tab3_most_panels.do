
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

*Create year first mortgage was taken
rename X802 year_main_mtg 
rename X902 year_main_mtg2 
rename X1002 year_main_mtg3
replace year_main_mtg=. if year_main_mtg==0
gen mtg_age = 2001 - year_main_mtg

replace year_main_mtg2=. if year_main_mtg2==0
replace year_main_mtg3=. if year_main_mtg3==0

gen mtg_age2=(2001-year_main_mtg2)
gen mtg_age3=(2001-year_main_mtg3)



*Create number of years agreed for payment for first mortgage
rename X806 nr_years_mtg_at_origin
replace nr_years_mtg_at_origin=. if nr_years_mtg_at_origin<=0


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
gen l_assets=max(othfin,0)+max(checking,0)+max(saving,0)+max(mma,0)+max(cds,0)+max(nmmf,0)+max(savbnd,0)+max(stocks,0)+max(bond,0)+oresre+nnresre   // oresre includes land contracts/notes, while nnresre doesn't

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

******************************
*Drop observation with wealth above 80th percentile
******************************
pctile pct = wealth [w=wgt], nq(100) genp(percent)
gen pk1=pct if percent==80
egen mean_pk1=mean(pk1)
drop if wealth>mean_pk1

*Drop households that are too young or too old
drop if age_head<25
drop if age_head>85

********************************************************************************************************************************************8
********
*panel A
********

*10 pct liq assets (all) / mean income (all)  
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth 
collapse (p10) ALAI (mean) inc [weight=wgt]
gen res=ALAI/inc
replace res = round(res, 0.01)
gen title="10 pct liq assets (all) / mean income (all)"
save moment1.dta, replace
restore 

*25 pct liq assets (all) / mean income (all)
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth
collapse (p25) ALAI (mean) inc [weight=wgt]
gen res=ALAI/inc
replace res = round(res, 0.01)
gen title="25 pct liq assets (all) / mean income (all)"
save moment2.dta, replace
restore 

*Median liq assets (all) / mean income (all)
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth
collapse (median) ALAI (mean) inc [weight=wgt]
gen res=ALAI/inc
replace res = round(res, 0.01)
gen title="Median liq assets (all) / mean income (all)"
save moment3.dta, replace
restore

*75 pct liq assets (all) / mean income (all)
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth
collapse (p75) ALAI (mean) inc [weight=wgt]
gen res=ALAI/inc
replace res = round(res, 0.01)
gen title="75 pct liq assets (all) / mean income (all)"
save moment4.dta, replace
restore

*90 pct liq assets (all) / mean income (all)
preserve
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth
collapse (p90) ALAI (mean) inc [weight=wgt]
gen res=ALAI/inc
replace res = round(res, 0.01)
gen title="90 pct liq assets (all) / mean income (all)"
save moment5.dta, replace
restore

********
*panel B
********

*10 pct liq assets (own) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth 
collapse (p10) ALAI (mean) meanpop [weight=wgt]  if ownership==1
gen res=ALAI/meanpop
replace res = round(res, 0.01)
gen title="10 pct liq assets (own) / mean income (all)"
save moment6.dta, replace
restore 

*25 pct liq assets (own) / mean income (all)
preserve
egen meanpop = wtmean(inc), weight(wgt)
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth
collapse (p25) ALAI (mean) meanpop [weight=wgt]  if ownership==1
gen res=ALAI/meanpop
replace res = round(res, 0.01)
gen title="25 pct liq assets (own) / mean income (all)"
save moment7.dta, replace
restore 

*Median liq assets (own) / mean income (all)
preserve
egen meanpop = wtmean(inc), weight(wgt)
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth
collapse (median) ALAI (mean) meanpop [weight=wgt]  if ownership==1
gen res=ALAI/meanpop 
replace res = round(res, 0.01)
gen title="Median liq assets (own) / mean income (all)"
save moment8.dta, replace
restore

*75 pct liq assets (own) / mean income (all)
preserve
egen meanpop = wtmean(inc), weight(wgt)
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth
collapse (p75) ALAI (mean) meanpop [weight=wgt]  if ownership==1
gen res=ALAI/meanpop
replace res = round(res, 0.01)
gen title="75 pct liq assets (own) / mean income (all)"
save moment9.dta, replace
restore

*90 pct liq assets (own) / mean income (all)
preserve
egen meanpop = wtmean(inc), weight(wgt)
gen liquid_wealth=(l_assets-l_debt)/equiv
gen ALAI=liquid_wealth
collapse (p90) ALAI (mean) meanpop [weight=wgt]  if ownership==1
gen res=ALAI/meanpop
replace res = round(res, 0.01)
gen title="90 pct liq assets (own) / mean income (all)"
save moment10.dta, replace
restore

********
*panel C
********

*10 pct Wealth (all) / mean income (all)
preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (p10) wtoi (mean) inc [weight=wgt] 
gen res=wtoi/inc
replace res = round(res, 0.01)
gen title="10 pct Wealth (all) / mean income (all)"
save moment11.dta, replace
restore

*25 pct Wealth (all) / mean income (all)
preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (p25) wtoi (mean) inc [weight=wgt] 
gen res=wtoi/inc
replace res = round(res, 0.01)
gen title="25 pct Wealth (all) / mean income (all)"
save moment12.dta, replace
restore

*Median Wealth (all) / mean income (all)  
preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (median) wtoi (mean) inc [weight=wgt] 
gen res=wtoi/inc
replace res = round(res, 0.01)
gen title="Median Wealth (all) / mean income (all)"
save moment13.dta, replace
restore

*75 pct Wealth (all) / mean income (all)     
preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (p75) wtoi (mean) inc [weight=wgt] 
gen res=wtoi/inc
replace res = round(res, 0.01)
gen title="75 pct Wealth (all) / mean income (all)"
save moment14.dta, replace
restore

*90 pct Wealth (all) / mean income (all)   
preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (p90) wtoi (mean) inc [weight=wgt] 
gen res=wtoi/inc
replace res = round(res, 0.01)
gen title="90 pct Wealth (all) / mean income (all)"
save moment15.dta, replace
restore

********
*panel D
********

*10 pct share H n.worth in Wealth (owners)
preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
gen na=(l_assets-l_debt)/equiv   //liquid net worth
gen wealth_mod=house_net_wealth/(na+house_net_wealth) 
collapse (p10) wealth_mod [weight=wgt] if ownership==1
gen res=wealth_mod
replace res = round(res, 0.01)
gen title="10 pct share H n.worth in Wealth (owners)"
save moment16.dta, replace
restore

*25 pct share H n.worth in Wealth (owners)
preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
gen na=(l_assets-l_debt)/equiv   //liquid net worth
gen wealth_mod=house_net_wealth/(na+house_net_wealth) 
collapse (p25) wealth_mod [weight=wgt] if ownership==1
gen res=wealth_mod
replace res = round(res, 0.01)
gen title="25 pct share H n.worth in Wealth (owners)"
save moment17.dta, replace
restore

*Median share H n.worth in Wealth (owners)
preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
gen na=(l_assets-l_debt)/equiv   //liquid net worth
gen wealth_mod=house_net_wealth/(na+house_net_wealth) 
collapse (median) wealth_mod [weight=wgt] if ownership==1
gen res=wealth_mod
replace res = round(res, 0.01)
gen title="Median share H n.worth in Wealth (owners)"
save moment18.dta, replace
restore

*75 pct share H n.worth in Wealth (owners)
preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
gen na=(l_assets-l_debt)/equiv   //liquid net worth
gen wealth_mod=house_net_wealth/(na+house_net_wealth) 
collapse (p75) wealth_mod [weight=wgt] if ownership==1
gen res=wealth_mod
replace res = round(res, 0.01)
gen title="75 pct share H n.worth in Wealth (owners)"
save moment19.dta, replace
restore

*90 pct share H n.worth in Wealth (owners)
preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
gen na=(l_assets-l_debt)/equiv   //liquid net worth
gen wealth_mod=house_net_wealth/(na+house_net_wealth) 
collapse (p90) wealth_mod [weight=wgt] if ownership==1
gen res=wealth_mod
replace res = round(res, 0.01)
gen title="90 pct share H n.worth in Wealth (owners)"
save moment20.dta, replace
restore

********
*panel E
********

*10 pct LTV (own; LTV>0 and <1)
preserve
gen mdebt=m_debt/equiv
gen ALAI=mdebt/h1
collapse (p10) ALAI [weight=wgt] if ownership==1 & ALAI>0 & ALAI<1
gen res=ALAI
replace res = round(res, 0.01)
gen title="10 pct LTV (own; LTV>0 and <1)"
save moment21.dta, replace
restore 

*25 pct LTV (own; LTV>0 and <1)
preserve
gen mdebt=m_debt/equiv
gen ALAI=mdebt/h1
collapse (p25) ALAI [weight=wgt] if ownership==1 & ALAI>0 & ALAI<1
gen res=ALAI
replace res = round(res, 0.01)
gen title="25 pct LTV (own; LTV>0 and <1)"
save moment22.dta, replace
restore 

*Median LTV (own; LTV>0 and <1)
preserve
gen mdebt=m_debt/equiv
gen ALAI=mdebt/h1
collapse (median) ALAI [weight=wgt] if ownership==1 & ALAI>0 & ALAI<1
gen res=ALAI
replace res = round(res, 0.01)
gen title="Median LTV (own; LTV>0 and <1)"
save moment23.dta, replace
restore

*75 pct LTV (own; LTV>0 and <1)
preserve
gen mdebt=m_debt/equiv
gen ALAI=mdebt/h1
collapse (p75) ALAI [weight=wgt] if ownership==1 & ALAI>0 & ALAI<1
gen res=ALAI
replace res = round(res, 0.01)
gen title="75 pct LTV (own; LTV>0 and <1)"
save moment24.dta, replace
restore

*90 pct LTV (own; LTV>0 and <1)
preserve
gen mdebt=m_debt/equiv
gen ALAI=mdebt/h1
collapse (p90) ALAI [weight=wgt] if ownership==1 & ALAI>0 & ALAI<1
gen res=ALAI
replace res = round(res, 0.01)
gen title="90 pct LTV (own; LTV>0 and <1)"
save moment25.dta, replace
restore

********
*panel G
********

*10 pct House to income ratio (own)
preserve
gen htoi=h1/inc
collapse (p10) htoi [weight=wgt] if ownership==1
gen res=htoi
replace res = round(res, 0.01)
gen title="10 pct House to income ratio (own)"
save moment26.dta, replace
restore

*25 pct House to income ratio (own)
preserve
gen htoi=h1/inc
collapse (p25) htoi [weight=wgt] if ownership==1
gen res=htoi
replace res = round(res, 0.01)
gen title="25 pct House to income ratio (own)"
save moment27.dta, replace 
restore

*Median House to income ratio (own)
preserve
gen htoi=h1/inc
collapse (median) htoi [weight=wgt] if ownership==1
gen res=htoi
replace res = round(res, 0.01)
gen title="Median House to income ratio (own)"
save moment28.dta, replace
restore

*75 pct House to income ratio (own)
preserve
gen htoi=h1/inc
collapse (p75) htoi [weight=wgt] if ownership==1
gen res=htoi
replace res = round(res, 0.01)
gen title="75 pct House to income ratio (own)"
save moment29.dta, replace
restore

*90 pct House to income ratio (own) 
preserve
gen htoi=h1/inc
collapse (p90) htoi [weight=wgt] if ownership==1
gen res=htoi
replace res = round(res, 0.01)
gen title="90 pct House to income ratio (own)"
save moment30.dta, replace
restore

********
*panel H
********

*10 pct Mortgage Age (adj for min age across mortgages)
preserve
gen htoi=min(mtg_age, mtg_age2, mtg_age3)
collapse (p10) htoi [weight=wgt] 
gen res=htoi
gen title="10 pct Mortgage Age (adj for min age across mortgages)"
save moment31.dta, replace
restore

*25 pct Mortgage Age (adj for min age across mortgages)
preserve
gen htoi=min(mtg_age, mtg_age2, mtg_age3)
collapse (p25) htoi [weight=wgt] 
gen res=htoi
gen title="25 pct Mortgage Age (adj for min age across mortgages)"
save moment32.dta, replace 
restore

*Median Mortgage Age (adj for min age across mortgages)
preserve
gen htoi=min(mtg_age, mtg_age2, mtg_age3)
collapse (median) htoi [weight=wgt] 
gen res=htoi
gen title="Median Mortgage Age (adj for min age across mortgages)"
save moment33.dta, replace
restore

*75 pct Mortgage Age (adj for min age across mortgages)
preserve
gen htoi=min(mtg_age, mtg_age2, mtg_age3)
collapse (p75) htoi [weight=wgt] 
gen res=htoi
gen title="75 pct Mortgage Age (adj for min age across mortgages)"
save moment34.dta, replace
restore

*90 pct Mortgage Age (adj for min age across mortgages)
preserve
gen htoi=min(mtg_age, mtg_age2, mtg_age3)
collapse (p90) htoi [weight=wgt] 
gen res=htoi
gen title="90 pct Mortgage Age (adj for min age across mortgages)"
save moment35.dta, replace
restore



forval x=1(1)35{
use moment`x'.dta, clear
keep res title
duplicates drop
save moment`x'.dta, replace
}

use moment1.dta, clear
forval x=2(1)35{
append using moment`x'.dta
}

order title res

***
cd ..

outsheet using "`output'/tab3_most_panels.csv", replace c



