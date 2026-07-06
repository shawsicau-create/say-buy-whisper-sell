# "美国住房市场的流动性约束"复现文件

作者: Corina Boar, Denis Gorea 和 Virgiliu Midrigan

---

## 1. 概述

本复现包的结构如下:

- **model_replication** 子文件夹包含生成模型结果所需的所有代码
- **data_replication** 子文件夹包含生成论文中所述数据矩所需的所有代码和数据
  
**请注意**: 用于生成我们论文结果的PSID数据和代码可在单独的仓库获取: https://doi.org/10.3886/E145381V1 (更多详细信息见下文)

---

## 2. 模型部分

本节详细介绍如何复现论文图表和表格中报告的模型结果。

所有模型输出均使用MATLAB生成。用户应首先安装 **CompEcon工具箱**,可从 https://pfackler.wordpress.ncsu.edu/compecon-download/ 获取,并使用演示文件验证.mex文件是否正确编译。

除CompEcon工具箱外,我们还使用了Matthias Kredler编写的kronm.m程序。该文件包含在使用它的文件夹中。

### 表格生成说明

**表2, 面板A, 描述收入过程的前4个矩**
- 运行 `/Income Process/start.m`

**表2, 面板A, 其余矩(除收入外的所有矩)**
- 运行 `/Main nu 3/start.m`

**表3、表4**
- 运行 `/Main nu 3/start.m`

**表2, 面板B**: 参见start.m文件开头的参数

**注意**:
- 虽然模型按季度计算,但在适当时我们在表中报告年度化值
- 我们模型中的平均年收入为5.4614,2001年SCF中收入底层80%家庭的平均收入为70,430美元(2016年),因此模型中的一个单位对应12,896美元(2016年)
- 抵押贷款再融资的固定成本(模型中为0.102974)等于0.102974 × 12,896 = 1,328,我们在文中四舍五入为1,330

**表5**
- 标记为"nu = 1/3"的列: 运行 `/Main nu 3/start.m`并在start.m第248行将switch指示符改为'table5'
- 标记为"nu = 1/10"的列: 运行 `/Main nu 10/start.m`并在start.m第248行将switch指示符改为'table5'
- 标记为"nu = 0"的列: 运行 `/Main nu infinity/start.m`并在start.m第248行将switch指示符改为'table5'

**表6**
- 标记为"nu = 1/3"的列: 运行 `/Main nu 3/start.m`并在start.m第268行将switch指示符改为'table6ss'
- 标记为"nu = 1/10"的列: 运行 `/Main nu 10/start.m`并在start.m第268行将switch指示符改为'table6ss'
- 标记为"nu = 0"的列: 运行 `/Main nu infinity/start.m`并在start.m第268行将switch指示符改为'table6ss'

**表6, 上升和下降(Panel C和D)**
- 对于Panel C (利率上升): 在相应的模型文件夹中运行start.m,将switch指示符改为'table6up'
- 对于Panel D (利率下降): 在相应的模型文件夹中运行start.m,将switch指示符改为'table6down'

**表7**
- 运行 `/Main nu 3/start.m`并将switch指示符改为'table7'

**表8, 面板A和B**
- 面板A: 运行 `/Main nu 3/start.m`并将switch指示符改为'table8A'
- 面板B: 运行 `/Main nu 3/start.m`并将switch指示符改为'table8B'

**图4**
- 运行 `/Main nu 3/start.m`并将switch指示符改为'figure4'

**图5**
- 运行 `/Main nu 3/start.m`并将switch指示符改为'figure5'

---

## 3. 数据复现部分

本节介绍如何复现论文中使用的数据矩。

### A. 数据清理

**收入动态面板研究 (PSID)**

`data_replication\psid\code`文件夹包含以下文件:

1. **taxsim.do**
   - (a) 读取原始PSID数据(收入和税收项目),使用Taxsim模型为每个PSID波次创建可支配收入数据
   - (b) 使用Stata中的taxsim9命令运行Taxsim模型
   - (c) 输出名为YYYY_taxsim.dta的文件(YYYY为调查年份)
   - (d) 此步骤需要原始PSID数据,该数据可从PSID网站获取

