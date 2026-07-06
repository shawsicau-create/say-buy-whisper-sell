"""
Step 2: Event Study
Research Report Rating Change and Trading Behavior Around Events

Tests:
- Rating upgrade/downgrade events
- Cumulative abnormal returns around event dates
- Volume/turnover changes
"""
from utils import *
from config import *
import pandas as pd
import numpy as np
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))


def run_step2():
    """
    Main function for Step 2 event study.

    Tests:
    - CAR around rating upgrade/downgrade events
    - Volume changes around events
    """
    print_section("Step 2: Event Study - Rating Changes")

    # Load data
    research_file = DATA_RAW / "research_reports.csv"
    daily_file = DATA_RAW / "daily_all.csv"

    if not research_file.exists() or not daily_file.exists():
        print("Data files not found.")
        return None

    df_research = pd.read_csv(research_file)
    df_daily = pd.read_csv(daily_file)

    print(f"Research reports: {len(df_research)}")
    print(f"Daily data: {len(df_daily)} rows")

    # Extract rating changes from research reports
    events = extract_rating_events(df_research)
    if len(events) == 0:
        print("No rating events found.")
        return None

    print(f"\nFound {len(events)} rating change events")
    print(f"  Upgrades: {(events['rating_change'] > 0).sum()}")
    print(f"  Downgrades: {(events['rating_change'] < 0).sum()}")

    # Calculate CAR for each event
    df_daily["trade_date"] = df_daily["trade_date"].astype(str)
    df_daily["pct_chg"] = pd.to_numeric(
        df_daily["pct_chg"], errors="coerce").fillna(0)

    # Market return (use equal-weighted average as proxy)
    mkt_ret = df_daily.groupby("trade_date")["pct_chg"].mean()

    car_results = []
    for _, event in events.iterrows():
        stock = event["ts_code"]
        event_date = event["ann_date"]
        change = event["rating_change"]

        car = calculate_car(stock, event_date, mkt_ret, df_daily)
        if car is not None:
            car_results.append({
                "ts_code": stock,
                "event_date": event_date,
                "rating_change": change,
                "car_3d": car["car_3d"],
                "car_20d": car["car_20d"],
            })

    if len(car_results) > 0:
        df_car = pd.DataFrame(car_results)
        results = analyze_car_results(df_car)
        save_results(df_car, results)
        return results

    return None


def extract_rating_events(df_research):
    """
    Extract rating upgrade/downgrade events from research reports.

    Returns DataFrame with ts_code, ann_date, rating_change
    """
    if len(df_research) == 0:
        return pd.DataFrame()

    # Check for rating columns
    rating_cols = [
        c for c in df_research.columns if "rating" in c.lower() or "评级" in c.lower()]

    events = []
    for _, row in df_research.iterrows():
        # Classify current rating
        for col in ["rating", "评级", "title", "rating_change"]:
            if col in row.index:
                rating = classify_rating(str(row[col]))
                ann_date = str(row.get("ann_date", row.get("date", "")))
                ts_code = str(row.get("ts_code", row.get("symbol", "")))

                events.append({
                    "ts_code": ts_code,
                    "ann_date": ann_date,
                    "rating": rating,
                    "rating_change": rating,  # Simplified: each report is a potential event
                })

    return pd.DataFrame(events)


def calculate_car(stock, event_date, mkt_ret, df_daily):
    """
    Calculate cumulative abnormal returns around event.

    Args:
        stock: stock code
        event_date: event date YYYYMMDD
        mkt_ret: market returns series
        df_daily: daily stock data

    Returns:
        dict with car_3d, car_20d
    """
    stock_d = df_daily[df_daily["ts_code"] == stock].sort_values("trade_date")
    if len(stock_d) == 0:
        return None

    try:
        event_idx = stock_d[stock_d["trade_date"] == event_date].index
        if len(event_idx) == 0:
            # Find closest date
            dates = stock_d["trade_date"].tolist()
            closest = min(dates, key=lambda x: abs(int(x) - int(event_date)))
            event_idx = stock_d[stock_d["trade_date"] == closest].index
    except:
        return None

    if len(event_idx) == 0:
        return None

    idx = event_idx[0]
    pos = stock_d.index.get_loc(idx)

    # CAR [-1, +1] = 3-day window
    car_3d = calculate_window_car(stock_d, mkt_ret, pos, 1)

    # CAR [-10, +10] = 20-day window
    car_20d = calculate_window_car(stock_d, mkt_ret, pos, 10)

    return {"car_3d": car_3d, "car_20d": car_20d}


def calculate_window_car(stock_d, mkt_ret, event_pos, half_window):
    """Calculate CAR for a symmetric window around event."""
    window = range(event_pos - half_window, event_pos + half_window + 1)
    valid_idx = [i for i in window if 0 <= i < len(stock_d)]

    if len(valid_idx) < half_window:
        return np.nan

    dates = stock_d.iloc[valid_idx]["trade_date"].tolist()
    stock_rets = stock_d.iloc[valid_idx]["pct_chg"].fillna(0).values / 100

    mkt_rets = []
    for d in dates:
        d_str = str(d)
        mr = mkt_ret.get(d_str, 0)
        if isinstance(mr, pd.Series):
            mr = mr.iloc[0] if len(mr) > 0 else 0
        mkt_rets.append(float(mr) / 100)

    ar = np.array(stock_rets) - np.array(mkt_rets)
    return float(np.sum(ar))


def analyze_car_results(df_car):
    """Analyze CAR results by event type."""
    upgrades = df_car[df_car["rating_change"] > 0]
    downgrades = df_car[df_car["rating_change"] < 0]

    results = {
        "upgrade_car3d_mean": upgrades["car_3d"].mean() if len(upgrades) > 0 else np.nan,
        "upgrade_car3d_tstat": upgrades["car_3d"].mean() / (upgrades["car_3d"].std() / np.sqrt(len(upgrades))) if len(upgrades) > 1 else np.nan,
        "upgrade_n": len(upgrades),
        "downgrade_car3d_mean": downgrades["car_3d"].mean() if len(downgrades) > 0 else np.nan,
        "downgrade_car3d_tstat": downgrades["car_3d"].mean() / (downgrades["car_3d"].std() / np.sqrt(len(downgrades))) if len(downgrades) > 1 else np.nan,
        "downgrade_n": len(downgrades),
    }

    print("\n=== Event Study Results ===")
    print(
        f"Rating Upgrades: CAR[-1,+1] = {results['upgrade_car3d_mean']:.4f} (t={results['upgrade_car3d_tstat']:.2f}, N={results['upgrade_n']})")
    print(
        f"Rating Downgrades: CAR[-1,+1] = {results['downgrade_car3d_mean']:.4f} (t={results['downgrade_car3d_tstat']:.2f}, N={results['downgrade_n']})")

    return results


def save_results(df_car, results):
    """Save event study results."""
    df_car.to_csv(RESULTS_DIR / "step2_event_car.csv",
                  index=False, encoding="utf-8-sig")

    df_results = pd.DataFrame([results])
    df_results.to_csv(RESULTS_DIR / "step2_event_results.csv",
                      index=False, encoding="utf-8-sig")
    print(f"\nResults saved to {RESULTS_DIR}")


if __name__ == "__main__":
    run_step2()
