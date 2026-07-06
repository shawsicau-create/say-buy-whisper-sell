# B ONLINE APPENDIX B

## B.1 List of Replication Reports

以下为整理版 Markdown。

说明：
- 条目名称与说明文字使用中文整理。
- `doi`、`Link to Full Report`、`Replication Package`、`Link to Replicators Package`、`Link to Original Authors Response`、`Original Authors Response`、`Original Authors Final Response`、`Link to Original Authors Final Response`、`Original Authors Package` 保留原文。

---

### 金融领域复现论文介绍

本附录包含多篇经济学与政治学顶级期刊论文的复现报告，其中以下论文属于**金融领域**，尤其值得关注：

---

**宏观金融与货币政策**

1. **B.1.6** - *Bubbles, Crashes, and Economic Growth: Theory and Evidence*（《泡沫、崩溃与经济增长：理论与证据》）
   - **发表期刊**：*American Economic Journal: Macroeconomics*（AEJ：宏观经济学）
   - **研究主题**：金融泡沫对经济增长的短期、中期和长期影响
   - **复现关键发现**：原论文使用硬编码数据，信贷/GDP 序列采用了极不寻常的 HP 滤波平滑参数（10^10 而非标准的 1600）；主要实证结论对股市市值/GDP 序列定性稳健，但对信贷/GDP 序列的辅助结论不稳健
   - **复现包**：https://osf.io/d76tn/

2. **B.1.51** & **B.1.52** - *Market-Based Monetary Policy Uncertainty*（《基于市场的货币政策不确定性》）
   - **发表期刊**：*Economic Journal*（经济学期刊）
   - **研究主题**：基于市场的货币政策不确定性测量及其对金融市场的影响
   - **复现包**：https://osf.io/qx8aw/

3. **B.1.59** - *News Shocks Under Financial Frictions*（《金融摩擦下的新闻冲击》）
   - **发表期刊**：*American Economic Journal: Macroeconomics*（AEJ：宏观经济学）
   - **研究主题**：全要素生产率新闻冲击对金融市场的影响
   - **复现包**：https://github.com/gionikola/replication-game-ucsd

4. **B.1.94** - *The Macroeconomics of Sticky Prices with Generalized Hazard Functions*（《具有广义风险函数的粘性价格宏观经济学》）
   - **发表期刊**：*Quarterly Journal of Economics*（经济学季刊）
   - **研究主题**：粘性价格模型与货币政策传导
   - **复现包**：https://github.com/atyho/Ottawa-Replication-Games-2023/

---

**银行与金融中介**

5. **B.1.89** - *The Effects of Banking Competition on Growth and Financial Stability: Evidence from the National Banking Era*（《银行竞争对增长和金融稳定的影响：来自国民银行时代的证据》）
   - **发表期刊**：*Journal of Political Economy*（政治经济学期刊）
   - **研究主题**：银行竞争与金融稳定、经济增长之间的关系
   - **复现包**：https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/BB864R

6. **B.1.47** - *Liquidity Constraints in the U.S. Housing Market*（《美国住房市场的流动性约束》）
   - **发表期刊**：*Review of Economic Studies*（经济研究评论）
   - **研究主题**：住房市场流动性约束
   - **复现包**：http://doi.org/10.5281/zenodo.5112964

---

**金融市场与资产定价**

7. **B.1.30** - *Finance and Green Growth*（《金融与绿色增长》）
   - **发表期刊**：*Economic Journal*（经济学期刊）
   - **研究主题**：金融部门规模和结构对去碳化的影响
   - **复现关键发现**：原论文存在多个编码错误，影响了系数的大小和精度
   - **复现包**：https://osf.io/h8ct2/

8. **B.1.108** - *Who Sells During a Crash? Evidence from Tax Return Data on Daily Sales of Stock*（《崩盘期间谁在卖出？来自纳税申报单数据的股票日度销售证据》）
   - **发表期刊**：*Economic Journal*（经济学期刊）
   - **研究主题**：金融危机期间的投资者行为
   - **复现包**：https://www.dropbox.com/scl/fo/c3ysdlenysq391mugzprm/h?rlkey=riooyohci7i5vwx475r13jaqq&dl=0

---

**公司金融与投资**

9. **B.1.28** - *Evaluating Deliberative Competence: A Simple Method with an Application to Financial Choice*（《评估审慎能力：一种应用于金融选择的简单方法》）
   - **发表期刊**：*American Economic Review*（美国经济评论）
   - **研究主题**：金融决策质量与干预措施评估
   - **复现包**：https://osf.io/scgbt/

---

以上论文涵盖了宏观金融、银行学、资产定价、公司金融等多个金融子领域，是该领域的重要研究。

---

### B.1.1
- 原论文标题：Antinormative Messaging, Group Cues, and the Nuclear Ban Treaty
- doi: https://doi.org/10.1086/714924, Journal of Politics
- 内容摘要：Herzog、Baron 和 Gibbons (2022) 探究了接触官方精英言论和群体线索对公众反对国际核武器禁止规范的支持的影响。作者发现精英线索，特别是安全和制度线索，会增加个人对《禁止核武器条约》（TPNW）的反对。然而，精英线索似乎对改变个人对核武器的更广泛态度没有影响，这通过个人对核武器的现有反对来衡量。我们复现并扩展了作者的方法和结果，以检验研究中发现的效应的稳健性。首先，我们使用作者的原始数据和方法复现主要发现。我们没有发现会破坏作者分析或结论的编码错误。其次，我们通过（1）使用不同的政党认同操作化，以及（2）计算额外的性别子组分析来检验结果的稳健性。我们发现我们的复现结果与原始结果没有显著差异，但女性对 TPNW 的支持对安全线索更敏感，而男性的支持对制度线索更敏感。
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/97.htm
- Replication Package: https://osf.io/xbvzg/
- Link to Original Authors Response: https://econpapers.repec.org/paper/zbwi4rdps/98.htm
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml;jsessionid=5bc4beb0b d5aef9d7a5ba5284fc6?persistentId=doi%3A10.7910%2FDVN%2FGLT4FX&version=&q=&fileTyp eGroupFacet=%22Text%22&fileAccess=&fileSortField=size

### B.1.2
- 原论文标题：Ascriptive Characteristics and Perceptions of Impropriety in the Rule of Law: Race, Gender, and Public Assessments of Whether Judges Can Be Impartial
- doi: https://doi.org/10.1111/ajps.12599, American Journal of Political Science
- 内容摘要：Ono 和 Zilis (2022) 研究了美国法官的先赋特征（如种族、性别和族裔）对公民对法官职业不当行为和裁决偏见看法的影响。他们开展了两项研究，比较公民对不同先赋特征的看法以及对法官偏见和案件回避必要性的判断。他们发现政治和意识形态倾向塑造了对司法不当行为的看法。在本评论中，我们使用不同软件重新编码分析并进行稳健性检验。我们成功复现了主要结果。
- Link to Full Report: https://osf.io/yf48r/
- Replication Package: https://osf.io/yf48r/
- Link to Original Authors Response: No response.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/ZHOL6Y

### B.1.3
- 原论文标题：Assortative Matching at the Top of the Distribution: Evidence from the World’s Most Exclusive Marriage Market
- doi: https://doi.org/10.1257/app.20180463, American Economic Journal: Applied Economics
- 内容摘要：Using novel data on peerage marriages in Britain, I find that low search costs and marriage-market segregation can generate sorting. Peers courted in the London Season, a matching technology introducing aristocratic bachelors to debutantes. When Queen Victoria went into mourning for her husband, the Season was interrupted (1861–1863), raising search costs and reducing market segregation. I exploit exogenous variation in women’s probability to marry dur- ing the interruption from their age in 1861. The interruption increased peer-commoner intermar- riage by 40 percent and reduced sorting along landed wealth by 30 percent. Eventually, this re- duced peers’ political power and affected public policy in late nineteenth-century England.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/47.htm
- Link to Replicators Package: https://osf.io/pqsem/
- Original Authors Response: “I now reviewed the report carefully and with interest, and I am glad to see that the authors succeeded in replicating all results and found no coding errors. I hope the replication package was clear and easy to work with. I am also happy to see that they performed several additional robustness checks and heterogeneity analysis, and that these show that the original estimates “are robust and are not significantly affected using these alternative specifications” (p. 1). Given this, and the replicators’ conclusion that “the study’s main findings demonstrate robustness and reliability” (p. 7), I think that there is nothing substantial for me to write in a response in the form of a discussion paper. This is because both the replication exercise and the additional analysis found no major issues in the original work to respond to. I would also like to thank the authors for the fairness and professionalism of their report, and also for the time and effort they put in producing it, from which I ultimately benefit — as it adds to the credibility of my original paper — as well as the profession as a whole benefits — as making replication exercises more common is important for economics. Please let me know if I can be of any further assistance regarding this replication report in the future. I am at your or the authors’ disposal, in case I can be of help in clarifying anything in the replication package or in the analysis of the original paper. As I stated above, I believe that increasing replication rates is important for our field, as it is making original datasets publicly available — even when, as in the case of my paper, the data collection is an important part of my contribution, and in this situation, many do not grant public access to the original data.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/140921/version/V 1/view

### B.1.4
- 原论文标题：Black Workers in White Places: Daytime Racial Diversity and White Public Opinion
- doi: https://doi.org/10.1086/716289, Journal of Politics
- 内容摘要：In this replication study, we revisit the main empirical claims of Hamel and Wilcox-Archuleta’s (HW) 2022 study on the impact of daytime racial diversity on White Ameri- cans’ voting behavior and racial attitudes. HW introduce a novel zip code level measure of racial diversity that accounts for the influx of Black workers during daytime, showing that conventional purely residential based measures often underestimate the true degree of experienced racial diver- sity. Using survey data from the CCES, their findings suggest a negative correlation between racial flux and White Americans’ Democratic voting tendencies and a positive correlation with racial resentment and opposition to affirmative action, all while controlling for the residential share of Blacks in the zip code. We assess the replicability of these findings by: (1) replicating the main results using the provided replication code, (2) reconstructing the racial flux measure and survey from raw data, (3) conducting multiverse analyses, and (4) replicating the analysis using an alterna- tive data source. Our replication validates the robustness and accuracy of HW’s initial conclusions, emphasizing the role of daytime racial diversity in shaping White Americans’ political and racial attitudes.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/61.htm
- Link to Replicators Package: https://osf.io/ue4pm/
- Original Authors Response: “We enjoyed reading the replication, and don’t see a need to write a response. Thank you for doing this important work.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml;jsessionid=da88db7b3 367419a2d1a87a9e687?persistentId=doi%3A10.7910%2FDVN%2FFMOR6K&version=&q=&fileT ypeGroupFacet=&fileAccess=&fileSortField=type

### B.1.5
- 原论文标题：Brahmin Left Versus Merchant Right: Changing Political Cleavages in 21 Western Democracies, 1948–2020
- doi: https://doi.org/10.1093/qje/qjab036, Quarterly Journal of Economics
- 内容摘要：Gethin, Mart ´ınez-Toledano and Piketty (2022) analyze the long-run evolution of political cleavages using a new database on socioeconomic determinants of voting from approx- imately 300 elections in 21 Western democracies between 1948 and 2020. They find that, in the 1950s and 1960s, voting for the ”left” was associated with lower-educated and low-income vot- ers. After that, voting for the ”left” has gradually become associated with higher-educated voters, while highincome voters have continued to vote for the ”right”. In the 2010s, there is a disconnec- tion between the effects of income and education on voting. In this replication, we first conduct a computational reproduction, using the replication package provided by the authors. Second, we do a robustness replication testing to what extent the original results are robust to i) restricting the sample to ”core” left and right parties, ii) analyzing the top 80% versus bottom 20%, iii) weighting by population, iv) dropping control variables, and v) using country fixed effects. The main results of the paper are found to be largely replicable and robust.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/19.htm
- Link to Replicators Package: https://osf.io/2hpeq/
- Original Authors Response: “Thank you for your mail and for your interesting report! We are happy to see that you were able to easily replicate our results and that our main conclusions were found to be largely robust. In this context, we do not think that an answer from our side would be particularly useful: we are happy with the report as it is. Thank you for the very valuable work that your institute is producing in testing the replicability and robustness of published studies!”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/XUSWG6

### B.1.6
- 原论文标题：Bubbles, Crashes, and Economic Growth: Theory and Evidence
- doi: https://doi.org/10.1257/mac.20220015, American Economic Journal: Macroeconomics
- 内容摘要：Guerron-Quintana、Hirano 和 Jinnai (2023) 通过宏观经济一般均衡框架探究了金融泡沫对经济增长的短期、中期和长期影响。在他们的模型中，一个关键理论结果是，净而言，泡沫期间资本投资的"挤入"使经济在泡沫破裂后进入比泡沫前更高的平衡增长路径（图 10），因此（表面上）表明经济泡沫促进增长。反过来，论文的主要结果是，只要泡沫反复出现，这种对泡沫的积极看法就是谬误，因为一个泡沫从一开始就从未发生的反事实经济增长速度显著更快（图 10）。原因在于对未来泡沫的预期会抑制资本投资，因此从长期来看会降低经济增长。我们使用复现包中提供的原始代码成功复现了论文的主要图表。鉴于论文中使用的所有实证数据都是硬编码的，我们的大部分工作致力于复现所使用的实证数据本身，然后使用我们自己的度量进行直接复现。使用 HP 滤波的各种设定，我们成功定性但未定量复现论文的主要时间序列（股市市值与 GDP 之比）。然而，即使不更新模型的参数化，论文的主要实证发现（即图 8-10）对我们自己的度量也基本稳健。反过来，我们成功定量复现了第二个关键时间序列（信贷与 GDP 之比），但仅使用了 HP 滤波平滑参数的高度不寻常设定（季度数据使用 10^10 而非 1600）。我们发现，与股市市值与 GDP 之比不同，论文的（辅助）发现对我们自己的信贷与 GDP 序列不稳健。
- Link to Full Report: https://osf.io/d76tn/
- Link to Replicators Package: https://osf.io/d76tn/
- Original Authors Response: Provided a short response and answered a question. Waiting for their final response.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/173441/version/V 1/view

### B.1.7
- 原论文标题：Campaign Contributions and Roll-Call Voting in the U.S. House of Repre- sentatives: The Case of the Sugar Industry
- doi: https://doi.org/10.1017/S0003055422000466, American Political Science Review
- 内容摘要：In their study, Grier et al. (2023) explore the causal relationship between cam- paign contributions and roll-call voting. Their analysis focuses on the influence of campaign con- tributions on two specific anti-sugar votes conducted in 2013 and 2018. The authors identify a substantial increase in inflationadjusted sugar contributions from the sugar industry to incumbent politicians between these two voting events. The aim of our research is to replicate and validate the authors’ main models. In addition to cross-platform replication, we conduct several robustness checks to further examine the reliability of their findings. These include (1) clustering the stan- dard errors, (2) utilizing an Ordinary Least Squares (OLS) model instead of the authors’ logistic regression, and (3) altering the dependent variable to represent the change in the vote from 2013 to 2018. Our results largely confirm the authors’ findings and reveal additional insights regarding the money buys vote hypothesis.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/57.htm
- Link to Replicators Package: https://osf.io/4hjb9/
- Original Authors Final Response: “We thank the Institute for Replication for their diligent work replicating and performing some extensions to our 2023 APSR paper. Replication is an important and often undervalued work in the scientific process. Of course we are quite pleased to see that our results do replicate and that the extensions performed largely support the results and ideas we advanced in our paper. Keep up the good work!”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/2IFZR9

### B.1.8
- 原论文标题：Can Information Reduce Ethnic Discrimination? Evidence from Airbnb
- doi: https://doi.org/10.1257/app.20190188, American Economic Journal: Applied Economics
- 内容摘要：Laou ´enan & Rathelot (2022) investigate the mechanism underlying ethnic dis- crimination using self-collected panel data from Airbnb between 2014 and 2017. They find that hosts from minority groups charge 3.2% less than those from the majority group within the same neighbourhood. Using a theoretical framework, they estimate that the ethnic price gap vanishes as more information (reviews) become available conditional on observables. The point estimates for their main results are statistically significant at the 1% level. This finding suggests that ethnic discrimination is due to statistical discrimination rather than taste-based discrimination. First, we reproduce the original article’s main findings using R, whereby the authors of the original article use STATA. We can reproduce the main findings in R except for a few marginal discrepancies at the second or third decimal place. Second, we extend two robustness analyses reported in the original article. These robustness analyses impose restrictions on the sample and these restrictions are not justified in the article. Once these restrictions are not imposed, the picture becomes more complex and the robustness analysis warrants more discussion. However, only a small fraction of the observations causes some ambiguity and there might be good reasons to impose restric- tions. Transparently presenting the robustness analyses with and without restrictions, motivating the restrictions and discussing its implications for the main findings would have been desirable. Generally, the original article does a great job with regard to reproducibility by providing data, code and documentation that ease the reproduction of a complex analysis. We conclude that our reproduction and replication support the main findings of the original article.
- Link to Full Report: https://osf.io/zn98a/
- Link to Replicators Package: https://github.com/TuanNguyen04/Replication Airbnb
- Original Authors Response: The authors provided initial feedback which the replicators took it into account.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/120078/version/V 1/view

### B.1.9
- 原论文标题：Can Technology Solve the Principal-Agent Problem? Evidence from China’s War on Air Pollution
- doi: https://doi.org/10.1257/aeri.20200373, American Economic Review: Insights
- 内容摘要：Greenstone et al. examine the effect of the introduction of automatic air pollu- tion monitoring on the reporting of local air pollution in China. Using 654 regression discontinuity designs (RDDs) based on city-level variation in the day that monitoring was automated, they find an immediate and lasting increase of 35 percent in reported PM10 concentrations post-automation. Moreover, they find that automation’s introduction increases online searches for face masks and air filters by 200 percent and 28 percent, respectively, using an RDD. Results are consistent when using an event study design. First, we were able to computationally replicate the results. Sec- ond, we find that results are robust to more flexible specifications of the weather variables, to re-constructed weather variables using the same matching procedure as the authors (i.e., closest station) and meteorological data with additional weather stations, to alternative construction of the weather variables using an inverse distance weighted approach of the surrounding weather stations, and to more flexible choices of fixed effects (up to the city level). Finally, we find limited evidence of discontinuity in objective measures of ground pollution (i.e., AOD) for a sub-sample using alternative weather variables. The estimate, however, is economically insignificant. More- over, no discontinuity is observed in the full sample. Therefore, we believe this result does not invalidate the original study’s findings.
- Link to Full Report: https://osf.io/b7dn2/
- Link to Replicators Package: https://osf.io/m8hfr/?view only=9f6632ec96c0451daf0f8889b9ad 2b25
- Original Authors Response: Ongoing back and forth.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/125321/version/V 1/view

