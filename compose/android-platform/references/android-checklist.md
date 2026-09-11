# Android 原生 Compose 交付前 6 步静态审查清单 (Review Mode Checklist)

在交付 Android Jetpack Compose 业务代码前，AI 必须对照以下 6 项逐一自查：

---

### 审查项 1：全面屏与 Insets 边距检查
* [ ] Activity 中是否已在 `setContent` 前调用 `enableEdgeToEdge()`？
* [ ] `Scaffold` 的 `innerPadding` 是否已被内容根布局显式消费？是否存在状态栏/导航栏遮挡？

### 审查项 2：副作用与清理机制检查
* [ ] 是否存在未注销的系统监听器？`DisposableEffect` 内部是否有对应的 `onDispose { }` 清理逻辑？
* [ ] `LaunchedEffect` 的 `key` 是否完整准确？是否存在裸启动协程的反模式？

### 审查项 3：Context 内存安全检查
* [ ] ViewModel 中是否绝对没有持有 Activity 或 View 相关的 Context 引用？
* [ ] `LocalContext.current` 是否仅在 UI 层即时使用，未被泄露给静态单例？

### 审查项 4：Modifier 顺序与触摸热区检查
* [ ] `Modifier.clickable` 与 `Modifier.padding` 的相对顺序是否符合设计意图（水波纹覆盖完整卡片）？
* [ ] 公共 Composable 第一个可选参数是否保留了 `modifier: Modifier = Modifier` 且应用到了根节点？
* [ ] 交互按钮点击热区是否达到 48dp × 48dp 最小无障碍标准？

### 审查项 5：路由导航与状态流收集检查
* [ ] 页面流收集是否使用了 `collectAsStateWithLifecycle()`？
* [ ] 导航是否采用了 `@Serializable` 驱动的类型安全路由（Type-Safe Navigation）？

### 审查项 6：代码体量红线检查
* [ ] 当前修改或新建的 Kotlin 文件代码行数是否严格控制在 500 行以内？
