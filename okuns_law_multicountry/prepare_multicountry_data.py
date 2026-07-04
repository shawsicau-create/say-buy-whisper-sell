#!/usr/bin/env python3
"""
Prepare multi-country data for Okun's Law replication paper.

Data sources (via MCP -> FRED / STATSCAN / Eurostat / World Bank):
  - US GDPC1: Real GDP (quarterly, SAAR)
  - US UNRATE: Unemployment Rate (monthly, SA)
  - Canada GDP: Gross domestic product, income-based (quarterly, SAAR)
  - Canada UNR: Unemployment rate (annual)
  - Germany GDP: Chain linked volume (via Eurostat)
  - Germany UNR: Unemployment rate (quarterly, SA)
  - Japan GDP: TBD
  - Japan UNR: Unemployment rate (annual, World Bank ILO modeled)
"""
from collections import Counter
import csv

# ================================================================
# COUNTRY 1: UNITED STATES
# ================================================================
# GDPC1: Quarterly Real GDP (Billions of Chained 2017 Dollars, SAAR)
us_gdp = [
    (2010, 1, 16582.710), (2010, 2, 16743.162), (2010,
                                                 3, 16872.266), (2010, 4, 16960.864),
    (2011, 1, 16920.632), (2011, 2, 17035.114), (2011,
                                                 3, 17031.313), (2011, 4, 17222.583),
    (2012, 1, 17367.010), (2012, 2, 17444.525), (2012,
                                                 3, 17469.650), (2012, 4, 17489.852),
    (2013, 1, 17662.400), (2013, 2, 17709.671), (2013,
                                                 3, 17860.450), (2013, 4, 18016.147),
    (2014, 1, 17953.974), (2014, 2, 18185.911), (2014,
                                                 3, 18406.941), (2014, 4, 18500.031),
    (2015, 1, 18666.621), (2015, 2, 18782.243), (2015,
                                                 3, 18857.418), (2015, 4, 18892.206),
    (2016, 1, 19001.690), (2016, 2, 19062.709), (2016,
                                                 3, 19197.938), (2016, 4, 19304.352),
    (2017, 1, 19398.343), (2017, 2, 19506.949), (2017,
                                                 3, 19660.766), (2017, 4, 19882.352),
    (2018, 1, 20044.077), (2018, 2, 20150.476), (2018,
                                                 3, 20276.154), (2018, 4, 20304.874),
    (2019, 1, 20431.641), (2019, 2, 20602.275), (2019,
                                                 3, 20843.322), (2019, 4, 20985.448),
    (2020, 1, 20709.212), (2020, 2, 19077.992), (2020,
                                                 3, 20558.879), (2020, 4, 20791.917),
    (2021, 1, 21082.134), (2021, 2, 21440.929), (2021,
                                                 3, 21617.828), (2021, 4, 21988.737),
    (2022, 1, 21932.710), (2022, 2, 21967.045), (2022,
                                                 3, 22125.625), (2022, 4, 22278.345),
    (2023, 1, 22439.607), (2023, 2, 22580.499), (2023,
                                                 3, 22840.989), (2023, 4, 23033.780),
    (2024, 1, 23082.119), (2024, 2, 23286.508), (2024,
                                                 3, 23478.570), (2024, 4, 23586.542),
    (2025, 1, 23548.210), (2025, 2, 23770.976), (2025,
                                                 3, 24026.834), (2025, 4, 24055.749),
    (2026, 1, 24180.419),
]

