---
name: android-platform
description: >-
  Android-specific Compose platform rules: Android 15+ edge-to-edge with mandatory WindowInsets consumption,
  Activity/Context memory-leak prevention (never inject Activity Context into ViewModel), Type-Safe Navigation
  Compose with @Serializable routes, and multi-device/light-dark Preview patterns.
  Use when working in a native Android project (AndroidManifest.xml, com.android.application, androidApp/,
  androidx.activity.compose), when handling insets or status/navigation bars, when wiring navigation routes,
  or when writing @Preview blocks.
---

# Android 平台规范 (Android Platform)

> **非规范镜像**：本文件是 `SKILL.md`（英文，规范版）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。


原生 Android 平台特化规则。**Compose 框架层规则见 `compose-foundations` 技能；KMP 架构见 `kmp-architecture`。**

---

## 一 · 沉浸式与 Insets

- **Android 15+ 强制** `enableEdgeToEdge()`（在 `Activity.onCreate` 中，`setContent` 之前）。
- `Scaffold` 提供的 `paddingValues` **必须消费**——禁止无视后自行硬编码状态栏高度。
- 需要手动处理时用 `WindowInsets.safeDrawing` / `Modifier.windowInsetsPadding(...)`，**不要**读 `LocalWindowInsets` 拼数值。
- 🚫 **废弃 Accompanist Insets**（已合入官方 `androidx.compose.foundation.layout`）。

> 细则：[`references/edge-to-edge-insets.md`](references/edge-to-edge-insets.md)

---

## 二 · Context 内存安全

- 🚫 **严禁**把 `Activity` / `Context` 注入 ViewModel（长生命周期持有短生命周期 = 泄漏）。
  - 需要资源时用 `AndroidViewModel` + `Application`，或把字符串/资源 ID 传进去。
- `LocalContext.current` 的**作用域必须收敛**：仅在 Composable 内即时使用，禁止存入 `remember` 后被长生命周期对象捕获。
- `remember` 中缓存 Context 派生对象时，确认其生命周期不长于 Composition。

> 判例：[`references/context-memory-safety.md`](references/context-memory-safety.md)

---

## 三 · Type-Safe 导航

- 🚫 **废弃字符串拼接路由**（`"detail/$id"` 这类）。
- ✅ 使用 Navigation Compose 的 **Type-Safe API**：路由声明为 `@Serializable` 数据类/对象，参数是构造属性。
- 参数类型由编译器保证，模块间跳转不再依赖手写字符串约定。

> 迁移对照：[`references/type-safe-navigation-preview.md`](references/type-safe-navigation-preview.md)

---

## 四 · Preview 体系

- 多尺寸 + 深浅色：`@Preview` 配合 `uiMode = UI_MODE_NIGHT_YES`、`device = Devices.*`，成组声明。
- Preview 函数保持 `private`，不污染公共 API；用 `@PreviewParameter` 覆盖多状态。
- 预览数据用假数据便于渲染，**不得**为此在生产代码中放宽可见性或加分支。

> 细则：[`references/type-safe-navigation-preview.md`](references/type-safe-navigation-preview.md)

---

## 五 · 交付前自检

逐项过 [`references/android-checklist.md`](references/android-checklist.md)：Insets 适配 → 副作用清理 → Context 引用安全 → Modifier 顺序 → 导航类型安全。
