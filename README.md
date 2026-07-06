# 论文复现项目

本项目为论文复现教学资源库，供学生参考学习使用。

## 论文来源

**Brodeur, A., & Nguyen, M. (2024). Mass Reproducibility and Replicability: A New Hope.**

- 原文见 `Brodeur-MassReproducibilityReplicability-2024.pdf`

## 项目内容

| 文件 | 说明 |
|------|------|
| `Brodeur-MassReproducibilityReplicability-2024.pdf` | 论文原文（PDF） |
| `B1_replication_reports_final.md` | 论文附录 B 中所有复现报告的元数据（Markdown 格式） |
| `replication_reports.bib` | 复现报告的参考文献条目（BibTeX 格式），可直接用于 LaTeX 或文献管理工具 |
| `analysis/B16_package.zip` | 论文附录 B.16 对应的分析数据与代码包 |
| `data/` | 论文复现数据包目录（原始数据需单独下载，代码和论文已在仓库中） |

## 已收录的复现包：Replication_ReStud

**Boar, C., Gorea, D. & Midrigan, V. (2021). Liquidity Constraints in the U.S. Housing Market.** *Review of Economic Studies*, 88(5), 2379-2428. [DOI: 10.1093/restud/rdab063](https://doi.org/10.1093/restud/rdab063)

本仓库已收录该论文的**完整复现代码**和**论文原文**（`data/Replication_ReStud/`）：

| 目录 | 内容 | 语言 |
|------|------|------|
| `data_replication/scf/code/` | 16个Stata .do文件，从SCF数据生成论文表格和图形 | Stata |
| `data_replication/scf/output/` | 已生成的CSV输出文件 | - |
| `model_replication/` | 11个模型变体的完整MATLAB代码（基准+稳健性检验） | MATLAB |
| 论文原文 | `https-:doi.org:10.1093:restud:rdab063.pdf` | - |
| 中文README | `README_CN.md` 详细的复现操作指南 | - |

**注意**：原始SCF数据文件（.dta，总计约1.1GB）因超过仓库大小限制未包含，可从以下途径获取：
- 代码中已提供 `proc_data/our_proc/` 下的备用处理后数据（需单独下载）
- PSID数据需从 [PSID网站](https://psidonline.isr.umich.edu/) 单独获取
- 完整复现包原始来源：[DOI: 10.3886/E145381V1](https://doi.org/10.3886/E145381V1)

## 数据包下载（推荐）

`data/` 目录包含以下复现数据包（由于文件较大，未包含在Git仓库中）：

| 包名 | 大小 | 推荐指数 | 说明 |
|------|------|----------|------|
| **B147_LiquidityConstraints_Replication.zip** | 84 MB | ⭐⭐⭐⭐⭐ | **强烈推荐** - 流动性约束与住房抵押模型，包含结构模型估计(MATLAB)和SCF数据分析(Stata)，教学价值极高 |
| B.1.48_Local_Elites_as_State_Capacity... | 1.1 GB | ⭐⭐⭐ | 刚果金地方精英与税收合规性实验，包含完整Stata代码和数据 |
| B16_package/ | ~50 MB | ⭐⭐⭐ | 已在analysis目录中提供 |
| B189_BankingCompetition/ | ~100 MB | ⭐⭐⭐ | 银行竞争的断点回归分析 |

**下载方法**：
```bash
# 使用项目提供的下载脚本
cd data/
python download_replication_packages.py
```

或从论文原文的[复现包仓库](https://doi.org/10.7910/DVN/DZCQP7)手动下载。

## 使用说明

1. **阅读原文**：先通读 PDF 了解论文的研究背景与复现方法论
2. **浏览复现报告**：通过 `B1_replication_reports_final.md` 了解 100+ 篇顶级期刊论文的复现报告元数据，包括：
   - 原始论文标题、发表期刊与 DOI
   - 复现关键发现与结论
   - 复现包与原始作者数据包的下载链接
3. **引用管理**：`replication_reports.bib` 提供了所有复现报告的 BibTeX 条目，可直接导入 Zotero / EndNote 等工具
4. **动手实践**：参考 `analysis/` 目录中的分析包进行复现练习

## 适用场景

- 研究方法课程的教学案例
- 学生学习论文复现流程与规范
- 了解经济学、政治学等领域的研究可复现性现状

## 许可声明

本项目仅用于教学与学术研究目的，论文原文版权归原作者所有。
