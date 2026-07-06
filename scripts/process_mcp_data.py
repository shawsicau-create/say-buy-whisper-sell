"""
Process MCP data and save to CSV
"""
import json
import pandas as pd
from pathlib import Path
import sys

# Setup paths
PROJECT_ROOT = Path(__file__).parent.parent
DATA_DIR = PROJECT_ROOT / "data" / "raw"
CACHE_DIR = Path.home() / ".qoder" / "cache" / "projects" / \
    "github 项目练习-c640eec5" / "agent-tools" / "0ee24bd0"


def load_mcp_result(filename):
    """Load MCP result from cache file"""
    filepath = CACHE_DIR / filename
    if not filepath.exists():
        print(f"File not found: {filepath}")
        return None
    with open(filepath, 'r') as f:
        content = f.read()
    try:
        data = json.loads(content)
        return data
    except Exception as e:
        print(f"Error loading {filename}: {e}")
        return None


def extract_tushare_data(data):
    """Extract data from tushare MCP response"""
    if data is None:
        return []

    # Direct list
    if isinstance(data, list):
        return data

    # Dict with result
    if isinstance(data, dict):
        if 'result' in data:
            result = data['result']
            if isinstance(result, list):
                return result
            if isinstance(result, dict) and 'items' in result:
                return result['items']

    return []


def process_daily_data():
    """Process daily price data"""
    print("\n=== Processing Daily Data ===")

    batch_files = [
        ('25a8510d.txt', 'batch1'),
        ('8e0b6d73.txt', 'batch2'),
        ('c2629815.txt', 'batch3'),
        ('5be2b0b4.txt', 'batch4'),
    ]

    all_data = []
    for fname, label in batch_files:
        data = load_mcp_result(fname)
        items = extract_tushare_data(data)
        if items:
            print(f"  {label}: {len(items)} rows")
            all_data.extend(items)

    if all_data:
        df = pd.DataFrame(all_data)
        # Remove duplicates
        df = df.drop_duplicates()
        # Sort by stock and date
        df = df.sort_values(['ts_code', 'trade_date'])

        # Save to CSV
        outpath = DATA_DIR / "daily_all.csv"
        df.to_csv(outpath, index=False, encoding='utf-8-sig')

        print(f"\nTotal: {len(df)} rows")
        print(f"Stocks: {df['ts_code'].nunique()}")
        print(
            f"Date range: {df['trade_date'].min()} to {df['trade_date'].max()}")
        print(f"Saved to: {outpath}")
        return df
    else:
        print("No daily data found")
        return None


def process_research_reports():
    """Process research report data"""
    print("\n=== Processing Research Reports ===")

    data = load_mcp_result('57e81e9e.txt')
    if data:
        # This is a markdown table format
        print(f"Research reports: loaded")
        # TODO: Parse markdown format
    else:
        print("No research report data found")
    return None


def main():
    print("=" * 60)
    print("Processing MCP Data")
    print("=" * 60)

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    # Process daily data
    df_daily = process_daily_data()

    # Process research reports
    process_research_reports()

    print("\n" + "=" * 60)
    print("Processing Complete")
    print("=" * 60)


if __name__ == "__main__":
    main()