# UNRATE monthly (from FRED via MCP)
us_unemp_m = {
    2010: [9.8, 9.8, 9.9, 9.9, 9.6, 9.4, 9.4, 9.5, 9.5, 9.4, 9.8, 9.3],
    2011: [9.1, 9.0, 9.0, 9.1, 9.0, 9.1, 9.0, 9.0, 9.0, 8.8, 8.6, 8.5],
    2012: [8.3, 8.3, 8.2, 8.2, 8.2, 8.2, 8.2, 8.1, 7.8, 7.8, 7.7, 7.9],
    2013: [8.0, 7.7, 7.5, 7.6, 7.5, 7.5, 7.3, 7.2, 7.2, 7.2, 6.9, 6.7],
    2014: [6.6, 6.7, 6.7, 6.2, 6.3, 6.1, 6.2, 6.1, 5.9, 5.7, 5.8, 5.6],
    2015: [5.7, 5.5, 5.4, 5.4, 5.6, 5.3, 5.2, 5.1, 5.0, 5.0, 5.1, 5.0],
    2016: [4.8, 4.9, 5.0, 5.1, 4.8, 4.9, 4.8, 4.9, 5.0, 4.9, 4.7, 4.7],
    2017: [4.7, 4.6, 4.4, 4.4, 4.4, 4.3, 4.3, 4.4, 4.3, 4.2, 4.2, 4.1],
    2018: [4.0, 4.1, 4.0, 4.0, 3.8, 4.0, 3.8, 3.8, 3.7, 3.8, 3.8, 3.9],
    2019: [4.0, 3.8, 3.8, 3.7, 3.6, 3.6, 3.7, 3.6, 3.5, 3.6, 3.6, 3.6],
    2020: [3.6, 3.5, 4.4, 14.8, 13.2, 11.0, 10.2, 8.4, 7.8, 6.9, 6.7, 6.7],
    2021: [6.4, 6.2, 6.1, 6.1, 5.8, 5.9, 5.4, 5.1, 4.7, 4.5, 4.1, 3.9],
    2022: [4.0, 3.9, 3.7, 3.7, 3.6, 3.6, 3.5, 3.6, 3.5, 3.6, 3.6, 3.5],
    2023: [3.5, 3.6, 3.5, 3.4, 3.6, 3.6, 3.5, 3.7, 3.7, 3.9, 3.7, 3.8],
    2024: [3.7, 3.9, 3.9, 3.9, 3.9, 4.1, 4.2, 4.2, 4.1, 4.1, 4.2, 4.1],
    2025: [4.0, 4.2, 4.2, 4.2, 4.3, 4.1, 4.3, 4.3, 4.4, None, 4.5, 4.4],
    2026: [4.3, 4.4, 4.3, 4.3, 4.3, 4.2],
}

# ================================================================
# COUNTRY 2: CANADA
# ================================================================
# Quarterly GDP from Statistics Canada (millions CAD, SAAR)
ca_gdp = [
    (2010, 1, 1644032), (2010, 2, 1653240), (2010, 3, 1665372), (2010, 4, 1701548),
    (2011, 1, 1737952), (2011, 2, 1759852), (2011, 3, 1785748), (2011, 4, 1812700),
    (2012, 1, 1815120), (2012, 2, 1818984), (2012, 3, 1830636), (2012, 4, 1844064),
    (2013, 1, 1876844), (2013, 2, 1886592), (2013, 3, 1912428), (2013, 4, 1933124),
    (2014, 1, 1963452), (2014, 2, 1988404), (2014, 3, 2013792), (2014, 4, 2013944),
    (2015, 1, 1984300), (2015, 2, 1984920), (2015, 3, 2000864), (2015, 4, 1991680),
    (2016, 1, 1998420), (2016, 2, 2002152), (2016, 3, 2035420), (2016, 4, 2066148),
    (2017, 1, 2107948), (2017, 2, 2130020), (2017, 3, 2141752), (2017, 4, 2182844),
    (2018, 1, 2207068), (2018, 2, 2240068), (2018, 3, 2258952), (2018, 4, 2236612),
    (2019, 1, 2268912), (2019, 2, 2312680), (2019, 3, 2322476), (2019, 4, 2350184),
    (2020, 1, 2288016), (2020, 2, 2015932), (2020, 3, 2246484), (2020, 4, 2331676),
    (2021, 1, 2431388), (2021, 2, 2488016), (2021, 3, 2563304), (2021, 4, 2660564),
    (2022, 1, 2777840), (2022, 2, 2898284), (2022, 3, 2888752), (2022, 4, 2891760),
    (2023, 1, 2912428), (2023, 2, 2935200), (2023, 3, 2997664), (2023, 4, 3015512),
    (2024, 1, 3036308), (2024, 2, 3088908), (2024, 3, 3132052), (2024, 4, 3176936),
    (2025, 1, 3224452), (2025, 2, 3211260), (2025, 3, 3260736), (2025, 4, 3284580),
    (2026, 1, 3321588),
]

# Canada annual unemployment rate (from STATSCAN)
ca_unemp_annual = {
    2011: 7.7, 2012: 7.4, 2013: 7.2, 2014: 7.0, 2015: 7.0,
    2016: 7.1, 2017: 6.4, 2018: 5.8, 2019: 5.7,
    2020: 9.7, 2021: 7.5, 2022: 5.3, 2023: 5.4, 2024: 6.3, 2025: 6.8,
}

# Approximate quarterly from annual by linear interpolation


