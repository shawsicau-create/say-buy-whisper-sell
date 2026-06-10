

clear all
set more off
set maxvar 10000

set mem 1000m

*Set path
***
*cd ---- specify path to \data_replication\scf\
local rawdata "./raw_data"
local procdata  "./proc_data"


*Merge Raw and Summary data
use "`rawdata'/p2001i6.dta", clear

joinby YY1 Y1 using "`rawdata'/rscfp2001.dta", unmatched(both)
tab _merge
drop _merge

***************************************************************************************
*INCOME & TAXSIM 
***************************************************************************************

*Generate tax year 
g year = 2001

*Generate state
g state = 0

*Generate marital status
g mstat = cond(X8023 != 1, 1, 2)

*Number of dependents (kids) per tax form. 
g depx=(X108>=4 & X108<=13)*(X110 < 19) +/*
  */(X114>=4 & X114<=13)*(X116 < 19) +/*
  */(X120>=4 & X120<=13)*(X122 < 19) +/*
  */(X126>=4 & X126<=13)*(X128 < 19) +/*
  */(X132>=4 & X132<=13)*(X134 < 19) +/*
  */(X202>=4 & X202<=13)*(X204 < 19) +/*
  */(X208>=4 & X208<=13)*(X210 < 19) +/*
  */(X214>=4 & X214<=13)*(X216 < 19) +/*
  */(X220>=4 & X220<=13)*(X222 < 19)

*Number of dependents under age 17
g depchild = (X108>=4 & X108<=13)*(X110 < 17) +/*
  */(X114>=4 & X114<=13)*(X116 < 17) +/*
  */(X120>=4 & X120<=13)*(X122 < 17) +/*
  */(X126>=4 & X126<=13)*(X128 < 17) +/*
  */(X132>=4 & X132<=13)*(X134 < 17) +/*
  */(X202>=4 & X202<=13)*(X204 < 17) +/*
  */(X208>=4 & X208<=13)*(X210 < 17) +/*
  */(X214>=4 & X214<=13)*(X216 < 17) +/*
  */(X220>=4 & X220<=13)*(X222 < 17)

gen pwages=max(wageinc+bussefarminc,0)*0.75
gen swages=max(wageinc+bussefarminc,0)*0.25

g gssi = max(ssretinc,0) //together wife and head     

*Transfers
gen transfers=max(transfothinc,0)

*Adjust for pension contributions
*Couldn't find the right codes for 1998 (codes may be changing in time?)
*Adjusted using average rate from PSID
replace pwages=0.94*pwages
replace swages=0.94*swages

*Taxsim 
taxsim9,replace

*Compute total income before tax
gen pretax_income = pwages + swages + transfers + gssi 

*Compute disposable income
rename fiitax federalTax
rename siitax stateTax
gen inc = pretax_income - federalTax - stateTax
 
*Adjust using equivalence scales (OECD)
gen size_fam=X101
gen nr_adult = size_fam-depchild
gen equiv = 1.0 + 0.7*(nr_adult-1) + 0.5*depchild

save "`procdata'/taxsim2001.dta", replace
