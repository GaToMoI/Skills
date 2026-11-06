---
name: compose-foundations
description: >-
  Framework-level Compose rules shared by Compose Multiplatform and native Android: effect lifecycle
  (LaunchedEffect keys, DisposableEffect cleanup, rememberUpdatedState), Modifier chaining order and 48dp
  touch targets, recomposition performance (stability, deferred reads, derivedStateOf), and the Composable
  component design contract (modifier-first parameter, Slot API).
  Use when writing any @Composable function, managing side effects, building reusable components, or when
  a UI is recomposing too often or a Modifier behaves unexpectedly. Not platform-specific, not KMP-specific.
---

# Compose 通用规范 (Compose Foundations)

> **非规范镜像**：本文件是 `SKILL.md`（英文，规范版）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。


KMP 与 Android 共用。**平台特化部分见 `kmp-architecture` / `android-platform` 技能。**

---

## 一 · 副作用与生命周期

| API | 铁律 |
|:--|:--|
| `LaunchedEffect` | key 必须**精准**；用 `Unit` 时确认真的只需执行一次 |
| `DisposableEffect` | **强制清理**（监听、订阅、回调必须 `onDispose` 反注册） |
| `rememberUpdatedState` | 长生命周期 effect 内引用**可变闭包**时必须包一层，防过期捕获 |
| `derivedStateOf` | 仅用于**减少重组触发**的派生计算，不是为了"好看" |

🚫 禁止：在 Composable 主体内直接启动协程 / 副作用（`GlobalScope.launch` 等）。

> 判例与反例：[`references/compose-side-effects.md`](references/compose-side-effects.md)

---

## 二 · Modifier 顺序与交互

- `clickable` 与 `padding` 的**链式顺序**决定水波纹范围与触摸死区——顺序写错会导致"看起来对但点不到"。
- **48dp 最小触摸热区**（Material 标准），图标按钮需显式撑开。
- 公共组件**首选参数必须是** `modifier: Modifier = Modifier`，由调用方决定外部布局。

> 顺序对照与防坑：[`references/modifier-chaining-pitfalls.md`](references/modifier-chaining-pitfalls.md)

---

## 三 · 重组性能

| 手段 | 用途 |
|:--|:--|
| `@Immutable` / `@Stable` | 参数稳定性标注，让 Compose 跳过重组 |
| `ImmutableList` / 持久化集合 | 替代 `List`（`List` 被 Compose 视为不稳定） |
| Lambda Modifier 延迟读取 | 用 `Modifier.offset { }` 等 lambda 版跳过重组 |
| `derivedStateOf` | 派生状态，减少下游重组 |
| 列表 `key` | `LazyColumn` 的 `items(key = ...)` 必须提供 |

🚫 禁止：把不稳定类型直接当 Composable 参数传递而不加稳定性标注。

> 详表：[`references/recomposition-performance.md`](references/recomposition-performance.md)

---

## 四 · Composable 组件设计契约

- 公共组件：**`modifier: Modifier = Modifier` 作为首个可选参数**。
- **Slot API** 优先：用 `content: @Composable () -> Unit` 槽位解耦，而非堆砌布尔开关。
- 设计令牌（DesignTokens）跨端统一，禁止在组件内硬编码色值/尺寸。
- 状态提升：组件本身尽量无状态（stateless），状态由调用方持有。

> 契约细则：[`references/composable-component-contract.md`](references/composable-component-contract.md)