### B.1.10
- 原论文标题：Can’t We All Just Get Along? How Women MPs Can Ameliorate Affective Polarization in Western Publics
- doi: https://doi.org/10.1017/S0003055422000491, American Political Science Review
- 内容摘要：We present a replication and extension of Adams et al. (2023), examining the influence of women Members of Parliament (MPs) on affective polarization. Conducted during the 2023 Montreal Replication Games, our analysis reaffirms the original findings through the au- thors’ base R code and a tidyverse simplification. Our results highlight that the mitigating effect on polarization is predominantly observed among left-wing respondents, with null effects noted for centrist and right-wing parties. This discrepancy is attributed to left-wing parties’ explicit commit- ment to gender equality. Further analysis reveals the study’s robustness across different countries and years (1996-2007) while addressing data structure and imputation methods to ensure reliabil- ity. Our findings underscore the nuanced role of women MPs in political dynamics, particularly among left-wing voters, against democratic backsliding concerns.
- Link to Full Report: https://osf.io/69px3/
- Link to Replicators Package: https://osf.io/69px3/
- Original Authors Response: Thank you for replicating our paper Can’t We All Just Get Along? How Women MPs Can Ameliorate Affective Polarization in Western Publics (APSR 2023) as part of the Montreal Replication Games. We appreciate the attention to detail and rigor applied to the replication project. We are pleased that our initial results replicate well. We appreciate your robust approach to testing the stability of our findings using a country and year ’leave-one-out’ cross- validation strategy. We also thank you for catching the coding error which dropped a handful of cases from the original analysis; we are glad that the results remain substantively the same when this error is corrected. We also are interested in the results from the extension you undertook, find- ing that our results are primarily driven by left-wing parties’ supporters, in particular parties from the green, radical left and social Democratic parties. On the other hand, the point estimates are positive for all parties excepting the conservative and radical right parties, which can be expected to have the most conservative views on gender roles. We note that the authors’ interpretation, that “the portion of women MPs affects the attitudes of left-wing voters and not the attitudes of the voters most likely to undermine democracy” is true, but that the results also suggest that far-right parties, who most aggressively challenge liberal democratic norms, may be able to “soften” their image among left-wing voters by running female candidates. This is consistent with the argument made by Catalano Week et al (2023), that radical right parties strategically run women to broaden their appeal. Again, we deeply appreciate your replication and insightful extension of our research.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/AHQRVR

### B.1.11
- doi: https://doi.org/10.1086/719416, Journal of Politics
- 内容摘要：This paper focuses on computational reproducibility and robustness replicabil- ity of Gubler et al.’s(2022) studies which examine the effect of media messages on empathic con- cern, dissonance, and out-group policy attitudes. The original paper tests four hypotheses using two online experiments with large samples from one US state (N1 = 5,800; N 2 = 2,200). Regarding the first experiment, we successfully reproduced the effect that initial antipathy weakens the effect of humanizing treatment on empathic concern (H1). However, we show that the moderating effect is negligible and has little practical significance. Moreover, the individual effect estimates in our analyses slightly differed from the original paper due to different procedure of data cleaning and minor coding errors in the original paper. The most relevant difference was the opposite effect of gender than reported in the original paper. We also show that empathic concern might mediate the effect of humanizing treatment on attitudes toward immigrants (H3). The original study rejected the mediation hypothesis due to not finding a total effect of humanizing treatment on attitudes. In contrast, we found that humanization treatment has a positive indirect effect on attitudes through empathic concern. At the same time, it also has a direct negative effect on attitudes. For the second experiment (H1, H2a, H2b, H3), we attempted to reproduce the results using a different software. We partially succeeded once receiving support from the authors of the original study. We note throughout the report issues we have encountered.
- Link to Full Report: https://repec.econ.muni.cz/mub/wpaper/wp/econ/WP MUNI ECON 2 024-02.pdf
- Link to Replicators Package: See Report’s Online Appendix for the codes.
- Original Authors Response: Ongoing back and forth.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/FUCDTT

### B.1.12
- 原论文标题：Changing Tides: Public Attitudes on Climate Migration
- doi: https://doi.org/10.1086/715163, Journal of Politics
- 内容摘要：See entry below.
- Link to Full Report: https://www.socialsciencereproduction.org/reproductions/791/publishe d/index
- Link to Replicators Package: https://github.com/alexkustov/Replication-of-Arias-and-Blair-2
- Original Authors Response: “Thank you very much for reaching out! We are very pleased to hear that the results of our study were replicated, and do not need to provide an answer.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml;jsessionid=e19065118 cc12d43f1b412109d41?persistentId=doi%3A10.7910%2FDVN%2FFDML2N&version=&q=&fileA ccess=&fileTag=&fileSortField=name&fileSortOrder=desc

### B.1.13
- 原论文标题：Checking and Sharing Alt-Facts
- doi: https://doi.org/10.1257/pol.20210037, American Economic Journal: Economic Policy
- 内容摘要：Henry, Zhuravskaya, and Guriev (2022) examine whether people are willing to share ”alternative facts” espoused by right-wing populist parties before the 2019 European elec- tions in France and how this interacted with the availability of fact-checking information. They find that both imposed and voluntary fact-checking reduce the likelihood of sharing false state- ments by approximately 45%, and that imposed and voluntary fact-checking have similar effect sizes. We reproduce these findings and introduce several alternative estimates to assess the robust- ness of the original results, including resolving an inconsistency in the handling of pre-treatment controls. Overall, our results align with the results of the original paper. The differences we find are small in absolute magnitude but, since many effects were small, not always trivial in terms of relative differences. This replication supports the conclusions of the original paper.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/34.htm
- Link to Replicators Package: https://doi.org/10.5281/zenodo.7858829
- Link to Original Authors Response: “Many thanks! No, we won’t be writing a response.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/140161/version/V 1/view

### B.1.14
- 原论文标题：Child Marriage Bans and Female Schooling and Labor Market Outcomes: Evidence from Natural Experiments in 17 Low- and Middle-Income Countries
- doi: https://doi.org/10.1257/pol.20200008, American Economic Journal: Economic Policy
- 内容摘要：By studying child marriage bans in 17 developing countries, Wilson (2022) finds that raising the minimum legal age of marriage to 18 successfully increased the age at first marriage, the age at first birth, and the likelihood of employment. Additionally, the bans reduced child marriage and increased educational attainment in urban areas. We replicate these findings by collecting the raw data from the same sources as the paper and analysing the data following the procedures described in the paper, without referring to the data and codes provided by the author. Our findings are consistent with the results of the paper in terms of the statistical significance of point estimates and differ in magnitude by a negligible amount.
- Link to Full Report: https://osf.io/5yhxc/
- Link to Replicators Package: https://livewarwickac-my.sharepoint.com/personal/u2084980 liv e warwick ac uk/ layouts/15/onedrive.aspx?id=%2Fpersonal%2Fu2084980%5Flive%5Fwarwick %5Fac%5Fuk%2FDocuments%2FAAA%20Warwick%20University%2FReplication%20Games%2F Wilson%282022%29%2DReplicationCodes%2DShared&ga=1
- Original Authors Response: We could not reach out the author.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/130784/version/V 1/view

### B.1.15
- 原论文标题：Concentration Bias in Intertemporal Choice
- doi: https://doi.org/10.1093/restud/rdab043, Review of Economic Studies
- 内容摘要：Dertwinkel-Kalt et al. (2022) examine the effect of concentration bias - the ten- dency to overweight advantages that are concentrated in time relative to costs that are spread over multiple time periods - on intertemporal choice in a laboratory experiment. In their preferred em- pirical specification, the authors report that concentration bias leads to a 22.4% higher willingness to work than explained by a standard model of intertemporal discounting. We conduct a computa- tional replication of the main results of the paper using the same procedures and original data. Our results confirm the sign, magnitude and statistical significance of the author’s reported estimates across each of their five main findings.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/42.htm
- Link to Replicators Package: https://osf.io/d42xr/
- Original Authors Response: “We thank Deer, Ellingsrud, Heuer, and Kordt (2023) for conducting the replication report and appreciate that their “results confirm the sign, magnitude and statistical significance of [our] reported estimates across each of [our] five main findings” (p. 1). We don’t have anything substantive to add to this. ”
- Original Authors Package: https://zenodo.org/records/5091975

### B.1.16
- 原论文标题：Cooperative Property Rights and Development: Evidence from Land Reform in El Salvador
- doi: https://doi.org/10.1086/717042, Journal of Political Economy
- 内容摘要：Montero (2022) explores a discontinuity in a land reform in El Salvador and re- ports two main findings. First, relative to outside-owned haciendas operated by contract workers, the productivity of worker-owned cooperatives is higher for staple crops and lower for cash-crop. Second, cooperative property rights increase workers’ incomes and compress wage distributions. In this comment, we show that the latter result rests on two mistakes: three-quarters of the obser- vations are duplicates and income inequality is calculated over too few workers to be meaningful. When corrected, the data sources and research design provide no credible evidence regarding the causal effects of ownership structure on income levels and inequality.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/20.htm
- Link to Replicators Package: https://doi.org/10.7910/DVN/AMD3NO
- Link to Original Authors Response: https://www.journals.uchicago.edu/doi/10.1086/725234
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/717042/s uppl file/20190161data.zip

### B.1.17
- 原论文标题：Decentralization Can Increase Cooperation among Public Officials
- doi: https://doi.org/10.1111/ajps.12606, American Journal of Political Science
- 内容摘要：Molina-Garz ´on, Grillos, Zarychta, and Andersson (2022) examine how health sector decentralization affects cooperation between public officials. Using a public goods game conducted in Honduras, they find that officials who work under decentralized regimes contributed 0.8 more lempiras per round to a group solidarity fund, compared to officials who work under centralized regimes. They also find that most of this increase in investment under decentralized regimes occurred during rounds of the game in which the participants were able to communi- cate with each other. Finally, they find that decentralization was associated with a 14 percentage point increase in the proportion of potential cross-level network ties between participants that were realized. In this paper, I examine whether these results are robust to (1) the omission of some individual-level controls that may have been affected by the decentralization treatment, and (2) the use of a linear regression model instead of a Poisson regression model for the network analy- sis. I find that omitting the individual-level controls leads to similar conclusions about the effect of decentralization on individual contributions in the public goods game, but the interaction effect between decentralization and communication becomes statistically insignificant at the 0.05 level. For the network analysis, I find that using a linear regression instead of a Poisson regression has little bearing on the magnitude of the effect of decentralization on the proportion of ties realized, though the effect of decentralization becomes statistically insignificant for one version of the net- work model.
- Link to Full Report: https://osf.io/q3dpt/
- Link to Replicators Package: https://osf.io/q3dpt/
- Link to Original Authors Response: https://osf.io/q3dpt/
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/ZLHYSZ

### B.1.18
- 原论文标题：Declining Worker Turnover: The Role of Short-Duration Employment Spells
- doi: https://doi.org/10.1257/mac.20190230, American Economic Journal: Macroeconomics
- 内容摘要：Using a Diamond-Mortensen-Pissarides (DMP) model with noisy signals on worker-firm match quality calibrated on data from 30 US states for 1999 and 2017, Pries and Roger- son argue that improved screening may explain the decrease in short-term employment spells ob- served in the US labor market. Using a decomposition exercise in a ”reduced form” model, the authors show that changes in short-term employment spells ( and ) are almost entirely accounted for by changes in the rate of learning on match quality and in the probability of a good match . Then, using a decomposition exercise in a ”structural” model, they show in their main calibration strategy that changes in and are mainly driven by changes in and , parameters pertaining to learning about match quality. First, we reproduce the authors’ codes in R and Python, two popular free open source programming languages. We find identical results to the paper. Second, we test the robustness of results to (1) using an earlier starting year, (2) adding additional states in the analysis, and (3) increasing the value of the 1999 mean vacancy duration parameter. The direc- tion and relative size of the effect of each parameter on and is preserved in all robustness tests, corroborating the authors’ argument.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/93.htm
- Link to Replicators Package: https://github.com/AlexandrePavlov/PriesRogerson2022Replicat ion
- Original Authors Response: Declined to respond.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/120568/version/V 1/view

### B.1.19
- 原论文标题：Digital Addiction
- doi: https://doi.org/10.1257/aer.20210867, American Economic Review
- 内容摘要：Using an original economic model of digital addiction and a randomized ex- periment, Hunt Allcott, Matthew Gentzkow, and Lena Song (2022) isolate the effect of habit for- mation and self-control problems on how people use their smartphones. They find a persistent effect of temporary incentives on reducing social media usage. With the model-free results, the study shows that (after the incentive was in effect), participants in the bonus group reduced use by 56, 19 and 12 minutes in periods 3, 4 and 5,respectively, suggesting a persistent effect. But be- fore the incentive was in effect in period 2, social media use reduced use by 5.1 minutes per day. Participants who used the limit functionality reduced FITSBY use by over 20 minutes per day, sug- gesting an impact of self-control problems on social media use. All these estimates are statistically significant. We perform a direct replication of the paper. Upon re-calculating the core dependent variable (FITSBY use by period), we find a small but concerning discrepancy: For a small number of observations, the aggregated dependent variable does not equal the sum of the disaggregated categories. Thankfully, this discrepancy does not have a major effect on the results. Using the pro- vided data, we re-coded the core figures from scratch and found that we could replicate them all. We also compare the pre-analysis plan (PAP) with the main study to identify gaps and perform computational reproduction/replication of the structural model and model-free analysis. We only find minor differences between the PAP and the main paper, almost all of which are acknowledged in the paper.
- Link to Full Report: https://osf.io/8kvdf/
- Link to Replicators Package: https://osf.io/8kvdf/
- Link to Original Authors Response: https://osf.io/8kvdf/
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/163822/version/V 2/view

### B.1.20
- 原论文标题：Do Thank-You Calls Increase Charitable Giving? Expert Forecasts and Field Experimental Evidence
- doi: https://doi.org/10.1257/app.20210068, American Economic Journal: Applied Economics
- 内容摘要：Samek and Longfield estimate the effect of ’thank you calls’ on the extensive and intensive margins of subsequent donations. Based on a series of experimental interventions, the authors find no statistically discernable effect of thank-you calls on either the likelihood of donating again, or on the size of any subsequent donations made within the period of the study. In a companion exercise the researchers quantify the ability of experts in charitable fundraising and non-experts (using the Understanding America Survey) to predict the behaviours elicited by the experiment. Experts and non-experts (incorrectly) make the same predictions of an increase to the extensive margin of donation behaviour induced by the thank you call, and while both groups overestimate the intensive margin, the non-experts overestimated by a smaller magnitude. We were able to reproduce the papers findings completely, discovering only one difference in an appendix table related to the average gift amount — treatment for experiment 1 where only the constant term of the regression was affected. Upon careful examination of the code we found a few small errors that did not affect the results (one of the errors in the code did not seem to be carried through and used anywhere). Finally, we conducted several extensions of the original analysis which demonstrated that the findings are robust to heterogeneity of treatment effect by initial donation size, as well as different specifications of the regression analysis.
- Link to Full Report: To be made available soon. Waiting for the authors’ response.
- Link to Original Authors Response: Waiting for the authors’ response.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/149481/version/V 1/view

### B.1.21
- 原论文标题：Do Transitional Justice Museums Persuade Visitors? Evidence from a Field Experiment
- doi: https://doi.org/10.1086/714765, Journal of Politics
- 内容摘要：Balcells et al. (2022) explore the effect of transitional justice museums through a field experiment in Santiago, Chile, and attendance at the government’s remembrance museum, the Museum of Memory and Human Rights which looks at the time of Pinochet’s dictatorship. The authors want to understand how such experiences shape an individual’s perceptions of trust in government institutions, and transitional justice policies, and how they are affected emotion- ally. Additionally, they seek to measure how long they last over time. They do this by creating treatment (museum attendance) and control (non-attendance) groups and administering pre-and post-treatment surveys and estimating the ‘complier average causal effect’ (CACE). They find that satisfaction with the current government significantly increases for the treatment group, looking over the entire population (= 0.15, p= .04) as measured with a 4-point Likert scale and support for a military government significantly drops by 11% (= 0.11, p= .002) across ideological stances. We first reproduce their results and find no major coding errors. Second, we test the robustness of the effects by 1) testing for heterogeneous effects by gender, 2) we combine the emotion variables into two indices, a mobilization and demobilization index, and 3) conduct a causal mediation analysis to see how confidence in the church may mediate effects found in the study.
- Link to Full Report: https://osf.io/m3hwg/
- Link to Replicators Package: https://osf.io/m3hwg/
- Original Authors Response: “We thank all involved for their interest in our work. We are happy to hear that the results from our paper successfully replicated. We are intrigued by the additional analyses performed by the replicators. We hope their insights and results can inform future theo- rizing and empirical studies of the impact of Transitional Justice.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml;jsessionid=a651e0dbc 9a5c140152aa84be2e0?persistentId=doi%3A10.7910%2FDVN%2FTNFDDX&version=&q=&fileT ypeGroupFacet=&fileAccess=Public&fileSortField=type

### B.1.22
- 原论文标题：Does Competence Make Citizens Tolerate Undemocratic Behavior?
- doi: https://doi.org/10.1017/S0003055422000119, American Political Science Review
- 内容摘要：We replicate the analysis conducted by Frederiksen, 2022a. We focus on assess- ing the computational and robustness replicability of their work. We find that their main exhibits and supplementary analysis are replicable, both when running their original Stata replication pack- age, and when we attempt to replicate their findings from scratch in R. We also conduct additional robustness checks by estimating additional specifications and by subsetting the dataset by the time taken by the respondent to complete the survey. We again find that their work is robust to our battery of alternative specifications.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/28.htm
- Link to Replicators Package: https://github.com/tjbrailey/nottingham replication 2023
- Link to Original Authors Final Response: “Thanks a lot for this initiative and not least for repli- cating my results.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/NGFLRO

### B.1.23
- 原论文标题：Does Patient Demand Contribute to the Overuse of Prescription Drugs?
- doi: https://doi.org/10.1257/app.20190722, American Economic Journal: Applied Economics
- 内容摘要：We replicate Lopez et al.’s (2022) study on gatekeeping costs and the poten- tial evidence for patient-driven and doctor-driven demand. Using their publicly available source materials, we first re-run their analysis “as is” to see if their results can be exactly replicated. We then expand the analysis to include patients previously excluded for not being acutely ill, offering a broader perspective on medication demand among all patient types. The findings confirm Lopez et al.’s results.
- Link to Full Report: https://osf.io/x7g9z/
- Link to Replicators Package: https://osf.io/x7g9z/
- Link to Original Authors Response: Provided feedback to an initial report. Final response: “ Thank you very much for sharing the updated report. We appreciate that the authors of the repli- cation reworked the paper and have no further response or comments.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/126722/version/V 1/view

