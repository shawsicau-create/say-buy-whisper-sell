# 奥肯定律跨国复现研究

**Does Okun's Law Still Hold? Cross-Country Evidence from the United States, Canada, and Germany (2010–2026)**

---

## 项目概述

本项目利用 AI 驱动的研究 pipeline，从零完成了一篇完整的实证经济学论文：

1. **文献调研** — 通过 WebSearch 发现 Neely (2010) 的奥肯定律研究缺口
2. **数据获取** — 通过 MCP 服务从 FRED、加拿大统计局、欧盟统计局抓取多国宏观经济数据
3. **实证分析** — 在 Stata MP 中执行 OLS + Newey-West HAC 回归、分国子样本分析、混合固定效应模型
4. **论文生成** — 自动输出英文和中文 LaTeX PDF 论文

**核心发现**：美国奥肯系数（β = -0.19）几乎完全由 COVID-19 驱动；德国奥肯关系在各子样本中保持稳健（β ≈ -0.044），得益于 Kurzarbeit 短时工作制；加拿大关系较弱。

---

## 技术栈

### AI Agent 平台

| 组件 | 说明 |
|------|------|
| **Qoder** | AI 编码助手 IDE，提供 Agent 模式运行全流程自动化 |
| **MCP（Model Context Protocol）** | 统一协议层，连接 AI 与外部数据源/工具 |

### 数据获取层（MCP 服务）

项目中使用的经济学数据 MCP 服务：

