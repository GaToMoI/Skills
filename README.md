# 通用工程与 AI 协作技能库 (Universal Skills Repository)

本仓库（`D:\GTMI\Skills`）用于归档、沉淀跨项目、跨语言通用的 **AI 协作技能（Skills）** 与 **工程交付准则**。各工程项目可直接软链、引用或复制本仓库中的技能规范。

本技能库采用 **开源分层模块化架构（Progressive Disclosure / 渐进式披露）**，实现超低初始 Token 消耗与按需加载。

---

## 技能目录索引 (Skill Catalog)

| 技能名称 | 目录路径 | 核心定位与适用范围 |
| :--- | :--- | :--- |
| **`engineering-discipline`** | [`./engineering-discipline/SKILL.md`](./engineering-discipline/SKILL.md) | **全语言通用工程纪律与协作准则**：事实查验、低 Token 4 级执行序、零谄媚客观交流、争议主动对齐、500行代码红线（Kotlin/Java/C++等）、文档同步规范、分级UI资产规范及默认二次需求核对机制。 |
| **`kmp-compose`** | [`./kmp-compose/SKILL.md`](./kmp-compose/SKILL.md) | **Kotlin Multiplatform & Compose 跨端开发规范**：`commonMain` 源码集隔离、Clean 架构、接口 DI 替代 `expect/actual`、`StateFlow` 单向数据流、Compose 重组性能优化、反模式黑白名单速查。 |
| **`android-compose`** | [`./android-compose/SKILL.md`](./android-compose/SKILL.md) | **Android 原生 Jetpack Compose 开发规范**：Android 15+ 沉浸式全面屏 `enableEdgeToEdge()`、WindowInsets 消费、副作用精准管理（`LaunchedEffect`/`DisposableEffect`）、Context 内存防泄漏、Modifier 顺序防坑与 Type-Safe 导航。 |

---

## 架构分层结构

```text
D:\GTMI\Skills\
├── README.md                                   # 技能仓库总览与导入指南
├── engineering-discipline\                     # 1. 全语言通用工程纪律与协作准则包
│   ├── SKILL.md
│   ├── rules\
│   └── references\
├── kmp-compose\                                # 2. KMP 跨端与 Compose Multiplatform 专用包
│   ├── SKILL.md
│   ├── rules\
│   └── references\
└── android-compose\                            # 3. Android 原生 Jetpack Compose 专用包
    ├── SKILL.md                                # 主入口 (触发识别与路由)
    ├── rules\                                  # 细分规则
    │   ├── 01-edge-to-edge-insets.md           # 01. 沉浸式全面屏与 Insets 规约
    │   ├── 02-compose-side-effects.md          # 02. 副作用与生命周期管理
    │   ├── 03-context-memory-safety.md         # 03. Context 内存安全底线
    │   ├── 04-modifier-chaining-pitfalls.md    # 04. Modifier 顺序与触摸热区防坑
    │   └── 05-type-safe-navigation-preview.md  # 05. Type-Safe 导航与多形态 Preview
    └── references\
        └── android-compose-checklist.md        # Android 原生交付自查清单
```

---

## 如何在项目中复用本技能库

### 方式 1：项目级引入（推荐，支持团队 VCS 协同）
在具体项目的根目录下创建 `.agents/skills/` 目录，将对应技能软链（或直接复制）至项目中：

* **Windows PowerShell (目录联接 Junction)**:
  ```powershell
  # 软链通用工程准则
  New-Item -ItemType Junction -Path "D:\YourProject\.agents\skills\engineering-discipline" -Target "D:\GTMI\Skills\engineering-discipline"

  # 软链 KMP 跨端规范
  New-Item -ItemType Junction -Path "D:\YourProject\.agents\skills\kmp-compose" -Target "D:\GTMI\Skills\kmp-compose"

  # 软链 Android 原生 Compose 规范
  New-Item -ItemType Junction -Path "D:\YourProject\.agents\skills\android-compose" -Target "D:\GTMI\Skills\android-compose"
  ```
* **复制方式**:
  ```powershell
  Copy-Item -Recurse "D:\GTMI\Skills\android-compose" "D:\YourProject\.agents\skills\"
  ```

### 方式 2：全局用户级配置
可将技能目录放置在 AI 工具的全局配置目录中，使其对本地所有工程默认生效：
* 全局路径示例：`~/.gemini/config/skills/` 或本地 Agent 配置根路径。
