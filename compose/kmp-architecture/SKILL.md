---
name: kmp-architecture
description: >-
  Kotlin Multiplatform architecture rules: commonMain purity, Clean Architecture layering, interface-based DI
  preferred over expect/actual, StateFlow-driven MVI with atomic updates, the banned-antipattern list, and the
  pre-delivery checklist. Use when working in a Kotlin Multiplatform project (commonMain/shared/composeApp
  source sets, org.jetbrains.kotlin.multiplatform or org.jetbrains.compose plugins), when designing shared
  state holders, or when deciding between expect/actual and an interface.
---

# KMP 架构规范 (KMP Architecture)

平台无关的跨端架构与状态管理。**Compose 框架层规则见 `compose-foundations` 技能。**

---

## 一 · 禁止的反模式（速查）

| 反模式 | 替代 |
|:--|:--|
| `_state.value = ...` | `_state.update { }`（原子更新） |
| ViewModel 内用 `mutableStateOf` | `MutableStateFlow` + `StateFlow<UiState>` |
| 裸收集 Flow（`collect` 无生命周期感知） | `collectAsStateWithLifecycle` / `stateIn` |
| 列表无 `key` | `items(key = { it.id })` |
| 状态类无 `@Immutable` | 加稳定性标注 |

> 完整黑白名单对照表：[`references/banned-antipatterns.md`](references/banned-antipatterns.md)

---

## 二 · 源码集隔离与 Clean 架构

- **`commonMain` 绝对纯粹**：不得出现平台 API、JVM-only 类或平台类型泄漏。
- **接口 DI 优于 `expect/actual`**：能靠接口倒置解决的一律用接口；`expect/actual` 只留给**无法抽象的真正平台原生能力**。
- 若必须用 `expect/actual`，`actual` 侧遵循**极薄转发原则**——只做转调，不承载业务逻辑。
- 分层：UI（Composable）→ StateHolder/ViewModel → UseCase → Repository → DataSource，依赖单向向内。

> 细则：[`references/sourceset-clean-arch.md`](references/sourceset-clean-arch.md)

---

## 三 · StateFlow 与 MVI / UDF

- 状态容器统一形态：`private val _state = MutableStateFlow(UiState())` + `val state: StateFlow<UiState>`。
- **原子更新**：一律 `_state.update { it.copy(...) }`，禁止读-改-写两步操作。
- **单向数据流**：UI 发 Intent/Event，容器改状态，UI 观察状态渲染；UI 不得直接改状态。
- UiState 必须为**不可变数据类**；一次性事件走独立 channel/SharedFlow，不塞进 state。
- 单测：纯 JVM `Turbine` 即可验证状态流转，无需 Android 仪器测试。

> 细则：[`references/stateflow-mvi-architecture.md`](references/stateflow-mvi-architecture.md)

---

## 四 · 交付前自检

逐项过 [`references/kmp-checklist.md`](references/kmp-checklist.md)：源码集隔离 → 状态原子更新 → 重组性能 → 组件契约 → 反模式扫描。
