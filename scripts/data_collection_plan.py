"""
Say-Buy/Whisper-Sell Research: Data Collection Plan
==================================================

## 研究数据需求分析

### 1. 核心变量

| 变量 | 描述 | 数据源 | 优先级 |
|------|------|--------|--------|
| analyst_rating | 分析师评级（买入/增持/中性/减持/卖出） | 研究报告 | ★★★ |
| inst_holder_chg | 机构持股比例变化 | 流通股东数据 | ★★★ |
| ret_q | 季度收益率 | 日交易数据 | ★★★ |
| market_cap | 市值 | 日交易数据 | ★ |
| turnover | 换手率 | 日交易数据 | ★ |

### 2. 数据源评估

| 数据源 | API | 覆盖范围 | 限流 | 成本 |
|--------|-----|---------|------|------|
| **Tushare PRO** | tushareMcp | 全面（交易/财务/股东/研报） | 严格 | 免费/付费 |
| **BaoStock** | baostock Python | 日K线/财务数据 | 无 | 免费 |
| **iFinD** | hexin-ifind-ds | 股东/选股/基本面 | 中等 | 付费 |
| **China-Stock** | china-stock-mcp | 研报/股东 | SSL错误 | 免费 |

### 3. 推荐采集方案

#### 方案A: Tushare PRO + BaoStock（推荐）

```
数据层               采集工具              频率
─────────────────────────────────────────────────
日交易数据    →    BaoStock (免费,无限制)
财务数据      →    BaoStock (免费,无限制)
分析师研报    →    Tushare PRO (需Token)
机构股东      →    Tushare PRO (需Token)
```

#### 方案B: 全MCP方案（依赖网络稳定性）

```
数据层               MCP工具                限流策略
──────────────────────────────────────────────────────
日交易数据    →    tushareMcp::daily       分批采集
股票列表      →    hexin-ifind-ds::search   限流
股东数据      →    hexin-ifind-ds::shareholders  限流
研究报告      →    china-stock-mcp (当前SSL错误)
```

## 数据采集脚本设计
"""

import os
import sys
from pathlib import Path

# Add project root to path
PROJECT_ROOT = Path(__file__).parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "scripts"))

print(__doc__)

# ============================================================
# 数据采集配置
# ============================================================

DATA_SOURCES = {
    # 1. 日交易数据 - 使用BaoStock（免费无限制）
    "daily": {
        "source": "baostock",
        "api": "query_history_k_data_plus",
        "frequency": "d",  # 日频
        "fields": "date,code,open,high,low,close,preclose,volume,amount,turn,pctChg",
        "limit": "无限制",
        "notes": "推荐作为主力数据源"
    },

    # 2. 分析师评级 - 使用Tushare PRO
    "research_report": {
        "source": "tushare",
        "api": "research_report",
        "frequency": "实时",
        "limit": "1次/分钟",
        "notes": "核心变量，需Tushare PRO Token"
    },

    # 3. 机构持股 - 使用Tushare PRO或iFinD
    "institutional_holders": {
        "source": "tushare + ifind",
        "apis": ["moneyflow_hsgt", "top10_floatholders"],
        "frequency": "季频",
        "limit": "Tushare 1次/分钟, iFinD 限流",
        "notes": "iFinD可查询多季度历史数据"
    },

    # 4. 股票列表 - 使用iFinD选股
    "stock_list": {
        "source": "hexin-ifind-ds",
        "api": "search_stocks",
        "frequency": "一次性",
        "limit": "10次/分钟",
        "notes": "可按市值、行业、板块筛选"
    },

    # 5. 财务数据 - 使用BaoStock
    "financial": {
        "source": "baostock",
        "api": "query_profit_data, query_balance_sheet_data",
        "frequency": "季频",
        "limit": "无限制",
        "notes": "可获取完整历史财务数据"
    },
}

# ============================================================
# 数据采集优先级
# ============================================================

