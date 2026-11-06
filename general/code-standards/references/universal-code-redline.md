# Universal File-Size Redline and Modularity

## 1. Core principles

1. **The 500-line universal hard redline**:
   - **Every source file in an object-oriented or systems language (Kotlin, Java, C++, Swift, TypeScript, C#, …) must not exceed 500 lines.**
   - The recommended healthy range is **100–300 lines**.
2. **Proactive review and responsibility decoupling**:
   - As soon as a file approaches 400–500 lines, review it for single responsibility *while coding* and split it physically. Never pile up god classes or merge components without order.
   - Split files must keep a clear **Single Responsibility Principle**: high cohesion, low coupling.

---

## 2. Splitting tactics per language family

### 1. Kotlin / Swift / modern expressive languages
* **Symptom**: the syntax is dense, so 500 lines here carry roughly the logic of 1000–1500 lines of traditional Java/C++.
* **Tactics**:
  * **Decouple UI components**: break large screens into separate SubComponent, Card, Bar files;
  * **Extract top-level extensions**: move domain-specific data mapping and helpers into `XxxExt.kt` files;
  * **Separate the state container**: move UI state and the logic driving it into a dedicated ViewModel / StateStore file.

### 2. Java / C# classic enterprise languages
* **Symptom**: strict typing and plenty of boilerplate make classes inflate easily.
* **Tactics**:
  * **Composition over inheritance**: split a large class along business facets into collaborating Service / Delegate / Strategy classes;
  * **Trim with modern features**: use Java 14+ `record`, Lombok annotations, and the like to remove meaningless getters/setters/constructors;
  * **Lift inner classes out**: promote large static inner classes, enums, and DTOs into standalone top-level files.

### 3. C++ / systems-level compiled languages
* **Symptom**: declaration and implementation are split (`.h`/`.hpp` vs `.cpp`), and file size directly drives preprocessing, compile, and link time.
* **Tactics**:
  * **Keep headers under control (≤ 300 lines)**: headers hold interface declarations and class structure only; never inline large implementations, which causes cascading include bloat;
  * **Implementation files (≤ 500 lines)**: hide private implementation behind the **Pimpl idiom** (pointer to implementation);
  * **Isolate algorithms**: move complex algorithms into their own translation unit (`.cpp`) or an internal header under `detail/`.