2. **merge_panel.do**
   - (a) 从上一步taxsim.do创建的PSID数据各波次生成面板数据
   - (b) 使用PSID的跨年度个人文件(IND2011ER.txt)创建个人ID和户主状态(原始数据文件位于...\data_replication\psid\raw_data子文件夹)
   - (c) merge_panel.do调用另一个.do文件(IND2011ER.do)读取原始数据,该文件位于...\data_replication\psid\raw_data
   - (d) 然后通过唯一家庭ID和时间追踪户主,将每个PSID波次的可支配收入数据合并

3. **consumption.do**
   - (a) 使用PSID原始消费数据生成具有可读变量名的.dta文件
   - (b) 依赖merge_panel.do生成的面板来识别我们样本中保留消费数据的家庭
   - (c) 消费.do需要名称为CON`XX`.txt的原始数据(XX为调查年份1999-2011)。我们使用的原始文件可在...\data_replication\psid\raw_data子文件夹中找到
   - (d) 读取原始数据时,consumption.do调用子程序CON`XX`.do,也存储在...\data_replication\psid\raw_data子文件夹中

### 消费者金融调查 (SCF)

**data_replication\scf\code**文件夹包含生成清理后SCF样本所需的所有.do文件。我们将清理后的样本存储在data_replication\scf\proc_data中,并将其作为生成论文表格和图表代码的输入。