### B.1.24
- 原论文标题：Does Public Opinion Affect the Preferences of Foreign Policy Leaders? Ex- perimental Evidence from the UK Parliament
- doi: https://doi.org/10.1086/719007, Journal of Politics
- 内容摘要：The study by Chu and Recchia (2022) tests the hypothesis that providing public opinion information can shift policymakers’ opinions in the direction of what the public favors. They surveyed 101 British Members of Parliament (MPs) about their views regarding the United Kingdom’s presence in the South China Sea. Their results demonstrated that MPs who received information about the public opinion poll expressed viewpoints closer to that of public opinion. The authors reported an effect that is “substantively meaningful and statistically significant at the .10 level.” Our computational replication of the original study found that the paper is fully com- putationally reproducible. We successfully replicated the authors’ results but found that the main findings are no longer significant when analyzed using unweighted data (see Table 1). We also conducted several robustness checks on sub-samples of the data to examine the key analyses both with and without weights. Here, we found that the results are once again robust and significant when weights are used, but no longer significant when weights are not used. As a further robust- ness check, we found no moderating effect of gender. Overall, our replication efforts suggest that the main finding of the original study may be sensitive to the use of survey weights.
- Link to Full Report: https://osf.io/bqz6w/
- Link to Replicators Package: https://osf.io/vwt2n/?view only=84e52a7c684942a4880410b3c89f f4c6
- Original Authors Response: “ Thank you for your note and engaging with our work. We don’t have a formal reply, though this is an honest question: isn’t it standard practice to use weights when using YouGov’s data, since making valid claims about representativeness depends on using their weights? YouGov’s MP panels operate similarly to their public opinion poll, in that their claims to representativeness rely on using weights, provided by YouGov. I [Chu] think your write- up mentioned that there’s a debate about using weights, and cited MTurk data, but I think that MTurk is quite different, and yes, I agree I do not use weights for MTurk data except unless re- quested by a reviewer for robustness checks, etc.. But I don’t think MTurk and the MP represen- tative poll we used is a good comparison in the context of evaluating the validity of weighting. In any case, happy to adapt if there is a clear consensus on this. Thanks again.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/BNINNL

### B.1.25
- 原论文标题：Effective for Whom? Ethnic Identity and Nonviolent Resistance
- doi: https://doi.org/10.1017/S0003055421000940, American Political Science Review
- 内容摘要：Manekin and Mitts (2022) investigate the success chances of minority ethnic groups when engaging in non-violent protests demanding political change. First, using obser- vational data, the authors find that the success rate for nonviolent campaign tactics is lower for excluded/minority ethnic groups than for non-excluded/majority ethnic groups. Second, the au- thors use two original survey experiments to show that non-violent protest by ethnic minorities is perceived as more violent and requiring more policing than identical protest by majorities. This report reproduces the paper computationally and conducts several sensitivity analyses for both the observational and the experimental parts of the paper. We can confirm the general direction of the postulated effects, but evidence becomes less consistent (effect magnitudes and significance levels are not robust to some of the changes).
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/86.htm
- Link to Replicators Package: https://zenodo.org/records/10193470
- Original Authors Response: Cannot provide a response.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/SHHVCA

### B.1.26
- 原论文标题：Enabling or Limiting Cognitive Flexibility? Evidence of Demand for Moral Commitment
- doi: https://doi.org/10.1257/aer.20201333, American Economic Review
- 内容摘要：We computationally reproduce Saccardo and Serra-Garcia (2023) where sub- jects exploit cognitive flexibility by viewing their incentives first and partially ignoring product quality information, and hence, recommend the incentivized product. We find one major coding error for the variable Selfishness. Additionally, two of the “moral cost” questions more likely cap- ture spitefulness. After correcting the erroneous coding or dropping the two questions, we find stronger support for the authors’ main conclusion regarding Selfishness driving incentive infor- mation avoidance with double effect size. Finally, we find weak evidence that subjects update their posterior beliefs differently depending on the product they are incentivized to recommend.
- Link to Full Report: https://osf.io/nwds7
- Link to Replicators Package: https://osf.io/yfdet/
- Link to Original Authors Response: https://www.aeaweb.org/doi/10.1257/aer.20201333.appx
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/180741/version/V 1/view

### B.1.27
- 原论文标题：Entertaining Beliefs in Economic Mobility
- doi: https://doi.org/10.1111/ajps.12702, American Journal of Political Science
- 内容摘要：In Entertaining Beliefs in Economic Mobility (AJPS 2023) Kim finds that watch- ing “rags-to-riches” style reality TV programs strengthens Americans’ belief in the American dream. Through thoughtful and clever experimental and observational analysis, she demonstrates that exposure to television programs containing everyday people working hard to earn large prizes increases Americans’ belief that success can be internally attributed and that economic mobility is possible. We computationally replicate Kim’s results, finding no major errors in her coding or sta- tistical procedure. We also include several robustness checks. First, we merge her two experimental samples, which increases the precision of her main quantity of interest such that it attains conven- tional levels of statistical significance. Second, we recreate tables and visualizations for alternative specifications of her main observational results. The original results are robust to these alternative models, but we do find that if sports programming is operationalized in the same manner as “rags- to-riches” programming, the sign, magnitude, and significance of watching either programming type are similar. We also uncover a partisan interaction effect, as only Democrats change their beliefs in economic mobility with increased TV viewing.
- Link to Full Report: https://osf.io/xf5w2/
- Link to Replicators Package: 
- Original Authors Response: “Thanks for this! I have no particular response per se. I’m grateful for your collective efforts to make social science much more transparent.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/FVRZYU

### B.1.28
- 原论文标题：Evaluating Deliberative Competence: A Simple Method with an Application to Financial Choice
- doi: https://doi.org/10.1257/aer.20210290, American Economic Review
- 内容摘要：Ambuehl et al. (2022) explore ways to evaluate interventions designed to en- hance decision-making quality when individuals misjudge the outcomes of their choices. The authors propose a novel outcome metric that can distinguish between interventions better than conventional metrics such as financial literacy and directional behavioral responses. The proposed metric, which transforms price-metric bias into interpretable welfare loss measures, can be applied to evaluate various training programs on financial products. Table 4 of the paper reports the au- thors’ significant main point estimates at the 1% level. In this replication exercise, we first replicate the main findings of the original paper. Then, we modify the clustering method by using k-means with demographic variables as inputs, then we re-calculate standard errors with jackknife estima- tors. Finally, we include subjects who were excluded by the authors due to multiple switching in the multiple price lists. We find that all of these replications result in robust findings. Addition- ally, we successfully replicate Figure 4 from the paper. Notably, this replication demonstrates the insensitivity of the results to the choice of distance metric.
- Link to Full Report: https://osf.io/scgbt/
- Link to Replicators Package: https://osf.io/scgbt/
- Link to Original Authors Response: Authors provided feedback.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/171681/version/V 1/view

### B.1.29
- 原论文标题：Exposure and Preferences: Evidence from Indian Slums
- doi: https://doi.org/10.1111/ajps.12570, American Journal of Political Science
- 内容摘要：Successful computational reproducibility. The replicators could not conduct the robustness checks without the help of the author.
- Link to Full Report: No report.
- Original Authors Response: “Thanks for your email. I am not interested in participating.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/AV8PLT

### B.1.30
- 原论文标题：Finance and Green Growth
- doi: https://doi.org/10.1093/ej/ueac081, Economic Journal
- 内容摘要：De Haas and Popov (2023) estimate the effect of country-level financial sector size and structure on decarbonization to show that countries with relatively more equity versus debt financing have more emission-efficient economies. We uncover multiple coding errors that change the magnitude and the precision of the coefficients of interest. These coding errors include misreporting of standard errors, and misspecifying generalized method of moments (GMM) esti- mators. We further provide robustness tests of the results to (1) restricting the sample to consistent sets of countries across the country and country-by industry samples, and (2) using a limited in- formation maximum likelihood (LIML) estimator to address a weak-instrument problem. We find that the results from the robustness checks are qualitatively different from the original results but similar to the corrected results.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/95.htm
- Link to Replicators Package: https://osf.io/h8ct2/
- Link to Original Authors Response: https://econpapers.repec.org/paper/zbwi4rdps/96.htm
- Original Authors Package: https://zenodo.org/records/7220094

### B.1.31
- 原论文标题：Flight to Safety: COVID-Induced Changes in the Intensity of Status Quo Preference and Voting Behavior
- doi: https://doi.org/10.1017/S0003055421000691, American Political Science Review
- 内容摘要：Bisbee and Honig (2022) examine the effect of the COVID-19 pandemic on voting for Bernie Sanders in the 2020 Democratic Party primary using a difference-in-differences design, finding evidence that exposure to COVID-19 resulted in a 7-15 percentage point increase in voting for Biden. The study also uses a regression design with district-level fixed effects to esti- mate the effect of the COVID-19 pandemic on voting for anti-establishment candidates during the US 2020 House primaries. It finds evidence that an increase in COVID cases was associated with a decline in voting for anti-establishment candidates in general, and for those endorsed by the Tea Party. We re-run the code for all tests in this paper, successfully reproducing its results in a prelim- inary replication. We then use the De Chaisemartin and D’Haultfoeuille difference-in-differences estimator to replicate their main results, finding that though the coefficient remains negative, the results are not statistically significant. We also replicate their tests regarding US House primary candidates using a different measure of anti-establishment candidates. Here, we find that the inter- action term between anti-establishment candidates and COVID-19 remain statistically significant, with the same sign. Finally, we employ an expanded dataset that includes Congressional primary candidates that were omitted in the initial dataset, as well as a re-coded extremism variable that also includes candidates endorsed by Donald Trump. These updated findings corroborate the pa- per’s initial results. However, due to a restrictive number of observations that interfered with our application of the De Chaisemartin and D’Haultfoeuille estimator, we believe that the expanded U.S. House primary results constitute the more robust half of our replication.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/36.htm
- Link to Replicators Package: https://github.com/Dmscates/Bisbee-and-Honig-2022-Flight-t o-Safety-Replication
- Original Authors Response: “You guys are amazing. Thank you for doing this! We are impressed by your rigor and grateful for the introduction to DCD’H DiD estimator that we’ll have to add to the repertoire. We were working on the conditional accept when the flurry of generalized DiD work (Goodman-Bacon, Callaway, etc.) was blowing up [...] We also appreciate the manner in which you communicated with us during the course of your re-analysis, and the thoughtfulness of your report. [...] Although I’m sure it is a logistical nightmare and likely would add even more delays to the publication pipeline, it would be very pro-science if this type of replication were part of a journal’s own pre-publication process. (This is what I naively thought replication meant back when I got my first publication, and have been disappointed in the process ever since.)”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/S5YMS7

### B.1.32
- 原论文标题：Gender Differences in Cooperative Environments? Evidence from The U.S. Congress
- doi: https://doi.org/10.1093/ej/ueab069, Economic Journal
- 内容摘要：Gagliarducci and Paserman (2022) study gender differences in cooperative be- havior among politicians using information from the U.S. House of Representatives between 1988 and 2010 on (i) the number of co-sponsors on bills and (ii) the share of co-sponsors from the ri- val party. Through different empirical strategies, they show that women-sponsored bills tend to have more co-sponsors, but the gap is only statistically significant among Republicans. Moreover, Republican women recruit a significantly larger share of co-sponsors from the rival party than Re- publican men, whereas the opposite is true among Democrats. GP argue that the observed pattern is consistent with a commonality of interest driving cooperation, rather than gender per se, since during this period Republican women were ideologically closer to the rival party than their male colleagues, while female Democrats were further away. We examine the robustness of these find- ings to (i) the correction of some errors in two control variables of the dataset used by GP and (ii) clustering the standard errors at the individual level, instead of individual-term. These changes have a relatively minor impact on results: most coefficients are still statistically significant and the main conclusions from the analysis are confirmed. Furthermore, we extend the analysis to the 2011- 2020 period. The analysis of gender differences in bipartisan cooperation confirms GP’s hypothesis that ideological distance plays an important role. However, results are slightly different when we analyze overall cooperation. The gender gap in favor of women is larger in magnitude than in GP and it is statistically significant in several specifications, providing support for the hypothesis that gender also matters for cooperation.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/75.htm
- Link to Replicators Package: https://www.dropbox.com/scl/fo/dmvgx5wlgql3tz98dx47u/h?r lkey=af83xiqrkw70rbjicdunoach9&dl=0
- Link to Original Authors Response: https://osf.io/w48tf/
- Original Authors Package: https://zenodo.org/records/5111360

### B.1.33
- 原论文标题：Good Reverberations? Teacher Influence in Music Composition since 1450
- doi: https://doi.org/10.1086/718370, Journal of Political Economy
- 内容摘要：Borowiecki (2022) studies the influence of teachers on the style of their students in the domain of musical composition. The author finds that realized student-teacher pairs are on average 0.2-0.3 standard deviations more similar to unrealized, but possible, student-teacher pairs. In this report we provide the results of our replication of Borowiecki (2022). We direct our atten- tion to the following tasks: 1) Replicating the outcome variables used in the paper, starting from the raw data, and generating alternative measures of similarity between students and teachers 2) Testing the validity of the random teacher-student pairing, a key assumption for the validity of the estimation strategy employed in the paper. We can replicate most of the outcome variables, but not all of them, due to incomplete raw data. Our alternative measures of similarity confirm the robustness of the original results. We find significantly different characteristics between paired and unpaired students, suggesting that matching between students and teachers does not occur randomly. However, controlling for these characteristics in the main regressions leads to quantita- tively similar results to the ones reported in the original paper.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/27.htm
- Link to Replicators Package: https://www.dropbox.com/scl/fo/6hecmgjsq3mjo5ekkv8lm/h?r lkey=ftuoe4mf5f9jon0hiabb4brtn&dl=0
- Link to Original Authors Response: https://osf.io/79e2z/
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/718370/s uppl file/20210405data.zip

### B.1.34
- 原论文标题：Hate Crimes and Gender Imbalances: Fears over Mate Competition and Violence against Refugees
- doi: https://doi.org/10.1111/ajps.12595, American Journal of Political Science
- 内容摘要：Dancygier et al. (2022) ascribe anti-refugee hate crime in Germany from 2015 to 2017 to the fear of mate competition felt by native German men, amplified by growing refugee populations and existing gender gaps. In a replication of this article, we discovered that the sub- stantively and statistically significant relationship between perceptions of mate competition and support for anti-refugee violence found in a 2016–17 survey of adults in Germany were robust when analyzed with ensembles of regression trees permitting arbitrary interactions in a large de- sign matrix. However, statistically significant pairwise comparisons between survey respondents’ perceptions of mate competition across strata of the municipality-level gender gap as recorded by German censuses were not robust to controlling the family-wise Type I error rate. Moreover, statistically significant relationships between the gender gap and the incidence of hate crime in Germany in the authors’ panel regressions vanished in a wide range of specifications with munic- ipality fixed effects—in certain cases, being replaced with statistically significant estimates of the opposite sign. Link to Full Report (and Initial Version of the Report): https://osf.io/5n3ds/
- Link to Replicators Package: https://osf.io/5n3ds/
- Link to Original Authors Response: https://osf.io/5n3ds/
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/QXJDJ5

### B.1.35
- 原论文标题：Historical Lynchings and the Contemporary Voting Behavior of Blacks
- doi: https://doi.org/10.1257/app.20190549, American Economic Journal: Applied Economics
- 内容摘要：Williams (2022) ties the political participation of Blacks to historical lynchings that occurred in the United States. Her findings document lower Black voter registration rates in southern counties with greater number of historical lynchings. We show that this effect is driven by four outlier counties with relatively high Black lynching rates. Excluding these counties from the analysis yields a point estimate that is no longer statistically significant. Dropping the ninety- fifth percentile lynching rates and correcting the errors in voter registration rates rule out the effect size reported by Williams (2022), which now becomes close to zero and statistically insignificant. We also show that the main results are highly sensitive to the way lynching and voter registration rates are measured.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/32.htm
- Link to Replicators Package: https://osf.io/hv7wp/
- Original Authors Response: No response to emails. Original Author’s Package: https://www.openicpsr.org/openicpsr/project/136741/version/V 1/view

### B.1.36
- 原论文标题：Hobo Economicus
- doi: https://doi.org/10.1093/ej/ueab103, Economic Journal
- 内容摘要：Peter Leeson, August Hardy and Paola Suarez (2022) test maximizing be- haviour of panhandlers at several Metrorail stations in Washington, D.C. Their main findings are that ”stations with more panhandling opportunities attract more panhandlers” (the first statement) and that ”cross-station differences in hourly panhandling receipts are statistically indistinguish- able from zero” (the second statement). We test computational reproducibility and robustness replicability of their results. We can reproduce both statements, in Stata and R. Our robustness replications for the first statement confirm the authors’ results in the vast majority of cases (repli- cation was successful in 91% of the cases). Our robustness replications for the second statement might raise doubts on this finding. We run weighted ANOVA tests, we change the bounds in min- utes used by authors by 5 minutes in their robustness checks, we run Bartlett’s tests of equality of variances of means, and run pair-wise tests of equality of means. In three out of four cases we can- not replicate the results, and the differences (of either means, medians or variances of donations) across Metrorail stations are statistically different from zero. We hypothesize that panhandlers have a general idea about which stations have more passers-by, and will rationally go more often there. However, they are unlikely to have information about smaller variations in the number of passers-by (e.g., variations in passers-by at the same station over time due to non-public events), and therefore might find it difficult to perfectly maximize donations.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/55.htm
- Link to Replicators Package: https://osf.io/s4bca/
- Original Authors Response: Declined to respond.
- Original Authors Package: https://zenodo.org/records/5719541

### B.1.37
- 原论文标题：How Do Beliefs about the Gender Wage Gap Affect the Demand for Public Policy?
- doi: https://doi.org/10.1257/pol.20200559, American Economic Journal: Economic Policy
- 内容摘要：We conduct a replication of Settele (2022), a online survey experiment designed to find out how individual’s beliefs about the gender wage gap affect their policy preferences. We reproduce Results 1 and 2 of the study: how prior beliefs around the wage gap are distributed among individuals and how a information treatment causally affects the policy demand. Our re- coded replication shows that the reported results are robust.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/12.htm
- Link to Replicators Package: https://osf.io/j2ubt/
- Original Authors Response: “I very much appreciate the effort of you and your team to replicate not just my paper, but many others too. It is quite impressive to see the scope of your project and I am curious about your future plans with this initiative. I just read the replication report for my paper and I think it is great. In particular, Figures 2 and 3 are really cool. (They are actually new, and offer a really insightful way of looking at the data. I should have come up with them myself!) Regarding your question, I don’t think the replication report requires a formal response from my side. I fully agree with the authors’ interpretation of the results, and just want to say thank you for their great work. Please go ahead and publish the report whenever it suits you.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/134041/version/V 1/view

### B.1.38
- 原论文标题：How Effective Are Monetary Incentives to Vote? Evidence from a Nation- wide Policy?
- doi: https://doi.org/10.1257/app.20200482, American Economic Journal: Applied Economics
- 内容摘要：Successful computational reproducibility. No re-analyses conducted.
- Link to Original Authors Response: Not contacted.
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/720458/s uppl file/20190733data.zip

### B.1.39
- 原论文标题：How Much Should We Trust the Dictator’s GDP Growth Estimates?
- doi: https://doi.org/10.1086/720458, Journal of Political Economy
- 内容摘要：In this brief commentary, we have conducted a robustness reproducibility and replicability of Martinez’s 2022 paper entitled “How much should we trust the dictator’s GDP growth estimates?” by selecting different clusters and omitting fixed effect terms. Concurrently, we conduct sub-sample analyses and employ alternative measurements for the sake of robust- ness and direct replicability. Our results are generally robust, yet they also raise some intriguing questions. First, we attempt to remove the year fixed effect in the model specifications, but the elimination of the year fixed effect from the baseline equation did not account forunobserved vari- ables across year, suggesting the variable bias by Oster (2019). Second, the entirety of the baseline results is influenced by the periods 2007-2013 (for a five-year interval) and 2010-2013 (for a three- year interval). Third, when utilizing a more varied dataset for the autocracy measurement, the effect vanished for countries that are partially unfree.
- Link to Full Report: https://osf.io/4sk52/
- Link to Replicators Package: https://osf.io/4sk52/ Original Author’s Final Response: “As before, please extend my gratitude to the replicators for their thoughtful work and for taking into consideration my previous comments. I am reassured by the fact that they were able to replicate all the original results in the paper. I also find it reas- suring that the results prove robust to additional robustness tests concerning alternative clustering structures for the standard errors or alternative data sources on political regimes (albeit with some loss of precision). The heterogeneous effects by subperiod are also quite intriguing and potentially reflect changes in the geopolitical incentives to overstate GDP growth in non-democracies. My paper is certainly not the final word on this topic and these results could be the first step towards new and exciting research.”
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/720458/s uppl file/20190733data.zip

