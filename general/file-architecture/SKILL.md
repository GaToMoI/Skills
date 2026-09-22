---
name: file-architecture
description: >-
  File and package architecture design — how to plan file/directory layout so a codebase
  stays navigable: the two-hop lookup model, self-describing names and one-word-per-concept,
  the feature-first / responsibility-second splitting order, planning-time pre-judgement
  with size heuristics (≤2 files stay flat; ≥3 UI files form a directory), the change-reason
  (CCP), information-hiding (Parnas) and reuse-scope criteria, dependency-direction discipline,
  and fake-splitting antipatterns.
  Use when planning a new feature's file layout, deciding whether to create a folder or package,
  reviewing a crowded directory, or judging whether an existing structure needs adjustment.
---

# 文件架构准则 (File Architecture)

面向「人找文件」与「功能可搬移」的**设计期**判据。**存量审查阈值与迁移纪律**见 [`code-standards`](../code-standards/SKILL.md) § 五；本技能管**规划期怎么想、按什么切、增量期怎么复核**。

---

## 一 · 可读性目标模型

判据只有一条：**一个人能否用最短路径定位到目标文件**。

- **两跳定位**：意图 → 模块/层 → 功能面目录 → 文件。每一跳都靠名称回答"里面装的是什么"，不靠记忆路径。
- **目录与文件名 = 关键词索引**：找文件的人通常不知道文件叫什么，只知道它**做什么**——名称必须描述"做什么"（领域词），而不是"是什么类型"。
- **一名一义**：同一概念全库只有一个名字。同义词漂移（如「卡片」与「work item」混用）会让关键词检索漏掉一半；概念词以项目设计文档为单一来源。
- **一文件一主题**：混装文件会让同一特征的行散落在不相干上下文里，找到也读不懂。

## 二 · 切分优先序

1. **第一层：按功能面切**——功能（一组协同实现同一概念的文件）是分包的基本单位；
2. **第二层：功能内按职责切**——UI / 状态 / 数据。

维度细节（按职责面/领域、禁止按类型横切）见 [`code-standards`](../code-standards/SKILL.md) § 五。

**规模启发式**（预判触发，只用于回答"值不值得建包"）：

| 情形 | 处理 |
|:--|:--|
| 功能总产出 ≤ 2 个文件 | 不建包，平铺即可 |
| 预判 UI 侧（遵守 500 行规范后）≥ 3 个文件 | 建功能目录，文件按职责命名 |
| 状态 / 数据类 | 按复用范围定——单功能用跟功能走；多功能用上提共享层 |

数字只是触发器，**分不分由下一节判据裁决**。

## 三 · 判据三连

1. **变更原因（CCP · 共同闭包原则）**：一起变更的放一起。"功能"只是"一起变"最常见的形态，判据本身是"谁和谁总是一起改"——一个功能内从不一起变的两块值得再分，两个功能共享的常变块该上提。
2. **信息隐藏（Parnas）自检**：动手前问 "**这个包要隐藏的秘密是什么？**"——答得出（如 zone 包藏命中/缩放算法）才是模块；答不出（只是把同类文件归拢）就只是分类，收益近乎零。
3. **复用范围（CRP · 共同复用原则）**：一起被复用的放一起，不强迫使用者依赖无关物——"整目录 copy 走"能否成立，由这条裁决。

## 四 · 流程三阶段

1. **规划期**：设计功能的同时设计文件落位——预判规模，定包结构；
2. **实现期**：按计划落位，该分就分，不先挤进一个文件等以后拆；
3. **增量期**：新增功能先判落点，同时复核既有结构是否需要调整。

**复核权重不低于预判**：预判常低估而非高估——辅助件（dialog / overlay / probe / readout）多是增量期长出来的。

## 五 · 依赖方向纪律

包边界只有配合依赖纪律才成立，否则"按功能分包"只是换了名字的平铺。

- 跨包依赖**单向、无环**，不得互相反向 import；
- 共用件一经出现即上提（多功能复用 → 共享/契约层），不留两处拷贝；
- **目录边界 ≈ 依赖边界**：目录内文件若反向依赖目录外的私有件，"整目录搬走"就不成立。

## 六 · 反模式（假分）

| 反模式 | 症状 |
|:--|:--|
| 按数量分 | 1~2 个文件也建目录，只因"看起来该有" |
| 按对称分 | 为结构整齐给每个功能都配包，共因不成立 |
| 杂物包 | `utils/` `helpers/` `common/` `misc/`——内容特征最杂，检索黑洞 |
| 只分类不隐藏 | 目录建了，但每个文件都得 `public` 才能协作——包没围住任何秘密 |

## 七 · 理论出处（同源思想）

| 本准则表述 | 对应概念 | 出处 |
|:--|:--|:--|
| 功能优先分包 | Package by Feature | [javapractices《Package by feature, not layer》](http://www.javapractices.com/topic/TopicAction.do?Id=205) |
| 目录"喊出"系统做什么 | Screaming Architecture | [Uncle Bob, 2011](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html) |
| 切片包含 UI、贯穿各层 | Vertical Slice Architecture | [Jimmy Bogard, 2018](https://www.jimmybogard.com/vertical-slice-architecture/) |
| 一起变更的放一起 | 共同闭包原则 CCP | 包内聚三原则（Uncle Bob, *Agile Software Development*, Ch.13） |
| 一起被复用的放一起 | 共同复用原则 CRP | 同上 |
| 按"隐藏的变化"分解模块 | Information Hiding | [Parnas, 1972](https://dl.acm.org/doi/10.1145/361598.361623) |
| 存量大包触发拆分 | — | [`code-standards`](../code-standards/SKILL.md) § 五；[Android modularization 指南](https://developer.android.com/topic/modularization) 同向 |

**数字阈值（≤2 / ≥3）无权威出处**，是经验启发式；主流文献只给定性判据（高内聚、低耦合），故本技能将其标定为「触发器」而非规则本体。
