---
name: code-standards
description: >-
  Code delivery standards: the 500-line redline and how to split by responsibility, directory/package layering
  (split triggers, grouping by responsibility, migration discipline), comment hygiene (usage-first, no design
  history), README maintenance & structure policy, temp-artifact discipline (which files may land in a repo at
  all, and what belongs in .tempcache/), plan-document lifecycle (active vs archived, per-item status,
  delete-on-completion, README handoff index).
  Use when writing, refactoring, splitting or reviewing files; when a package grows crowded; when creating or
  renaming modules; when adding comments or public APIs; when drafting a multi-phase plan; or when about to
  create a non-source file (log, one-off script, screenshot, export, test package), when stray or unexplained
  files appear in a repo root or module dir, when the tree is cluttered and nobody dares delete
  (仓库根被不明文件污染 / 项目结构变乱 / 临时文件乱放), or when asking whether an artifact belongs in the repo.
---

# 代码交付准则 (Code Standards)

> **非规范镜像**：本文件是 `SKILL.md`（英文，规范版）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。


跨语言（Kotlin / Java / C++ / Swift / TS / C# 等）通用的源码体量、注释、文档与产物纪律。

---

## 一 · 全语言 500 行红线

- 所有源码文件**单文件 ≤ 500 行**，健康区间 **100~300 行**。
- 逼近 **400~500 行即主动拆分**，按单一职责切分，杜绝 God Class。
- 拆分手法随语言选择：

| 语言 | 手法 |
|:--|:--|
| Kotlin / Swift | UI 组件解耦、扩展函数提炼、状态容器剥离 |
| Java / C# | 组合优于继承、内部类外提 |
| C++ | 头文件 ≤ 300 行、Pimpl、算法独立翻译单元 |

> 详表（含各语言拆分判例）：[`references/universal-code-redline.md`](references/universal-code-redline.md)

---

## 二 · 注释与文档完整性

- 注释**面向使用者**写，形态对齐官方 KDoc / Javadoc：说明这个方法 / 类**做什么**、**参数与返回值**是什么含义、**怎么调用**；严禁 `// 将 index 加 1` 类语法复述。
- **公共 API 强制 KDoc / Javadoc**（`@param` 约束 / `@return` 语义 / `@throws` 分支）。
- **禁止设计沿革注释**：不写「从 X 演进而来」「讨论文档 § x / ADR-xxx」类来源出处。
- **禁止设计论证注释**：不写「为什么放在 A 处而不是 B 处」类权衡论证——设计决策归 ADR / 设计文档。
- **禁止变更日志式注释**：不写日期、版本、「本次修改……」——改动历史由 git 承载。
- 例外：魔法数字与复杂算法必须注明公式来源或物理意义（此处的「来源」是必要信息）。
- **保护既有注释铁律**：修改代码时严禁删除 / 篡改与本次变更无关的业务注释与 TODO；存量旧形态注释不追溯清理，本规范只约束**新写 / 新改**的注释。
- TODO 格式：`// TODO(责任人/日期): 事项`。

> 细则：[`references/code-commenting-guidelines.md`](references/code-commenting-guidelines.md)

---

## 三 · 架构文档同步

- 工程根 README 维护：全局架构 / 技术栈 / 模块索引 / 构建指南。
- 有独立构建脚本的模块**必须**维护模块级 README；README 须到**逐文件职责**粒度（目录树逐文件职责注释 + 核心文件职责矩阵）。
- **新增 / 重命名 / 移动 / 拆分 / 删除文件，必须在同次任务中同步更新对应 README。**

> 细则与结构模板：[`references/doc-sync-policy.md`](references/doc-sync-policy.md)

---

## 四 · 临时产物纪律

> **触发时机**：本会话**首次向磁盘写非源码文件之前**；以及每次任务收尾前的结构自查。

判据只有一个问题——**「这文件进版本库吗？」**