### B.1.40
- 原论文标题：Ideological Asymmetries and the Determinants of Politically Motivated Rea- soning
- doi: https://doi.org/10.1111/ajps.12624, American Journal of Political Science
- 内容摘要：Guay and Johnston (2022) examine asymmetric politically motivated reasoning on the part of liberals and conservaites. In our replication of the paper we examine four potential issues with the analysis: confounding in the numeracy task, heterogeneity across ideological con- straints, the use of control variables, and heterogenity in the moderator index items. None of these potential issues are in fact issues. The results are quite robust. We found only one minor issue with the codebook, which does not affect the results.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/79.htm
- Link to Replicators Package: https://osf.io/mh5sk/
- Link to Original Authors Response: “Thank you again for examining our paper so closely [...] we changed the codebook and appreciate this replication effort.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/CGHTPZ

### B.1.41
- 原论文标题：Immigration and Redistribution
- doi: https://doi.org/10.1093/restud/rdac011, Review of Economic Studies
- 内容摘要：Alesina et al. (2023) examine how people perceive the number and charac- teristics of migrants and how those perceptions affect their support for redistribution. They find that respondents from the United States, United Kingdom, Sweden, Italy, Germany and France markedly overestimate the share of immigrants in each country, with the average respondent in all countries except Sweden overestimating by more than a factor of two. We reproduce these results using the original code and data and test the robustness by (i) including participants ex- cluded for time to complete the survey, (ii) extending the analysis of misperceptions to all survey respondents, and (iii) using alternative authoritative estimates of the proportion of immigrants. We find that these checks marginally change the estimates of the size of the misperception but do not change the conclusions to be drawn from the analysis. Alesina et al. (2023) also test the effect on support for redistribution of showing videos on immigrant characteristics. We computationally reproduced the treatment effects on support for redistribution.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/40.htm
- Link to Replicators Package: https://osf.io/ajm9g/
- Original Authors Response: “Dear Institute for Replication team, Thank you very much for taking the time to replicate our paper. We appreciate the important work you do. We are happy to see that our results replicated well and that our robustness checks were confirmed. With best wishes, Armando Miano and Stefanie Stantcheva”
- Original Authors Package: https://zenodo.org/records/5997521

### B.1.42
- 原论文标题：Indecent Disclosures: Anticorruption Reforms and Political Selection
- doi: https://doi.org/10.1111/ajps.12646, American Journal of Political Science
- 内容摘要：This short report summarises a replication exercise performed on data from Szakonyi (2021). The original work applies a difference-in-differences design to the case of an anti-corruption reform implemented in Russia for local election candidates, mandating financial disclosures. The author applies this design by comparing the electoral outcomes of municipalities that happened to hold elections right after the reform with those that held elections right before the reform. For both groups, the design uses information from the previous electoral cycle as a pre-treatment benchmark. Using only data provided by the author in the original dataset, I first verified that results are reproducible when using alternative software. Second, I performed two simple placebo tests to obtain evidence on violations of the design’s identifying assumptions. These placebo tests return null results, reassuring on the reproducibility of the original findings.
- Link to Full Report: https://osf.io/gx4d6/
- Link to Replicators Package: https://osf.io/gx4d6/
- Original Authors Response: “Many thanks to the replicator for taking the time to replicate and extend the paper. The placebo tests are very helpful in illuminating whether the identifying as- sumptions hold. I will make sure to run versions of these in future analyses.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/KDUMRM

### B.1.43
- 原论文标题：Inflammatory Political Campaigns and Racial Bias in Policing
- doi: https://doi.org/10.1093/qje/qjac037, Quarterly Journal of Economics
- 内容摘要：Grosjean et al. (2023) (GMY2023) estimate the causal effect of a Trump rally on the number of black drivers stopped by police officers, using a difference-in-difference approach. In their preferred specification, the authors find that after a Trump rally, the probability that a stopped driver is black increases by 5.74%. This effect is significant at the 1% level. In this report we focus on reproducing the main claim of the paper. First, we reproduce the paper’s main findings and uncover an issue with counties that experience multiple Trump rally treatments, given the original modelling choices taken in GMY2023. When we remove counties that experience multiple rallies, the estimated effect size drops to 2.46% and loses statistical significance. Second, we attempt to conduct a direct replicability check, by employing a new data set as a source for the dependent variable. We use data from the National Incident Based Reporting System (NIBRS). We observe no effect of Trump rallies both on the original data, covered by NIBRS and on the NIBRS data. Third, we conduct a robustness replicability exercise by coding an event-study difference-in-difference design at the day level. We estimate the event-study in a [7; +7] window. We do not discover any systematic effect of Trump rallies on the dependent variable from GMY2023.
- Link to Full Report: https://osf.io/xadb6/
- Link to Replicators Package: https://osf.io/c7j58/
- Original Authors Response: Provided comments, but declined to respond.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/A3B9HE

### B.1.44
- 原论文标题：Interaction, Stereotypes, and Performance: Evidence from South Africa
- doi: https://doi.org/10.1257/aer.20181805, American Economic Review
- 内容摘要：Corno, La Ferrara and Burns (2022) exploit the random allocation of freshman roommates in a large South African university to gauge the impact of a roommate’s race on racial attitudes as measured by an implicit association test, and on school performance. They notably find that (a) white students randomly assigned to black roommates have less negative racial stereo- types, and (b) black students randomly assigned to live with white students have higher GPAs. We first reproduce all regression tables in Corno et al. (Corno et al. (2022)), and then test for robustness by varying the controls and conducting influential analysis. Overall, we find the results for finding (a) and (b) and robust in 15% and 40% of the robustness checks we ran, and the t/z scores are on average 78% and 85% as large as the original study.
- Link to Full Report: To be made available soon. Ongoing back and forth with the authors.
- Link to Replicators Package: https://osf.io/kr9nx/
- Link to Original Authors Response: Ongoing back and forth with the replicators.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/174501/version/V 1/view

### B.1.45
- 原论文标题：Interventions and Cognitive Spillovers
- doi: https://doi.org/10.1093/restud/rdab087, Review of Economic Studies
- 内容摘要：In the paper of, Altmann et al. (2022) the authors investigate whether posi- tive effects which are due to behavioral policy interventions in policytargeted domains come along with negative effects in policy non-targeted domains. Using lab and online experiments where subjects have to solve one policy-focused decision task and one non-focused background task, the authors show that increasing incentives or steering attention to the former led to higher attention spans, lower default adherence rates, and a higher choice quality in the decision task. However, because of steering participants focus to the decision task, lower choice quality and lower atten- tion spans in the background task emerged as a consequence, which was particularly pronounced among individuals with lower cognitive capabilities and complex decision tasks. Essentially, the authors also describe that the negative effects in the background tasks offset the positive effects in the decision task, ultimately yielding a net-zero effect overall. Therefore, the authors emphasize policymakers to also consider the potential negative cognitive spillovers in order to not overesti- mate the benefits of behavioral policy interventions. All the results the authors in the main text report are significant on 5% and 1% significance levels. All findings presented in the main text of the paper can be replicated using the original Stata code and verified thoroughly using R. Addi- tionally, we performed two robustness tests to ensure the reliability of the paper’s main results, and they remained consistent. Hence, the reported findings in the paper appear to be robust.
- Link to Full Report: https://www.econstor.eu/bitstream/10419/272845/1/I4R-DP043.pdf
- Link to Replicators Package: https://osf.io/kugbs/
- Original Authors Response: “We do not have any comments regarding the replication. We just want to briefly express our gratitude for the thorough and excellent work of the authors of the replication study.”
- Original Authors Package: https://zenodo.org/records/5652808

### B.1.46
- 原论文标题：Jumping the Gun: How Dictators Got Ahead of Their Subjects
- doi: https://doi.org/10.1093/ej/ueac073, Economic Journal
- 内容摘要：Hariri and Wingender add new nuance to the traditional wisdom that economic modernisation is a path to democracy. They show that the diffusion of repressive, military tech- nologies, causes a decline in the number of democratisations in the following years, and argue that this is because of a greater ability to forcefully oppress popular dissent. We conduct a robust- ness replication exercise, focussed on three tests: i) Are findings robust to alternative weightings of individual technologies in the instrument for country-aggregate military technology? ii) Is high leverage in individual countries, regions or time periods driving the global findings? iii) Are the strength of the IV and its independence of important macroeconomic indicators a chance occur- rence? The main findings of the paper are largely robust to these tests.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/50.htm
- Link to Replicators Package: https://osf.io/4cx86/
- Original Authors Response: “we do not have any comments to the replication report, so I’m just sending you this email to applaud the initiative. You and the Institute for Replication is doing a great service to the profession.”
- Original Authors Package: https://zenodo.org/records/7077694

### B.1.47
- 原论文标题：Liquidity Constraints in the U.S. Housing Market
- doi: https://doi.org/10.1093/restud/rdab063, Review of Economic Studies
- 内容摘要：Successful computational reproducibility. No re-analyses conducted.
- Link to Original Authors Response: Authors provided feedback and suggestions.
- Original Authors Package: http://doi.org/10.5281/zenodo.5112964

### B.1.48
- 原论文标题：Local Elites as State Capacity: How City Chiefs Use Local Information to Increase Tax Compliance in the Democratic Republic of the Congo
- doi: https://doi.org/10.1257/aer.20201159, American Economic Review
- 内容摘要：Bal´an et al. (2022) evaluate the impact of “local elites” involvement in local tax collection in a large city in the Democratic Republic of Congo. Using a randomized controlled trial to vary the identities of tax collectors, they find that local elites’ involvement raises tax compliance and total revenue by 50 and 44 percent, respectively. The paper argues that the primary mechanism behind the results is better targeting made possible by local elites’ superior information about property holders’ willingness and ability to pay. In this replication comment, we first reproduce the paper’s main results. Then, we assess the robustness of the results by (1) employing randomization inference for statistical tests; (2) controlling for baseline characteristics that are not balanced; and (3) using an alternative method to examine the claims supporting the preferred mechanism of better targeting. We find robust estimates in (1). However, the results are less robust both in terms of statistical significance and magnitude for (2) and (3). We conclude that the average treatment effect is robust, while the main claim about mechanisms, the information channel, is less robust to alternative estimation approaches. We contextualize and discuss the significance of these results, including the negligible revenue potential even under full compliance.
- Link to Full Report: Final report to be made available shortly. Ongoing back and forth between authors and replicators.
- Link to Replicators Package: https://github.com/SossouAdjisse/LocalTaxReplicationProject.git
- Link to Original Authors Response: Ongoing back and forth between authors and replicators.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/147561/version/V 1/view

### B.1.49
- 原论文标题：Major Reforms in Electricity Pricing: Evidence from a Quasi-Experiment
- doi: https://doi.org/10.1093/ej/ueab076, Economic Journal
- 内容摘要：Labandeira et al. (2022) examine the effect of a policy in Spain that modified the electricity bill structure for all Spanish households. The policy simultaneously increased fixed costs and decreased marginal costs on household electricity bills. Using fixed effects and instru- mental variables (IV) specifications, the main causal finding in the paper is that the reform reduced house- hold electricity consumption for Spanish households by 15%. Their point estimate is statis- tically significant at the 1% level. In a similar specification, they find the reform reduced household expenditures on electricity by 9.8%, statistically significant at the 1% level. The code provided by the authors is computationally reproducible. We found two coding errors in different IV specifica- tions, which had served as robustness checks to their main results. Correcting the errors removes statistical significance in two of four IV results, but increases the point estimates and statistical significance in the other two IV results. We also perform robustness checks. The IV estimates lose statistical significance in two of four robustness checks (with point estimates changing 1.1% to -39%). However, the OLS regressions are robust to changing covariates (sign and significance remained for 12 of 14 tests of the OLS specification, with changes in the estimates ranging from -157% to 64%, but averaging -3.3%).
- Link to Full Report: https://osf.io/bysa7/
- Link to Replicators Package: https://osf.io/bysa7/
- Original Authors Response: Original authors provided feedback. Multiple rounds of back and forth with replicators.
- Original Authors Package: https://zenodo.org/records/5423782

### B.1.50
- 原论文标题：Market Access and Quality Upgrading: Evidence from Four Field Experi- ments
- doi: https://doi.org/10.1257/aer.20210122, American Economic Review
- 内容摘要：Bold et al. (2022b) investigate the effect of providing access to a market (i.e. a buyer) which rewards quality with a premium on farm productivity and farming incomes from smallholder maize farmers in western Uganda, using a series of randomized experiments and a difference-in-differences approach. We successfully reproduce the results of this study using the publicly provided replication packet. Then test the robustness of these results by re-defining treatment and outcome variables, testing for model misspecification and the leverage of outliers, and testing for non-random selection in the Fisher-permutation process. Our results show that the findings in Bold et al. (2022b) are robust to a variety of decisions in the research process. This evokes confidence in the internal validity of the findings.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/72.htm
- Link to Replicators Package: https://journaldata.zbw.eu/dataset/bold-et-al-american-economi c-review-2022
- Original Authors Response: “Thank you very much for sharing the report (and taking the time to replicate the study). We have no comments.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/158401/version/V 1/view

### B.1.51
- 原论文标题：Market-Based Monetary Policy Uncertainty
- doi: https://doi.org/10.1093/ej/ueab086, Economic Journal
- 内容摘要：Bauer et al. (2022) derive market-based monetary policy uncertainty and un- cover an ’FOMC uncertainty cycle’ characterized by a fall of uncertainty after FOMC announce- ments and its subsequent built-up. Then, the authors show that the financial markets’ response to monetary policy announcements depends on the level of short-rate uncertainty on the day before the FOMC announcement. First, we reproduced the paper’s findings, though with Matlab version- specific issues. Second, we tested the robustness of the two main results of the paper. We show that the uncertainty cycle in the monetary policy uncertainty is confirmed when the crisis period is included in the sample or when the median instead of the average of changes in the monetary policy uncertainty is considered. However, the FOMC uncertainty cycle does not appear when the monetary policy uncertainty index (Husted et al. 2020) or the daily economic policy uncertainty index (Baker et al. 2016) are used as uncertainty proxies.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/77.htm
- Link to Replicators Package: https://osf.io/qx8aw/
- Original Authors Response: “Thank you, glad to see that this work found our results to be rock solid! We won’t write a response. Do let us know if you have any other questions about our work.”
- Original Authors Package: https://zenodo.org/records/5566246

### B.1.52
- 原论文标题：Market-Based Monetary Policy Uncertainty
- doi: https://doi.org/10.1093/ej/ueab086, Economic Journal
- 内容摘要：This report replicates and examines Bauer et al.’s (2021) paper on monetary policy transmission to financial markets. The paper introduces novel measures of monetary pol- icy uncertainty and analyses its drivers. It also investigates the impact of uncertainty changes on interest rates and financial asset prices. We assess reproducibility, consolidate market uncer- tainty measures using PCA and Factor Analysis, and rigorously test the reduction of uncertainty after Federal Market Open Committee (FOMC) announcements. Our findings support the paper’s claim of reduced uncertainty on meeting days. Additionally, we explore the implications of the uncertainty channel on various financial assets, such as Gold, the Swiss Franc, European stock indexes, and Bitcoin.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/76.htm
- Link to Replicators Package: https://github.com/YaolangZhong/Nottingham Replication G ame/tree/main/replication code
- Original Authors Response: “Thank you, glad to see that this work found our results to be rock solid! We won’t write a response. Do let us know if you have any other questions about our work.”
- Original Authors Package: https://zenodo.org/records/5566246

### B.1.53
- 原论文标题：Measuring the Welfare Effects of Shame and Pride
- doi: https://doi.org/10.1257/aer.20190433, American Economic Review
- 内容摘要：This replication report examines and extends the research conducted by Butera, Metcalfe, Morrison, and Taubinsky (2022) on ”The Welfare Effects of Pride and Shame.” The orig- inal paper explores the welfare implications of public recognition as a motivator for desirable be- havior and introduces an empirical methodology to measure Public Recognition Utility (PRU), which quantifies the utility individuals experience when their actions are publicly recognized. This report focuses on the real effort experiment reported in the paper that was conducted using a class- room sample, a lab sample, and an online sample. I computationally reproduce the original results and verify their robustness. While reproducing the results, I found two minor coding errors in the replication package. Correcting these errors slightly changes some estimates reported in the paper but does not turn over any results. The main treatment effect findings are further robust to using different sets of controls and sample selection criteria. Moreover, I conduct a heterogeneity analysis which reveals significant variations in how participants value public recognition. Overall, the replication study confirms the original conclusions while providing additional insights into the heterogeneity of PRU shapes on an individual level.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/64.htm
- Link to Replicators Package: https://github.com/tilmanfries/welfare-shame-pride-replication -report
- Original Authors Final Response: “Thanks again for all your hard work on this.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/145141/version/V 1/view

### B.1.54
- 原论文标题：Mental Health Costs of Lockdowns: Evidence from Age-Specific Curfews in Turkey
- doi: https://doi.org/10.1257/app.20200811, American Economic Journal: Applied Economics
- 内容摘要：This report presents a replication of Altindag et al. (2022) performed at the Olso Replication Games in 2022. Altindag et al. (2022) estimate the effects of an age-specific lock- down on mental health outcomes and mobility among adults aged 65 and older in Turkey, using a regression discontinuity design. The authors find a decline in mobility with a one-day decrease in the number of days being outside and an increase in the probability of never going out by 30 percentage points. These point estimates are statistically significant at the 1% level. The mobility restrictions lead to a worsening in mental health outcomes of approximately 0.2 standard devi- ations, statistically significant at the 10% level in their preferred specification. In this paper we accomplish two things. First, we successfully reproduce Altindag et al.’s main findings. Second, we test the ro-bustness of the results to a small number of changes to their preferred estimations by (1) not clustering the standard errors on the running variable, (2) not including control variables, and (3) calculating the optimal bandwidth using another technique. Point estimates for mobility outcomes are stable to all three manipulations, and standard errors only change marginally. Point estimates and standard errors for the mental health outcomes are somewhat more sensitive, es- pecially to changing the optimal bandwidth selection method. However, the observed changes are reason-ably expected when applying data-driven model selection methods to noisy data (to avoid over-fitting, it is likely preferable to apply a less data-driven approach like the original au- thors did). Our general impression is that the original analyses and results are both theoretically plausible and credible, despite some defensible model dependencies.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/16.htm
- Link to Replicators Package: https://osf.io/25u7b/
- Link to Original Authors Response: https://econpapers.repec.org/paper/zbwi4rdps/17.htm
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/131981/version/V 1/view

