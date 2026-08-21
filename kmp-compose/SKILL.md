---
name: kmp-compose
description: >-
  Kotlin Multiplatform (KMP) and Compose Multiplatform architecture guidelines. Enforces pure commonMain source sets, Clean Architecture, interface-based DI over expect/actual, StateFlow MVI state management, atomic updates, recomposition optimization, and Composable component design contracts. Activate when working on Kotlin Multiplatform or Compose code.
---

# Kotlin Multiplatform & Compose 跨端开发规范 (KMP & Compose Skill)

本技能定义了基于 **Kotlin Multiplatform (KMP)** 与 **Compose Multiplatform** 跨端工程的现代架构准则、状态管理范式与组件设计契约。

本项目采用**分层模块化架构（Progressive Disclosure / 渐进式披露）**，主入口提供触发条件与规则索引，具体技术规范按需查阅各子规则文件。

---

## 触发与识别条件 (Trigger Conditions)

当工作区或当前任务满足以下任一条件时，自动激活本技能：
1. 项目包含 `commonMain/`、`composeApp/`、`shared/` 等 KMP 经典源码集；
2. 构建脚本（`build.gradle.kts`）包含 `org.jetbrains.kotlin.multiplatform` 或 `org.jetbrains.compose` 插件；
3. 代码涉及 Kuikly / Compose 声明式 UI 跨端渲染与状态流转。

---

## 核心规则路由索引 (Rules Index)

| 规则模块 | 核心定位与要义 | 详细规范路径 |
| :--- | :--- | :--- |
| **01. 禁止的反模式速查** | 禁止 `_state.value=`、禁止 ViewModel 中用 `mutableStateOf`、列表必须有 `key`、禁止裸 Flow 收集。 | [`./rules/banned-antipatterns.md`](./rules/banned-antipatterns.md) |
| **02. KMP 源码集与架构隔离** | `commonMain` 绝对纯粹；接口依赖注入 (DI) > `expect/actual`；`actual` 极薄转发原则。 | [`./rules/kmp-sourceset-clean-arch.md`](./rules/kmp-sourceset-clean-arch.md) |
| **03. Compose 重组性能优化** | 参数稳定性（`@Immutable` / `ImmutableList`）；Lambda Modifier 延迟读取跳过重组；`derivedStateOf`。 | [`./rules/compose-recomposition-performance.md`](./rules/compose-recomposition-performance.md) |
| **04. StateFlow 与 MVI 状态架构** | `StateFlow<UiState>` + `_state.update { }` 原子更新；单向数据流 (UDF)；纯 JVM `Turbine` 单元测试。 | [`./rules/stateflow-mvi-architecture.md`](./rules/stateflow-mvi-architecture.md) |
| **05. Composable 组件设计契约** | 公共组件首选参数必带 `modifier: Modifier = Modifier`；Slot API 槽位解耦；跨端 DesignTokens。 | [`./rules/composable-component-contract.md`](./rules/composable-component-contract.md) |

---

## 审查手册 (References)

* **交付前 6 步静态审查清单**：[`./references/kmp-compose-checklist.md`](./references/kmp-compose-checklist.md)
  * 在交付代码前对照清单逐一自查源码集隔离、状态原子更新与重组性能。
