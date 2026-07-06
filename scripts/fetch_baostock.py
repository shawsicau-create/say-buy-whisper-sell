"""
BaoStock Data Fetcher for Say-Buy/Whisper-Sell Research
======================================================
BaoStock: 免费、无需注册、无频率限制的A股数据源

功能：
1. 日交易数据（K线）
2. 财务指标
3. 复权因子
"""

from config import DATA_RAW, SAMPLE_START, SAMPLE_END
import baostock as bs
import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime
import sys
import time

# Add project paths
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "scripts"))

# BaoStock股票代码转换


def ts_to_baostock(ts_code):
    """将Tushare格式(000001.SZ)转换为BaoStock格式(sz.000001)"""
    if ts_code.endswith('.SH'):
        return f"sh.{ts_code.replace('.SH', '')}"
    elif ts_code.endswith('.SZ'):
        return f"sz.{ts_code.replace('.SZ', '')}"
    return ts_code


def baostock_to_ts(code):
    """将BaoStock格式(sz.000001)转换为Tushare格式(000001.SZ)"""
    if code.startswith('sh.'):
        return f"{code.replace('sh.', '')}.SH"
    elif code.startswith('sz.'):
        return f"{code.replace('sz.', '')}.SZ"
    return code


def fetch_daily_data(bs_code, start_date, end_date, fields=None):
    """
    采集单只股票的日交易数据

    Args:
        bs_code: BaoStock格式代码 (如 'sz.000001')
        start_date: 开始日期 'YYYY-MM-DD'
        end_date: 结束日期 'YYYY-MM-DD'
        fields: 字段列表

    Returns:
        pd.DataFrame
    """
    if fields is None:
        fields = "date,code,open,high,low,close,preclose,volume,amount,turn,pctChg"

    rs = bs.query_history_k_data_plus(
        bs_code,
        fields,
        start_date=start_date,
        end_date=end_date,
        frequency="d",
        adjustflag="3"  # 不复权
    )

    data = []
    while rs.error_code == '0' and rs.next():
        data.append(rs.get_row_data())

    if data:
        df = pd.DataFrame(data, columns=rs.fields)
        df['ts_code'] = baostock_to_ts(bs_code)
        return df
    return pd.DataFrame()


def fetch_all_daily(stock_list=None, start_date='2010-01-01', end_date=None):
    """
    批量采集所有股票的日交易数据

    Args:
        stock_list: 股票代码列表，None则采集沪深300成分
        start_date: 开始日期
        end_date: 结束日期，默认今天
    """
    if end_date is None:
        end_date = datetime.now().strftime('%Y-%m-%d')

    # 默认股票列表（示例）
    if stock_list is None:
        stock_list = [
            'sz.000001', 'sz.000002', 'sz.000063', 'sz.000333', 'sz.000858',
            'sh.600519', 'sh.600036', 'sh.600276', 'sh.600887', 'sh.601318',
            'sh.601166', 'sh.601398',
        ]

    all_data = []
    total = len(stock_list)

    print(f"开始采集 {total} 只股票的日交易数据...")
    print(f"日期范围: {start_date} 至 {end_date}")
    print("-" * 50)

    for i, code in enumerate(stock_list, 1):
        try:
            df = fetch_daily_data(code, start_date, end_date)
            if len(df) > 0:
                all_data.append(df)
                print(f"[{i}/{total}] {code}: {len(df)} 条记录")
            else:
                print(f"[{i}/{total}] {code}: 无数据")
        except Exception as e:
            print(f"[{i}/{total}] {code}: 错误 - {e}")

        # 避免请求过快
        time.sleep(0.1)

    if all_data:
        combined = pd.concat(all_data, ignore_index=True)

        # 数据类型转换
        numeric_cols = ['open', 'high', 'low', 'close', 'preclose',
                        'volume', 'amount', 'turn', 'pctChg']
        for col in numeric_cols:
            if col in combined.columns:
                combined[col] = pd.to_numeric(combined[col], errors='coerce')

        return combined
    return pd.DataFrame()


def fetch_financial_data(bs_code, year, quarter):
    """
    采集单季度财务数据
    """
    # 利润表
    rs_profit = bs.query_profit_data(code=bs_code, year=year, quarter=quarter)
    profit_data = []
    while rs_profit.error_code == '0' and rs_profit.next():
        profit_data.append(rs_profit.get_row_data())

    # 资产负债表
    rs_balance = bs.query_balance_sheet_data(
        code=bs_code, year=year, quarter=quarter)
    balance_data = []
    while rs_balance.error_code == '0' and rs_balance.next():
        balance_data.append(rs_balance.get_row_data())

    return pd.DataFrame(profit_data), pd.DataFrame(balance_data)


def fetch_all_financial(stock_list, start_year=2010, end_year=None):
    """
    批量采集财务数据
    """
    if end_year is None:
        end_year = datetime.now().year

    all_financial = []
    total = len(stock_list) * 4 * (end_year - start_year + 1)  # 4 quarters

    print(f"开始采集财务数据...")
    print("-" * 50)

    count = 0
    for code in stock_list:
        for year in range(start_year, end_year + 1):
            for quarter in range(1, 5):
                try:
                    profit_df, balance_df = fetch_financial_data(
                        code, year, quarter)
                    if len(profit_df) > 0:
                        profit_df['type'] = 'profit'
                        balance_df['type'] = 'balance'
                        all_financial.extend([profit_df, balance_df])
                    count += 1
                except Exception as e:
                    pass

                time.sleep(0.05)

    if all_financial:
        return pd.concat(all_financial, ignore_index=True)
    return pd.DataFrame()


def main():
    """主函数"""
    print("=" * 60)
    print("BaoStock Data Fetcher for Say-Buy/Whisper-Sell Research")
    print("=" * 60)

    # 确保数据目录存在
    DATA_RAW.mkdir(parents=True, exist_ok=True)

    # 登录BaoStock
    print("\n登录BaoStock...")
    lg = bs.login()
    print(f"  登录状态: {'成功' if lg.error_code == '0' else '失败'}")

    # 采集日交易数据
    print("\n>>> 采集日交易数据")
    daily_df = fetch_all_daily(
        start_date='2020-01-01',  # 研究样本起始年
        end_date='2026-06-30'
    )

    if len(daily_df) > 0:
        outpath = DATA_RAW / "daily_baostock.csv"
        daily_df.to_csv(outpath, index=False, encoding='utf-8-sig')
        print(f"\n日交易数据已保存: {len(daily_df)} 条记录 -> {outpath}")
        print(f"股票数量: {daily_df['ts_code'].nunique()}")
        print(f"日期范围: {daily_df['date'].min()} 至 {daily_df['date'].max()}")
    else:
        print("\n未采集到日交易数据")

    # 登出
    bs.logout()
    print("\n" + "=" * 60)
    print("采集完成")
    print("=" * 60)


if __name__ == "__main__":
    main()
