---
name: kmp-architecture
description: >-
  Kotlin Multiplatform architecture rules: commonMain purity, Clean Architecture layering, interface-based DI
  preferred over expect/actual, StateFlow-driven MVI with atomic updates, the banned-antipattern list, and the
  pre-delivery checklist. Use when working in a Kotlin Multiplatform project (commonMain/shared/composeApp
  source sets, org.jetbrains.kotlin.multiplatform or org.jetbrains.compose plugins), when designing shared
  state holders, or when deciding between expect/actual and an interface.
---

# KMP Architecture

Platform-agnostic cross-platform architecture and state management. **Framework-level Compose rules live in the `compose-foundations` skill.**

---

## 1 · Banned antipatterns (quick reference)

| Antipattern | Replacement |
|:--|:--|
| `_state.value = ...` | `_state.update { }` (atomic update) |
| `mutableStateOf` inside a ViewModel | `MutableStateFlow` + `StateFlow<UiState>` |
| Collecting a bare Flow (no lifecycle awareness) | `collectAsStateWithLifecycle` / `stateIn` |
| List items without `key` | `items(key = { it.id })` |
| State class without `@Immutable` | Add the stability annotation |

> Full do/don't table: [`references/banned-antipatterns.md`](references/banned-antipatterns.md) (zh)

---

## 2 · Source-set isolation and Clean layering

- **`commonMain` stays absolutely pure**: no platform APIs, no JVM-only classes, no platform type leaks.
- **Interface DI beats `expect/actual`**: whatever can be solved by inverting behind an interface, do that; `expect/actual` is reserved for **genuinely platform-native capabilities that cannot be abstracted**.
- When `expect/actual` is unavoidable, the `actual` side follows the **razor-thin forwarding rule** — it only delegates, never carries business logic.
- Layering: UI (Composable) → StateHolder/ViewModel → UseCase → Repository → DataSource, dependencies pointing inward only.

> Details: [`references/sourceset-clean-arch.md`](references/sourceset-clean-arch.md) (zh)

---

## 3 · StateFlow, MVI, and unidirectional data flow

- Canonical state-holder shape: `private val _state = MutableStateFlow(UiState())` + `val state: StateFlow<UiState>`.
- **Atomic updates**: always `_state.update { it.copy(...) }`; never read-modify-write as two steps.
- **Unidirectional flow**: the UI sends intents/events, the holder mutates state, the UI observes state to render. The UI never mutates state directly.
- `UiState` must be an **immutable data class**; one-off events travel on their own channel/SharedFlow and never sit inside state.
- Unit tests: plain JVM `Turbine` is enough to verify state transitions; no Android instrumentation required.

> Details: [`references/stateflow-mvi-architecture.md`](references/stateflow-mvi-architecture.md) (zh)

---

## 4 · Pre-delivery checklist

Work through [`references/kmp-checklist.md`](references/kmp-checklist.md) (zh): source-set isolation → atomic state updates → recomposition performance → component contract → antipattern sweep.