PRIORITY_COLLECTION = [
    # 第一优先级：核心变量
    ("1_daily_prices", "日交易数据", ["baostock", "tushareMcp"]),
    ("2_research_reports", "分析师研报", ["tushareMcp", "china-stock-mcp"]),
    ("3_institutional_holders", "机构持股数据", ["hexin-ifind-ds", "tushareMcp"]),

    # 第二优先级：辅助变量
    ("4_financial_data", "财务数据", ["baostock"]),
    ("5_stock_list", "股票列表", ["hexin-ifind-ds"]),

    # 第三优先级：补充数据
    ("6_market_index", "市场指数", ["baostock", "tushareMcp"]),
    ("7_shareholder_number", "股东户数", ["tushareMcp"]),
]

# ============================================================
# 采集脚本模板
# ============================================================

COLLECTION_SCRIPTS = '''
# ============================================================
# 采集脚本使用说明
# ============================================================

## Step 1: 安装依赖

```bash
pip install baostock pandas numpy
```

## Step 2: BaoStock日交易数据采集

```python
import baostock as bs
import pandas as pd
from pathlib import Path

# 登录
bs.login()

# 采集单只股票历史数据
def fetch_daily_data(code, start_date, end_date):
    rs = bs.query_history_k_data_plus(
        code,
        "date,code,open,high,low,close,preclose,volume,amount,turn,pctChg",
        start_date=start_date, end_date=end_date, frequency="d"
    )
    data = []
    while rs.error_code == '0' and rs.next():
        data.append(rs.get_row_data())
    return pd.DataFrame(data, columns=rs.fields)

# 批量采集
stocks = pd.read_csv("data/raw/stock_list.csv")
for _, row in stocks.iterrows():
    code = row['ts_code'].replace('.SZ', '.sz').replace('.SH', '.sh')
    df = fetch_daily_data(code, "2010-01-01", "2026-06-30")
    # 保存到CSV
```

## Step 3: Tushare PRO研究报告采集

```python
import tushare as ts

# 设置Token
ts.set_token('YOUR_TOKEN')
pro = ts.pro_api()

# 采集研报
df = pro.research_report(ts_code='000001.SZ', start_date='20100101')
```

## Step 4: iFinD机构持股采集

```python
# 使用hexin-ifind-ds-stock-mcp
get_stock_shareholders(query="000001.SZ 2024年末机构持股比例")
```

## Step 5: 数据整合脚本

```python
# build_panel.py - 构建分析面板
import pandas as pd
from pathlib import Path

def build_analysis_panel():
    # 1. 加载日交易数据
    daily = pd.read_csv("data/raw/daily_all.csv")
    
    # 2. 加载研报数据
    reports = pd.read_csv("data/raw/research_reports.csv")
    
    # 3. 加载机构持股数据
    holders = pd.read_csv("data/raw/shareholders_ifind.csv")
    
    # 4. 合并构建面板
    panel = ...
    return panel
```

'''

print(COLLECTION_SCRIPTS)

# ============================================================
# 输出采集方案
# ============================================================

print("""
================================================================================
                     数据采集方案总结
================================================================================

┌─────────────────────────────────────────────────────────────────────────────┐
│  推荐方案：Tushare PRO + BaoStock + iFinD 三源互补                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  数据类型          采集工具              成本        备注                    │
│  ─────────────────────────────────────────────────────────────────────────  │
│  日交易数据        BaoStock             免费        主力数据源                │
│  分析师研报        Tushare PRO         免费Token   核心变量                  │
│  机构持股          iFinD + Tushare     付费/免费   多季度历史                │
│  股票列表          iFinD search_stocks  限流        智能选股                 │
│  财务数据          BaoStock             免费        基本面控制                │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  采集顺序                                                          │
│  ─────────────────────────────────────────────────────────────────────────  │
│  1. 股票列表 (iFinD search_stocks)                                       │
│  2. 日交易数据 (BaoStock) - 全量历史                                      │
│  3. 机构持股数据 (iFinD + Tushare)                                        │
│  4. 分析师研报 (Tushare PRO)                                              │
│  5. 财务数据 (BaoStock)                                                   │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  脚本位置                                                              │
│  ─────────────────────────────────────────────────────────────────────────  │
│  • scripts/fetch_baostock.py  - BaoStock数据采集                          │
│  • scripts/fetch_tushare.py   - Tushare数据采集                           │
│  • scripts/fetch_ifind.py     - iFinD数据采集                             │
│  • scripts/build_panel.py     - 构建分析面板                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
""")
