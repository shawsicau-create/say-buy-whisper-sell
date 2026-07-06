"""
Generate simulated analyst ratings from research reports sample
Since get_stock_research_report API is temporarily unavailable,
we simulate ratings based on existing sample data patterns
"""
import pandas as pd
import numpy as np
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent
DATA_RAW = PROJECT_ROOT / "data" / "raw"
DATA_PROCESSED = PROJECT_ROOT / "data" / "processed"


def generate_simulated_research_data():
    """Generate simulated research data for demo purposes"""
    print("Generating simulated analyst ratings...")

    # Load analysis panel
    panel_path = DATA_PROCESSED / "analysis_panel.csv"
    df = pd.read_csv(panel_path)

    # Simulate analyst ratings based on quarter
    # In reality, this would come from get_stock_research_report API
    np.random.seed(42)

    # Assign random ratings with realistic distribution
    # ~60% Buy/Outperform, ~25% Hold, ~15% Sell/Downgrade
    # StrongBuy, Buy, Hold, Reduce, Sell
    probs = [0.25, 0.25, 0.20, 0.15, 0.15]
    ratings = ['强烈买入', '买入', '中性', '减持', '卖出']

    df['rating'] = np.random.choice(ratings, size=len(df), p=probs)
    df['rating_score'] = df['rating'].map({
        '强烈买入': 2, '买入': 1, '中性': 0, '减持': -1, '卖出': -2
    })
    df['report_date'] = df['quarter_date']

    # Simulate institutional holding change based on returns
    # When returns are high, institutions tend to increase holdings
    df['inst_holder_chg'] = np.where(
        df['ret_q'] > 0,
        np.random.uniform(0, 5, len(df)),  # Increase
        np.random.uniform(-5, 0, len(df))  # Decrease
    )

    # Assign groups based on rating and holder change
    df['rating_high'] = (df['rating_score'] > 0).astype(int)
    df['inst_decrease'] = (df['inst_holder_chg'] < 0).astype(int)

    # 2x2 grouping: A=HighRating+InstIncrease, B=HighRating+InstDecrease,
    #                C=LowRating+InstIncrease, D=LowRating+InstDecrease
    df['group'] = df.apply(
        lambda x: 'A' if x['rating_high'] == 1 and x['inst_decrease'] == 0
        else 'B' if x['rating_high'] == 1 and x['inst_decrease'] == 1
        else 'C' if x['rating_high'] == 0 and x['inst_decrease'] == 0
        else 'D',
        axis=1
    )

    # Save simulated research data
    research_out = DATA_RAW / "research_reports_simulated.csv"
    df[['ts_code', 'quarter', 'rating', 'rating_score', 'report_date']].to_csv(
        research_out, index=False, encoding='utf-8-sig'
    )
    print(f"  Saved simulated ratings to {research_out}")

    # Save enhanced panel
    enhanced_panel = DATA_PROCESSED / "analysis_panel_enhanced.csv"
    df.to_csv(enhanced_panel, index=False, encoding='utf-8-sig')
    print(f"  Saved enhanced panel to {enhanced_panel}")

    # Print group distribution
    print("\nGroup Distribution:")
    print(df['group'].value_counts().sort_index())

    return df


if __name__ == "__main__":
    df = generate_simulated_research_data()
