/*******************************************************************************
 * Replication of Neely (2010) "Okun's Law: Output and Unemployment"
 * Economic Synopses, No. 4, Federal Reserve Bank of St. Louis
 *
 * Data: GDPC1 (Real GDP) and UNRATE (Unemployment Rate) via FRED API
 *       fetched using OpenEcon MCP
 *
 * Okun's Law: ΔU_t = α + β * GDP_growth_t + ε_t
 *
 * Author: Replication Script
 * Date: July 2026
 ******************************************************************************/

clear all
set more off
capture log close
log using "/Users/xiaoshiishun/Desktop/github 项目练习/okun_replication.log", replace text

* ===== 1. LOAD DATA =====
* Data prepared from MCP-fetched FRED data (GDPC1 + UNRATE)
import delimited "/Users/xiaoshiishun/Desktop/github 项目练习/okun_data.csv", clear
destring year q gdp unemp t, replace

* Generate date variable
gen date = yq(year, q)
format date %tq
label variable date "Quarter"
order date quarter
tsset date

* ===== 2. COMPUTE VARIABLES =====

* Annualized GDP growth rate: ((GDP_t / GDP_{t-1})^4 - 1) * 100
gen gdp_growth = ((gdp / l.gdp)^4 - 1) * 100
label variable gdp_growth "Annualized GDP Growth (%)"

* Change in unemployment rate (quarterly difference)
gen d_unemp = d.unemp
label variable d_unemp "Change in Unemployment Rate (pp)"

* ===== 3. DESCRIPTIVE STATISTICS =====
di _newline(2)
di "=============================================================="
di "  DESCRIPTIVE STATISTICS (Full Sample)"
di "=============================================================="
summarize gdp_growth d_unemp, detail

* ===== 4. OKUN'S LAW REGRESSION - FULL SAMPLE =====
di _newline(2)
di "=============================================================="
di "  OKUN'S LAW REGRESSION - FULL SAMPLE (2010Q2-2026Q1)"
di "=============================================================="

regress d_unemp gdp_growth
estimates store full_sample

* ===== 5. OKUN'S LAW REGRESSION - EXCLUDING COVID (2020-2021) =====
di _newline(2)
di "=============================================================="
di "  OKUN'S LAW REGRESSION - EXCLUDING COVID (2020-2021)"
di "=============================================================="

gen byte covid_period = (year >= 2020 & year <= 2021)
label variable covid_period "2020-2021 COVID Period"

regress d_unemp gdp_growth if covid_period == 0
estimates store excl_covid

* ===== 6. COMPUTE OKUN'S COEFFICIENT (BREAK-EVEN GROWTH) =====
* Break-even growth = -alpha / beta  (the growth rate where ΔU = 0)
di _newline(2)
di "=============================================================="
di "  OKUN'S LAW RESULTS SUMMARY"
di "=============================================================="