### B.1.55
- 原论文标题：Mortality, Temperature, and Public Health Provision: Evidence from Mexico
- doi: https://doi.org/10.1257/pol.20180594, American Economic Journal: Economic Policy
- 内容摘要：Cohen and Dechezlepr ˆetre (2022) investigate the heterogeneous impact of tem- perature on mortality across Mexico, and how affordable healthcare services that target the low- income population attenuate the mortality effects of weather events. They find that while extreme temperatures are more dangerous than less extreme temperatures, the increased frequency of non- extreme temperatures mean these temperatures cause more deaths. First, we reproduce the paper’s main findings, uncovering a minor coding error that has a trivial effect on the main results. Sec- ond, we test the robustness of the results to clustering at the state level, omitting precipitation, and using a different weighting scheme. The original results are robust to all of these changes.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/90.htm
- Link to Replicators Package: https://osf.io/q52e4/ Original Authors’ Response : Cohen: “We thank The Institute for Replication. Next time, I will make sure I do not forget Feb. 29th in the code!”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/125201/version/V 1/view

### B.1.56
- 原论文标题：Motivated Beliefs and Anticipation of Uncertainty Resolution
- doi: https://doi.org/10.1257/aeri.20200829, American Economic Review: Insights
- 内容摘要：Drobner (2022) examines the effect of manipulating experimental subjects’ ex- pectations about uncertainty resolution in learning about their performance on their belief updat- ing patterns in an ego-relevant domain. In their preferred empirical specification, the author finds that individuals update their beliefs optimistically as they exhibit a higher belief adjustment in response to good compared to bad news only when they do not expect resolution of underlying uncertainty about their performance in an IQ test and neutrally when they know they will find out their relative performance at the end of the experiment. First, we reproduce the all of the paper’s findings without identifying any coding errors. Second, we test the robustness of the results to (1) adding individual covariates and (2) excluding subjects who exhibit a fundamental error in their belief updating from the analysis. We find no substantial changes in the main coefficients of interest with the inclusion of demographic variables in the analysis, consistent with demonstrated balance in covariates between the two experimental groups. Yet, several of the main estimates lose statisti- cal significance and change from conservatism (under-updating) to over-inference (over-updating) in some conditions on the subset of participants excluding those who exhibit fundamental errors in belief updating.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/65.htm
- Link to Replicators Package: https://osf.io/evt3a/
- Original Authors Response: “Thanks for sharing the report. I think it’s a great initiative and feel free to publish this report on your webpage. I will not be able to provide an “answer”.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/139262/version/V 1/view

### B.1.57
- 原论文标题：Multinationals’ Sales and Profit Shifting in Tax Havens
- doi: https://doi.org/10.1257/pol.20200203, American Economic Journal: Economic Policy
- 内容摘要：We perform a robustness replication analysis of Laffitte and Toubal (2022), which considers how multinational corporations shift profit to ”tax havens”, jurisdictions where they face lower tax burdens. We find that the main results of Laffitte and Toubal (2022), are fairly ro- bust to alternative versions of three important researcher choices: i) the definition of tax havens; ii) the use of a continuous measure of tax-friendliness rather than a binary classification of tax havens; and iii) a sample that omits two small but ”extreme” tax havens: Bermuda and Barbados. In all cases, results remain of the same sign and retain statistical significance, though the magnitudes are somewhat attenuated in our robustness exercises.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/37.htm
- Link to Replicators Package: https://osf.io/3sbmr/
- Original Authors Response: “Thanks for your email and for replicating our exercise. Your work is useful. We recognize that the results remain consistent even when considering different inter- pretations of the haven concept and a smaller sample of observations. We are also pleased to hear that the replication file we shared with the AEJ: Policy has proven helpful.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/148301/version/V 1/view

### B.1.58
- 原论文标题：Multiracial identity and political preferences
- doi: https://doi.org/10.1086/714760, Journal of Politics
- 内容摘要：The growing concern regarding reproducibility and replicability of social sci- ence re- sults has powered the adoption of open data and code requirements at journals and norms among researchers. However, even when these norms and requirements are fol- lowed, changes to the software used in data cleaning and analysis can render papers non-reproducible. This paper details the challenges of reproducibility in the face of software updates. We present a case study of a published article whose results are no longer reproducible due to changes in the software used. We then discuss the tools and techniques researchers can use to ensure that their research remains reproducible despite changes in the software used.
- Link to Full Report: https://osf.io/ecymu/
- Link to Replicators Package: https://github.com/taylorjwright/r and p versioning
- Original Authors Response: Ongoing back and forth with the authors.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/BLVJJH

### B.1.59
- 原论文标题：News Shocks Under Financial Frictions
- doi: https://doi.org/10.1257/mac.20170066, American Economic Journal: Macroeconomics
- 内容摘要：G ¨ortz et al. (2022) estimate the effects of innovations to future total factor productivity (TFP) on financial markets. In a Bayesian vector autoregression, they identify a TFP news shock as one that explains the largest share of 40- quarter ahead forecast error variance (FEV) of TFP . Their estimated impulse responses functions show that a positive news shock significantly decreases credit market spreads and increases credit market supply. They also find that a shock that explains the maximum of the FEV of the ”excess bond premium” (EBP) (Gilchrist and Zakrajsek 2012) causes similar responses. These results are consistent with an estimated DSGE model with financial frictions. We estimate the main IRFs of the study using the original data and a frequentist estimation approach. We obtain similar point estimates for the dynamic responses to TFP news and EBP max-share shocks. We also update their macroeconomic and financial time series, as some of the data has been revised substantially since their original estimate. We use the updated data to re-estimate the above-mentioned IRFs, and we find that the results are robust to this change in the data. Finally, we investigate the computational reproducibility of their DSGE results, and find that their provided code (consistent with warnings in their README file) does not execute in the most recent version of Dynare or Matlab. Using the version indicated in their replication files, we encounter issues estimating the posterior mode.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/51.htm
- Link to Replicators Package: https://github.com/gionikola/replication-game-ucsd
- Original Authors Final Response: “Thank you for the update and considering our work for repli- cation.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/130141/version/V 1/view

### B.1.60
- 原论文标题：Non-Linearities, State-Dependent Prices and the Transmission Mechanism of Monetary Policy
- doi: https://doi.org/10.1093/ej/ueab049, Economic Journal
- 内容摘要：Ascari and Haber (2022) fill the gaps in the literature by showing evidence in favor of the state-dependent sticky price model’s predictions using the macro-aggregates. We re- port a replication and robustness check of the study. We employ several additional macroeconomic control variables and different alternative measurements for monetary policy shocks and find that the original results remain qualitatively robust. Our analysis further shows that the turbulent pe- riods of inflation in the 1970s and 1980s have an important role in claiming the robustness of the original results.
- Link to Full Report: https://osf.io/kbwap/
- Link to Replicators Package: https://osf.io/kbwap/
- Original Authors Response: No response.
- Original Authors Package: https://oup.silverchair-cdn.com/oup/backfile/Content public/Jo urnal/ej/132/641/10.1093 ej ueab049/1/ueab049 replication package.zip?Expires=170492207 6&Signature=LWVbDI23c3c8fbYXPnP1BoN9pWtEiXHPj5BnotI-VjHHz7LhS23a ∼cm37gqC ∼5XT f∼PntqGRlMOySoOD5Y9MH-cq8ScUPMoEhbPoQGqmbeZpbPmto6siB3LZRg3sEYqHO196h2A wonsc0vctdkzGqH3JHt∼luPUe1mS6z2oHqMirnzzcN∼578kQ8lT2kv7-lNVsqB6xwPocgbZq4WJpS 07-Q4fp-r3IDXGsvZlGQRYxEJZ65yqEf ∼teKjFjFhNxeYI8w ∼∼WuJOKQzSMUs82yAmFPA9lVzEL ymhr37M9lREz9-OycBI ∼4sPQ8MA0b4jQ9oPk ∼M4qBGRqcFIyc1tVy6g &Key-Pair-Id=APKAIE 5G5CRDK6RD3PGA

### B.1.61
- 原论文标题：Not All Elections Are Created Equal: Election Quality and Civil Conflict
- doi: https://doi.org/10.1086/714778, Journal of Politics
- 内容摘要：Utilizing a time-series cross-sectional dataset on developing countries, Donno et al. (2022) examine how variation in election quality shapes opportunities and incentives for civil conflict. Across a number of models in their analysis, they find that civil conflict is more likely when elections are not free and fair. They also find that for countries with low integrity elections, the probability of conflict occurring is higher if it has experienced conflict before. We begin by reproducing Donno et al.’s (2022) main models and findings, which yielded no coding errors or differences in effect estimates. Afterwards, for replication purposes we run a series of robustness and conceptual replication tests. For our first replication, we examine the heterogeneous effect be- tween electoral integrity and ethnic fractionalization on conflict. Our second test examines whether a subsample of authoritarian regimes should have been included in the authors’ original analysis.
- Link to Full Report: https://osf.io/unhkr/
- Link to Replicators Package: https://drive.google.com/drive/folders/1Vlwfr3 Q7c56XFPsQu KUNSnEU lMFUQz?usp=sharing
- Link to Original Authors Response: https://osf.io/unhkr/
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/8B31FG

### B.1.62
- 原论文标题：Parties as Disciplinarians: Charisma and Commitment Problems in Pro- grammatic Campaigning
- doi: https://doi.org/10.1111/ajps.12638, American Journal of Political Science
- 内容摘要：Hollyer, Klaˇsnja, and Titiunik (2022) analyse the trade-off that political parties face between running programmatic campaigns and fielding charismatic candidates, whose elec- toral appeal may come at the cost of undermining the party brand. They argue that higher electoral volatility prompts parties to rely on charismatic candidates, even though they might not be as loyal to the party’s programmatic stance. They substantiate their argument with a cross-national dataset and a quantitative case study in Brazil. We computationally reproduced and conducted further ro- bustness tests for their cross-national study by translating the Stata code to R. Next, we conducted a computational reproduction and some additional robustness tests for the quantitative case study. We find that their cross-national analysis is reproducible, albeit with some minor discrepancies. The quantitative case study is also largely reproducible and both are robust in several ways. We conclude by making some suggestions about data dissemination and robustness checks for authors of regression discontinuity designs.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/54.htm
- Link to Replicators Package: https://osf.io/93gfx/?view only=7063353244d646ffaf7bfd53013e3
- Original Authors Response: “Thanks for your note and for all the work of Kelly, Odermatt, and Metson in replicating our paper. [...] Our read of the Replication Reports that the findings in our paper hold in the Kelly et al replication. [...] Our sense is that the discrepancies between the replication and original paper are sufficiently small, and the task of comparing the replication R code to the original Stata code is likely to be sufficiently demanding of time, that the opportunity cost of a thorough response is high. So, I think we’ll forgo the opportunity to draft a response, and just let the replication stand without reply. We’ll leave it to any sufficiently interested parties with expertise in both Stata and R to iron out the discrepancies between the replication and original paper.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/AWSQTW

### B.1.63
- 原论文标题：Patience, Risk-Taking, and Human Capital Investment Across Countries
- doi: https://doi.org/10.1093/ej/ueab105, Economical Journal
- 内容摘要：Hanushek et al. (2021) test how country-level measures of patience and risk- taking from the Global Preference Survey predict student performance on the Programme for In- ternational Student Assessment (PISA) math test. They find that country-level patience positively predicts math test scores and country-level risk-taking negatively predicts math test scores. They find similar results when holding country of residence characteristics constant and focusing on the preferences of the country of origin of migrants. We have checked the computational repro- ducibility and find that the data and analysis script provided by the authors allowed us to exactly reproduce the main tables in the paper. We also checked the robustness replicability by testing how robust the results are to decisions about imputation, weighting, operationalization of depen- dent variables, choice of control variables, and the inclusion of highly leveraged observations. We see that results are generally robust, though statistical significance of the risk-taking coefficient in the migrant analysis hinges on whether a control for OECD country of residence is included. Finally, we check the conceptual replicability of the results by using data from the Trends in In- ternational Mathematics and Science Study (TIMSS) instead of PISA - a different dataset with a different standardized test. This exercise shows that their results are robust to expanding the anal- ysis to countries participating in both PISA and TIMSS.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/48.htm
- Link to Replicators Package: https://osf.io/kgt8z/
- Link to Original Authors Response: “We would like to thank the replicators and compliment them for their thoughtful replication and extension of our paper. We are particularly impressed by the extension to the TIMSS data, which is actually great support for the underlying idea. We do not see a reason to formulate a formal response for your website. Thank you all for your valuable work!”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/153101/version/V 2/view

### B.1.64
- 原论文标题：Peer Effects in Academic Research: Senders and Receives
- doi: https://doi.org/10.1093/ej/ueac031, Economical Journal
- 内容摘要：In this report, we provide an overview from reproducing and replicating Bosquet et al. (2022). As a first step, we successfully reproduce all the results in the paper, as well as figure A1. All results were fully reproducible and match the published version of the pa- per. Next, we carry out three sensitivity analysis. We examine how the main results change from the weights used, additional controls, and author-university pairs. The main results are robust to these checks.
- Link to Full Report: https://osf.io/czkgw/
- Link to Replicators Package: https://osf.io/czkgw/
- Link to Original Authors Response: The authors responded to the replicators’ questions. Bosquet then responded to the final report: “I would simply thank the team of replicators and I am happy to see that the tested results are robust to the tested alternatives. As written in my previous email, I think those kinds of efforts are very useful for the community and the credibility of published results so thanks as well for that.”
- Original Authors Package: https://zenodo.org/records/6457037

### B.1.65
- 原论文标题：Playing Politics with Environmental Protection: The Political Economy of Designating Protected Areas
- doi: https://doi.org/10.1086/718978, Journal of Politics
- 内容摘要：Mangonnet et al. (2022) examine whether political alignment at the national and sub-national levels explain the spatial designation of Protected Areas (PAs) in Brazil. Their iden- tification relies on spatial discontinuities in political alignment across municipalities. They find that a president-mayor coalition alignment reduces the incidence of PAs by about one percentage point, whereas they find no party alignment effects. We were able to reproduce the paper’s find- ings using the same code and software. Alternative software routines reproduce their results with small and inconsequential numerical differences. Moreover, robustness replications find consistent results for one out the two treatments. Finally, we find no evidence of fabrication of data.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/73.htm
- Link to Replicators Package: https://osf.io/t76jd/
- Original Authors Response: “We are grateful to Laura Villalobos, Jill Caviglia-Harris, Tharaka Jayalath, and the team at the Institute for Replication for generously replicating our work. We encourage readers to follow their alternative software routines for faster estimations.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/N6LIMH

### B.1.66
- 原论文标题：Policy Deliberation and Voter Persuasion: Experimental Evidence from an Election in the Philippines
- doi: https://doi.org/10.1111/ajps.12566, American Journal of Political Science
- 内容摘要：I would characterize my robustness replication as almost entirely successful. The design checks I report all support a straightforward understanding of the design. My effect and uncertainty estimates barely differ from the original estimates (when compared with like es- timation procedures), with any discrepancies attributable to simulation error. One small area of difference was the weighting scheme employed by the authors to correct for “over-representation” of meeting attendees in the treatment group. As discussed below, I do not understand the design reason for this choice and when I simulate its properties, I can obtain small amounts of bias. The net consequence of their approach was usually to make coefficient estimates smaller, so we don’t have a major difference in conclusion except perhaps in a secondary analysis of mechanisms.
- Link to Full Report: https://osf.io/y8ubt/
- Link to Replicators Package: https://osf.io/y8ubt/
- Link to Original Authors Response: https://osf.io/y8ubt/
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/S3HACJ

### B.1.67
- 原论文标题：Political Turnover, Bureaucratic Turnover, and the Quality of Public Services
- doi: https://doi.org/10.1257/aer.20171867, American Economic Review
- 内容摘要：The politically motivated replacement in local governments is a pervasive fact in our modern democracies. Whether it has causal effects on the quality of public services, such as education, is a critical question and yet understudied. This paper uses a regression discontinuity design (RDD) for close elections to replicate Akthari, Moreira and Trucco (2022) who find negative effects on the quality of public education in Brazil (.05-.08 standard deviations of lower test scores). I first reproduce these main results, finding minor computational differences that have no effect on the conclusions. I also show that the estimates for Brazil are in general robust to different specifications following Brodeur, Cook and Heyes (2020). Finally, I implement the same RDD framework now applied to Chilean administrative records to find null effects on test scores. Taken together, these results suggest that political turnover has weakly negative effects on service quality.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/39.htm
- Link to Replicators Package: https://osf.io/q43vz/
- Link to Original Authors Response: https://osf.io/kv4pj/
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/150323/version/V 1/view

### B.1.68
- 原论文标题：Pre-Colonial Warfare and Long-Run Development in India
- doi: https://doi.org/10.1093/ej/ueab089, Economic Journal
- 内容摘要：We test the reproducibility and replicability of Dincecco et al. (2022), which reports a positive relationship between pre-colonial interstate warfare and long-run development patterns across India. Overall, we confirm that all of the study’s estimates are computationally reproducible by using both the provided replication package in Stata and code written by the present authors in R. We test for and find no evidence of data manipulation in the final datasets. Concerning direct replicability, we consider different ways of measuring distance to conflicts and also alternative proxies for both the dependent variable and variables which capture channels by which the main effects operate. We are able to replicate the magnitude and significance of the estimated coefficient on conflict exposure in most of the tests, noting that while most estimates are substantively in line with the original study, some alternative measures of distance to conflict imply different magnitudes for estimates, and proxy estimates are sensitive to both the time period and type of conflict considered.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/35.htm
- Link to Replicators Package: https://osf.io/af6m2/
- Link to Original Authors Response: https://osf.io/af6m2/
- Original Authors Package: https://zenodo.org/records/5583263

### B.1.69
- 原论文标题：Public Infrastructure and Economic Development: Evidence from Postal Systems
- doi: https://doi.org/10.1111/ajps.12594, American Journal of Political Science
- 内容摘要：Rogowski et al. (2022) use secondary data to study the impact of historic postal infrastructure on economic development, both cross-country and within the US. Their results sug- gest a large positive effect of post offices on economic development that is robust across various sensitivity checks. We successfully computationally reproduce all results. In a robustness assess- ment, we find the results to be robust to simple changes in the analysis but observe some sensitivity to accounting for spatial trends in the cross-country analysis. Additionally, we correct a coding in- consistency, showing that in the corrected version, one main robustness check for the US-analysis is no longer supporting the result. Despite this, we find the results to be overall robust given the numerous analyses and robustness checks in the original paper.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/92.htm
- Link to Replicators Package: https://osf.io/j3ydr/?view only=ad14a07cb3a741ca9bbfab391ad7 c6fe
- Original Authors Response: “Thanks so much for reproducing the findings in our paper and exploring extensions of our results. We also appreciate your sharing the report with us. [...] I [Rogowski] confirm that we are comfortable letting your report stand and that we will not write a response to it. ”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/33K3EF

