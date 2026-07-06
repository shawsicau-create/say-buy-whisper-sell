#!/usr/bin/env python3
"""
Replication of Neely (2010) "Okun's Law: Output and Unemployment"
Economic Synopses, No. 4, Federal Reserve Bank of St. Louis

Data sources (via OpenEcon MCP / FRED):
  - GDPC1: Real Gross Domestic Product (quarterly, SAAR)
  - UNRATE: Unemployment Rate (monthly, SA)

Okun's Law: ΔU_t = α + β * GDP_growth_t + ε_t
where ΔU is change in unemployment rate and GDP_growth is annualized growth.
"""

import matplotlib.pyplot as plt
import numpy as np
from scipy import stats
import matplotlib
matplotlib.use('Agg')

# ============================================================
# DATA (from OpenEcon MCP / FRED API)
# ============================================================

# GDPC1: Quarterly Real GDP (Billions of Chained 2017 Dollars, SAAR)
gdp_data = {
    "2010Q1": 16582.710, "2010Q2": 16743.162, "2010Q3": 16872.266, "2010Q4": 16960.864,
    "2011Q1": 16920.632, "2011Q2": 17035.114, "2011Q3": 17031.313, "2011Q4": 17222.583,
    "2012Q1": 17367.010, "2012Q2": 17444.525, "2012Q3": 17469.650, "2012Q4": 17489.852,
    "2013Q1": 17662.400, "2013Q2": 17709.671, "2013Q3": 17860.450, "2013Q4": 18016.147,
    "2014Q1": 17953.974, "2014Q2": 18185.911, "2014Q3": 18406.941, "2014Q4": 18500.031,
    "2015Q1": 18666.621, "2015Q2": 18782.243, "2015Q3": 18857.418, "2015Q4": 18892.206,
    "2016Q1": 19001.690, "2016Q2": 19062.709, "2016Q3": 19197.938, "2016Q4": 19304.352,
    "2017Q1": 19398.343, "2017Q2": 19506.949, "2017Q3": 19660.766, "2017Q4": 19882.352,
    "2018Q1": 20044.077, "2018Q2": 20150.476, "2018Q3": 20276.154, "2018Q4": 20304.874,
    "2019Q1": 20431.641, "2019Q2": 20602.275, "2019Q3": 20843.322, "2019Q4": 20985.448,
    "2020Q1": 20709.212, "2020Q2": 19077.992, "2020Q3": 20558.879, "2020Q4": 20791.917,
    "2021Q1": 21082.134, "2021Q2": 21440.929, "2021Q3": 21617.828, "2021Q4": 21988.737,
    "2022Q1": 21932.710, "2022Q2": 21967.045, "2022Q3": 22125.625, "2022Q4": 22278.345,
    "2023Q1": 22439.607, "2023Q2": 22580.499, "2023Q3": 22840.989, "2023Q4": 23033.780,
    "2024Q1": 23082.119, "2024Q2": 23286.508, "2024Q3": 23478.570, "2024Q4": 23586.542,
    "2025Q1": 23548.210, "2025Q2": 23770.976, "2025Q3": 24026.834, "2025Q4": 24055.749,
    "2026Q1": 24180.419
}