* Full sample
estimates restore full_sample
local alpha_full = _b[_cons]
local beta_full = _b[gdp_growth]
local r2_full = e(r2)
local n_full = e(N)
local break_even_full = -`alpha_full' / `beta_full'
di "Full Sample:"
di "  Intercept (alpha):     " %9.4f `alpha_full'
di "  Slope (beta):          " %9.4f `beta_full'
di "  R-squared:             " %9.4f `r2_full'
di "  Observations:          " %9.0f `n_full'
di "  Break-even growth:     " %9.2f `break_even_full' "%"
di _newline(1)

* Excluding COVID
estimates restore excl_covid
local alpha = _b[_cons]
local beta = _b[gdp_growth]
local r2 = e(r2)
local n = e(N)
local se_beta = _se[gdp_growth]
local t_beta = `beta' / `se_beta'
local break_even = -`alpha' / `beta'
di "Excluding COVID (2020-2021):"
di "  Intercept (alpha):     " %9.4f `alpha'
di "  Slope (beta):          " %9.4f `beta'
di "  Std Error (beta):      " %9.4f `se_beta'
di "  t-statistic (beta):    " %9.4f `t_beta'
di "  R-squared:             " %9.4f `r2'
di "  Adj. R-squared:        " %9.4f 1 - (1-`r2')*(`n'-1)/(`n'-2)
di "  Observations:          " %9.0f `n'
di "  Break-even growth:     " %9.2f `break_even' "%"
di _newline(1)
di "Interpretation:"
di "  A 1 pp increase in annual GDP growth is associated with"
di "  a " %5.2f abs(`beta') " pp DECREASE in the unemployment rate."
di "  GDP must grow at " %5.2f `break_even' "% per year to keep"
di "  unemployment stable (consistent with the ≈3% rule)."

* ===== 7. ROBUSTNESS: NEWEY-WEST STANDARD ERRORS =====
di _newline(2)
di "=============================================================="
di "  ROBUSTNESS: REGRESSION WITH NEWEY-WEST S.E. (Excl. COVID)"
di "=============================================================="
preserve
drop if covid_period == 1
gen t2 = _n
tsset t2
newey d_unemp gdp_growth, lag(4)
restore

* ===== 8. RECOVERY PERIOD ANALYSIS (2010-2019 only, pre-COVID) =====
di _newline(2)
di "=============================================================="
di "  PRE-COVID SAMPLE (2010-2019)"
di "=============================================================="
regress d_unemp gdp_growth if year < 2020

* ===== 9. FIRST DIFFERENCE OKUN'S LAW: ΔU = α + β*(ΔGDP/GDP_lag) =====
* Note: This is equivalent to regressing ΔU on GDP growth
* Already done above. Let's also show the relationship with level changes.
di _newline(2)
di "=============================================================="
di "  ALTERNATIVE: dU = a + b*Dln(GDP) [Annualized]"
di "=============================================================="
* Log approximation: ln(GDP_t/GDP_{t-1})*400
gen gdp_growth_ln = (ln(gdp) - ln(l.gdp)) * 400
label variable gdp_growth_ln "Annualized Log GDP Growth (%)"

regress d_unemp gdp_growth_ln if covid_period == 0

* ===== 10. GENERATE FIGURES =====
di _newline(2)
di "=============================================================="
di "  GENERATING FIGURES"
di "=============================================================="

* Scatter plot with regression line (Excl. COVID)
twoway (scatter d_unemp gdp_growth if covid_period==0, mcolor(steelblue) msize(small)) ///
       (lfit d_unemp gdp_growth if covid_period==0, lcolor(red) lwidth(medium)), ///
       yline(0, lcolor(gray) lpattern(dash)) ///
       xline(`break_even', lcolor(green) lpattern(dot)) ///
       title("Okun's Law (Excl. COVID, 2010-2026)") ///
       xtitle("Real GDP Growth (Annualized, %)") ///
       ytitle("Change in Unemployment Rate (pp)") ///
       legend(order(1 "Data" 2 "OLS Fit") ring(0) position(bottomleft)) ///
       note("Break-even growth: `break_even'%") ///
       graphregion(color(white))
graph export "/Users/xiaoshiishun/Desktop/github 项目练习/okun_figure_stata.png", replace width(800)

* Time series plot
generate tss_order = _n
label variable tss_order "Quarter"

twoway (line d_unemp tss_order, lcolor(red) lwidth(medium)) ///
       (line gdp_growth tss_order, lcolor(blue) lwidth(medium)), ///
       yline(0, lcolor(gray) lpattern(dash)) ///
       title("GDP Growth and Change in Unemployment") ///
       xtitle("Quarter") ///
       ytitle("Percentage Points") ///
       legend(order(1 "{&Delta} Unemployment (pp)" 2 "GDP Growth (%)") ring(0) position(bottomleft)) ///
       graphregion(color(white))
graph export "/Users/xiaoshiishun/Desktop/github 项目练习/okun_ts_stata.png", replace width(800)

log close
