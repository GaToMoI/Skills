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

# Compose Foundations

Shared by KMP and Android. **Platform-specific rules live in `kmp-architecture` / `android-platform`.**

---

## 1 · Side effects and lifecycle

| API | Iron rule |
|:--|:--|
| `LaunchedEffect` | Keys must be **exact**; when using `Unit`, confirm it truly must run only once |
| `DisposableEffect` | **Cleanup is mandatory** — listeners, subscriptions, and callbacks must be unregistered in `onDispose` |
| `rememberUpdatedState` | Wrap any **mutable closure** captured by a long-lived effect, to prevent stale capture |
| `derivedStateOf` | Only for derived computation that **reduces recomposition** — never for aesthetics |

🚫 Forbidden: launching coroutines or side effects directly in a composable body (`GlobalScope.launch`, etc.).

> Cases and counter-examples: [`references/compose-side-effects.md`](references/compose-side-effects.md) (zh)

---

## 2 · Modifier order and interaction

- The **chaining order** of `clickable` and `padding` decides ripple bounds and touch dead zones — the wrong order gives "looks right but cannot be tapped".
- **48dp minimum touch target** (Material standard); icon buttons must be expanded explicitly.
- A shared component's **first parameter must be** `modifier: Modifier = Modifier`, letting the caller own external layout.

> Order comparisons and pitfalls: [`references/modifier-chaining-pitfalls.md`](references/modifier-chaining-pitfalls.md) (zh)

---

## 3 · Recomposition performance

| Lever | Purpose |
|:--|:--|
| `@Immutable` / `@Stable` | Mark parameter stability so Compose can skip recomposition |
| `ImmutableList` / persistent collections | Replace `List` (Compose treats `List` as unstable) |
| Lambda-based Modifiers (deferred reads) | `Modifier.offset { }` and friends skip recomposition |
| `derivedStateOf` | Derived state that spares downstream recomposition |
| List `key` | `LazyColumn`'s `items(key = ...)` is mandatory |

🚫 Forbidden: passing an unstable type directly as a composable parameter without a stability annotation.

> Full table: [`references/recomposition-performance.md`](references/recomposition-performance.md) (zh)

---

## 4 · Composable design contract

- Shared components: **`modifier: Modifier = Modifier` as the first optional parameter**.
- **Prefer the Slot API**: decouple with `content: @Composable () -> Unit` slots instead of piling up boolean switches.
- Design tokens are shared across platforms; never hardcode colours or dimensions inside a component.
- State hoisting: keep components stateless where possible; the caller owns the state.

> Contract details: [`references/composable-component-contract.md`](references/composable-component-contract.md) (zh)
