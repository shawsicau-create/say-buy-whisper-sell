

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

********************************************************************************************************************************************

********
*Panel A
********

*mean income (25-30) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if age_head<=30
gen res=inc/meanpop
gen title="mean income (25-30) / mean income (all)"
save moment1.dta, replace
restore 

*mean income (31-35) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>30) & (age_head<=35)
gen res=inc/meanpop
gen title="mean income (31-35) / mean income (all)"
save moment2.dta, replace
restore 

*mean income (36-40) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>35) & (age_head<=40)
gen res=inc/meanpop
gen title="mean income (36-40) / mean income (all)"
save moment3.dta, replace
restore 

*mean income (41-45) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>40) & (age_head<=45)
gen res=inc/meanpop
gen title="mean income (41-45) / mean income (all)"
save moment4.dta, replace
restore 

*mean income (46-50) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>45) & (age_head<=50)
gen res=inc/meanpop
gen title="mean income (46-50) / mean income (all)"
save moment5.dta, replace
restore

*mean income (51-55) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>50) & (age_head<=55)
gen res=inc/meanpop
gen title="mean income (51-55) / mean income (all)"
save moment6.dta, replace
restore

*mean income (56-60) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>55) & (age_head<=60)
gen res=inc/meanpop
gen title="mean income (56-60) / mean income (all)"
save moment7.dta, replace
restore

*mean income (61-65) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>60) & (age_head<=65)
gen res=inc/meanpop
gen title="mean income (61-65) / mean income (all)"
save moment8.dta, replace
restore

*mean income (66-70) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>65) & (age_head<=70)
gen res=inc/meanpop
gen title="mean income (66-70) / mean income (all)"
save moment9.dta, replace
restore

*mean income (71-75) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>70) & (age_head<=75)
gen res=inc/meanpop
gen title="mean income (71-75) / mean income (all)"
save moment10.dta, replace
restore

*mean income (76-80) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>75) & (age_head<=80)
gen res=inc/meanpop
gen title="mean income (76-80) / mean income (all)"
save moment11.dta, replace
restore

*mean income (81-85) / mean income (all)  
preserve
egen meanpop = wtmean(inc), weight(wgt)
collapse (mean) inc (mean) meanpop [weight=wgt] if (age_head>80) & (age_head<=85)
gen res=inc/meanpop
gen title="mean income (81-85) / mean income (all)"
save moment12.dta, replace
restore

********
*Panel B
********

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if age_head<=30
gen res=wtoi/inc
gen title="Wealth to income (25-30) "
save moment13.dta, replace
restore 

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>30) & (age_head<=35)
gen res=wtoi/inc
gen title="Wealth to income (31-35) "
save moment14.dta, replace
restore 

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>35) & (age_head<=40)
gen res=wtoi/inc
gen title="Wealth to income (36-40) "
save moment15.dta, replace
restore 

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>40) & (age_head<=45)
gen res=wtoi/inc
gen title="Wealth to income (41-45) "
save moment16.dta, replace
restore 

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>45) & (age_head<=50)
gen res=wtoi/inc
gen title="Wealth to income (46-50) "
save moment17.dta, replace
restore

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>50) & (age_head<=55)
gen res=wtoi/inc
gen title="Wealth to income (51-55) "
save moment18.dta, replace
restore

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>55) & (age_head<=60)
gen res=wtoi/inc
gen title="Wealth to income (56-60) "
save moment19.dta, replace
restore

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>60) & (age_head<=65)
gen res=wtoi/inc
gen title="Wealth to income (61-65) "
save moment20.dta, replace
restore

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>65) & (age_head<=70)
gen res=wtoi/inc
gen title="Wealth to income (66-70) "
save moment21.dta, replace
restore

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>70) & (age_head<=75)
gen res=wtoi/inc
gen title="Wealth to income (71-75) "
save moment22.dta, replace
restore

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>75) & (age_head<=80)
gen res=wtoi/inc
gen title="Wealth to income (76-80) "
save moment23.dta, replace
restore

preserve
replace wealth=wealth/equiv
gen wtoi=wealth
collapse (mean) wtoi (mean) inc [weight=wgt] if (age_head>80) & (age_head<=85)
gen res=wtoi/inc
gen title="Wealth to income (81-85) "
save moment24.dta, replace
restore


********
*Panel C
********

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if age_head<=30
gen res=h1/inc
gen title="Housing value to income (25-30) "
save moment25.dta, replace
restore 

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>30) & (age_head<=35)
gen res=h1/inc
gen title="Housing value to income (31-35) "
save moment26.dta, replace
restore 

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>35) & (age_head<=40)
gen res=h1/inc
gen title="Housing value to income (36-40) "
save moment27.dta, replace
restore 

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>40) & (age_head<=45)
gen res=h1/inc
gen title="Housing value to income (41-45) "
save moment28.dta, replace
restore 

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>45) & (age_head<=50)
gen res=h1/inc
gen title="Housing value to income (46-50) "
save moment29.dta, replace
restore

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>50) & (age_head<=55)
gen res=h1/inc
gen title="Housing value to income (51-55) "
save moment30.dta, replace
restore

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>55) & (age_head<=60)
gen res=h1/inc
gen title="Housing value to income (56-60) "
save moment31.dta, replace
restore

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>60) & (age_head<=65)
gen res=h1/inc
gen title="Housing value to income (61-65) "
save moment32.dta, replace
restore

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>65) & (age_head<=70)
gen res=h1/inc
gen title="Housing value to income (66-70) "
save moment33.dta, replace
restore

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>70) & (age_head<=75)
gen res=h1/inc
gen title="Housing value to income (71-75) "
save moment34.dta, replace
restore

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>75) & (age_head<=80)
gen res=h1/inc
gen title="Housing value to income (76-80) "
save moment35.dta, replace
restore

preserve
collapse (mean) h1 (mean) inc [weight=wgt] if (age_head>80) & (age_head<=85)
gen res=h1/inc
gen title="Housing value to income (81-85) "
save moment36.dta, replace
restore

********
*Panel D
********

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if age_head<=30
gen res=house_net_wealth/inc
gen title="Housing wealth to income (25-30) "
save moment37.dta, replace
restore 

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>30) & (age_head<=35)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (31-35) "
save moment38.dta, replace
restore 

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>35) & (age_head<=40)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (36-40) "
save moment39.dta, replace
restore 

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>40) & (age_head<=45)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (41-45) "
save moment40.dta, replace
restore 

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>45) & (age_head<=50)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (46-50) "
save moment41.dta, replace
restore

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>50) & (age_head<=55)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (51-55) "
save moment42.dta, replace
restore

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>55) & (age_head<=60)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (56-60) "
save moment43.dta, replace
restore

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>60) & (age_head<=65)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (61-65) "
save moment44.dta, replace
restore

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>65) & (age_head<=70)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (66-70) "
save moment45.dta, replace
restore

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>70) & (age_head<=75)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (71-75) "
save moment46.dta, replace
restore

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>75) & (age_head<=80)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (76-80) "
save moment47.dta, replace
restore

preserve
gen house_net_wealth=(h1*equiv-m_debt)/equiv
collapse (mean) house_net_wealth (mean) inc [weight=wgt] if (age_head>80) & (age_head<=85)
gen res=house_net_wealth/inc
gen title="Housing wealth to income (81-85) "
save moment48.dta, replace
restore



forval x=1(1)48{
use moment`x'.dta, clear
keep res title
duplicates drop
save moment`x'.dta, replace
}

use moment1.dta, clear
forval x=2(1)48{
append using moment`x'.dta
}

order title res

***
cd ..

outsheet using "`output'/fig3.csv", replace c



