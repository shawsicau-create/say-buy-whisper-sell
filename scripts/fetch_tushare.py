"""
Tushare Data Fetcher for Say-Buy/Whisper-Sell Research
=======================================================
Tushare PRO: 专业级A股数据，需要Token

功能：
1. 研究报告/分析师评级
2. 机构持股数据
3. 股东户数变化
4. 资金流向
"""

from config import DATA_RAW, SAMPLE_START, SAMPLE_END
import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime
import sys
import time
import json

# Add project paths
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "scripts"))

# 检查Tushare是否可用
try:
    import tushare as ts
    TUSHARE_AVAILABLE = True
except ImportError:
    TUSHARE_AVAILABLE = False
    print("警告: Tushare未安装，请运行 pip install tushare")

# Tushare Token（需要从 tushare.pro 注册获取）
TUSHARE_TOKEN = os.environ.get('TUSHARE_TOKEN', 'YOUR_TOKEN_HERE')

# Rating关键词
POSITIVE_KEYWORDS = ["买入", "增持", "强烈买入", "推荐", "优于大市", "强推", "买入-A", "增持-A"]
NEGATIVE_KEYWORDS = ["卖出", "减持", "回避", "中性", "中性-A", "减持-A", "卖出-A"]


def init_tushare():
    """初始化Tushare"""
    if not TUSHARE_AVAILABLE:
        return None
    try:
        ts.set_token(TUSHARE_TOKEN)
        return ts.pro_api()
    except Exception as e:
        print(f"Tushare初始化失败: {e}")
        return None


def classify_rating(rating_str):
    """根据评级文本分类"""
    if pd.isna(rating_str) or not rating_str:
        return 0  # 无评级

    rating_str = str(rating_str)

    # 正面评级
    for kw in POSITIVE_KEYWORDS:
        if kw in rating_str:
            return 1

    # 负面评级
    for kw in NEGATIVE_KEYWORDS:
        if kw in rating_str:
            return -1

    return 0  # 中性/其他


def fetch_research_reports(stock_list, start_date=None, end_date=None):
    """
    采集研究报告数据

    Args:
        stock_list: 股票代码列表
        start_date: 开始日期 YYYYMMDD
        end_date: 结束日期 YYYYMMDD

    Returns:
        pd.DataFrame: 研究报告数据
    """
    if not TUSHARE_AVAILABLE:
        print("Tushare不可用，跳过研究报告采集")
        return pd.DataFrame()

    pro = init_tushare()
    if pro is None:
        return pd.DataFrame()

    if start_date is None:
        start_date = SAMPLE_START
    if end_date is None:
        end_date = SAMPLE_END

    all_reports = []
    total = len(stock_list)

    print(f"\n>>> 采集研究报告数据 ({total} 只股票)")
    print("-" * 50)

    for i, code in enumerate(stock_list, 1):
        try:
            # 注意：research_report需要Tushare PRO高级权限
            # 如果没有权限，可以使用东财等替代数据源
            df = pro.research_report(
                ts_code=code, start_date=start_date, end_date=end_date)

            if df is not None and len(df) > 0:
                df['ts_code'] = code
                all_reports.append(df)
                print(f"[{i}/{total}] {code}: {len(df)} 份研报")
            else:
                print(f"[{i}/{total}] {code}: 无研报")

        except Exception as e:
            # 研究报告API可能需要付费权限
            print(f"[{i}/{total}] {code}: 错误 - {e}")

        # 避免请求过快（1次/秒）
        time.sleep(1)

    if all_reports:
        combined = pd.concat(all_reports, ignore_index=True)

        # 添加评级分类
        if 'rating' in combined.columns:
            combined['rating_score'] = combined['rating'].apply(
                classify_rating)

        return combined
    return pd.DataFrame()


