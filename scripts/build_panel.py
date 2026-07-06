"""
Data Panel Builder
Merges daily prices, research reports, shareholder data into a unified stock-day panel.
"""
from utils import *
from config import *
import pandas as pd
import numpy as np
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))


def build_analysis_panel():
    """
    Build the main analysis panel.

    Returns:
        pd.DataFrame: stock-quarter panel with key variables
    """
    print_section("Building Analysis Panel")

    # Load BaoStock daily data (primary source)
    baostock_file = DATA_RAW / "daily_baostock.csv"
    tushare_file = DATA_RAW / "daily_all.csv"

    if baostock_file.exists():
        df_daily = pd.read_csv(baostock_file)
        # Convert BaoStock format to standard format
        if 'code' in df_daily.columns:
            df_daily['ts_code'] = df_daily['code'].apply(
                lambda x: x.replace('sh.', '').replace(
                    'sz.', '') + ('.SH' if x.startswith('sh') else '.SZ')
            )
        print(f"Loaded BaoStock daily data: {len(df_daily)} rows")
    elif tushare_file.exists():
        df_daily = pd.read_csv(tushare_file)
        print(f"Loaded Tushare daily data: {len(df_daily)} rows")
    else:
        print("Daily data not found. Run fetch_baostock.py first.")
        df_daily = pd.DataFrame()

    # Load research reports
    research_file = DATA_RAW / "research_reports.csv"
    if research_file.exists():
        df_research = pd.read_csv(research_file)
        print(f"Loaded research reports: {len(df_research)} rows")
    else:
        print("Research data not found.")
        df_research = pd.DataFrame()

    # Load shareholder data
    holder_file = DATA_RAW / "circulate_holders.csv"
    if holder_file.exists():
        df_holders = pd.read_csv(holder_file)
        print(f"Loaded holder data: {len(df_holders)} rows")
    else:
        df_holders = pd.DataFrame()

    # Load shareholder count (retail proxy)
    holdernum_file = DATA_RAW / "holder_number.csv"
    if holdernum_file.exists():
        df_holdernum = pd.read_csv(holdernum_file)
        print(f"Loaded holder number data: {len(df_holdernum)} rows")
    else:
        df_holdernum = pd.DataFrame()

    # Build quarterly panel
    panel = build_quarterly_panel(
        df_daily, df_research, df_holders, df_holdernum)

    if len(panel) > 0:
        out_path = DATA_PROCESSED / "analysis_panel.csv"
        panel.to_csv(out_path, index=False, encoding="utf-8-sig")
        print(f"\nPanel saved: {len(panel)} rows to {out_path}")
        print(panel.head())

    return panel


def build_quarterly_panel(df_daily, df_research, df_holders, df_holdernum):
    """
    Build stock-quarter panel for the 5 empirical steps.

    Variables:
    - ts_code: stock code
    - quarter: YYYYQN format
    - ret_q: quarterly return
    - ret_1m, ret_3m, ret_6m: forward holding period returns
    - avg_turnover: average daily turnover in quarter
    - inst_holder_pct: institutional holding percentage (from circulate holders)
    - inst_holder_chg: QoQ change in institutional holdings
    - rating_score: consensus rating score (positive minus negative reports)
    - rating_count: total number of reports
    - holder_num_chg: QoQ change in shareholder count (retail proxy)
    - size: market cap at quarter end
    """
    quarters = quarter_end_dates()

    panel_rows = []
    for q in quarters:
        # Process each quarter
        q_data = process_quarter(
            q, df_daily, df_research, df_holders, df_holdernum)
        if q_data is not None:
            panel_rows.extend(q_data)

    if not panel_rows:
        return pd.DataFrame()

    panel = pd.DataFrame(panel_rows)

    # Add derived variables
    if "rating_score" in panel.columns:
        panel["has_buy_rating"] = (panel["rating_score"] > 0).astype(int)

    if "inst_holder_chg" in panel.columns:
        panel["inst_decrease"] = (panel["inst_holder_chg"] < 0).astype(int)

    return panel


def process_quarter(quarter_date, df_daily, df_research, df_holders, df_holdernum):
    """Process data for a single quarter."""
    q_dt = pd.to_datetime(quarter_date)
    q_year = q_dt.year
    q_month = q_dt.month
    q_label = f"{q_year}Q{(q_month - 1) // 3 + 1}"

    # Filter daily data for this quarter
    if len(df_daily) == 0:
        return []

    df_daily["trade_date"] = df_daily.get(
        "trade_date", df_daily.get("date", "")).astype(str)
    q_start = f"{q_year}{q_month:02d}01"
    q_end = quarter_date

    q_daily = df_daily[
        (df_daily["trade_date"] >= q_start) &
        (df_daily["trade_date"] <= q_end)
    ]

    if len(q_daily) == 0:
        return []

    # Aggregate to stock-quarter
    stocks = q_daily["ts_code"].unique()
    rows = []
    for stock in stocks:
        stock_d = q_daily[q_daily["ts_code"]
                          == stock].sort_values("trade_date")
        if len(stock_d) < 5:
            continue

        # Returns
        ret_q = (1 + stock_d["pct_chg"].fillna(0) / 100).prod() - 1
        ret_1m = (1 + stock_d["pct_chg"].fillna(0).iloc[-5:] /
                  100).prod() - 1 if len(stock_d) >= 5 else np.nan
        ret_3m = np.nan
        ret_6m = np.nan

        # Turnover
        avg_turnover = stock_d["vol"].mean(
        ) if "vol" in stock_d.columns else np.nan

        rows.append({
            "ts_code": stock,
            "quarter": q_label,
            "quarter_date": quarter_date,
            "ret_q": ret_q,
            "ret_1m": ret_1m,
            "ret_3m": ret_3m,
            "ret_6m": ret_6m,
            "avg_turnover": avg_turnover,
            "n_trading_days": len(stock_d),
        })

    return rows


if __name__ == "__main__":
    panel = build_analysis_panel()
