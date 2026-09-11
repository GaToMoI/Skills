# 核心准则一：沉浸式全面屏与 WindowInsets 规约 (Edge-to-Edge & WindowInsets Guidelines)

## 1. 强制启用 `enableEdgeToEdge()` (Android 15+ 标准)

* **Activity 初始化规范**：
  * 在 `ComponentActivity.onCreate()` 中调用 `setContent { }` 之前，**必须显式调用 `enableEdgeToEdge()`**（来自 `androidx.activity`）；
  * **废弃库禁令**：严禁引入或使用已废弃的 Accompanist `SystemUiController`，全面拥抱原生 Insets API。

```kotlin
// 正确标准做法
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge() // 必须置于 setContent 之前
        super.onCreate(savedInstanceState)
        setContent {
            AppTheme {
                MainScreen()
            }
        }
    }
}
```

---

## 2. Insets 边距消费与布局适配

1. **Scaffold 内边距强制消费 (Mandatory Inner Padding)**：
   * 使用 `Scaffold` 时，其提供的 `innerPadding`（`PaddingValues`）**必须传递给内部内容根节点**，防止内容被系统状态栏（Status Bar）、底部手势导航条（Navigation Bar）或输入法（IME）遮挡。
   ```kotlin
   Scaffold(
       modifier = Modifier.fillMaxSize(),
       topBar = { TopAppBar(...) }
   ) { innerPadding ->
       // 必须消费 innerPadding
       Box(modifier = Modifier.fillMaxSize().padding(innerPadding)) {
           ContentScreen()
       }
   }
   ```
2. **细粒度 WindowInsets 修饰符**：
   * 不需要全屏 Scaffold 时，使用以下标准修饰符自适应系统栏：
     * `Modifier.safeDrawingPadding()`：自动适配系统栏与切口屏（Cutout）；
     * `Modifier.windowInsetsPadding(WindowInsets.ime)`：输入法软键盘弹出自适应；
     * `Modifier.windowInsetsPadding(WindowInsets.statusBars)`：状态栏独立内边距。
3. **严禁硬编码系统栏高度**：
   * 严禁在代码中写死 `48.dp`、`24.dp` 等魔数来假设状态栏或导航栏高度。