| MCP 服务 | 类型 | 用途 | 认证 |
|----------|------|------|------|
| **[OpenEcon Data MCP](https://data.openecon.ai/mcp)** | HTTP (Streamable) | 主数据通道：通过统一 API 查询 FRED、Statistics Canada、Eurostat 的经济时间序列 | 免 API Key（开放数据） |
| **[fred-mcp](https://github.com/stefanoamorelli/fred-mcp-server)** | npx 本地进程 | US GDPC1（实际GDP）、UNRATE（失业率）数据 | 需 `FRED_API_KEY` |
| **[World Bank Data360 MCP](https://maimcpext.worldbank.org/ext/data360/mcp)** | HTTP (Streamable) | 世界银行宏观数据（本项目中使用为辅助/备选） | 免 API Key |
| **[OECD MCP](https://github.com/oecd-mcp/oecd-mcp)** | npx 本地进程 | OECD 国民账户数据（QNA 数据流） | 免 API Key |

开发环境还配置了以下支持性 MCP 服务：

| MCP 服务 | 用途 |
|----------|------|
| **chrome-devtools MCP** | 浏览器自动化，用于 FRED API Key 注册页面的交互式操作 |
| **browser-use MCP** | 浏览器导航与截图，辅助数据源验证 |
| **scansci-pdf MCP** | 学术 PDF 搜索和下载，用于文献调研阶段的论文原文获取 |

### 数据分析层

| 组件 | 版本 | 用途 |
|------|------|------|
| **Python 3** | 3.9+ | 数据预处理：MCP 返回数据的清洗、插值、拼接、CSV 输出 |
| **Stata MP 18** | `/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp` | 核心计量分析：OLS 回归、Newey-West HAC 标准误、子样本分析、混合固定效应模型、交互效应检验 |
| **[stata-mcp](https://github.com/ayushshiv/Stata-MCP)** | `mcp-remote` 传输 | AI Agent 到 Stata 的命令通道 |

### 数据处理脚本

| 脚本 | 功能 |
|------|------|
| `prepare_multicountry_data.py` | 多国数据清洗与合并。内置硬编码的 US GDP/UNR、Canada GDP、Germany GDP/UNR 数据，输出 `okun_multicountry_data.csv` |
| `okun_multicountry.do` | Stata 完整分析流程：导入数据 → 分国回归（4个子样本）→ Newey-West → 混合FE → 交互模型 → 表格输出 → 图表导出 |

### 论文输出层

| 组件 | 用途 |
|------|------|
| **LaTeX** | 论文排版，`ctexart` 中文支持 |
| **XeLaTeX** | 编译引擎，支持中文字体 |
| **Natbib** | 参考文献管理 |

---

## 项目文件结构

```
.
├── README.md                                    # 本文件
├── IDEA_REPORT.md                               # 文献调研与创意报告
│
├── Data & Analysis
├── prepare_multicountry_data.py                  # 多国数据预处理 (Python, 283行)
├── okun_multicountry_data.csv                    # 多国数据集 (194 obs, 3国)
├── okun_multicountry.do                          # Stata 实证分析 (296行)
├── okun_multicountry_results.log                 # 完整回归输出日志
│
├── Figures (Stata 生成)
├── okun_multicountry_scatter.png                 # 散点图: GDP增长 vs 失业变动
├── okun_multicountry_gdp_ts.png                  # GDP增长率时间序列
├── okun_multicountry_unemp_ts.png                # 失业率时间序列
│
├── Paper Outputs
├── paper_okun_multicountry.tex                   # 英文论文 LaTeX 源码
├── paper_okun_multicountry.pdf                   # 英文论文 PDF (12页)
├── paper_okun_multicountry_zh.tex                # 中文论文 LaTeX 源码
├── paper_okun_multicountry_zh.pdf                # 中文论文 PDF (11页)
│
├── Archive (单国复现 - 前期版本)
├── okun_replication.do                           # 单国 (US) Stata 分析
├── okun_replication.log                          # 单国回归结果
├── okun_data.csv                                 # 单国数据集 (65 obs)
├── prepare_data.py                               # 单国数据预处理
├── okuns_law_replication.py                      # Python 版本的奥肯分析
├── okuns_law_figure.png                          # 单国散点图
├── okun_figure_stata.png                         # Stata 单国图形
├── okun_ts_stata.png                             # Stata 时间序列图
│
├── MCP/Tools (非核心)
├── api_config.json                               # API 测试配置
├── api_test_results.json                         # API 连通性测试结果
├── test_api_connection.py                        # API 并行测试脚本
├── fred_api_key_page.png                         # FRED 注册截图
├── fred_login.png                                # FRED 登录截图
├── fred_homepage_modal.png                       # FRED 主页截图
```

---

## MCP 服务架构详解

本项目的核心创新在于利用 **MCP（Model Context Protocol）** 构建了一条从数据获取到论文生成的全自动化 pipeline。

### 数据流架构

```
用户 (自然语言) 
    │
    ▼
┌────────────────────────────────────────────────────────┐
│  Qoder AI Agent                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  1. WebSearch → 文献发现                         │   │
│  │  2. OpenEcon MCP → GDP/UNR 数据获取              │   │
│  │  3. FRED MCP / World Bank MCP → 补充/验证        │   │
│  │  4. Python 脚本 → 数据清洗 & 合并                 │   │
│  │  5. Stata MCP → 计量分析 (回归、检验、图形)       │   │
│  │  6. LaTeX → PDF 论文生成                          │   │
│  └─────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────┘
    │
    ├── ▶ OpenEcon Data MCP (HTTP) → FRED / StatsCan / Eurostat
    ├── ▶ FRED MCP (npx) → FRED API Key 认证通道
    ├── ▶ World Bank Data360 MCP (HTTP) → 备选数据
    ├── ▶ OECD MCP (npx) → 国民账户数据
    ├── ▶ Stata MCP (mcp-remote) → Stata MP 18 执行
    ├── ▶ scansci-pdf MCP → 学术 PDF 获取
    └── ▶ chrome-devtools MCP → 浏览器自动化 (注册/截图)
```

### MCP 配置 (`mcp.json`)

所有 MCP 服务统一在 Qoder 的 `mcp.json` 中配置：

```json
{
  "mcpServers": {
    "openecon-data": {
      "type": "streamablehttp",
      "url": "https://data.openecon.ai/mcp"
    },
    "fred-mcp": {
      "command": "npx",
      "args": ["-y", "@stefanoamorelli/fred-mcp-server@latest"],
      "env": { "FRED_API_KEY": "your_key_here" }
    },
    "stata-mcp": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://localhost:4000/mcp-streamable"]
    }
  }
}
```

### 关键 MCP 服务详解

#### OpenEcon Data MCP
- **URL**: `https://data.openecon.ai/mcp`
- **协议**: Streamable HTTP
- **功能**: 统一接口查询多来源经济数据（FRED、Statistics Canada、Eurostat、World Bank、IMF 等）
- **本项目使用**: 获取 US GDPC1、US UNRATE、Canada GDP、Germany GDP/GDP增长率、Germany 失业率
- **特点**: 无需 API Key，开放免费使用

#### FRED MCP
- **启动方式**: `npx @stefanoamorelli/fred-mcp-server@latest`
- **功能**: FRED 数据库专用接口，支持系列搜索、观测值查询、元数据获取
- **本项目使用**: 作为 OpenEcon 的 US 数据补充/验证通道
- **前置条件**: 需注册 FRED 账户获取免费 API Key

#### Stata MCP
- **架构**: MCP-Remote 桥接 → Stata MP 18 本地实例
- **功能**: 允许 AI Agent 直接向 Stata 发送 do-file 命令并获取输出
- **本项目使用**: 执行 `okun_multicountry.do` 全部计量分析
- **关键路径**: `/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp`

#### World Bank Data360 MCP
- **URL**: `https://maimcpext.worldbank.org/ext/data360/mcp`
- **功能**: 世界银行数据查询（各国发展指标）
- **本项目使用**: 辅助验证年/季度宏观经济数据
- **特点**: 世界银行官方托管，免 API Key

#### OECD MCP
- **启动方式**: `npx oecd-mcp`
- **功能**: OECD 统计数据查询（国民账户、就业、生产率等）
- **本项目使用**: 尝试获取 QNA（季度国民账户）数据流用于多国 GDP 分析
- **特点**: 基于 SDMX 数据标准，支持复杂过滤查询

---

## 运行指南

### 前置条件

- **Stata MP 18**（安装在默认路径）
- **Python 3.9+**
- **LaTeX 发行版**（MacTeX / TeX Live，含 `ctex` 包用于中文）
- **Node.js 18+**（用于运行 MCP 本地服务）
- **Qoder IDE**（或兼容 MCP 协议的 AI 客户端）

### 复现步骤

```bash
# 1. 数据准备
python3 prepare_multicountry_data.py

# 2. Stata 分析
/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp \
  -e do okun_multicountry.do

# 3. 编译英文论文
pdflatex paper_okun_multicountry.tex

# 4. 编译中文论文
xelatex paper_okun_multicountry_zh.tex
```

---

## 核心实证结果

| 样本 | 美国 β | 加拿大 β | 德国 β |
|------|--------|---------|--------|
| 全样本 | **-0.1914*** (R²=0.747) | -0.0084** (R²=0.063) | -0.0064* (R²=0.050) |
| 排除COVID | -0.0202* (R²=0.071) | -0.0249** (R²=0.117) | **-0.0471*** (R²=0.310) |
| COVID前 | -0.0047 (R²=0.003) | 0.0020 (R²=0.001) | **-0.0409*** (R²=0.195) |
| COVID后 | -0.0388 (R²=0.073) | -0.0287*** (R²=0.382) | **-0.0491*** (R²=0.377) |

---

## 参考文献

- Neely, C. J. (2010). "Okun's Law: Output and Unemployment." *Federal Reserve Bank of St. Louis Economic Synopses*, No. 4.
- Ball, L., D. Leigh, and P. Loungani (2017). "Okun's Law: Fit at 50?" *Journal of Money, Credit and Banking*, 49(7): 1413–1441.
- Russnak, J., D. H. Kim, and M. H. Pesaran (2023). "Does Okun's Law Suffer from COVID-19?" *Economics Letters*, 222: 110946.
- Boda, M., and M. Povazanova (2023). "How Credible Are Okun Coefficients?" *Economic Modelling*, 120: 106159.
