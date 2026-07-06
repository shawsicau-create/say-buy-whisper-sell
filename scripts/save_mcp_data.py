"""
Save MCP data to files for processing
"""
import json
import pandas as pd
from pathlib import Path
from io import StringIO

# Project paths
PROJECT_ROOT = Path(__file__).parent.parent
DATA_DIR = PROJECT_ROOT / "data" / "raw"

# Stock list from iFinD search
STOCK_LIST = """000001.SZ,000021.SZ,000100.SZ,000157.SZ,000166.SZ,000301.SZ,000338.SZ,000333.SZ,000425.SZ,000538.SZ,000568.SZ,000651.SZ,000625.SZ,000703.SZ,000708.SZ,000725.SZ,000768.SZ,000776.SZ,000783.SZ,000792.SZ,000858.SZ,000831.SZ,000895.SZ,000960.SZ,000963.SZ,000975.SZ,000977.SZ,001965.SZ,001979.SZ,002001.SZ,002008.SZ,002027.SZ,002028.SZ,002049.SZ,002064.SZ,002142.SZ,002179.SZ,002185.SZ,002230.SZ,002236.SZ,002241.SZ,002281.SZ,002311.SZ,002304.SZ,002352.SZ,002371.SZ,002409.SZ,002414.SZ,002415.SZ,002422.SZ,002436.SZ,002460.SZ,002463.SZ,002466.SZ,002475.SZ,002493.SZ,002594.SZ,002648.SZ,002736.SZ,002821.SZ,002850.SZ,002916.SZ,002920.SZ,002938.SZ,003031.SZ,003816.SZ,600000.SH,600011.SH,600010.SH,600015.SH,600018.SH,600016.SH,600019.SH,600023.SH,600025.SH,600030.SH,600036.SH,600039.SH,600050.SH,600115.SH,600160.SH,600188.SH,600196.SH,600309.SH,600346.SH,600362.SH,600372.SH,600378.SH,600406.SH,600415.SH,600436.SH,600482.SH,600489.SH,600497.SH,600498.SH,600519.SH,600547.SH,600584.SH,600585.SH,600660.SH,600674.SH,600803.SH,600795.SH,600809.SH,600875.SH,600887.SH,600886.SH,600879.SH,600885.SH,600893.SH,600900.SH,600905.SH,600909.SH,600919.SH,600926.SH,600938.SH,600958.SH,600989.SH,600988.SH,600999.SH,601006.SH,601009.SH,601088.SH,601059.SH,601066.SH,601100.SH,601111.SH,601138.SH,601166.SH,601169.SH,601186.SH,601179.SH,601229.SH,601288.SH,601233.SH,601318.SH,601328.SH,601336.SH,601319.SH,601360.SH,601377.SH,601398.SH,601601.SH,601628.SH,601658.SH,601668.SH,601669.SH,601689.SH,601698.SH,601728.SH,601788.SH,601800.SH,601818.SH,601868.SH,601872.SH,601888.SH,601881.SH,601898.SH,601899.SH,601901.SH,601916.SH,601919.SH,601958.SH,601939.SH,601988.SH,601991.SH,601995.SH,601998.SH,603156.SH,603260.SH,603259.SH,603650.SH,603799.SH,605117.SH,600276.SH"""


def save_stock_list():
    """Save stock list"""
    stocks = [s.strip() for s in STOCK_LIST.split(',') if s.strip()]
    df = pd.DataFrame({'ts_code': stocks})
    df['symbol'] = df['ts_code'].str.replace('.SZ|.SH', '', regex=True)
    df['exchange'] = df['ts_code'].apply(
        lambda x: 'SZ' if x.endswith('.SZ') else 'SH')
    outpath = DATA_DIR / "stock_list.csv"
    df.to_csv(outpath, index=False, encoding='utf-8-sig')
    print(f"Saved {len(df)} stocks to {outpath}")
    return df


def save_shareholder_data():
    """Save shareholder data from iFinD results"""
    # 贵州茅台
    kweijiu_data = """ts_code,date,inst_holding_pct,top10_holding_pct
600519.SH,20241231,76.46,71.31
600519.SH,20231231,77.11,71.34"""

    # 平安银行
    pingan_data = """ts_code,date,inst_holding_pct,top10_holding_pct
000001.SZ,20241231,69.07,66.56"""

    # 美的集团 (multiple quarters)
    meidi_data = """ts_code,date,inst_holding_pct,top10_holding_pct
000333.SZ,20241231,66.05,60.23
000333.SZ,20240930,64.94,60.67
000333.SZ,20240630,66.90,59.02
000333.SZ,20240331,65.90,60.96"""

    all_data = []
    for data_str in [kweijiu_data, pingan_data, meidi_data]:
        df = pd.read_csv(StringIO(data_str))
        all_data.append(df)

    combined = pd.concat(all_data, ignore_index=True)
    outpath = DATA_DIR / "shareholders_ifind.csv"
    combined.to_csv(outpath, index=False, encoding='utf-8-sig')
    print(f"Saved {len(combined)} shareholder records to {outpath}")
    return combined


def main():
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    print("=" * 60)
    print("Saving MCP Data")
    print("=" * 60)

    # Save stock list
    df_stocks = save_stock_list()

    # Save shareholder data
    df_shareholders = save_shareholder_data()

    print("\n" + "=" * 60)
    print("Stock list sample:")
    print(df_stocks.head(10))
    print("\nShareholder data sample:")
    print(df_shareholders)
    print("=" * 60)


if __name__ == "__main__":
    main()