### B.1.70
- 原论文标题：Re-Assessing Elite-Public Gaps in Political Behavior
- doi: https://doi.org/10.1111/ajps.12583, American Journal of Political Science
- 内容摘要：Kertzer (2022) conducts a meta-analysis of parallel experiments on samples of political elites and ordinary citizens. He examines whether the average treatment effect for elites is significantly different from the average treatment effect for citizens, finding that only 19 of 162 (11.7%) difference-in-difference estimates are statistically significant after adjusting for the false discovery rate. He also finds that elites and masses hold similar foreign policy attitudes after controlling for their demographic characteristics. In this replication report, we begin by running robustness and heterogeneity tests for the first claim. We find that the results survive many robust- ness tests. We also find, however, that only a small number of the these treatments significantly affected masses (N=28) or elites (N=30). This low rate suggests the possibility that almost all of these experiments failed to successfully manipulate either masses or elites. If so, we may not be able to conclude that masses and elites respond similarly to experiments with confidence until po- litical scientists produce more experiments with actual treatment effects or with successful manip- ulation checks in cases of null effects. In the second part of this replication report, we conceptually replicate the second Kertzer analysis, finding a strong correlation between elite and mass political decisions and attitudes, thus confirming Kertzer’s analysis.
- Link to Full Report: https://www.econstor.eu/bitstream/10419/266385/1/I4R-DP010.pdf
- Link to Replicators Package: https://osf.io/93urk/
- Original Authors Response: “Thank you for your email and for the invitation. [...] please send my appreciation to the authors for their interest in the manuscript; I find their analysis very inter- esting.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/LHOTOK

### B.1.71
- 原论文标题：Rebel on the Canal: Disrupted Trade Access and Social Conflict in China, 1650–1911
- doi: https://doi.org/10.1257/aer.20201283, American Economic Review
- 内容摘要：Cao and Chen (2022a) study the role of disruption of trade on social conflict in China in the 19th century. Identification builds on the closure of China’s Grand Canal in 1826 in a difference-in-differences framework. In their preferred analytical specification, the authors find that counties along the canal experienced a 117 percent increase in rebelliousness after the initial closure of the canal in 1826 relative to their non-canal counterparts. First, we reproduce the paper’s main findings using the official replication package. Second, we examine whether a sub-sample of counties/prefectures/provinces drives the result. Third, we test the robustness of the results to alternative treatment periods.
- Link to Full Report: https://osf.io/dhn6e/
- Link to Replicators Package: https://osf.io/dhn6e/
- Link to Original Authors Response: https://osf.io/dhn6e/
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/157781/version/V 1/view

### B.1.72
- 原论文标题：Recessions, Mortality, and Migration Bias: Evidence from the Lancashire Cotton Famine
- doi: https://doi.org/10.1257/app.20190131, American Economic Journal: Applied Economics
- 内容摘要：Vellore Arthi, Brian Beach and W. Walker Hanlon (2022) investigate the effect of the Lancashire Cotton Famine on mortality, accounting for the migration response to the down- turn. They use difference-in-differences to estimate the effect of the cotton famine on mortality. To account for the migration response to the cotton famine, they construct a linked dataset giving mortality rates by district of residence during the cotton famine, rather than by district of residence at the time of death. They find that the cotton famine increased mortality in cotton-textile produc- ing districts, and that accounting for migration matters, in the sense that their estimates would have been markedly different had they not accounted for it. I check that ABH results are fully reproducible using their data and code, and that their claims are robust to (1) decreasing the age window for building the linked dataset, (2) modifying the specification and (3) computing differ- ent standard errors. The only significant discrepancy in results is that I find stronger effects of the cotton famine when I decrease the age window for building the linked dataset, likely because this reduces measurement errors.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/25.htm
- Link to Replicators Package: https://www.openicpsr.org/openicpsr/project/192272/version /V1/view
- Original Authors Response: “Thanks for the interest in our work. We’ve had a chance to review the report and it looks like everything replicated. Since there are no outstanding queries, we are happy to sign off on this.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/128521/version/V 1/view

### B.1.73
- 原论文标题：Reshaping Adolescents’ Gender Attitudes: Evidence from a School-Based Experiment in India
- doi: https://doi.org/10.1257/aer.20201112, American Economic Review
- 内容摘要：Dhar et al. (2022) examine the effect of a gender attitude change program in secondary schools in India. In their preferred specification, the authors show that the program made the students report more gender-egalitarian attitudes by 0.18 of a standard deviation, and shifted self-reported behaviors to be more aligned with gender-progressive norms by 0.20 standard deviations (both significant at 1% level). In contrast, they found no effect on girls’ aspirations, as these were already high before the intervention. The effects did not attenuate between the first end- line (right after the programme was completed) and the second (two years later). To put the pa- per’s results in perspective, we first comment on the authors’ deviations from their pre-registration and pre-analysis plans, provide detailed power calculations, and add multiple-hypothesis-testing- adjusted standard errors. Second, we show that the paper’s results are perfectly reproducible. Third, we show that the results are robust to excluding control variables, and alternative ways of constructing indices and dealing with non-response.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/24.htm
- Link to Replicators Package: https://osf.io/r5jfe/ Final Original Authors’ Response: “Thanks. the revision looks good. I actually don’t think we need to have a formal response any more. [...] Thus, I don’t think there is anything substantive for us to include in a discussion paper/response. That reflects the fact that the Replication Reports fair and there is nothing major to respond to, so it’s good news, from both the perspective of the integrity of our original paper and the professionalism of the replication.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/149882/version/V 1/view

### B.1.74
- 原论文标题：Run-off Elections in the Laboratory
- doi: https://doi.org/10.1093/ej/ueab051, Economic Journal
- 内容摘要：Bouton et al. (2022) make a causal claim by manipulating the voting system un- der which participants vote (runoff or plurality) and examining whether this manipulation affects the proportion of strategic voting. They estimate the effect of the voting system on the proportion of strategic voting for the participant population, using random effect regression where standard er- rors are clustered on group level. Regarding replication results, we reproduced the original study’s main findings. Our analysis confirms that there are minor and mostly non-significant disparities in electoral outcomes and voters’ welfare between the two voting systems, consistent with the original study’s conclusions. Specifically, we conducted tests to assess the study’s computational reproducibility and direct replicability. While the authors provided the raw data, they did not in- clude a script for cleaning it or a codebook describing its contents. Consequently, we developed a data cleaning script to ensure accurate and consistent data processing.
- Link to Full Report: https://osf.io/a8cev/
- Link to Replicators Package: https://github.com/carinahausladen/runoff-elections
- Original Authors Response: The authors provided feedback which was taken into account.
- Original Authors Package: https://oup.silverchair-cdn.com/oup/backfile/Content public/Jo urnal/ej/132/641/10.1093 ej ueab051/1/ueab051 replication files.zip?Expires=1704993942&Si gnature=4IGTUYh-IfKsIvWJDcNRrfEdvehlL ∼h9QzAwuLIHhIm1K8lXbGdONIWK2OK77Fxq ∼G dQAlilJyP0-BlPHa0iBNn-Mv7acHnbCOBcH3XokNsUXz4oXnKRijyFul7nlqKnWjs3OcBjkqAKY Kz9∼F0NIfLXKnO0lqO9RuizzRE4vpwyfk2Bu ∼pOqGPi8O∼Zd8qWBH1mBF5GxRQxUHYQxV1l TpiXfwY14LoNkOBEu-k3mhtEyfxThmUXObJpnpGJuwGJiqQUa4a91FjTE2CFjbfiBuiK-jWfdFMv DG40nBdBUj0glLuyHmx7rzmuiWJEHY7kz89ut6z8rv ∼jV3zNiQngdQ &Key-Pair-Id=APKAIE 5G5CRDK6RD3PGA

### B.1.75
- 原论文标题：School Spending and Student Outcomes: Evidence from Revenue Limit Elections in Wisconsin
- doi: https://doi.org/10.1257/pol.20200226, American Economic Journal: Economic Policy
- 内容摘要：Baron (2022) explores the independent effects of operational expenditure and capital expenditure on student outcomes in school districts across Wisconsin from the outcomes of close referendum approvals. By utilizing a dynamic regression discontinuity framework and cubic specification, the author finds that narrowly passing an operational referendum, increases opera- tional expenditure per pupil by $298 each year on average, following the referendum over a ten year period. From this $198 are spent on instructional expenses. These point estimates are statisti- cally significant at the 10% and 5% level, respectively. We first reproduce the main results from the paper without any issues arising. Secondly, we conduct a robustness replicability to (1) dropping school districts from the top and bottom 5% of the revenue limits distribution, categorically, and (2) dividing the time frame of the study into two periods: 1996-2005 and 2005-2014. We find that dropping the top 5% of the school districts by revenue limits reduces the additional operational expenditure by $140 per pupil (lower by 50 percent) and the effects of passing an operational ref- erendum were nearly double in the former period compared to the latter period. Lastly, we find that the estimated effects on student outcomes rely heavily on recent observations.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/88.htm
- Link to Replicators Package: https://osf.io/m2w4x/
- Original Authors Response: “Thank you for sharing the replication report. Please pass on my thanks to the replicators for their important work. First and foremost, I’m glad to see that the results in the paper are reproducible without any issues arising. The report explores two additional sources of heterogeneity. I have no additional comments on these. I do briefly want to clarify the last sentence in the report’s abstract, which reads “Lastly, we find that the estimated effects on student outcomes rely heavily on recent observations.” While I am not entirely sure what the replicators are referring to, my guess is that they refer to Table 2 in the report. In this table, they discuss that they are unable to study heterogeneity in the impacts of passing a referendum on test scores and postsecondary enrollment from 1996-2005, because data on these outcomes are unavailable prior to 2005. The availability of each dataset was discussed in the published version of the paper (see, for example, Table 1). Perhaps a more accurate statement would be to explain that the replicators couldn’t explore the impact of passing a referendum on these specific outcomes in the early period due to data constraints—and that this was acknowledged in the published version.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/125821/version/V 1/view

### B.1.76
- 原论文标题：Social Class and (Un)Ethical Behaviour: Causal and Correlational Evidence
- doi: https://doi.org/10.1093/ej/ueac022, Economic Journal
- 内容摘要：The relationship between social status and ethical behavior is a widely de- bated topic in research. In their study, Gsottbauer et al. (2022b) investigate whether higher socio-economic status is linked to lower ethical behavior, using data from two large survey ex- periments involving over 11,000 participants. In this replication project, we test the computational reproducibility and robustness to the replication of their study, using the provided data and code from the replication package (Gsottbauer et al., 2022a). Nearly all the figures and tables were reproducible-in the process of reproducing the results, some minor rounding or transcription er- rors were discovered. In testing the robustness replicability, we find consistent results for our extensions. The effort for the replication was manageable, even though the authors treat categor- ical variables as numeric, or use manually-coded interaction variables (i.e., in regression models). In summary, we applaud the transparency of Gsottbauer et al. (2022b) in facilitating replications, and make some general recommendations for further improvements for data-analysis studies.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/29.htm
- Link to Replicators Package: https://github.com/ha0ye/replication-gsottbauer-2022
- Original Authors Response: Declined to respond.
- Original Authors Package: https://zenodo.org/records/6226207

### B.1.77
- 原论文标题：Sorting or Steering: The Effects of Housing Discrimination on Neighborhood Choice
- doi: https://doi.org/10.1086/720140, Journal of Political Economy
- 内容摘要：This comment revisits the analysis in Christensen and Timmins (2022). We iden- tify two critical errors used in the original analysis, one with the data and the other with coding. When either error is corrected several major results in the paper change, either in statistical signif- icance or in effect size. The data error is a result of including fixed effects for the string variable ‘city’. The raw variable is case sensitive and has many spelling mistakes. The coding error involves assigning a value of zero for the variable “of color” to both individuals identified as ‘white’ and as ‘other’ in the raw data. The level of clustering in the paper is also arguably too fine. Many of the results are not robust to clustering at the city level, as opposed to the subject pair level. In total, we affirm the authors’ overarching claim of substantial and nuanced housing discrimination against racial minorities generally, and African Americans in particular; however, the effect sizes and significance are generally (although not always) smaller than the original authors findings. Additionally, there are several instances where the effects of discrimination on African Americans are no longer statistically significant but the effect of discrimination on Hispanics becomes signifi- cant.
- Link to Full Report: https://osf.io/vwgxd/
- Link to Replicators Package: https://github.com/mattdwebb/HUDreplication
- Original Authors Response: Authors mentioned that they are currently writing a response.
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/720140/s uppl file/20191181data.zip

### B.1.78
- 原论文标题：Spillover Effects of Intellectual Property Protection in the Interwar Aircraft Industry
- doi: https://doi.org/10.1093/ej/ueab091, Economic Journal
- 内容摘要：We are attempting to reproduce the results of Hanlon and Jaworski (2022) based on their dataset. Our work is conducted in two different ways: (i) computational reproducibility, aiming to produce the same results using different software, notably R, with the given data; and (ii) checking the robustness of the results. For (i), the estimated coefficients are consistent based on the R software. For (ii), we carefully examine the given datasets of Hanlon and Jaworski (2022) and review the economic history of the US Interwar aircraft industry between 1918 and 1935 to identify potential confounding variables (apart from IPP strengthening in the year 1926) that might affect both the controls and error term, and thus the results. We identify some confounding variables that may affect the results and attempt to illustrate them before and after 1926 when IPP is strengthened. Overall, we find that the results are replicable by utilizing the codes and datasets of Hanlon and Jaworski (2022), which is encouraging.
- Link to Full Report: https://osf.io/t4avf/
- Link to Replicators Package: https://osf.io/t4avf/
- Link to Original Authors Response: https://osf.io/t4avf/
- Original Authors Package: https://zenodo.org/records/5627298

### B.1.79
- 原论文标题：State Action to Prevent Violence against Women: The Effect of Women’s Police Stations on Men’s Attitudes toward Gender-Based Violence
- doi: https://doi.org/10.1086/714931, Journal of Politics
- 内容摘要：C ´ordova and Kras (2022) examine how the existence of a women’s police sta- tion (WPS) in the place of residence influences citizens’ attitudes toward gender-based violence in Brazil. In their analytical specification, the authors find that men are more likely to reject vi- olence against women (VAW) and support bystander intervention in municipalities with a WPS, especially if the WPS has been operating for a long time. This paper examines the replicability and robustness of C ´ordova & Kras’ (2022) findings. First, we reproduce the paper’s main find- ings and uncover one minor coding error and three estimates that have been reported with the opposite sign compared to that in our reproduction; neither is of consequence for the study’s main results. Second, we test the robustness of the results by (1) recoding one of the main explanatory variables and several of the control variables to account for non-linear trends, (2) using alternative techniques to estimate clustered standard errors, (3) consistently applying a 95% confidence level in the presentation of the results, (4) altering the propensity score matching (PSM) procedure as well as the composition of the variables used in the PSM robustness check, (5) using an alternative technique to test for multicollinearity, (6) excluding potential endogenous control variables, and (7) using an alternative coding for computing margins. Reassuringly, the results are robust to most of these tests. However, two of the robustness checks challenge parts of the paper’s main findings. First, allowing for non-linearity in the effect of time since the establishment of WPS shows (a) a non-linear effect on VAW and (b) no apparent changes in either male or female attitudes over time once the WPS has been established. Second, the inclusion of other variables in the PSM procedure renders part of the main estimates of interest statistically nonsignificant (p < 0.1). Our findings highlight the need for further re-analyses and replications for investigating the preventive effects of women’s police stations.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/67.htm
- Link to Replicators Package: https://osf.io/yjwr8/
- Link to Original Authors Response: Responded to our emails but no formal response as of Febru- ary 2024.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/D2WL5I

### B.1.80
- 原论文标题：Student Performance, Peer Effects, and Friend Networks: Evidence from a Randomized Peer Intervention
- doi: https://doi.org/10.1257/pol.20200563, American Economic Journal: Economic Policy
- 内容摘要：Wu et al. (2023) estimate the effect of classroom seating arrangements in China using a randomized control trial with two treatment schemes. The first treatment scheme involves seating high and low achieving students together, and the second treatment involves this same seating arrangement with financial incentives for the high-achieving students, if their deskmates’ test scores improved. All statistically significant impacts come from the incentivized treatment scheme. Wu et al. (2023) find that low-achieving students sitting next to incentivized high- achieving students perform 0.24 SD (p-value=0.018) better on math exams. In addition, being assigned to the incentive treatment scheme increased extraversion and agreeableness for low and high achieving students. Lastly, they do not find much evidence of peer effects on test scores nor personality traits. This study is computationally reproducible using their provided replication package. We ran their code using Stata 14, 17, and 18. After running their replication package, we further investigated Tables 2-5. The main conclusions are generally robust to various coding deci- sions. Notably, in investigating the peer effects, when we change the specification to also control for the difference in baseline scores between the student and their deskmate, we find that the more dissimilar deskmates are at baseline, the bigger the peer effects.
- Link to Full Report: https://osf.io/9hx3b/
- Original Authors Response: The authors provided feedback which was taken into account.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/149262/version/V 2/view

### B.1.81
- 原论文标题：Talking Shops: The Effects of Caucus Discussion on Policy Coalitions
- doi: https://doi.org/10.1111/ajps.12636, American Journal of Political Science
- 内容摘要：In Talking Shops: The Effects of Caucus Discussion on Policy Coalitions, Zelizer analyzes the causal effect of caucus deliberations on legislative policy coalitions. In practice, politi- cal scientists have little empirical evidence on how policy discussions actually work among sitting legislators and whether these discussions have an effect on policy making and policy opinion. Tak- ing on this challenge, Zelizer conducted two field experiments in an American state legislature. In short, the experiments randomized whether a bill was selected for discussion among a bi-partisan legislative caucus. The paper then measures and reports the corresponding effects of that discus- sion around the bill. Zelizer finds that deliberation increased the amount of co-sponsorship for a given bill, among both co-partisans and counter-partisans, but deliberation did not effect whether a bill was passed by the legislature or whether the bill received more amendments. We conduct a robustness replication of the main results of Talking Shops. Specifically, we reproduce Tables 3 and 4 of the paper under alternative specifications. We find that the main results of the paper are reproducible and robust to multiple alternative specifications.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/69.htm
- Link to Replicators Package: https://osf.io/tmfyj/
- Link to Original Authors Response: “One purpose of replication, among others, is to evalu- ate whether published results are sensitive to modeling decisions. Do alternative, reasonable ap- proaches generate the same, or different, results? Did the author’s approach provide an outlier estimate that is indicative of p-hacking or, to be kinder about it, sensitivity of results to modeling decisions? That seems incredibly useful. That purpose is not advanced, in my view, by testing ’incorrect’ methods or models. We do not learn about the robustness of results from testing alter- native approaches that introduce bias, or by estimating different estimands that are a combination of treatment effects and selection bias. While it doesn’t seem to matter too much in this case — selection bias appears relatively small, and in the same direction as treatment effects — I think this issue matters for the exercise in general for several reasons. First, do the analyses justify the infer- ences being made? In my view, changing the estimand or estimating biased models cannot justify saying anything about the robustness of the original results. Second, what would have happened if the new results did not match the original? Are we willing to claim published results are not ro- bust when applying estimators with known flaws generates different results? And third, shouldn’t we just generally aim to use ’correct’ estimators for a given situation? While IPW is not perfect, ignoring differential treatment probabilities is a conscious decision to ignore selection bias. Why would we want to run that model if our goal is inference about treatment effects? I appreciate the work everyone is doing on this enterprise. Hopefully these comments, whether correct or not, help advance the goal of publishing robust, valid empirical research.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/S3M5AX

