# 核心准则四：StateFlow 驱动的 MVI/UDF 架构与单测设计 (StateFlow & MVI/UDF Architecture)

## 1. 单向数据流 (Unidirectional Data Flow - UDF)

共享 ViewModel 必须遵循严格的 MVI 模式：

```text
[UI View] ───(Intent / User Event)───► [ViewModel]
   ▲                                         │
   │                                         ▼
   └───────(StateFlow<UiState>)────────[State Update]
```

### 状态定义与暴露标准模板

```kotlin
// 1. 状态定义为不可变数据类 (Immutable)
@Immutable
data class ProjectUiState(
    val isLoading: Boolean = false,
    val items: ImmutableList<ProjectItem> = persistentListOf(),
    val errorMessage: String? = null
)

// 2. ViewModel 中私有可变 + 公开只读
class ProjectViewModel(
    private val repository: ProjectRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(ProjectUiState())
    val uiState: StateFlow<ProjectUiState> = _uiState.asStateFlow()

    // 3. 状态修改必须使用原子操作 update { }
    fun onRefresh() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true, errorMessage = null) }
            try {
                val data = repository.fetchProjects()
                _uiState.update { it.copy(isLoading = false, items = data.toImmutableList()) }
            } catch (e: Exception) {
                _uiState.update { it.copy(isLoading = false, errorMessage = e.message) }
            }
        }
    }
}
```

---

## 2. 为什么坚持 `StateFlow` 而非 `mutableStateOf`？

1. **跨端表现层一致性**：
   * `StateFlow` 属于纯 Kotlin 协程标准，iOS 端可以使用 `KMP-NativeCoroutines` 或 `SKIE` 自动转为 Swift 的 `AsyncSequence` / SwiftUI `@Published`，无需强迫 iOS 依赖 Compose Runtime；
2. **纯 JVM 极速单元测试**：
   * 在 `commonTest` 目录下，使用 `Turbine` 库即可在纯 JVM 环境下秒级完成状态断言，无需任何真机或 Snapshot 环境：
   ```kotlin
   @Test
   fun testRefreshSuccess() = runTest {
       viewModel.uiState.test {
           assertEquals(false, awaitItem().isLoading) // 初始状态
           viewModel.onRefresh()
           assertEquals(true, awaitItem().isLoading)  // 加载中
           assertEquals(2, awaitItem().items.size)    // 成功加载
       }
   }
   ```