# UNRATE: Monthly Unemployment Rate (%) - quarterly average
unemp_data = {
    "2010Q1": (9.8 + 9.8 + 9.9) / 3,   "2010Q2": (9.9 + 9.6 + 9.4) / 3,
    "2010Q3": (9.4 + 9.5 + 9.5) / 3,   "2010Q4": (9.4 + 9.8 + 9.3) / 3,
    "2011Q1": (9.1 + 9.0 + 9.0) / 3,   "2011Q2": (9.1 + 9.0 + 9.1) / 3,
    "2011Q3": (9.0 + 9.0 + 9.0) / 3,   "2011Q4": (8.8 + 8.6 + 8.5) / 3,
    "2012Q1": (8.3 + 8.3 + 8.2) / 3,   "2012Q2": (8.2 + 8.2 + 8.2) / 3,
    "2012Q3": (8.2 + 8.1 + 7.8) / 3,   "2012Q4": (7.8 + 7.7 + 7.9) / 3,
    "2013Q1": (8.0 + 7.7 + 7.5) / 3,   "2013Q2": (7.6 + 7.5 + 7.5) / 3,
    "2013Q3": (7.3 + 7.2 + 7.2) / 3,   "2013Q4": (7.2 + 6.9 + 6.7) / 3,
    "2014Q1": (6.6 + 6.7 + 6.7) / 3,   "2014Q2": (6.2 + 6.3 + 6.1) / 3,
    "2014Q3": (6.2 + 6.1 + 5.9) / 3,   "2014Q4": (5.7 + 5.8 + 5.6) / 3,
    "2015Q1": (5.7 + 5.5 + 5.4) / 3,   "2015Q2": (5.4 + 5.6 + 5.3) / 3,
    "2015Q3": (5.2 + 5.1 + 5.0) / 3,   "2015Q4": (5.0 + 5.1 + 5.0) / 3,
    "2016Q1": (4.8 + 4.9 + 5.0) / 3,   "2016Q2": (5.1 + 4.8 + 4.9) / 3,
    "2016Q3": (4.8 + 4.9 + 5.0) / 3,   "2016Q4": (4.9 + 4.7 + 4.7) / 3,
    "2017Q1": (4.7 + 4.6 + 4.4) / 3,   "2017Q2": (4.4 + 4.4 + 4.3) / 3,
    "2017Q3": (4.3 + 4.4 + 4.3) / 3,   "2017Q4": (4.2 + 4.2 + 4.1) / 3,
    "2018Q1": (4.0 + 4.1 + 4.0) / 3,   "2018Q2": (4.0 + 3.8 + 4.0) / 3,
    "2018Q3": (3.8 + 3.8 + 3.7) / 3,   "2018Q4": (3.8 + 3.8 + 3.9) / 3,
    "2019Q1": (4.0 + 3.8 + 3.8) / 3,   "2019Q2": (3.7 + 3.6 + 3.6) / 3,
    "2019Q3": (3.7 + 3.6 + 3.5) / 3,   "2019Q4": (3.6 + 3.6 + 3.6) / 3,
    "2020Q1": (3.6 + 3.5 + 4.4) / 3,   "2020Q2": (14.8 + 13.2 + 11.0) / 3,
    "2020Q3": (10.2 + 8.4 + 7.8) / 3,  "2020Q4": (6.9 + 6.7 + 6.7) / 3,
    "2021Q1": (6.4 + 6.2 + 6.1) / 3,   "2021Q2": (6.1 + 5.8 + 5.9) / 3,
    "2021Q3": (5.4 + 5.1 + 4.7) / 3,   "2021Q4": (4.5 + 4.1 + 3.9) / 3,
    "2022Q1": (4.0 + 3.9 + 3.7) / 3,   "2022Q2": (3.7 + 3.6 + 3.6) / 3,
    "2022Q3": (3.5 + 3.6 + 3.5) / 3,   "2022Q4": (3.6 + 3.6 + 3.5) / 3,
    "2023Q1": (3.5 + 3.6 + 3.5) / 3,   "2023Q2": (3.4 + 3.6 + 3.6) / 3,
    "2023Q3": (3.5 + 3.7 + 3.7) / 3,   "2023Q4": (3.9 + 3.7 + 3.8) / 3,
    "2024Q1": (3.7 + 3.9 + 3.9) / 3,   "2024Q2": (3.9 + 3.9 + 4.1) / 3,
    "2024Q3": (4.2 + 4.2 + 4.1) / 3,   "2024Q4": (4.1 + 4.2 + 4.1) / 3,
    "2025Q1": (4.0 + 4.2 + 4.2) / 3,   "2025Q2": (4.2 + 4.3 + 4.1) / 3,
    "2025Q3": (4.3 + 4.3 + 4.4) / 3,   "2025Q4": (None + 4.5 + 4.4) / 3 if False else (4.5 + 4.4) / 2,
    "2026Q1": (4.3 + 4.4 + 4.3) / 3,
}

# Fix 2025Q4 (missing Oct value)
unemp_data["2025Q4"] = (4.5 + 4.4) / 2  # using Nov and Dec

quarters = sorted(gdp_data.keys())

# Compute annualized GDP growth rate: ((GDP_t / GDP_{t-1})^4 - 1) * 100
gdp_growth = {}
gdp_vals = [gdp_data[q] for q in quarters]
for i in range(1, len(quarters)):
    g_qoq = (gdp_vals[i] / gdp_vals[i-1]) ** 4 - 1
    gdp_growth[quarters[i]] = g_qoq * 100  # percent

# Compute change in unemployment rate (quarterly change)
du = {}
unemp_vals = [unemp_data[q] for q in quarters]
for i in range(1, len(quarters)):
    du[quarters[i]] = unemp_vals[i] - unemp_vals[i-1]

# Prepare regression data
# Exclude 2020-2021 COVID outliers for main specification
quarters_reg = [q for q in quarters if q in gdp_growth and q in du
                and not (q.startswith("2020") or q.startswith("2021"))]

x_all = [gdp_growth[q] for q in quarters_reg]
y_all = [du[q] for q in quarters_reg]

