# 核心准则二：KMP 源码集隔离与 expect/actual 收敛法则 (KMP Clean Architecture & SourceSet Rules)

## 1. 源码集分层原则 (SourceSet Clean Architecture)

KMP 项目必须严格遵守 Clean Architecture 边界：

```text
shared/src/
├── commonMain/         # 100% 纯 Kotlin：Domain (用例/实体)、Data (Ktor/Room/Repo)、Presentation (Shared ViewModel/Compose)
├── androidMain/        # Android 平台专有实现 (如平台系统通知、相机驱动桥接)
├── iosMain/            # iOS 平台专有实现 (如 Apple Crypto、CoreLocation 桥接)
└── ohosMain/           # OpenHarmony 平台专有实现 (如 Harmony N-API 桥接)
```

### `commonMain` 纯粹性铁律
* **严禁渗入任何平台专有导入**：严禁在 `commonMain` 中导入 `android.content.*`、`android.view.*`、`platform.UIKit.*` 等任何平台类；
* **保持纯 Kotlin 工具库依赖**：仅使用官方多平台库（如 `kotlinx.coroutines`、`kotlinx.serialization`、`kotlinx.datetime`、`Ktor`、`Koin`）。

---

## 2. `expect`/`actual` 黄金收敛法则

### 核心指导思想：接口依赖注入 (DI) > `expect`/`actual`

1. **业务服务与数据层一律使用 Interface + DI**：
   * **错误做法**：声明 `expect class DatabaseDriverFactory` 或 `expect class AccountManager`；
   * **正确标准**：在 `commonMain` 中定义 `interface DatabaseDriverFactory`，在各平台端编写具体实现，并通过 Koin / Kotlin-Inject / 手动构造注入；
   * **根本原因**：`expect`/`actual` 是编译期静态链接，无法在纯 JVM `commonTest` 中被 Mock 或注入 Fake 实现，严重阻碍自动化测试。

2. **`expect`/`actual` 仅限于底层系统无状态桥接**：
   * **允许场景**：获取当前平台类型、获取毫秒时间戳、访问平台原生日志（如 Logcat / NSLog / Hilog）；
   * **命名契约**：按**语义意图**命名（如 `expect fun getPlatformName(): String`），严禁以平台命名（如 `expect fun getAndroidVersion()`）。

3. **Thin Actuals 原则（极薄实现）**：
   * `actual` 内部代码必须极薄（通常只有 1~3 行），仅作向底层系统 API 的转发，**严禁在 `actual` 中编写复杂的业务逻辑、数据转换或控制流**。
