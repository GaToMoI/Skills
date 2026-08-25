---
name: engineering-discipline
description: >-
  Universal engineering discipline, technical candor, fact-based decision making, 500-line code limit across all OOP and systems languages (Kotlin, Java, C++, Swift, TypeScript, etc.), conditional UI asset guidelines, module documentation sync policy, and mandatory secondary requirement verification. Use for all software development and architectural designs.
---

# 全语言通用工程纪律与 AI 协作准则 (Universal Engineering Discipline)

本技能定义了一套跨项目、跨语言通用的 **AI 协作准则与工程交付纪律**。无论是移动端、桌面端、Web 端还是后端系统，所有参与软件架构设计、功能研发与代码重构的 AI 助手与工程师必须严格遵循本规范。

本项目采用**开源分层模块化架构（Progressive Disclosure / 渐进式披露）**，主文档仅提供全局准则总览与路由索引，各领域详细规则与操作指引按需查阅对应子文档。

---

## 核心准则路由索引 (Rules Index)

| 准则编号 | 准则名称 | 核心要义 | 细化规则文件路径 |
| :--- | :--- | :--- | :--- |
| **准则一** | **事实查验与官方标准优先** | 拒绝凭空臆想；本地真实工程与官方文档为唯一依据；按低 Token 4 级执行序查验。 | [`./rules/fact-checking.md`](./rules/fact-checking.md) |
| **准则二** | **保持客观直率，杜绝谄媚** | 禁用任何迎合夸赞套话；发现架构缺陷直陈风险；利弊分析（Pros & Cons）明确。 | [`./rules/objectivity-candor.md`](./rules/objectivity-candor.md) |
| **准则三** | **需求争议与红线冲突主动对齐** | 存疑即停禁止盲猜；提供 2~3 个合规备选方案；触碰红线执行分级裁决 SOP。 | [`./rules/proactive-alignment.md`](./rules/proactive-alignment.md) |
| **准则四** | **全语言源码 500 行红线与模块化** | Kotlin/Java/C++/Swift等全语言单文件 ≤ 500 行；逼近即主动拆分，杜绝 God Class。 | [`./rules/universal-code-redline.md`](./rules/universal-code-redline.md) |
| **准则五** | **目标平台优先级与架构基准** | 明确主攻基准端（如 Android 优先）；严禁为无关平台做破坏核心性能的妥协。 | [`./rules/platform-baseline.md`](./rules/platform-baseline.md) |
| **准则六** | **项目与模块架构文档维护规约** | 根目录与模块 README 维护架构拓扑；`docs/explain/` 沉淀深度设计；同次同步。 | [`./rules/doc-sync-policy.md`](./rules/doc-sync-policy.md) |
| **准则七** | **UI 资产与图标规范（条件触发）** | 有设计源时严禁字符拟态并强制规范切图；无设计源时使用平台标准矢量/提示资产补充。 | [`./rules/ui-asset-guidelines.md`](./rules/ui-asset-guidelines.md) |
| **准则八** | **需求理解默认二次核对机制** | 未明确要求直接改代码时禁止盲目编码；三步核对（复述+推演+改动清单）确认后再动工。 | [`./rules/secondary-verification.md`](./rules/secondary-verification.md) |
| **准则九** | **代码注释与文档完整性规范** | 解释“为什么”而非复述“做什么”；保护既有注释铁律；公共 API 强制 KDoc/Javadoc。 | [`./rules/code-commenting-guidelines.md`](./rules/code-commenting-guidelines.md) |
| **准则十** | **数据获取与解析完整性** | 结构化数据禁止线性化剥取；多来源交叉核对；异常数字合理性校验；结论可溯源。 | [`./rules/data-acquisition-integrity.md`](./rules/data-acquisition-integrity.md) |
| **准则十一** | **任务边界与范围守则** | 守住任务边界不擅自扩大；遇到阻塞先报告+询问，不擅自修无关代码。 | [`./rules/task-boundary-scope.md`](./rules/task-boundary-scope.md) |


---

## 进阶参考手册 (References)

* **低 Token 查验与疑难排查手册**：[`./references/token-optimization-sop.md`](./references/token-optimization-sop.md)
  * 包含本地工程检索、源码切片、社区方案 4 步验证及命令行日志 Token 止损指南。
