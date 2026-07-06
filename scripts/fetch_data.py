"""
Data Collection Script
Collects full-sample data for say-buy/whisper-sell research
"""
from config import DATA_RAW
import json
import pandas as pd
from pathlib import Path
from datetime import datetime, timedelta
import sys
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts"))

# Data directory
DATA_DIR = DATA_RAW


def save_json_to_csv(data, filename):
    """Convert JSON data to CSV and save"""
    filepath = DATA_DIR / filename
    if isinstance(data, dict) and "result" in data:
        result = data["result"]
        if isinstance(result, str):
            # Try to parse as JSON
            try:
                result = json.loads(result)
            except:
                print(f"  Warning: Could not parse JSON for {filename}")
                return None
        if isinstance(result, list) and len(result) > 0:
            df = pd.DataFrame(result)
            df.to_csv(filepath, index=False, encoding="utf-8-sig")
            print(f"  Saved {len(df)} rows to {filepath}")
            return df
        elif isinstance(result, dict):
            df = pd.DataFrame([result])
            df.to_csv(filepath, index=False, encoding="utf-8-sig")
            print(f"  Saved 1 row to {filepath}")
            return df
    return None


def main():
    """Main data collection function"""
    print("=" * 60)
    print("Data Collection for Say-Buy/Whisper-Sell Research")
    print("=" * 60)

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    # Sample stocks for demo (in production, use full stock list)
    # These are representative stocks from different industries
    sample_stocks = [
        "000001.SZ",  # 平安银行
        "000002.SZ",  # 万科A
        "000063.SZ",  # 中兴通讯
        "000333.SZ",  # 美的集团
        "000858.SZ",  # 五粮液
        "600519.SH",  # 贵州茅台
        "600036.SH",  # 招商银行
        "600276.SH",  # 恒瑞医药
        "600887.SH",  # 伊利股份
        "601318.SH",  # 中国平安
    ]

    print("\nData will be collected for:")
    for s in sample_stocks:
        print(f"  - {s}")
    print(f"\nTotal: {len(sample_stocks)} stocks")
    print("\nNote: Run MCP tools manually to fetch data, then use this script to process.")
    print("\nRequired data files:")
    print("  1. daily_all.csv - Daily price data")
    print("  2. research_reports.csv - Research reports with ratings")
    print("  3. circulate_holders.csv - Institutional holders data")
    print("  4. holder_number.csv - Shareholder count data")


if __name__ == "__main__":
    main()
