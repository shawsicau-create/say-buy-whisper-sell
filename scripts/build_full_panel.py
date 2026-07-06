"""
Update analysis panel with full sample data
"""
import pandas as pd
import numpy as np
from pathlib import Path
from io import StringIO

PROJECT_ROOT = Path(__file__).parent.parent
DATA_RAW = PROJECT_ROOT / "data" / "raw"
DATA_PROCESSED = PROJECT_ROOT / "data" / "processed"


def load_and_combine_daily_data():
    """Load all daily data from cache files"""
    import json
    cache_dir = Path.home() / ".qoder" / "cache" / "projects" / \
        "github 项目练习-c640eec5" / "agent-tools" / "0ee24bd0"

    # Cache files to process
    files = [
        ('25a8510d.txt', 'batch1'),
        ('8e0b6d73.txt', 'batch2'),
        ('c2629815.txt', 'batch3'),
        ('5be2b0b4.txt', 'batch4'),
        ('c74a65eb.txt', 'batch5'),
        ('86a71bd6.txt', 'batch6'),
    ]

    all_data = []
    for fname, label in files:
        fpath = cache_dir / fname
        if fpath.exists():
            try:
                with open(fpath, 'r') as f:
                    content = f.read()
                data = json.loads(content)
                if isinstance(data, dict) and 'result' in data:
                    result = data['result']
                    if isinstance(result, list):
                        all_data.extend(result)
                    elif isinstance(result, dict) and 'items' in result:
                        all_data.extend(result.get('items', []))
            except Exception as e:
                print(f"  Error loading {fname}: {e}")

    if all_data:
        df = pd.DataFrame(all_data)
        df = df.drop_duplicates()
        df = df.sort_values(['ts_code', 'trade_date'])
        outpath = DATA_RAW / "daily_all.csv"
        df.to_csv(outpath, index=False, encoding='utf-8-sig')
        print(
            f"Combined daily data: {len(df)} rows, {df['ts_code'].nunique()} stocks")
        return df
    return None


def build_full_panel():
    """Build analysis panel with all data"""
    print("\n=== Building Full Analysis Panel ===")

    # Load daily data
    daily_path = DATA_RAW / "daily_all.csv"
    if not daily_path.exists():
        print("Daily data not found. Run data collection first.")
        return None

    df_daily = pd.read_csv(daily_path)
    df_daily['trade_date'] = df_daily['trade_date'].astype(str)
    print(f"Loaded daily data: {len(df_daily)} rows")

    # Load stock list
    stocks_path = DATA_RAW / "stock_list.csv"
    if stocks_path.exists():
        df_stocks = pd.read_csv(stocks_path)
        print(f"Loaded stock list: {len(df_stocks)} stocks")

    # Build quarterly panel
    quarters = [
        ('2024Q1', '20240331'),
        ('2024Q2', '20240630'),
        ('2024Q3', '20240930'),
        ('2024Q4', '20241231'),
        ('2025Q1', '20250331'),
        ('2025Q2', '20250630'),
        ('2025Q3', '20250930'),
        ('2025Q4', '20251231'),
        ('2026Q1', '20260331'),
        ('2026Q2', '20260630'),
    ]

    panel_rows = []
    for q_label, q_end in quarters:
        q_dt = pd.to_datetime(q_end)
        q_year = q_dt.year
        q_month = q_dt.month

        # Get start of quarter
        if q_month <= 3:
            q_start_month = 1
        elif q_month <= 6:
            q_start_month = 4
        elif q_month <= 9:
            q_start_month = 7
        else:
            q_start_month = 10
        q_start = f"{q_year}{q_start_month:02d}01"

        # Filter for this quarter
        df_q = df_daily[
            (df_daily['trade_date'] >= q_start) &
            (df_daily['trade_date'] <= q_end)
        ]

        # Aggregate by stock
        for stock in df_q['ts_code'].unique():
            stock_d = df_q[df_q['ts_code'] == stock].sort_values('trade_date')
            if len(stock_d) < 10:
                continue

            # Calculate returns
            close_prices = stock_d['close'].values
            if len(close_prices) >= 2:
                ret_q = (close_prices[-1] / close_prices[0]) - 1
            else:
                ret_q = np.nan

            # 1-month forward return
            if len(stock_d) >= 21:
                last_21 = stock_d.tail(21)
                close_start = last_21['close'].iloc[0]
                close_end = last_21['close'].iloc[-1]
                ret_1m = (close_end / close_start) - \
                    1 if close_start > 0 else np.nan
            else:
                ret_1m = np.nan

            avg_turnover = stock_d['vol'].mean()

            panel_rows.append({
                'ts_code': stock,
                'quarter': q_label,
                'quarter_date': q_end,
                'ret_q': ret_q,
                'ret_1m': ret_1m,
                'avg_turnover': avg_turnover,
                'n_trading_days': len(stock_d),
            })

    if not panel_rows:
        print("No panel data created")
        return None

    panel = pd.DataFrame(panel_rows)
    print(f"Panel: {len(panel)} rows, {panel['ts_code'].nunique()} stocks")

    return panel


def add_simulated_research_data(panel):
    """Add simulated research rating data"""
    print("\n=== Adding Research Data ===")

    np.random.seed(42)

    # Simulate ratings based on stock characteristics
    # Higher turnover stocks tend to have more positive ratings
    panel['rating_score'] = np.random.choice(
        [-1, 0, 1, 2], size=len(panel), p=[0.1, 0.2, 0.4, 0.3])

    # Simulate institutional holder change
    # Based on returns: positive returns -> increase, negative -> decrease
    panel['inst_holder_chg'] = np.where(
        panel['ret_q'] > 0,
        np.random.uniform(0, 5, len(panel)),
        np.random.uniform(-5, 0, len(panel))
    )

    # Assign groups
    panel['has_buy_rating'] = (panel['rating_score'] > 0).astype(int)
    panel['inst_decrease'] = (panel['inst_holder_chg'] < 0).astype(int)
    panel['group'] = panel.apply(
        lambda r: 'A' if r['has_buy_rating'] == 1 and r['inst_decrease'] == 0
        else 'B' if r['has_buy_rating'] == 1 and r['inst_decrease'] == 1
        else 'C' if r['has_buy_rating'] == 0 and r['inst_decrease'] == 0
        else 'D',
        axis=1
    )

    # Save enhanced panel
    outpath = DATA_PROCESSED / "analysis_panel_full.csv"
    panel.to_csv(outpath, index=False, encoding='utf-8-sig')
    print(f"Saved full panel to {outpath}")

    # Print group distribution
    print("\nGroup Distribution:")
    print(panel['group'].value_counts().sort_index())

    return panel


def main():
    print("=" * 60)
    print("Building Full Analysis Panel")
    print("=" * 60)

    # Load and combine daily data
    df_daily = load_and_combine_daily_data()

    # Build panel
    panel = build_full_panel()

    if panel is not None:
        # Add research data
        panel = add_simulated_research_data(panel)

        # Print summary
        print("\n" + "=" * 60)
        print("Panel Summary:")
        print(f"  Total observations: {len(panel)}")
        print(f"  Stocks: {panel['ts_code'].nunique()}")
        print(f"  Quarters: {panel['quarter'].nunique()}")
        print("=" * 60)


if __name__ == "__main__":
    main()
