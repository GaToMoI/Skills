# 核心准则三：Compose Multiplatform 重组性能优化 (Compose Recomposition Performance)

## 1. 保证参数稳定性 (Stability & Skippability)

Compose 编译器通过推断参数类型是否为 `@Stable` 或 `@Immutable` 来决定是否跳过重组（Smart Recomposition）：

1. **集合类型稳定性**：
   * **隐患**：标准库的 `List<T>`、`Set<T>`、`Map<K, V>` 在 Compose 编译器眼里默认是**不稳定（Unstable）**的接口类型，容易导致父组件重组时子组件无条件被动重组；
   * **解决方案**：
     * 使用 `kotlinx.collections.immutable` 的 `ImmutableList<T>` / `PersistentList<T>`；
     * 或在包装的数据类上显式添加 `@Immutable` / `@Stable` 注解。
2. **Lambda 闭包捕获优化**：
   * 传递给 Composable 的事件回调（如 `onClick: () -> Unit`），避免在 Composable 作用域内声明不稳定捕获，优先使用方法引用或无捕获闭包。

---

## 2. 延迟状态读取 (Deferred State Reads)

Compose 的渲染包含三个阶段：**Composition（重组） ➔ Layout（布局） ➔ Draw（绘制）**。

1. **高频变化状态使用 Lambda Modifier**：
   * **错误做法 (触发高频重组)**：
     ```kotlin
     // 每次 scrollOffset 改变都会触发整个 Box 的重组！
     Box(modifier = Modifier.offset(x = scrollOffset.dp))
     ```
   * **正确做法 (跳过重组阶段)**：
     ```kotlin
     // 状态读取延迟到 Layout 阶段，重组次数降为 0
     Box(modifier = Modifier.offset { IntOffset(x = scrollOffset.roundToInt(), y = 0) })
     ```
2. **复杂派生状态使用 `derivedStateOf`**：
   * 当基于一个高频状态计算出一个低频布尔值/标志位时（如根据滑动位置计算是否显示“回到顶部”按钮），必须包裹在 `remember { derivedStateOf { ... } }` 中，只有计算结果真正改变时才触发下游重组。

---

## 3. 列表组件必须显式指定 `key`

* 所有 `LazyColumn` / `LazyRow` / `LazyVerticalGrid` 的 `items` 必须显式声明唯一稳定的 `key`：
  ```kotlin
  items(
      items = projectList,
      key = { project -> project.id } // 保证局部增删时不发生全列表重组与动画错位
  ) { project ->
      ProjectCard(project = project)
  }
  ```
