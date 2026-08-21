# 核心准则五：Composable 组件设计契约与 DesignTokens (Composable Component Contract)

## 1. Composable 公共组件四大契约

### 契约 1：第一个可选参数必须为 `modifier: Modifier = Modifier`
* **规则**：所有对外暴露的公共 Composable 组件，必须将 `modifier` 作为第一个带有默认值的参数；
* **目的**：外层调用方可以自由控制该组件的布局约束（如 padding、fillMaxWidth、alignment），组件内部必须将该 modifier 应用到根布局节点上。

```kotlin
// 正确标准契约
@Composable
fun ProjectCard(
    project: ProjectItem,
    onClick: () -> Unit,
    modifier: Modifier = Modifier // 必须提供默认值且置于可选参数第一位
) {
    Card(
        modifier = modifier.clickable { onClick() }
    ) { ... }
}
```

### 契约 2：Slot API 模式解耦内容
* 对于包含复杂子元素的容器组件（如卡片、TopBar、对话框），优先采用 `@Composable () -> Unit` 槽位（Slot）接收子内容，避免传入几十个零碎参数导致组件僵化。

### 契约 3：状态提升（State Hoisting）
* 基础 UI 组件应当尽可能设计为**无状态组件（Stateless）**：只接收 `State` 和事件回调（`onEvent: () -> Unit`），不直接在组件内部硬编码修改业务状态。

---

## 2. 跨端 DesignTokens 与多语言规范

1. **严禁硬编码字面量**：
   * 严禁在 Composable 内部写死 `Text("确定")`，必须统一使用 Compose Multiplatform 资源系统：`stringResource(Res.string.confirm)`；
2. **尺寸与主题收敛**：
   * 尺寸（Padding、Margin、CornerRadius、IconSize）和颜色值必须统一从 DesignTokens / MaterialTheme 中引用，严禁散落 `17.dp`、`Color(0xFF123456)` 等魔数。
