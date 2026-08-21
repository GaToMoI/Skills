---
name: android-compose
description: >-
  Android Native Jetpack Compose development standards. Enforces Android 15+ enableEdgeToEdge and WindowInsets consumption, strict side-effect lifecycle management (LaunchedEffect, DisposableEffect, rememberUpdatedState), Context memory leak prevention, Modifier ordering and touch targets, Type-Safe Navigation Compose, and multi-device preview patterns. Activate when developing native Android Compose applications.
---

# Android Jetpack Compose 原生开发规范 (Android Compose Skill)

本技能定义了 **Android 原生 Jetpack Compose** 应用开发的现代架构准则、副作用管理、内存安全与组件设计契约。

本项目采用**分层模块化架构（Progressive Disclosure / 渐进式披露）**，主入口提供触发条件与规则索引，具体技术规范按需查阅各子规则文件。

---

## 触发与识别条件 (Trigger Conditions)

当工作区或当前任务满足以下任一条件时，自动激活本技能：
1. 项目包含 `AndroidManifest.xml`、`androidApp/` 或 `com.android.application` / `com.android.library` 插件；
2. 源码直接使用 Android 专有 UI 库（`androidx.activity.compose`、`androidx.lifecycle.compose`、`androidx.navigation.compose`）；
3. 任务涉及 Android 原生 Activity 生命周期、沉浸式全面屏（Edge-to-Edge）、Android Context 交互。

---

## 核心规则路由索引 (Rules Index)

| 规则模块 | 核心定位与要义 | 详细规范路径 |
| :--- | :--- | :--- |
| **01. 沉浸式与 Insets 规约** | Android 15+ 强制 `enableEdgeToEdge()`；`Scaffold` 内边距强制消费；废弃 Accompanist。 | [`./rules/01-edge-to-edge-insets.md`](./rules/01-edge-to-edge-insets.md) |
| **02. 副作用与生命周期管理** | `LaunchedEffect` 精准 key；`DisposableEffect` 强制清理；`rememberUpdatedState` 闭包防刷。 | [`./rules/02-compose-side-effects.md`](./rules/02-compose-side-effects.md) |
| **03. Context 内存安全底线** | 严禁 Activity Context 注入 ViewModel；`LocalContext.current` 作用域收敛防泄漏。 | [`./rules/03-context-memory-safety.md`](./rules/03-context-memory-safety.md) |
| **04. Modifier 顺序与交互防坑** | `clickable` 与 `padding` 链式调用顺序（水波纹与死区）；48dp 最小触摸热区；首参契约。 | [`./rules/04-modifier-chaining-pitfalls.md`](./rules/04-modifier-chaining-pitfalls.md) |
| **05. Type-Safe 导航与 Preview** | 废弃字符串拼接路由，使用 `@Serializable` 类型安全导航；多尺寸与深浅色 Preview 注解。 | [`./rules/05-type-safe-navigation-preview.md`](./rules/05-type-safe-navigation-preview.md) |

---

## 审查手册 (References)

* **Android 原生 Compose 交付自查清单**：[`./references/android-compose-checklist.md`](./references/android-compose-checklist.md)
  * 在交付代码前对照清单逐一自查 Insets 适配、副作用清理、Context 引用安全与 Modifier 顺序。