### B.1.82
- 原论文标题：Targeting High Ability Entrepreneurs Using Community Information: Mechanism Design in the Field
- doi: https://doi.org/10.1257/aer.20200751, American Economic Review
- 内容摘要：Hussam et al. (2022a) use a cash grant experiment in India to demonstrate that community knowledge can help target high-growth microentrepreneurs. In their preferred spec- ification, the authors find that the average marginal return to the grant is 9.4 percent per month, while estimated returns for entrepreneurs reported by peers to be in the top third of the commu- nity are between 24 percent and 30 percent. First, we reproduce the paper’s main findings and uncover one minor coding error, which affects the estimates for one of the main tables but does not change the overall conclusions of the paper. Second, we test the robustness of the results to: (1) different treatment of outliers, (2) dropping surveyor and survey month fixed effects, and (3) using quartiles instead of terciles for grouping the ranking of entrepreneurs. The paper’s results are robust to these robustness checks. Finally, we test heterogeneity of results by gender, which was not reported in the original study.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/49.htm
- Link to Replicators Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/DI7RR9
- Link to Original Authors Response: “We are very grateful to Isabella Masetto, Diego Ubfal, and to the team at I4R for their excellent work. We verified the coding error and we agree that it did not meaningfully alter the conclusion of our paper that community information is informative over and above the predictive power of observable characteristics. We will post a link to this correction on our websites and will consult the editors of the AER as to whether this error rises to the level of requiring a formal correction.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/151841/version/V 1/view

### B.1.83
- 原论文标题：Teaching Norms: Direct Evidence of Parental Transmission
- doi: https://doi.org/10.1093/ej/ueac074, Economic Journal
- 内容摘要：This paper is a replication study of Brouwer, T., Galeotti, F., & Villeval, M. C. (2023), using the original data. The study explores how social norms are transmitted from one generation to another, specifically from parents to children. The authors conducted a field experi- ment involving 601 parents of children aged 3 to 12 in Lyon, France, to examine whether parents engage more in norm enforcement in the presence of their child, and whether the nature of punish- ment changes in the presence of the child. The study found that parents do engage more in norm enforcement in the presence of their child, and tend to use more indirect punishment when their child is present. This study highlights the role that parents play in transmitting social norms to their children. The replication analysis was successful, with the results of the original study being robust to changes in the model specification.
- Link to Full Report: https://osf.io/qnbfa/
- Link to Replicators Package: https://zenodo.org/records/8114738
- Original Authors Response: The replicators took into account the authors’ feedback. They wrote at the end of the back and forth: “We thank you and the replication team for the replication and the successive interactions. We created an OSF project including the data replication package enabling the reproduction of the analysis presented in our article. The package comprises a source file (in Stata format and in TXT) and a Stata do-file that allows the reconstruction of the master file used in the replication package submitted to the Economic Journal.”
- Original Authors Package: https://zenodo.org/records/7045559

### B.1.84
- 原论文标题：Technological Change and the Consequences of Job Loss
- doi: https://doi.org/110.1257/aer.20210182, American Economic Review
- 内容摘要：Braxton and Taska (2023) find that technological change accounts for 45 percent of the decline in earnings after job loss. We first reproduce all regression tables in Braxton and Taska (2023), and then test for robustness by controlling for the initial level of wages, additional fixed effects, multi-way clustering, and conducting influential analysis. We find that the paper’s original results are sensitive to controlling for initial wages and some additional fixed effects. Overall, we find the results are robust with a coefficient in the same direction and significant at 5% in 33% of the robustness checks we ran, with average t/z scores 28% as large as the original study.
- Link to Full Report: https://osf.io/qws2p/
- Link to Replicators Package: https://osf.io/qws2p/
- Original Authors Response: Authors mentioned they would write a response in the coming weeks.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/181166/version/V 1/view

### B.1.85
- 原论文标题：The Common-Probability Auction Puzzle
- doi: https://doi.org/10.1257/aer.20191927, American Economic Review
- 内容摘要：Ngangou ´e and Schotter (2023) investigate common-probability auctions. By running an experiment, they find that, in contrast to the substantial overbidding found in common- value auctions, bidding in strategically equivalent common-probability auctions is consistent with the Nash equilibrium. We reproduce their results in R, conduct robustness checks on how their sample was constructed, and consider possible heterogeneity. We confirm their documented qual- itative results.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/74.htm
- Link to Replicators Package: https://osf.io/7bq4s/
- Original Authors Response: “Thank you for putting the effort in replicating our study! Your results are also quite interesting to us as we haven’t thought of all the robustness checks you’ve made. At this point, we do not have any major comments to make and refrain from submitting a response.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/184041/version/V 1/view

### B.1.86
- 原论文标题：The Curious Case of Theresa May and the Public That Did Not Rally: Gen- dered Reactions to Terrorist Attacks Can Cause Slumps Not Bumps
- doi: https://doi.org/10.1017/S0003055421000861, American Political Science Review
- 内容摘要：Holman et al. (2022; HMZ) propose women (compared to men) political lead- ers experience significant drops in public approval ratings after a transnational terrorist attack. After documenting how survey-based evaluations of then-Prime Minister Theresa May suffered after the 2017 Manchester Arena attack, HMZ assemble a country-quarter level panel database to explore the generality of their hypothesis. They report evidence suggesting women (compared to men) leaders systematically experience decreased public approval rates after major transnational terrorist attacks (p-value of 0.020). We find that result disappears once any of the following adjust- ments is implemented: (i) excluding election quarter covariates (p = 0.104); (ii) correcting objective coding errors in the election quarter covariates (p = 0.058); (iii) excluding the May-Manchester ob- servation (p = 0.098); or (iv) clustering standard errors at the country level (p = 0.558). Exploring all 25 combinations of the five control groups HMZ incorporate in their specification, none of them clears the 5% threshold of statistical significance once the corrected election quarter variables are employed. We conclude that the empirical evidence does not provide sufficient support for HMZ’s abstract claim that ”conventional theory on rally events requires revision: women leaders cannot count on rallies following major terrorist attacks.”
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/41.htm
- Link to Replicators Package: https://doi.org/10.5683/SP3/6SYCML
- Link to Original Authors Response: https://econpapers.repec.org/paper/zbwi4rdps/44.htm
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/VHNPUO

### B.1.87
- 原论文标题：The Dynamics and Spillovers of Management Interventions: Evidence from the Training within Industry Program
- doi: https://doi.org/10.1086/719277, Journal of Political Economy
- 内容摘要：Bianchi and Giorcelli (2022) study the long-term and spillover effects of a man- agement intervention program on firm performance in the US, between 1940 and 1945. The authors find that the Training Within Industry (TWI) program led to positive effects which lasted for at least 10 years. Firm sales of treated firms increased by 5.3% in the first year after implementation, peak- ing at 21.7% after 8 years, before reducing to 16% gains after a decade. The authors claim that the program generated long-lasting changes in managerial practices. Finally, the program also led to positive spillover effects on the supply chain of treated firms. First, we reproduce the paper’s main findings. Second, we test the robustness of the results to (1) changing the main specification sample and (2) testing other difference-in-differences estimators, using the same data, provided by the authors. We find that the results are robust to these changes. All point estimates in the study remain statistically significant and of similar magnitude. While the paper’s finding reproduce and replicate, challenges in reproducing results we encountered lead us to recommend improvements to journals’ code policies.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/66.htm
- Link to Replicators Package: https://github.com/cwestheide/i4r dp66 code
- Original Authors Final Response: “Thanks a lot for sharing the updated report with us. We don’t have anything to add at this point.”
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/719277/s uppl file/20200781data.zip

### B.1.88
- 原论文标题：The Economic Effects of Long-Term Climate Change: Evidence from the Little Ice Age
- doi: https://doi.org/10.1086/720393, Journal of Political Economy
- 内容摘要：Waldinger (2022) finds significant negative economic effects (proxied by city size) from gradual climate change which occurred during the Little Ice Age (1600-1850) and offers two potential mechanisms (agricultural productivity and mortality) and two potential adaptations (trade and land use). In this comment, we show that while Waldinger (2022)’s findings can be replicated, the main result relies on a critical author assumption: Cities with 0 inhabitants in the original data are instead assumed to have 500. This assumption affects 23.5% of observations and 49.6% of cities in the sample. When these “missing data” are excluded from the analysis, the effect estimated by otherwise identical research methods is of similar magnitude and statistical significance but of opposite sign.
- Link to Full Report: https://osf.io/tmn2j/
- Link to Replicators Package: https://osf.io/tmn2j/
- Link to Original Authors Response: https://osf.io/tmn2j/
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/720393/s uppl file/2015548data.zip

### B.1.89
- 原论文标题：The Effects of Banking Competition on Growth and Financial Stability: Evi- dence from the National Banking Era
- doi: https://doi.org/10.1086/717453, Journal of Political Economy
- 内容摘要：Carlson et al. (2022) examine the causal impact of banking competition by in- vestigating a unique circumstance in the National Banking Era of the nineteenth century in the US, where a discontinuity in bank capital requirements occurred. On the one hand, their findings suggest that banks operating in markets with fewer barriers to entry tend to increase their lending activities, promoting real economic growth. On the other hand, banks in less restricted markets also exhibit a higher propensity for risk-taking, posing risks to financial stability. First, we fully re- produce the paper’s outcomes apart from a minor discrepancy in the estimate of Table 9 attributed to issues in the provided codes. Second, we test the robustness of the results by (i) changing the ranges used to select the sample of cities included in the analysis, (ii) adopting different options to address outliers’ potential issues and (iii) introducing additional control variables. We observe that the estimation results remain mostly consistent when subjecting them to various robustness checks. However, it is worth highlighting that the results can be partially influenced by the criteria used to select the sample of cities and the inclusion of control variables.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/81.htm
- Link to Replicators Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/BB864R
- Original Authors Final Response: “We thank the replication team (Andrea Calef, Sya In Chzhen, Marco Mandas, and Fabio Motoki) for the detailed replication report. We are glad to hear that the replicating team affirms the robustness of the paper’s findings. We are also glad that the repli- cators were able to successfully replicate all tables and figures. We thank the replicating team for identifying various smaller issues regarding the code structure which fortunately did not affect our original findings. We believe that the report as such does not require us to respond in any further detail. We highly appreciate the effort of both the replicating team and the I4R.”
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/717453/s uppl file/20200610data.zip

### B.1.90
- 原论文标题：The Geography of Repression and Opposition to Autocracy
- doi: https://doi.org/10.1111/ajps.12614, American Journal of Political Science
- 内容摘要：Analytic data sets and analysis code are available and they produce the same re- sults as presented in the paper (CRA). Robustness checks involve the (i) use of matching estimators to address possible bias from misspecification, based on propensity score estimated from a random forest model, (ii) doubly robust (TMLE) estimation to address possible bias from misspecification in either the propensity score or outcome regression stages, using a super learner ensemble with random forest, GAM, mean, and non-parametric regression models and averaged over repeated runs to minimize randomness, (iii) define treated comunas as those within a fixed physical distance radius of the nearest military base, rather than only those that contain it, and (iv) instead of using 2SLS to assess the causally mediated effect of military bases on plebiscite outcomes via repression, we propose to conduct mediation analysis (Tingley et al 2013), implemented in the R ’mediation’ package.
- Link to Full Report: https://www.socialsciencereproduction.org/reproductions/789/publishe d/index?step=4
- Link to Replicators Package: https://github.com/pjesscarter/repression-replication
- Link to Original Authors Response: We are happy that the replicators successfully reproduced all the analysis in our published paper. Moreover, additional robustness checks within the quantita- tive framework of the paper further confirm the empirical results. Two extensions using propensity score matching give somewhat different results. Unfortunately, these additional estimators violate standard requirements for credible matching designs, i.e., overlap in the propensity score distri- bution across treatment and control groups. As shown by previous research, this lack of overlap leads to unstable estimators with variance that may explode in finite samples such as ours (Fr¨olich 2004, Khan and Tamer 2010). In another extension, the replicators employ a mediation analysis to re-interpret the empirical evidence in our paper. To support the use of our method, i.e., instru- mental variables, we rule out alternative explanations and provide a range of historical evidence. Without historical and contextual support for alternative assumptions, we believe that the method used by the replicators is hard to interpret.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/EYAWES

### B.1.91
- 原论文标题：The Labor Market Impacts of Universal and Permanent Cash Transfers: Evidence from the Alaska Permanent Fund
- doi: https://doi.org/10.1257/pol.20190299, American Economic Journal: Economic Policy
- 内容摘要：Jones and Marinescu (2022) study the employment effects of a universal cash transfer in Alaska. Using a synthetic control method, they find that the transfer had no negative effects on employment. We reproduce the results using their replication package and investigate if the results hold when using a different software to run the analysis. We also use different estima- tion techniques and perform sensitivity checks to assess robustness of the results. We find some differences in the size and significance of the average treatment effects on labor force participation and hours worked when we use a different software (R) and various extensions of the synthetic control method. We also find smaller coefficients on part-time employment when including more covariates. However, these differences do not contradict the main conclusion of the paper.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/80.htm
- Link to Replicators Package: https://osf.io/6atfw/
- Original Authors Final Response: “Thanks for putting in all this effort to evaluate the robustness of our results! I [Marinescu] think this is really a worthwhile endeavor.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/140121/version/V 1/view

### B.1.92
- 原论文标题：The Long-Run Effects of Sports Club Vouchers for Primary School Children
- doi: https://doi.org/10.1257/pol.20200431, American Economic Journal: Economic Policy
- 内容摘要：Marcus, Siedler and Ziebarth (2022 American Economic Journal: Economic Policy) examine the long-run health effects of a universal sports-club voucher program that was introduced in Saxony for primary school children in 2009. In 2018, the authors designed a survey that targeted the affected cohorts and nearby cohorts in Saxony and two neighboring states, and use a differences-in-differences identification strategy that exploits variation across states and co- horts in policy exposure. The authors document that treated individuals have knowledge of the program and recall receiving and redeeming the vouchers at higher rates, but find no effects on any health outcomes or behaviors. We successfully reproduce the main results of the paper exactly using data available in the paper’s replication package and new Stata and R code. We also verify the robustness of the results using different outcomes, different control variables, different sample restrictions and different inference methods.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/46.htm
- Link to Replicators Package: https://osf.io/4bnjt/
- Original Authors Response: “We would like to thank the authors for their interest in our paper. We greatly appreciate their careful reading of the paper and the insightful robustness exercises they conducted. We are pleased that our results were successfully reproduced using different software packages, and that the additional robustness analyses performed by the authors further strengthen and support our conclusions.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/138922/version/V 1/view

### B.1.93
- 原论文标题：The Long-Term Effects of Measles Vaccination on Earnings and Employment
- doi: https://doi.org/10.1257/pol.20190509, American Economic Journal: Economic Policy
- 内容摘要：Atwood (2022) analyzes the effects of the 1963 U.S. measles vaccination on longrun labor market outcomes, using a generalized difference-in-differences approach. We repro- duce the results of this paper and perform a battery of robustness checks. Overall, we confirm that the measles vaccination had positive labor market effects. While the negative effect on the likelihood of living in poverty and the positive effect on the probability of being employed are very robust across the different specifications, the headline estimate-the effect on earnings-is more sensitive to the exclusion of certain regions and survey years.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/33.htm
- Link to Replicators Package: https://osf.io/jv7kx/
- Link to Original Authors Response: https://osf.io/qxjnk/
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/138401/version/V 1/view

### B.1.94
- 原论文标题：The Macroeconomics of Sticky Prices with Generalized Hazard Functions
- doi: https://doi.org/10.1093/qje/qjab042, Quarterly Journal of Economics
- 内容摘要：We replicate the empirical results in Section 4 of Alvarez et al. (2022). First, we were able to reproduce the original authors’ major empirical results, but only after editing the program for it to run on our computing platform. There are small discrepancies in the empirical estimates, e.g. bootstrapped standard errors, that involve the use of simulations. Second, we replicated Alvarez et al.’s results by adopting the data cleaning criteria used by their original data source (Cavallo 2018) to evaluate its robustness to data handling procedures. We found noticeable changes in the empirical results that can have important implications on the effects of monetary policy. To conclude, we propose using Docker container to promote research reproducibility, and more attention is needed on data handling to improve the robustness of empirical research.
- Link to Full Report: https://github.com/atyho/Ottawa-Replication-Games-2023/blob/main/ Ho Huynh Rea Replication Report.pdf
- Link to Replicators Package: https://github.com/atyho/Ottawa-Replication-Games-2023/
- Link to Original Authors Response: 
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/IBM0IE

### B.1.95
- 原论文标题：The Morning After: Cabinet Instability and the Purging of Ministers after Failed Coup Attempts in Autocracies
- doi: https://doi.org/10.1086/716952, Journal of Politics
- 内容摘要：We replicate the analysis provided in Bokobza et al. (2022). They identify a causal effect of failed coup attempts on cabinet minister removals in autocracies on both the country and individual minister level and show that higher-ranking ministers and those holding strategic positions are more likely to be purged than more loyal and veteran ministers using fixed effects panel models. We focus on computational reproducibility and robustness replicability. In addition to reproducing the original results using Stata and R, we replicate analyses using random effects panel models and ordered beta regression models, reproduced analyses performed in R using different packages, replaced the main independent variable, clustered standard errors on a different level, and added independent variables related to coup-proofing. We find that the original findings were reproducible and robust.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/45.htm
- Link to Replicators Package: https://doi.org/10.7910/DVN/21HZCC
- Link to Original Authors Response: https://osf.io/sm526/
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/GCDJ25

### B.1.96
- 原论文标题：The Origin of the State: Land Productivity or Appropriability?
- doi: https://doi.org/10.1086/718372, Journal of Political Economy
- 内容摘要：This is a replication of Mayshar et al. (2022) (MPP).The article posits that the state (defined as societal hierarchy such as tax-levying elites) originated from cultivation of appropriable cereal grains, contrary to the conventional theory that the state originated from in- creased land productivity following the adoption of agriculture. The article uses multiple datasets to demonstrate a causal effect of cereal cultivation on hierarchy (Claim 1) without finding a similar effect for land productivity (Claim 2), and that societies based on roots or tubers display levels of hierarchy similar to nonfarming societies (Claim 3). The results of our replication in brief are: 1. The data and code provided by MMP closely reproduce the main results presented in their Table 1 (see our Table 1). 2. Concurrently testing the cereal cultivation and land productivity claims leads to slightly less statistical significance, on average, than the published article (Table 2).3. Remov- ing the inherited 1-5 scale of the dependent variable (hierarchy) finds that cereal production is not as effective at moving across all levels of hierarchy compared to the more general claim (Table 3 and 4).4. Using the same procedures with an aim to confirm the conventional hypothesis (land productivity leads to increased hierarchy conditional on cereal growth) offers statistically signifi- cant evidence both for and against Claims 1 and 2 and against Claim 3 (Table 6). 5. The statistical significance of Claim 1 is sensitive to the removal of the top 3% of observations outliers (Table 7). 6. Correction of mis-classified ‘none or none specified’ crop societies alters the interpretation of coefficients behind Claim 3. Societies that rely more on agriculture among farming societies experience more complex hierarchies, irrespective of being primarily cereal producing or tubers growing (Table 8 and 9). (...)
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/82.htm
- Link to Replicators Package: https://osf.io/ekzdg/
- Original Authors Response: Comments taken into account in the report.
- Original Authors Package: https://www.journals.uchicago.edu/doi/suppl/10.1086/718372/s uppl file/2018030data.zip

