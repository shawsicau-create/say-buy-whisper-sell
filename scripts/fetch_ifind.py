"""
iFinD Data Fetcher for Say-Buy/Whisper-Sell Research
====================================================
iFinD (同花顺): 专业级金融数据服务

功能：
1. 智能选股 (search_stocks)
2. 股东结构数据 (get_stock_shareholders)
3. 机构持股数据
"""

from config import DATA_RAW
import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime
import sys
import time
import re

# Add project paths
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "scripts"))

# ============================================================
# iFinD MCP工具调用（通过MCP协议）
# ============================================================

# MCP工具已在Qoder环境中配置
# 调用方式：使用CallMcpTool调用hexin-ifind-ds-stock-mcp


def parse_shareholder_table(text):
    """
    解析iFinD股东数据表格
    返回结构化DataFrame
    """
    lines = text.strip().split('\n')
    if len(lines) < 3:
        return pd.DataFrame()

    # 解析表格头部
    headers = [h.strip() for h in lines[0].split('|') if h.strip()]

    data = []
    for line in lines[2:]:  # 跳过表头和分隔符
        cells = [c.strip() for c in line.split('|') if c.strip()]
        if len(cells) >= 4:
            data.append(cells)

    if data:
        df = pd.DataFrame(data)
        # 尝试匹配列名
        if len(df.columns) >= 4:
            df.columns = df.columns[:len(df.columns)]
        return df
    return pd.DataFrame()


def extract_stock_list_from_ifind(text):
    """
    从iFinD选股结果中提取股票代码列表
    """
    lines = text.strip().split('\n')
    stocks = []

    for line in lines:
        # 匹配股票代码格式: 000001.SZ, 600519.SH
        matches = re.findall(r'(\d{6}\.(?:SZ|SH))', line)
        stocks.extend(matches)

    return list(set(stocks))

# ============================================================
# MCP工具调用封装
# ============================================================

# 注意：以下函数需要通过MCP协议调用
# 在Qoder环境中使用 CallMcpTool()


def ifind_search_stocks(query):
    """
    使用iFinD智能选股

    Args:
        query: 自然语言查询，如 "沪深主板，市值大于500亿"

    Returns:
        list: 股票代码列表
    """
    # 通过MCP调用
    # result = CallMcpTool({
    #     "server_name": "hexin-ifind-ds-stock-mcp",
    #     "tool_name": "search_stocks",
    #     "arguments": {"query": query}
    # })
    # return extract_stock_list_from_ifind(result)
    pass


def ifind_get_shareholders(ts_code, date=None):
    """
    获取股票股东数据

    Args:
        ts_code: 股票代码，如 "000001.SZ"
        date: 日期，如 "20241231"

    Returns:
        pd.DataFrame: 股东数据
    """
    # 通过MCP调用
    # query = f"{ts_code}"
    # if date:
    #     query += f" {date[:4]}年末"
    # query += " 前10大股东持股比例，机构持股比例"
    #
    # result = CallMcpTool({
    #     "server_name": "hexin-ifind-ds-stock-mcp",
    #     "tool_name": "get_stock_shareholders",
    #     "arguments": {"query": query}
    # })
    # return parse_shareholder_table(result)
    pass

# ============================================================
# 手动采集脚本（当MCP不可用时）
# ============================================================


def fetch_stock_list_manually():
    """
    从文件读取股票列表
    （当iFinD API不可用时使用）
    """
    stock_file = DATA_RAW / "stock_list.csv"
    if stock_file.exists():
        df = pd.read_csv(stock_file)
        return df['ts_code'].tolist()
    return []


def fetch_shareholders_manually():
    """
    从文件读取股东数据
    （当iFinD API不可用时使用）
    """
    holder_file = DATA_RAW / "shareholders_ifind.csv"
    if holder_file.exists():
        return pd.read_csv(holder_file)
    return pd.DataFrame()

# ============================================================
# 数据整合
# ============================================================


def merge_shareholder_data(shareholder_df, stock_list_df):
    """
    合并股东数据和股票列表
    计算机构持股变化
    """
    if len(shareholder_df) == 0:
        return pd.DataFrame()

    # 提取关键指标
    holder_summary = shareholder_df[[
        'ts_code', 'date', 'inst_holding_pct', 'top10_holding_pct']].copy()

    # 转换日期格式
    holder_summary['date'] = pd.to_datetime(
        holder_summary['date'], format='%Y%m%d')
    holder_summary = holder_summary.sort_values(['ts_code', 'date'])

    # 计算环比变化
    holder_summary['inst_chg'] = holder_summary.groupby(
        'ts_code')['inst_holding_pct'].diff()

    # 标记机构增减
    holder_summary['inst_decrease'] = (
        holder_summary['inst_chg'] < 0).astype(int)

    return holder_summary


def main():
    """主函数"""
    print("=" * 60)
    print("iFinD Data Fetcher for Say-Buy/Whisper-Sell Research")
    print("=" * 60)

    DATA_RAW.mkdir(parents=True, exist_ok=True)

    # 尝试加载现有数据
    stock_list = fetch_stock_list_manually()
    shareholders = fetch_shareholders_manually()

    print(f"\n已加载股票列表: {len(stock_list)} 只")
    print(f"已加载股东数据: {len(shareholders)} 条")

    # 合并数据
    if len(shareholders) > 0:
        merged = merge_shareholder_data(shareholders, None)
        outpath = DATA_RAW / "holders_processed.csv"
        merged.to_csv(outpath, index=False, encoding='utf-8-sig')
        print(f"\n股东数据已处理并保存: {outpath}")
        print(merged.head())

    print("\n" + "=" * 60)
    print("提示: 使用MCP工具获取更多数据")
    print("  - hexin-ifind-ds-stock-mcp::search_stocks")
    print("  - hexin-ifind-ds-stock-mcp::get_stock_shareholders")
    print("=" * 60)


if __name__ == "__main__":
    main()