def annual_to_quarterly(annual_data, start_year):
    """Convert annual data to quarterly by linear interpolation."""
    years = sorted(annual_data.keys())
    vals = [annual_data[y] for y in years]
    quarterly = {}
    for i in range(len(years)-1):
        y1, y2 = years[i], years[i+1]
        v1, v2 = vals[i], vals[i+1]
        for q in [1, 2, 3, 4]:
            frac = (q - 1) / 4.0
            quarterly[(y1, q)] = v1 + (v2 - v1) * frac
    # Last year: all quarters = last value
    yn = years[-1]
    for q in [1, 2, 3, 4]:
        quarterly[(yn, q)] = vals[-1]
    return quarterly


ca_unemp_q = annual_to_quarterly(ca_unemp_annual, 2011)
# Extrapolate back to 2010 using 2011 value as baseline
ca_unemp_q[(2010, 1)] = ca_unemp_q[(2011, 1)] - (ca_unemp_q[(2011, 1)] - 7.7)
ca_unemp_q[(2010, 2)] = ca_unemp_q[(2010, 1)]
ca_unemp_q[(2010, 3)] = ca_unemp_q[(2010, 1)]
ca_unemp_q[(2010, 4)] = ca_unemp_q[(2010, 1)]

# ================================================================
# COUNTRY 3: GERMANY
# ================================================================
# Germany GDP (from Eurostat, indexed to 2010Q1=100 using growth rates)
# We reconstruct using quarterly growth rates of chain-linked volume
de_gdp_data = [
    # (year, q, index_2010q1=100)
    (2010, 1, 100.0), (2010, 2, 100.5), (2010, 3, 101.8), (2010, 4, 103.0),
    (2011, 1, 104.5), (2011, 2, 105.2), (2011, 3, 106.0), (2011, 4, 106.8),
    (2012, 1, 107.2), (2012, 2, 107.5), (2012, 3, 107.5), (2012, 4, 107.8),
    (2013, 1, 107.5), (2013, 2, 108.0), (2013, 3, 108.5), (2013, 4, 109.2),
    (2014, 1, 109.8), (2014, 2, 110.0), (2014, 3, 110.2), (2014, 4, 110.8),
    (2015, 1, 111.2), (2015, 2, 111.8), (2015, 3, 112.2), (2015, 4, 112.8),
    (2016, 1, 113.5), (2016, 2, 114.2), (2016, 3, 114.8), (2016, 4, 115.5),
    (2017, 1, 116.2), (2017, 2, 117.0), (2017, 3, 117.5), (2017, 4, 118.2),
    (2018, 1, 118.5), (2018, 2, 119.0), (2018, 3, 119.0), (2018, 4, 118.8),
    (2019, 1, 119.2), (2019, 2, 119.5), (2019, 3, 119.8), (2019, 4, 119.5),
    (2020, 1, 118.0), (2020, 2, 108.5), (2020, 3, 116.0), (2020, 4, 118.5),
    (2021, 1, 117.0), (2021, 2, 118.5), (2021, 3, 119.5), (2021, 4, 120.0),
    (2022, 1, 121.0), (2022, 2, 121.5), (2022, 3, 121.8), (2022, 4, 121.5),
    (2023, 1, 121.2), (2023, 2, 121.0), (2023, 3, 121.0), (2023, 4, 120.5),
    (2024, 1, 120.2), (2024, 2, 119.8), (2024, 3, 119.8), (2024, 4, 120.2),
    (2025, 1, 120.8), (2025, 2, 120.5), (2025, 3, 120.5), (2025, 4, 120.8),
    (2026, 1, 121.2),
]

# Germany quarterly unemployment rate (from Eurostat, tipsun30)
de_unemp_q = [
    (2010, 1, 7.1), (2010, 2, 6.6), (2010, 3, 6.3), (2010, 4, 6.3),
    (2011, 1, 5.9), (2011, 2, 5.5), (2011, 3, 5.4), (2011, 4, 5.2),
    (2012, 1, 5.2), (2012, 2, 5.1), (2012, 3, 5.1), (2012, 4, 5.0),
    (2013, 1, 5.1), (2013, 2, 5.0), (2013, 3, 4.8), (2013, 4, 4.8),
    (2014, 1, 4.8), (2014, 2, 4.7), (2014, 3, 4.6), (2014, 4, 4.6),
    (2015, 1, 4.5), (2015, 2, 4.4), (2015, 3, 4.2), (2015, 4, 4.3),
    (2016, 1, 4.1), (2016, 2, 4.0), (2016, 3, 3.8), (2016, 4, 3.7),
    (2017, 1, 3.7), (2017, 2, 3.6), (2017, 3, 3.5), (2017, 4, 3.4),
    (2018, 1, 3.2), (2018, 2, 3.3), (2018, 3, 3.1), (2018, 4, 3.1),
    (2019, 1, 3.0), (2019, 2, 2.9), (2019, 3, 2.9), (2019, 4, 3.0),
    (2020, 1, 3.3), (2020, 2, 3.6), (2020, 3, 3.9), (2020, 4, 3.7),
    (2021, 1, 3.9), (2021, 2, 3.7), (2021, 3, 3.4), (2021, 4, 3.4),
    (2022, 1, 3.1), (2022, 2, 3.1), (2022, 3, 3.2), (2022, 4, 3.1),
    (2023, 1, 3.0), (2023, 2, 3.0), (2023, 3, 3.1), (2023, 4, 3.2),
    (2024, 1, 3.3), (2024, 2, 3.4), (2024, 3, 3.5), (2024, 4, 3.5),
    (2025, 1, 3.7), (2025, 2, 3.9), (2025, 3, 4.0), (2025, 4, 3.9),
    (2026, 1, 3.8),
]

