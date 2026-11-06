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

# Android Platform

Rules specific to native Android. **Framework-level Compose rules live in `compose-foundations`; KMP architecture in `kmp-architecture`.**

---

## 1 · Edge-to-edge and insets

- **Android 15+ mandates** `enableEdgeToEdge()` (in `Activity.onCreate`, before `setContent`).
- The `paddingValues` provided by `Scaffold` **must be consumed** — never ignore them and hardcode a status-bar height.
- When manual handling is needed, use `WindowInsets.safeDrawing` / `Modifier.windowInsetsPadding(...)`; **do not** read `LocalWindowInsets` and assemble numbers yourself.
- 🚫 **Accompanist Insets is deprecated** (merged into official `androidx.compose.foundation.layout`).

> Details: [`references/edge-to-edge-insets.md`](references/edge-to-edge-insets.md) (zh)

---

## 2 · Context memory safety

- 🚫 **Never** inject an `Activity` / `Context` into a ViewModel (a long-lived object holding a short-lived one = leak).
  - When resources are needed, use `AndroidViewModel` + `Application`, or pass strings / resource IDs in.
- Keep `LocalContext.current`'s **scope tight**: use it immediately inside the composable; never store it in `remember` where a long-lived object can capture it.
- When caching a Context-derived object in `remember`, confirm its lifetime does not exceed the composition.

> Cases: [`references/context-memory-safety.md`](references/context-memory-safety.md) (zh)

---

## 3 · Type-safe navigation

- 🚫 **String-concatenated routes are deprecated** (`"detail/$id"` and the like).
- ✅ Use Navigation Compose's **Type-Safe API**: declare routes as `@Serializable` data classes/objects, with arguments as constructor properties.
- The compiler guarantees argument types; cross-module navigation no longer relies on hand-written string conventions.

> Migration comparison: [`references/type-safe-navigation-preview.md`](references/type-safe-navigation-preview.md) (zh)

---

## 4 · Preview system

- Multiple sizes plus light/dark: `@Preview` with `uiMode = UI_MODE_NIGHT_YES` and `device = Devices.*`, declared as a group.
- Preview functions stay `private` and never pollute the public API; use `@PreviewParameter` to cover multiple states.
- Preview data may be fake for rendering, but **never** loosen visibility or add branches in production code to accommodate it.

> Details: [`references/type-safe-navigation-preview.md`](references/type-safe-navigation-preview.md) (zh)

---

## 5 · Pre-delivery checklist

Work through [`references/android-checklist.md`](references/android-checklist.md) (zh): insets handling → side-effect cleanup → Context reference safety → Modifier order → type-safe navigation.
