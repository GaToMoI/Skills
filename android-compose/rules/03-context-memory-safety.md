# 核心准则三：Android Context 内存安全与防泄漏底线 (Context & Memory Safety)

## 1. Context 引用隔离铁律

Android 中的 `Context`（尤其是包含界面资源与主题树的 `Activity Context`）如果被长期持有，极易引发严重内存泄漏（Activity 销毁后无法被 GC 回收）。

### 铁律 1：严禁将 Activity Context 传入 ViewModel
* **错误**：
  ```kotlin
  // 严禁在 ViewModel 构造函数或成员变量中持有 Activity/Context
  class MainViewModel(private val context: Context) : ViewModel()
  ```
* **正确标准**：
  1. 如果 ViewModel 确实需要访问系统资源或服务（如网络连接状态、全局 SharedPreferences），继承 `AndroidViewModel(application)` 或直接注入 `Application Context`；
  2. 优先通过依赖注入（Hilt `@ApplicationContext`）注入全局应用级上下文。

---

## 2. Compose UI 层的 Context 使用规范

1. **统一使用 `LocalContext.current`**：
   * 在 Composable 内部，必须通过 `val context = LocalContext.current` 获取当前上下文；
2. **Context 使用范围收敛**：
   * `LocalContext.current` 仅限用于执行即时性 UI 操作：
     * 启动系统 Activity (`context.startActivity(intent)`)；
     * 弹出系统 Toast (`Toast.makeText(context, ...).show()`)；
     * 获取系统服务 (`context.getSystemService(...)`)。
3. **禁止将 `LocalContext.current` 缓存至全局静态对象**：
   * 严禁将 `LocalContext.current` 赋值给任何单例、静态伴生对象（`companion object`）或未受生命周期管理的集合中。