### B.1.97
- 原论文标题：The Power of Hydroelectric Dams: Historical Evidence from the United States over the Twentieth Century
- doi: https://doi.org/10.1093/ej/ueac059, Economic Journal
- 内容摘要：Successful computational reproducibility. No coding errors uncovered.
- Original Authors Package: https://zenodo.org/records/7019816

### B.1.98
- 原论文标题：The Relative Efficiency of Skilled Labor across Countries: Measurement and Interpretation
- doi: https://doi.org/10.1257/aer.20191852, American Economic Review
- 内容摘要：Rossi (2022) examines the relative efficiency of skilled workers across countries. He finds the elasticity of skill efficiency with respect to GDP per worker is 1.4 and that the relative human capital accounts for only about 9 percent. We reproduce the paper’s main findings and test the sensitivity of the results to (1) alternative samples and (2) additional controls for determining wages. We find the results remain robust to these alternative specifications, and the estimated values of the key elasticities remain nearly unchanged.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/59.htm
- Link to Replicators Package: https://osf.io/fge7z/
- Original Authors Response: “Thanks for replicating the paper. I don’t have any comments to add to the report.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/146041/version/V 1/view

### B.1.99
- 原论文标题：The Side Effects of Immunity: Malaria and African Slavery in the United States
- doi: https://doi.org/10.1257/app.20190372, American Economic Journal: Applied Economics
- 内容摘要：Esposito (2022) documents the role of malaria in the diffusion of African slav- ery in the US. She finds that the introduction of malaria triggered a demand for malaria-resistant labour, which led to a massive expansion of African enslaved workers in more malaria-infested areas. Further results document that, among African slaves, more malaria-resistant individuals commanded significantly higher prices. We reproduce the paper’s main findings, uncovering only one minor coding error that has no effect on the study’s main results. We then test the robustness of the results to (1) varying the set of control variables used in various analyses; (2) conducting permutation tests; and (3) conducting event studies that account for time-varying controls. We generally find that the author’s results are robust to all of these alternative specifications, though there are some sets of controls that cause estimates to become small and statistically insignificant.
- Link to Full Report: https://osf.io/728ud/
- Link to Replicators Package: https://osf.io/728ud/
- Original Authors Response: Original author provided feedback. No final response on the up- dated version.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/120483/version/V 1/view

### B.1.100
- 原论文标题：The Wheels of Change: Technology Adoption, Millwrights and the Persis- tence in Britain’S Industrialisation
- doi: https://doi.org/10.1093/ej/ueab102, Economic Journal
- 内容摘要：Mokyr et al. (2022) estimate the effects of early technology adoption on indus- trialization. Authors argue that human capital was the main determinant of the location of the industry in the first decades of the Industrial Revolution. They document that the location of mills in the eleventh century (reported in the Doomsday Book) has a positive and statistically significant impact on the number of wrights in the early eighteenth century. We confirm the computational reproducibility of the paper. The estimates are not sensitive to outliers, which are common in the data. The results are also robust to changes in the control variables. The results remain robust if we adjust the estimated p-values for the low number of clusters, and if we include county fixed effects. We conduct a placebo experiment with a present-day outcome (the Brexit referendum) to check if the results are picking up on a more general demographic and economic correlation pattern; the experiment shows no spurious correlations.
- Link to Full Report: https://osf.io/gdne3/
- Link to Replicators Package: https://osf.io/tws8n/
- Original Authors Response: No response.
- Original Authors Package: https://zenodo.org/records/5734954

### B.1.101
- 原论文标题：Understanding Ethnolinguistic Differences: The Roles of Geography and Trade
- doi: https://doi.org/10.1093/ej/ueab065, Economic Journal
- 内容摘要：Dickens (2022) studies the role of trade on long-run inter-ethnic linguistic differences. He establishes that neighboring ethnolinguistic groups have smaller (lexicostatisti- cal) linguistic distances when there is a larger agricultural productivity variation between them. Specifically, he establishes that pre-1500 land productivity variation (CSI SD) and its change due to Columbian Exchange in the post-1500 (CSI SD CHANGE) era decrease linguistic distances be- tween groups. In what can be considered his main specification, which includes geographical con- trols, spatial controls, and language family fixed effects (Table 1 column 5), he estimates that a one standard deviation increase in the change in land productivity variation (post-1500) decreases lin- guistic distances by 0.11 standard deviations (p-value ¡ 0.01) and a one standard deviation increase in land productivity variation (pre-1500) decreases linguistic distances by 0.06 standard deviations (p-value = 0.12). We conduct a direct replication of the paper by (i) reconstructing the main in- dependent variables using the same original sources and following the procedures explained in the original study, (ii) using an updated version of the linguistic map (Ethnologue v17 instead of v16), and (iii) constructing alternative measures of inter-ethnic potential gains from trade. Our re- sults basically confirm the sign, magnitude, and statistical significance of the point estimates in the original study.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/62.htm
- Link to Replicators Package: https://osf.io/k3p7g/
- Link to Original Authors Response: https://econpapers.repec.org/paper/zbwi4rdps/63.htm
- Original Authors Package: https://oup.silverchair-cdn.com/oup/backfile/Content public/Jo urnal/ej/132/643/10.1093 ej ueab065/2/ueab065 replication files.zip?Expires=1704996457&Sign ature=vd4j4Sgew70tKc9uWbPKOHlAGfK48X1HRxhQJgweFXIbFcEKdILQEyfh8FdhERkzWILg GurP0VSMDLETGC9VaG3CgKIpAwM3q∼ZOQcpkS8-aL7wWR5uGOeUe6tspavXQZO03ZSfMJI ZdZoagJHeuKK-rbftOfNFQRVC7N6Bdry184zWa8RQy4xKSncJRgJmUBVCGZJBdA6KGfQx6o4 S0lXMy7GOy8rBGQKRZEvC9qre1LYXXUx71ozqVClckTI6DmE0qpkhE9Xu20s-g-7LUxlY9pd8G uRzsWT4kSBqbznx7lys2iaMB2eej ∼30pZkHgMWs2XkTJYP1YQUbxijWN-A &Key-Pair-Id=AP KAIE5G5CRDK6RD3PGA

### B.1.102
- 原论文标题：Vulnerability and Clientelism
- doi: https://doi.org/10.1257/aer.20190565, American Economic Review
- 内容摘要：The paper estimates the effect that changes in household vulnerability have on citizens’ participation in clientelist relationships. The authors exploit two sources of variation in household vulnerability: rainfall shocks, and a randomized intervention that provided cisterns in drought-prone areas. We reproduce all the findings presented in the four main results tables presented in the paper. The results of our robustness replication show that the results in the orig- inal paper are robust to variations in the rainfall period used as a baseline to assess changes in household vulnerability, and to exclusions that eliminate individuals in the sample who may have been substituted with others at different survey points. However, some of the original results that explain the underlying mechanisms are sensitive to how “clientelist relationships” are de- fined. When more frequent interactions with politicians are used as the defining characteristic of households in clientelist relationships, we find that the original results suggesting clientelism as a significant mechanism are no longer statistically significant at any standard significance level. We note, however, that the authors, in a reply to questions we sent them after the Replication Games, convincingly show that their results are robust to changing the definition of the clientelist marker.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/83.htm
- Link to Replicators Package: https://osf.io/q2tw6/
- Link to Original Authors Response: https://econpapers.repec.org/paper/zbwi4rdps/84.htm
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/173341/version/V 1/view

### B.1.103
- 原论文标题：Wage Cyclicality and Labor Market Sorting
- doi: https://doi.org/10.1257/aeri.20210161, American Economic Review: Insights
- 内容摘要：Figueiredo (2022) examines wage cyclicality across the skill mismatch distribu- tion finding large differences. Some key results include finding that wages are acyclical in good labor market matches but procyclical in poor matches. Using the public replication material pro- vided by the authors, we were able to exactly duplicate the results of the study. Further, using several further robustness checks, such as subtracting (potentially correlated) covariates in the re- gressions, using different standard errors (rather than clustered ones), or different time periods of the data left the key results largely unchanged with some minor caveats.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/78.htm
- Link to Replicators Package: https://osf.io/a8hcg/
- Original Authors Response: “I have read the report and I do not wish to write a reply. Congratulations on this initiative – it is great!”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/150581/version/V 1/view

### B.1.104
- 原论文标题：War, Socialism, and the Rise of Fascism: an Empirical Exploration
- doi: https://doi.org/10.1093/qje/qjac001, Quarterly Journal of Economics
- 内容摘要：In this report, we present the results from a replication of Acemoglu et al. (2022). The authors suggest that the emergence of the ‘Red Scare’ in the aftermath of World War I led to a rise of fascism in Italy in the early 1920s. Their approach uses the war casualties as an instrument for the rise in socialist voting. We performed a series of replication strategies, including pre-trend controls, applying an alternative instrument and modifying the first-stage specification, as well as investigating the long-run political alignment. Based on our findings, the original authors’ results are replicable under a variety of alternative specifications.
- Link to Full Report: https://osf.io/a672c/
- Link to Replicators Package: https://osf.io/a672c/
- Link to Original Authors Response: No response.
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi: 10.7910/DVN/CLJTSC

### B.1.105
- 原论文标题：What Makes Anticorruption Punishment Popular? Individual-Level Evi- dence from China
- doi: https://doi.org/10.1086/715252, Journal of Politics
- 内容摘要：t also indirect effects through affecting evaluations of competence and morality. Conducting a conjoint study in China where respondents were asked to choose between two po- tential local officials, Tsai et al. found that 26% of the total effect of these officials punishing corrupt subordinates was estimated to come through indirect effects that go through evaluations of moral- ity and competence. Using their code, I reproduced their original findings, and did not find any notable coding errors while doing so. Then, taking advantage of the fact that Tsai et al. included several additional covariates beyond punishment in their experiment, I engaged in an extension of the original model, using the same method, to examine whether economic performance character- istics have indirect effects on evaluation through competence and morality as well. I found results that suggest that economic performance does have an indirect effect on preferences through com- petence and morality. I then tested the robustness of Tsai et al.’s original heterogeneous sensitivity tests by varying cut points on two demographic variables and found that their findings of a lack of heterogeneous sensitivity remain robust to different cut-points. In all, my efforts suggest that Tsai et al.’s methods are valid and their findings robust.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/7.htm
- Link to Replicators Package: https://osf.io/czs6j/
- Original Authors Response: “We appreciate your efforts, both in replicating our paper and in doing so systematically for other studies in leading political science and economic journals. Your contribution is valuable to the entire academic community and to us especially. We also appreciate your sharing replication reports with the original authors prior to dissemination and are glad to see from the replication report that our results and methods appear to be both valid and robust. Although a longer follow-up may not be necessary, we do wish to convey our gratitude to the replicator(s) and to the editorial team.”
- Original Authors Package: https://dataverse.harvard.edu/dataset.xhtml;jsessionid=34454d461 ad29192edc557995095?persistentId=doi%3A10.7910%2FDVN%2FXTRWKG&version=&q=&fileT ypeGroupFacet=&fileAccess=Public&fileSortField=date

### B.1.106
- doi: https://doi.org/10.1257/aer.20210701, American Economic Review
- 内容摘要：Okeke (2023) evaluates a policy experiment conducted in Nigeria, whereby communities were randomly allocated to receive a new doctor at the local public health center. The performance of these centers was compared to other sites which were allocated either a new midlevel health-care provider, or no additional staff. The study finds that communities assigned a new doctor were associated with a decrease in seven-day infant mortality, such a decrease was not observed in communities assigned a midlevel health-care provider. This suggests that it is the ’quality’ of the additional doctor driving the effects rather than due to a quantity increase of an additional health worker. The size of the mortality reduction increased with increased exposure to the intervention. We first conduct a computational reproduction, rerunning the original code and data, finding that the results reported in the original study are reproducible. Second, we test the robustness of the results in several ways, by 1) adapting the existing controls to make the results robust to contamination bias, 2) altering and adding to the control variables included, 3) changing the specification or regression technique used, and 4) testing coding grouping and changing how service use was coded. These changes cause little change to the point estimates, although we find that the original paper’s standard errors were overly conservative, and thus the statistical significance of some results was understated.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/53.htm
- Link to Replicators Package: https://github.com/e-mcmanus/Okeke23 Replication
- Original Authors Response: “Thank you for sharing the replication report (and please pass on my thanks to the replicators). There does not appear to be much for me to respond to. It is gratifying to see that the results have held up well to additional scrutiny.”
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/181581/version/V 1/view

### B.1.107
- 原论文标题：Who Chooses Commitment? Evidence and Welfare Implications
- doi: https://doi.org/10.1093/restud/rdab056, Review of Econoimc Studies
- 内容摘要：We conduct a computational reproduction and a robustness replication of Car- rera et al. (2022) by using the same dataset and similar procedures as specified in their paper (i.e., method and analysis). Instead of using STATA, we use R and code the results from scratch. We also replicate the MATLAB code used for simulations and test whether it produces reasonable results for different parameter values. We confirm all of the main results and do not find high sensitivity of the model to changes in parameters.
- Link to Full Report: https://osf.io/752q9/
- Link to Replicators Package: https://osf.io/752q9/
- Link to Original Authors Response: The authors provided feedback which was taken into ac- count.
- Original Authors Package: https://zenodo.org/records/5173081

### B.1.108
- 原论文标题：Who Sells During a Crash? Evidence from Tax Return Data on Daily Sales of Stock
- doi: https://doi.org/10.1093/ej/ueab059, Economic Journal
- 内容摘要：Hoopes et al., (2021) analyze United States tax return data encompassing all individual taxable stock sales between 2008 and 2009, to investigate the individuals who increased their stock sales in response to market turbulence. Our findings reveal that such increases were notably prevalent among investors in the highest tiers of the income distribution, including the top 1% and 0.1%, as well as retirees and those at the uppermost levels of the dividend income distribution. We reproduce the paper’s main findings and results are very similar.
- Link to Full Report: https://osf.io/b6s9k/
- Link to Replicators Package: https://www.dropbox.com/scl/fo/c3ysdlenysq391mugzprm/h?r lkey=riooyohci7i5vwx475r13jaqq&dl=0
- Original Authors Response: The authors provided feedback which was taken into account.
- Original Authors Package: https://oup.silverchair-cdn.com/oup/backfile/Content public/Jo urnal/ej/132/641/10.1093 ej ueab059/1/ueab059 replication files.zip?Expires=1704997287&Si gnature=upyVQnDMB8sNLQdV8sEneBiOcslAUwcueEn5D9bSDy-XtIMI1GC8cuUSONoONguJ 2exME∼p4ap2V4vqFcH4UwnYece8Xqf84jorKGaCSxUu2GufwIYi9Io2JA3xqxW-gZ1chzZ8mt0FW EYqkrfSkAJM1kxuBWT3yRj6MPbG9ObHH ∼g9ynCpndkxbUHZYuX8Rgr57j6KWNBQ0WSyb3D 9Y-0-o5TaQETTCL93hRMhCciipdP96qZq ∼0Ml9QgquGTVs7QK-FP4HD7JONWESzoFYTNterBQ ypZV1DbCP056qtgH12 ∼77cC2aJycGL56wkQ2r0dgSD1bw1JvDIfPuRFipyA &Key-Pair-Id=AP KAIE5G5CRDK6RD3PGA

### B.1.109
- 原论文标题：Why Don’t Firms Hire Young Workers During Recessions?
- doi: https://doi.org/10.1093/ej/ueab096, Economic Journal
- 内容摘要：We gauge the replicability of the results of Forsythe (2022) studying the cyclical- ity of individuals’ labor market transitions conditional on their experience. Using Current Popula- tion Survey (CPS) data and state-level variation in cyclical unemployment, this paper shows that the hiring probability of youths is more sensitive to business-cycle conditions than that of experi- enced individuals. We replicate the main results in this paper by reconstructing the dataset using data from the IPUMS-CPS database (Flood et al. (2020)) and recoding the paper’s main regres- sions. We also conduct a robustness replicability analysis and show that the paper’s main results are robust in terms of statistical significance to (i) extending the sample period from 1994-2014 to 1994-2019 and (ii) using MSA-level unemployment variation instead of state-level variation. However, these extensions reduce the magnitude of the main effects of interest. The paper’s key conclusions are unaffected.
- Link to Full Report: https://osf.io/3pqbt/
- Link to Replicators Package: https://github.com/jcrechet/replication forsythe 2022 EJ
- Link to Original Authors Response: The author responded but did not provide a response.
- Original Authors Package: https://zenodo.org/records/5710784

### B.1.110
- 原论文标题：Yellow Vests, Pessimistic Beliefs, and Carbon Tax Aversion
- doi: https://doi.org/10.1257/pol.20200092, American Economic Journal: Economic Policy
- 内容摘要：Douenne and Fabre (2022) implement a representative survey following the Yellow Vests movement in France that started in opposition to the carbon tax in 2018. They find that a majority of French citizens would oppose a carbon tax and dividend program with proceeds paid equally to each adult. The authors further find that respondents have pessimistic beliefs about several aspects of the policy. They then show how informational treatments cause respondents to update these beliefs, and they finally estimate the causal effect of these beliefs on support for the policy. In this note, we focus on the second section of this paper: the causal effects of feedback on beliefs. Based on elicited household characteristics, Douenne and Fabre (2022) estimate whether each household ”wins” or ”loses” from the carbon tax and dividend reform. They provide this binary (win vs. lose) information to households and subsequently ask households to evaluate whether they believe they would financially benefit from the policy. By exploiting the disconti- nuity in win vs. lose feedback, they assess the degree to which feedback affects subjective beliefs, finding that a household that is told it will ”win” as a result of the reform increases its subjective belief that it will not lose by about 25 percentage points. The subset of households that is part of the Yellow Vests movement, however, revises its subjective belief of not losing upwards by only 10 percentage points after being told that it will ”win” from the carbon tax reform. Conversely, house- holds who initially support the tax increase this belief by 41 percentage points when told they will ”win.” In this note we replicate this second section of the paper-the causal effects of feedback on beliefs- using the processed data provided by the authors. We successfully replicate the average treatment effect, but we find that the heterogeneous treatment effects may be biased due to model misspecification. While our results support the conclusion that these estimated effects depend on a household’s attitudes toward the policy, we find that the source of heterogeneity differs. Fur- ther, we note two changes to the analysis that we believe are appropriate (which do not affect the conclusions drawn): first, some (1.8%) of observations in the dataset appear to be misclassified- wrongly coded as if a household would ”lose” when in fact they would ”win”-and second, the main causal analysis is based on a regression discontinuity design, but does not include standard components of such a design (e.g., a RD plot, optimal selection of bandwidth, density analysis, placebo tests). We update the design to address both of these points. We find results that generally support the main conclusions of Douenne and Fabre (2022), but we urge caution when interpreting the heterogeneous treatment effects.
- Link to Full Report: https://econpapers.repec.org/paper/zbwi4rdps/58.htm
- Link to Replicators Package: https://github.com/karemanyassin/Yellow-Vests-Pessimistic-Bel iefs-and-Carbon-Tax-Aversion-2022-A-Comment
- Original Authors Response: Authors provided feedback which was taken into account. No re- sponse.
- Original Authors Package: https://www.openicpsr.org/openicpsr/project/128143/version/V 1/view
