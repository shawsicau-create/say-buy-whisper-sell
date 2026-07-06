# Say-Buy/Whisper-Sell: 中国A股分析师"言行不一"实证策略

## 研究背景

基于 Hirshleifer, Shi & Wu (2024) 的"说买/私下卖"(Say-Buy/Whisper-Sell) 假说，检验中国A股市场分析师公开推荐与机构实际交易方向背离的现象。

## 项目结构

```
say-buy-whisper-sell/
├── scripts/
│   ├── config.py           # 配置参数
│   ├── utils.py            # 工具函数
│   ├── build_panel.py      # 数据面板构建
│   ├── step1_portfolio.py  # Step 1: 投资组合测试
│   ├── step2_event.py      # Step 2: 事件研究
│   ├── step3_quarterly.py  # Step 3: 季度持仓分析
│   ├── step4_insider.py    # Step 4: 内部人交易
│   ├── step5_crosssection.py # Step 5: 横截面异质性
│   └── main.py             # 主运行脚本
├── data/
│   ├── raw/                # 原始MCP数据
│   └── processed/          # 处理后数据
├── analysis/                # 分析目录
└── results/                # 结果输出
```

## 数据来源

本项目使用以下MCP工具获取数据：

| 数据类型 | MCP工具 | 状态 |
|---------|---------|------|
| 日线行情 | tushareMcp::daily | ✅ 可用 |
| 研报评级 | china-stock-mcp::get_stock_research_report | ✅ 可用 |
| 流通股东 | china-stock-mcp::get_stock_circulate_stock_holder | ✅ 可用 |
| 股东户数 | tushareMcp::stk_holdernumber | ✅ 可用 |
| 历史行情 | china-stock-mcp::get_hist_data | ✅ 可用 |
| 券商金股 | tushareMcp::broker_recommend | ❌ 需付费 |
| 资金流向 | tushareMcp::moneyflow | ❌ 需付费 |
| 机构持仓 | tushareMcp::fund_portfolio | ❌ 需付费 |

## 五个实证步骤

### Step 1: 核心投资组合检验
- 构建2x2分组：分析师评级 × 机构持仓变化
- **Group B (言行不一)**: 高评级 + 机构减持
- 检验各组未来持有期异常收益

### Step 2: 研报评级调整事件研究
- 以评级调整事件日为基准
- 计算[-20, +20]窗口的累积异常收益

### Step 3: 季度机构持仓一致性
- 检验研报评级变化与机构持仓变化的相关性

### Step 4: 内部人交易与分析师乐观偏差
- 使用间接代理变量检验内部人减持时分析师的评级行为

### Step 5: 横截面异质性分析
- 按市场状态、规模、券商声誉分组检验

## 使用方法

### 1. 准备数据
通过MCP工具获取数据并保存为CSV文件到 `data/raw/`:
- `daily_all.csv` - 日线行情
- `research_reports.csv` - 研报数据
- `circulate_holders.csv` - 流通股东数据
- `holder_number.csv` - 股东户数

### 2. 构建面板
```bash
python scripts/build_panel.py
```

### 3. 运行分析
```bash
python scripts/main.py
```

或单独运行每个步骤:
```bash
python scripts/step1_portfolio.py
python scripts/step2_event.py
# ...
```

## 数据限制说明

由于`moneyflow`（资金流向大单/小单分类）等接口需要Tushare PRO付费权限，本项目使用以下替代方案：
- 用季度流通股东数据计算机构持仓变化
- 用股东户数变化作为散户参与代理变量
- 用日均成交量作为交易活跃度代理

这些替代方案保留了研究框架的核心逻辑，但精度有所下降。

## 参考文献

- Hirshleifer, D., Shi, Y., & Wu, W. (2024). Do Sell-Side Analysts Say "Buy" While Whispering "Sell"? NBER Working Paper 30032.
- Hobbs, J., & Singh, A. (2015). Buy-Side vs. Sell-Side Analysts.
- Busse, J., Green, T., & Jegadeesh, N. (2012). Buy-Side Trades and Sell-Side Recommendations.
