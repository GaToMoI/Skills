# KMP & Compose 交付前 6 步静态审查清单 (Review Mode Checklist)

在每次编写或重构 KMP / Compose 代码交付前，AI 必须对照以下 6 项进行自查审查：

---

### 审查项 1：源码集隔离性检查 (SourceSet Isolation)
* [ ] 检查 `commonMain` 中是否存在任何 `android.*`、`UIKit.*` 平台专有包的导入？
* [ ] 检查新增的业务服务是否错误使用了 `expect/actual`？（业务层必须使用 Interface + DI）

### 审查项 2：状态管理规范检查 (State & Concurrency)
* [ ] 检查共享 ViewModel 中是否使用了 `mutableStateOf`？（必须使用 `StateFlow<UiState>`）
* [ ] 检查 `MutableStateFlow` 的状态赋值是否全部使用了原子操作 `_state.update { }`？

### 审查项 3：重组性能与稳定性检查 (Recomposition)
* [ ] 检查所有 `LazyColumn` / `LazyRow` 是否已显式声明稳定的 `key`？
* [ ] 检查高频变化的状态（如滚动 Offset、高频动画）是否使用了 Lambda Modifier 避免了触发重组？
* [ ] 检查传递给 Composable 的列表参数是否使用了 `@Immutable` 或 `ImmutableList`？

### 审查项 4：生命周期流安全检查 (Lifecycle Safety)
* [ ] 检查 UI 层收集 Flow 时是否使用了生命周期感知的收集器（`collectAsStateWithLifecycle`）？
* [ ] 检查协程启动是否使用了 `viewModelScope` 或与组件生命周期绑定的 `LaunchedEffect(key)`？

### 审查项 5：组件设计契约检查 (Component Contract)
* [ ] 检查公共 Composable 组件第一个可选参数是否为 `modifier: Modifier = Modifier`？
* [ ] 检查基础组件是否完成了状态提升（Stateless）？

### 审查项 6：代码体量红线检查 (500-Line Redline)
* [ ] 检查当前修改或新建的 Kotlin 文件代码量是否控制在 500 行以内？
