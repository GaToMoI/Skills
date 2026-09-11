# 核心准则二：副作用 API 与生命周期精准管理 (Compose Side-Effects Guidelines)

## 1. 副作用 API 选型矩阵与边界

在 Compose 中管理副作用（如异步请求、资源监听、定时器）时，必须严格对照下表选型：

| API 类型 | 核心定位与使用场景 | 必须配套的规范 |
| :--- | :--- | :--- |
| **`LaunchedEffect(key)`** | 在协程中执行挂起函数（如加载数据、触发单次动效、监听特定状态变更）。 | `key` 必须精准声明依赖；严禁无条件传入 `Unit` 除非该任务在整个组件生命周期内只执行一次。 |
| **`DisposableEffect(key)`** | 需要明确清理/注销资源的场景（如注册广播接收器、LifecycleObserver、硬件传感器、ViewTreeObserver）。 | **必须在 `onDispose { }` 块中执行注销/清理逻辑**，防止内存泄漏。 |
| **`rememberUpdatedState(value)`** | 在长期运行的 Effect（如计时器/动画）内部引用外部频繁变动的 Lambda/值。 | 避免因为 Lambda 实例改变而导致 Effect 无意义反复取消并重启。 |
| **`produceState(initialValue)`** | 将非 Compose 的异步数据源（如 RxJava、第三方 SDK 回调）转为 Compose State。 | 内部提供 `awaitDispose { }` 确保组件离开组合时终止监听。 |
| **`SideEffect { }`** | 仅用于将 Compose 状态发布给非 Compose 对象（如向外部分析 SDK 打点、更新系统属性）。 | **严禁在 `SideEffect` 内部启动协程或执行耗时阻塞操作**。 |

---

## 2. 经典反模式与正解

### 场景 1：注销系统监听器
```kotlin
// 正确标准做法
@Composable
fun SystemBroadcastReceiver(
    systemAction: String,
    onReceive: (Intent?) -> Unit
) {
    val context = LocalContext.current
    val currentOnReceive by rememberUpdatedState(onReceive)

    DisposableEffect(context, systemAction) {
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                currentOnReceive(intent)
            }
        }
        val filter = IntentFilter(systemAction)
        context.registerReceiver(receiver, filter)

        onDispose {
            // 必须安全注销
            context.unregisterReceiver(receiver)
        }
    }
}
```

### 场景 2：严禁裸启动协程
* **错误**：严禁在 Composable 函数顶层直接执行异步逻辑或全局协程 `GlobalScope.launch`；
* **正确**：用户点击触发的异步事件必须使用 `rememberCoroutineScope().launch { }`；进入页面自动触发的异步任务使用 `LaunchedEffect`。