| 产物类别 | 判据 | 去处 |
|:--|:--|:--|
| 项目产物 | 进版本库：源码、配置、文档、资源 | 原位 |
| 构建输出 | 不入库，但项目自己能再生成：`build/`、`.gradle/`、`node_modules/`、构建工具直接产出的 jar/zip | 原位 + gitignore（不进 `.tempcache/`） |
| **其余一切** | 既不入库也不能由构建再生成：日志、一次性脚本、截图、抓取中间件、手动复制或重命名用于测试的包、导出物 | **`<repo>/.tempcache/<用途>/`** |

- **默认桶原则**：不是「列在例子里的才算临时」，而是**除前两类之外一律算临时**。判不出来时按临时处理。
- 严禁落仓库根、模块根、实验区目录——这是最常见的项目结构污染源。
- `.tempcache/` 内部同样遵循所在仓库的文件架构规范：按用途分子目录（`logs/` / `scratch/` / `captures/`）、语义化命名，严禁序号副本式堆叠。
- `.tempcache/` 可随时整体清理，不得留下悬空引用。
- 实验区目录只保留**有引用价值的产物**（被文档引用的演示稿、试验模块、调研溯源证据）。

> 细则：[`references/temp-artifacts-discipline.md`](references/temp-artifacts-discipline.md)

---

## 五 · 目录与包分层（分包规则）

500 行红线管「单个文件多大」，本节管「文件怎么放」。

> 设计期判据（规划期如何预判分包、功能/职责切分序、判据三连、依赖方向纪律）见 [`file-architecture`](../file-architecture/SKILL.md)；本节管**存量触发**（≥8 文件阈值）与迁移纪律。

- **触发分包**（满足任一即该拆，不等「感觉乱」）：单包源文件 ≥ **8** 个；或一个包混入了两种**互相不该知道**的东西（如循环引擎与业务工具集、记录器与渲染件）。
- **分包维度**：按**职责面 / 领域**分（`engine/`、`prompt/`、`tools/`、`session/`），**禁止按类型横切**（`model/`、`ports/`、`impl/`、`internal/`）——类型横切包密度必低，且不承担任何约束。
- **密度与命名**：不建 1 文件包（特例须写明理由）；包名 = 小写职责名词，与目录同名。
- **可见性**：包**不承担可见性**边界（如 Kotlin 的 `internal` 是模块级，与目录无关）；禁止为「看起来封装」而造 `internal/` 目录。
- **模块 vs 包**：模块边界回答「谁拥有这摊事」，包分层回答「模块内怎么找文件」——两个独立问题，都按本节触发条件处理。
- **迁移纪律**：一次一批（一个模块一批）；改完立刻跑该模块测试 + 全量构建；**构建绿 ≠ 测试跑了**——核对测试报告用例计数 > 0；批量 import 重写先 dry-run 逐文件核对。
- **决策留痕**：成规模重排（跨模块、改公共包名）先立 ADR / 决策记录；阈值与命名口径写进项目规范，不靠手感。

---

## 六 · 计划文档生命周期

多阶段 / 多期计划（切片计划、里程碑计划、跨会话长计划）的文档形态与收口纪律。**单次任务的子步骤清单不适用**——不建计划文档、不进索引。

- **双目录分工**：项目内维护两处——**执行中计划目录**（如 `docs/todo/`）与**历史归档目录**（如 `docs/plans/`）。多期计划一律起草到执行中目录，**不进**归档目录；归档目录冻结，不再新增。
- **逐项状态即进度真相**：计划内任务逐项带状态——未完成 `- [ ]`，完成改 `- [x]（日期）`，**完成一项即标一项**，不批量补记。
- **完成即销毁**：计划全部任务完成后**删除该计划文档**，并同步更新执行中目录 README 清单；完成痕迹由 changelog 与 git 承载，计划文档本身不作成果沉淀。
- **目录 README = 交接索引**：执行中目录必须维护 `README.md`，作为 **clear context 后第一读物**，含三块——**计划索引表**（计划链接 | 状态 | 说明，并置顶「先看这里」的接续指引）、**遗留表**（编号 `L1 / L2 …`，收容非计划内的悬置项）、**待讨论区**（未讨论清楚的构想进独立子目录，不落地为计划文档，讨论清楚后再转正）。

> 模板、状态词口径、判例：[`references/plan-doc-lifecycle.md`](references/plan-doc-lifecycle.md)