# Regress ΔU = α + β * GDP_growth
slope, intercept, r_value, p_value, std_err = stats.linregress(x_all, y_all)

# Full sample with COVID
quarters_full = [q for q in quarters if q in gdp_growth and q in du]
x_full = [gdp_growth[q] for q in quarters_full]
y_full = [du[q] for q in quarters_full]
slope_f, intercept_f, r_f, p_f, se_f = stats.linregress(x_full, y_full)

# Results summary
n = len(x_all)
t_stat = slope / std_err
print("=" * 70)
print("REPLICATION OF NEELY (2010) - OKUN'S LAW: OUTPUT AND UNEMPLOYMENT")
print("=" * 70)
print(
    f"\nData range: {quarters_reg[0]} to {quarters_reg[-1]}, excluding 2020-2021 COVID period")
print(f"Observations: {n}")
print(f"\nRegression: ΔUnemployment = α + β × GDP_Growth")
print(f"\nResults (excl. COVID):")
print(f"  Intercept (α):    {intercept:.4f}")
print(f"  Slope (β):        {slope:.4f}")
print(f"  R-squared:        {r_value**2:.4f}")
print(f"  Adj. R-squared:   {1 - (1-r_value**2)*(n-1)/(n-2):.4f}")
print(f"  Std Error (β):    {std_err:.4f}")
print(f"  t-statistic:      {t_stat:.4f}")
print(f"  p-value:          {p_value:.6f}")
print(f"\nInterpretation:")
print(f"  A 1 percentage point increase in annual GDP growth")
print(f"  is associated with a {abs(slope):.2f} percentage point DECREASE")
print(f"  in the unemployment rate.")
print(f"\n  The 'break-even' GDP growth rate (ΔU=0) = {-intercept/slope:.2f}%")
print(f"  This means GDP must grow at {-intercept/slope:.2f}% per year")
print(f"  to keep the unemployment rate stable (consistent with ≈3% rule).")
print()

print("-" * 70)
print("Full sample (including COVID):")
print(f"  Slope (β):        {slope_f:.4f}")
print(f"  R-squared:        {r_f**2:.4f}")
print(
    f"  Adj. R-squared:   {1 - (1-r_f**2)*(len(x_full)-1)/(len(x_full)-2):.4f}")
print(f"  Intercept (α):    {intercept_f:.4f}")
print(f"  Break-even growth: {-intercept_f/slope_f:.2f}%")
print()

# === Plot ===
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

# Scatter plot (excl. COVID)
ax1.scatter(x_all, y_all, alpha=0.6, color='steelblue', edgecolors='white')
x_line = np.linspace(min(x_all), max(x_all), 100)
y_line = intercept + slope * x_line
ax1.plot(x_line, y_line, 'r-', linewidth=2,
         label=f'OLS: ΔU = {intercept:.2f} + ({slope:.2f})·g')
ax1.axhline(y=0, color='gray', linestyle='--', alpha=0.5)
ax1.axvline(x=-intercept/slope, color='green', linestyle=':', alpha=0.7,
            label=f'Break-even: {-intercept/slope:.1f}%')
ax1.set_xlabel('Real GDP Growth (Annualized, %)')
ax1.set_ylabel('Change in Unemployment Rate (pp)')
ax1.set_title(
    f'Okun\'s Law (Excl. COVID, {quarters_reg[0]}-{quarters_reg[-1]})')
ax1.legend(fontsize=8)
ax1.grid(True, alpha=0.3)

# Time series
quarters_ts = quarters[1:]  # start from first diff
gdp_ts = [gdp_growth[q] for q in quarters_ts]
du_ts = [du[q] for q in quarters_ts]
x_idx = range(len(quarters_ts))

ax2.plot(x_idx, gdp_ts, 'b-', linewidth=1.5,
         alpha=0.7, label='GDP Growth (%, RHS)')
ax2.plot(x_idx, du_ts, 'r-', linewidth=1.5, label='Δ Unemployment (pp, LHS)')
ax2.axhline(y=0, color='gray', linestyle='--', alpha=0.5)
ax2.set_xlabel('Quarter')
ax2.set_ylabel('Percentage Points')
ax2.set_title('GDP Growth and Change in Unemployment')
ax2.legend(fontsize=8)
ax2.grid(True, alpha=0.3)
ax2.set_xticks(range(0, len(quarters_ts), 12))
ax2.set_xticklabels([quarters_ts[i] for i in range(
    0, len(quarters_ts), 12)], rotation=45, fontsize=7)

plt.tight_layout()
plt.savefig(
    '/Users/xiaoshiishun/Desktop/github 项目练习/okuns_law_figure.png', dpi=150)
print("Figure saved to okuns_law_figure.png")
print("=" * 70)
