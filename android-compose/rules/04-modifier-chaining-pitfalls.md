# 核心准则四：Modifier 链式顺序与交互防坑 (Modifier Chaining & Touch Pitfalls)

## 1. Modifier 链式调用顺序决定渲染与事件结果

Compose 中 Modifier 的链接顺序是**从左向右（从外向内）包裹执行**的，顺序错误会导致严重的 UI 显示错误或手势点击死区。

### 关键顺序对照：点击区域与内边距

```kotlin
// 场景 A：期望整个卡片（含内边距区域）都能点击，且水波纹波及整张卡片（推荐标准）
Modifier
    .clickable { onClick() } // 1. 先声明点击区域为整个外围
    .padding(16.dp)          // 2. 再为内部子元素留出 16dp 内边距

// 场景 B：内边距区域不响应点击，仅内部文字区域响应（容易产生点击死区 Bug）
Modifier
    .padding(16.dp)          // 1. 先缩小可用区域
    .clickable { onClick() } // 2. 点击与水波纹只在缩小后的区域生效
```

---

## 2. 交互与触摸热区四大规范

1. **最小触摸热区标准（Accessibility Target Size）**：
   * 交互按钮的物理点击热区必须满足 Material 规范的 **48dp × 48dp** 最低标准，过小图标必须通过 `Modifier.sizeIn(minWidth = 48.dp, minHeight = 48.dp)` 或使用 `IconButton` 扩展热区。
2. **背景与裁剪（Clip）顺序**：
   * 若需给组件添加圆角与背景，必须**先 Clip 后 Background**：
   ```kotlin
   Modifier
       .clip(RoundedCornerShape(8.dp)) // 先裁剪形状
       .background(MaterialTheme.colorScheme.surface) // 再绘制背景
       .clickable { } // 最后附加上水波纹
   ```
3. **公共组件第一参数契约**：
   * 所有公共对外暴露的 Composable，必须将 `modifier: Modifier = Modifier` 作为第一个带有默认值的可选参数，并应用到根布局节点上。
