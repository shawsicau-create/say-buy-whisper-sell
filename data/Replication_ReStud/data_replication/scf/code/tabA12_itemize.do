

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

*generate dummy for whether anyone in the household itemizes on their tax return (either jointly or separately)
gen itemizer = 1 if X7367==1 | X7368==1 | X7369==1
replace itemizer = 0  if itemizer==.

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

*Fraction of homeowners  that itemize
preserve
replace ownership=0 if ownership!=1
collapse (mean) itemizer [weight=wgt] if ownership==1
gen res=itemizer
replace res = round(res, 0.01)
gen title="Fraction of homeowners that itemize"
save moment1.dta, replace
restore

********************************************************************************************************************************************************
*-------------------------------------------------------------------------------------------------------------------------------------------------------
********************************************************************************************************************************************************

*Fraction of homeowners with mortgage (LTV>0) that itemize
preserve
replace ownership=0 if ownership!=1
gen mdebt=m_debt/equiv
gen ALAI=mdebt/h1
collapse (mean) itemizer [weight=wgt] if ownership==1 & ALAI>0 
gen res=itemizer
replace res = round(res, 0.01)
gen title="Fraction of homeowners with mortgage (LTV>0) that itemize"
save moment2.dta, replace
restore 






forval x=1(1)2{
use moment`x'.dta, clear
keep res title
duplicates drop
save moment`x'.dta, replace
}

use moment1.dta, clear
forval x=2(1)2{
append using moment`x'.dta
}

order title res


***
cd ..


outsheet using "`output'/tabA12_itemize.csv", replace c



