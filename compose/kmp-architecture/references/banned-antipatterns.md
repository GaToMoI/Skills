# 核心准则一：禁止的反模式与现代跨端标准对照表 (Banned Antipatterns Reference)

在 Kotlin Multiplatform (KMP) 和 Compose Multiplatform 研发中，AI **严禁生成任何已废弃或存在并发/内存/跨端缺陷的反模式代码**。所有代码必须严格按照下表右侧的现代标准实现：

---

## 1. 核心反模式与现代标准对照表

| 严禁的反模式 (Antipattern ❌) | 现代强制标准做法 (Right Pattern ✅) | 根本工程原因 |
| :--- | :--- | :--- |
| `_state.value = state.copy(...)` | `_state.update { it.copy(...) }` | **防并发竞态**：`update` 底层基于原子 CAS 操作，保证多协程/多线程并发写入时状态安全。 |
| 在共享 ViewModel 中使用 `mutableStateOf` | 使用 `StateFlow<UiState>` + `Immutable` | **保证跨端通用性与单测可行性**：`mutableStateOf` 强耦合 Compose Runtime，导致 iOS/非 Compose 平台无法原生观察，且纯 JVM 单测困难。 |
| `collectAsState()` 裸收集 | `collectAsStateWithLifecycle()`（或跨端生命周期流收集器） | **防后台资源泄漏**：离开前台时自动暂停 Flow 收集，避免后台无感耗电与无效运算。 |
| `GlobalScope.launch { }` / 裸协程 | `viewModelScope.launch { }` / 结构化 CoroutineScope | **防内存泄漏**：协程必须与页面/生命周期强绑定，离开时自动 Cancel。 |
| `LazyColumn` / `LazyRow` 不传 key | `items(list, key = { it.id })` | **防无效全量重组与滚动错位**：显式 key 保证列表局部增删移动时仅重组变更项。 |
| 在 Composable 函数体内高频读取 State 驱动动效 | 使用 Lambda Modifier（如 `Modifier.offset { ... }`） | **跳过重组阶段**：延迟到 Layout/Draw 阶段读取状态，彻底规避高频 Composition 损耗。 |
| 在 `commonMain` 中引用平台专有类（如 `Context` / `UIKit`） | `commonMain` 定义接口，平台端实现并通过 DI 注入 | **防止抽象泄漏**：保持跨端核心逻辑纯粹，杜绝平台代码污染共享源码集。 |
| 业务层滥用 `expect`/`actual` | 使用 Interface + 依赖注入（如 Koin / Kotlin-Inject） | **可测试性与模块解耦**：`expect`/`actual` 属于静态绑定，难以编写 Mock/Fake 单测，仅限底层系统无状态桥接。 |
| 硬编码魔数 / 字符串字面量 | `Res.string.xxx` / 统一 `DesignTokens` | **支持跨端多语言**与统一主题规范。 |