def fetch_top10_holders(stock_list, start_date=None, end_date=None):
    """
    采集前10大流通股东数据（机构持股代理）

    Args:
        stock_list: 股票代码列表
        start_date: 开始日期 YYYYMMDD
        end_date: 结束日期 YYYYMMDD

    Returns:
        pd.DataFrame: 股东数据
    """
    if not TUSHARE_AVAILABLE:
        print("Tushare不可用，跳过股东数据采集")
        return pd.DataFrame()

    pro = init_tushare()
    if pro is None:
        return pd.DataFrame()

    if start_date is None:
        start_date = SAMPLE_START
    if end_date is None:
        end_date = SAMPLE_END

    all_holders = []
    total = len(stock_list)

    print(f"\n>>> 采集前10大流通股东数据 ({total} 只股票)")
    print("-" * 50)

    for i, code in enumerate(stock_list, 1):
        try:
            df = pro.top10_floatholders(
                ts_code=code, start_date=start_date, end_date=end_date)

            if df is not None and len(df) > 0:
                all_holders.append(df)
                print(f"[{i}/{total}] {code}: {len(df)} 条记录")
            else:
                print(f"[{i}/{total}] {code}: 无数据")

        except Exception as e:
            print(f"[{i}/{total}] {code}: 错误 - {e}")

        # 限流
        time.sleep(1)

    if all_holders:
        combined = pd.concat(all_holders, ignore_index=True)
        return combined
    return pd.DataFrame()


def fetch_holder_number(stock_list, start_date=None, end_date=None):
    """
    采集股东户数变化（散户代理指标）
    """
    if not TUSHARE_AVAILABLE:
        return pd.DataFrame()

    pro = init_tushare()
    if pro is None:
        return pd.DataFrame()

    if start_date is None:
        start_date = SAMPLE_START
    if end_date is None:
        end_date = SAMPLE_END

    all_data = []
    total = len(stock_list)

    print(f"\n>>> 采集股东户数数据 ({total} 只股票)")
    print("-" * 50)

    for i, code in enumerate(stock_list, 1):
        try:
            df = pro.stk_holdernumber(
                ts_code=code, start_date=start_date, end_date=end_date)

            if df is not None and len(df) > 0:
                all_data.append(df)
                print(f"[{i}/{total}] {code}: {len(df)} 条记录")
            else:
                print(f"[{i}/{total}] {code}: 无数据")

        except Exception as e:
            print(f"[{i}/{total}] {code}: 错误 - {e}")

        time.sleep(1)

    if all_data:
        return pd.concat(all_data, ignore_index=True)
    return pd.DataFrame()


def main():
    """主函数"""
    import os

    print("=" * 60)
    print("Tushare Data Fetcher for Say-Buy/Whisper-Sell Research")
    print("=" * 60)

    DATA_RAW.mkdir(parents=True, exist_ok=True)

    # 检查Token
    token = os.environ.get('TUSHARE_TOKEN', '')
    if token == 'YOUR_TOKEN_HERE' or not token:
        print("\n⚠️ 警告: 未设置TUSHARE_TOKEN环境变量")
        print("请设置: export TUSHARE_TOKEN='your_token_here'")
        print("或从 https://tushare.pro 注册获取Token")

    # 股票列表
    stock_list = [
        '000001.SZ', '000002.SZ', '000063.SZ', '000333.SZ', '000858.SZ',
        '600519.SH', '600036.SH', '600276.SH', '600887.SH', '601318.SH',
    ]

    # 1. 采集研究报告（需要PRO权限）
    # reports_df = fetch_research_reports(stock_list)
    # if len(reports_df) > 0:
    #     reports_df.to_csv(DATA_RAW / "research_reports.csv", index=False)
    #     print(f"\n研报数据已保存: {len(reports_df)} 条")

    # 2. 采集股东数据
    # holders_df = fetch_top10_holders(stock_list)
    # if len(holders_df) > 0:
    #     holders_df.to_csv(DATA_RAW / "top10_holders.csv", index=False)
    #     print(f"股东数据已保存: {len(holders_df)} 条")

    print("\n" + "=" * 60)
    print("提示: 请设置TUSHARE_TOKEN后运行完整采集")
    print("=" * 60)


if __name__ == "__main__":
    main()