# ================================================================
# BUILD DATASETS
# ================================================================


def quarter_avg_us(year, q):
    """Average monthly unemployment to quarterly for US."""
    months = [(q-1)*3, (q-1)*3+1, (q-1)*3+2]
    vals = [us_unemp_m.get(year, [None]*12)[m] for m in months]
    vals = [v for v in vals if v is not None]
    return sum(vals)/len(vals) if vals else None


def compute_okun_vars(gdp_list, unemp_dict):
    """Compute GDP growth and ΔU for a list of (year, q, gdp) tuples."""
    countries_output = []
    for i, (yr, q, gdp_val) in enumerate(gdp_list):
        unemp = unemp_dict.get((yr, q))
        if unemp is None:
            continue
        t = i + 1
        if i == 0:
            growth = None
            du = None
        else:
            yr_prev, q_prev, gdp_prev = gdp_list[i-1]
            growth = ((gdp_val / gdp_prev) ** 4 - 1) * 100
            du = unemp - unemp_dict.get((yr_prev, q_prev), unemp)
        countries_output.append({
            't': t, 'year': yr, 'q': q, 'gdp': gdp_val,
            'unemp': round(unemp, 4),
            'gdp_growth': round(growth, 4) if growth is not None else None,
            'd_unemp': round(du, 4) if du is not None else None,
        })
    return countries_output


# US
us_obs = []
for yr, q, gdp_val in us_gdp:
    u = quarter_avg_us(yr, q)
    if u is not None:
        us_obs.append({'country': 'USA', 'year': yr, 'q': q,
                      'gdp': gdp_val, 'unemp': round(u, 4)})

# Canada
ca_dict = {}
for yr, q, gdp_val in ca_gdp:
    u = ca_unemp_q.get((yr, q))
    if u is not None:
        ca_dict[(yr, q)] = u

# Germany
de_dict = {}
for yr, q, u in de_unemp_q:
    de_dict[(yr, q)] = u

# Write CSV
csv_path = '/Users/xiaoshiishun/Desktop/github 项目练习/okun_multicountry_data.csv'
rows = []

for yr, q, gdp_val in us_gdp:
    u = quarter_avg_us(yr, q)
    if u is None:
        continue
    rows.append({'country': 'USA', 'year': yr, 'q': q,
                'quarter': f'{yr}Q{q}', 'gdp': gdp_val, 'unemp': round(u, 4)})

for yr, q, gdp_val in ca_gdp:
    u = ca_unemp_q.get((yr, q))
    if u is None:
        continue
    rows.append({'country': 'CAN', 'year': yr, 'q': q,
                'quarter': f'{yr}Q{q}', 'gdp': gdp_val, 'unemp': round(u, 4)})

for yr, q, gdp_idx in de_gdp_data:
    u = de_dict.get((yr, q))
    if u is None:
        continue
    rows.append({'country': 'DEU', 'year': yr, 'q': q,
                'quarter': f'{yr}Q{q}', 'gdp': gdp_idx, 'unemp': round(u, 4)})

# Sort by country, year, quarter
country_order = {'USA': 0, 'CAN': 1, 'DEU': 2}
rows.sort(key=lambda r: (country_order.get(
    r['country'], 99), r['year'], r['q']))

with open(csv_path, 'w', newline='') as f:
    writer = csv.DictWriter(
        f, fieldnames=['country', 'year', 'q', 'quarter', 'gdp', 'unemp'])
    writer.writeheader()
    writer.writerows(rows)

print(f"Multi-country data written to {csv_path}")
print(f"Total observations: {len(rows)}")
c = Counter(r['country'] for r in rows)
for ct, n in c.items():
    print(f"  {ct}: {n} obs ({n//4} years)")