**1. taxsim_2001.do 和 taxsim_2016.do**
   - (a) 这两个文件使用2001年和2016年的原始SCF数据,通过指定Taxsim模型的输入来计算可支配收入。与PSID数据一样,我们在Stata中使用taxsim9命令运行模型
   
   **重要提示**:
   - i. taxsim9已被taxsim27取代(更多信息: https://users.nber.org/~taxsim/)。taxsim9仍可用但不再更新。我们提供了用于处理原始数据的taxsim9的ado和帮助文件。这些文件存储在PSID和SCF数据复现文件夹的|.\code\taxsim9_ado_files|中。要在计算机上运行代码,应将这些ado和帮助文件粘贴到Stata查找ado文件时调用的文件夹中。在Windows计算机上,这些通常存储在C:\Users\...\ado\plus\t(即包含以字母"t"开头的ado文件的子文件夹)
   
   - ii. 由于计算机FTP防火墙访问限制,部分Taxsim用户在运行taxsim9例程时遇到错误。如何解决此问题的更多信息: http://users.nber.org/~taxsim/ftp-problem.html。如果无法解决,请使用我们存储在\data_replication\scf\proc_data\our_proc文件夹中的已处理数据文件。这些文件是运行生成论文表格和图表代码所需的文件。只需将它们从\data_replication\scf\proc_data\our_proc复制到\data_replication\scf\proc_data,即可无问题运行其余代码
   
   - (b) taxsim_2001.do和taxsim_2016.do使用的输入是来自https://www.federalreserve.gov/econres/scf-previous-surveys.htm的原始和汇总SCF文件(检查相应调查波次的页面)。我们将用于生成论文数据矩的原始SCF数据存储在data_replication\scf\raw_data中
   
   - (c) 要运行taxsim_2001.do和taxsim_2016.do,需要在每个文件中指定计算机上以下文件夹的路径...\data_replication\scf\(检查路径注释行: "*Set path")

### B. 表格和图表

以下列表描述了计算论文中使用的数据矩需要运行的代码。文件名的前4-5个字符代表论文和附录中使用的表格或图表编号(例如,tab1代表论文中的表1)。

#### 收入动态面板研究 (PSID文件夹,可通过上述https://doi.org/10.3886/E145381V1获取)

1. **tab1_refi_moments.do 和 tab1_refi_liquidity.do**
   - (a) 生成表1面板B中报告的PSID数据输出
   - (b) 使用merge_panel.do创建的面板作为输入,以及清理财富数据的子程序FAM`XX`ER.do和wealth_comp`XX`.do(存储在data_replication\psid\raw_data)
   - (c) 输出: tab1_refi_moments.csv 和 tab1_refi_liquidity.csv

2. **tab2_income.do**
   - (a) 生成表2面板A中报告的收入过程矩
   - (b) 使用merge_panel.do创建的面板和consumption.do的输出文件作为输入
   - (c) 输出: tab2_income.csv

3. **tabA3_refi.do**
   - (a) 生成附录表A3中报告的提取住房权益的家庭比例
   - (b) 此文件需要先运行taxsim_2020.do和merge_panel_2020.do。这两个.do文件是taxsim.do和merge_panel.do的副本,改编用于处理2013、2015和2017年PSID调查的原始数据
   - (c) 还使用子程序FAM`XX`ER.do和wealth_comp`XX`.do清理财富数据
   - (d) 输出: tabA3_refi.csv

#### 消费者金融调查 (SCF)

1. **tab1_all_households.do, tab1_richest20%.do 和 tab1_poorest80%.do**
   - (a) 生成表1面板A中报告的SCF数据的启发性证据
   - (b) 使用taxsim_2001.do创建的样本作为输入
   - (c) 输出: tab1_all_households.csv, tab1_richest20%.csv 和 tab1_poorest80%.csv

2. **tab2_wealth.do**
   - (a) 生成表2面板B中报告的校准使用的矩
   - (b) 使用taxsim_2001.do创建的样本作为输入
   - (c) 输出: tab2_wealth.csv

3. **tab3_most_panels.do 和 tab3_panelF.do**
   - (a) 生成表3中报告的矩
   - (b) 使用taxsim_2001.do创建的样本作为输入
   - (c) 输出: tab3_most_panels.csv 和 tab3_panelF.csv

4. **tab4_ahead_on_payments.do**
   - (a) 生成表4面板A中报告的"提前还款家庭比例"矩。注意表4中的其余矩基于表1面板B中报告的矩
   - (b) 使用taxsim_2001.do创建的样本作为输入
   - (c) 输出: tab4_ahead_on_payments.csv

5. **tab10_wealth.do**
   - (a) 生成表10面板A中报告的矩。注意"提取权益的借款人比例"矩基于PSID数据,由psid文件夹中的tabA3_refi.do文件创建
   - (b) 使用taxsim_2016.do创建的样本作为输入
   - (c) 输出: tab10_wealth.csv

6. **fig3.do**
   - (a) 生成用于绘制图3生命周期统计的矩
   - (b) 使用taxsim_2001.do创建的样本作为输入
   - (c) 输出: fig3.csv

7. **tabA3_wealth.do**
   - (a) 生成附录表A3面板A中报告的矩
   - (b) 使用taxsim_2016.do创建的样本作为输入
   - (c) 输出: tabA3_wealth.csv

8. **tabA10_wealth.do**
   - (a) 生成附录表A10面板A中报告的矩
   - (b) 使用taxsim_2001.do创建的样本作为输入
   - (c) 输出: tabA10_wealth.csv

9. **tabA12_itemize.do**
   - (a) 生成附录表A12中报告的矩
   - (b) 使用taxsim_2001.do创建的样本作为输入
   - (c) 输出: tabA12_itemize.csv

10. **tabA13_no_other_prop.do**
    - (a) 生成附录表A13中报告的矩
    - (b) 使用taxsim_2001.do创建的样本作为输入
    - (c) 输出: tabA13_no_other_prop.csv

11. **fig1&2_appendix.do**
    - (a) 生成用于绘制附录图1和图2的住房拥有率
    - (b) 使用taxsim_2001.do创建的样本作为输入
    - (c) 输出: fig1&2_appendix.csv

---

## 参考文献

**美联储理事会**。2001年和2016年消费者金融调查(SCF)

**收入动态面板研究**, 公用数据集。由密歇根大学安娜堡社会研究所调查中心生产和分发(2014)

**PSID复现数据** (1999-2017)和"美国住房市场的流动性约束"论文代码,作者Corina Boar, Denis Gorea和Virgiliu Midrigan。https://doi.org/10.3886/E145381V1

---

## PSID致谢

本研究中使用的数据收集部分得到以下机构支持:
- 美国国立卫生研究院 (NIH) 资助号 R01 HD069609 和 R01 AG040213
- 美国国家科学基金会 (NSF) 资助号 SES 1157698 和 1623684

---

**翻译说明**: 本文档为B147数据包README的中文翻译,保留了所有技术细节和文件路径,便于中文用户理解和使用。
