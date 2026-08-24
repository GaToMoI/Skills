---
name: universal-skills-router
description: >-
  Top-level skills router for the universal engineering skills repository.
  Always activates engineering-discipline and toolchain as the global baseline,
  then conditionally loads project-type-specific skills (kmp-compose, android-compose).
  Use for ALL projects — this is the single entry point.
---

# 通用技能路由入口 (Universal Skills Router)

本文件是整个技能库的**唯一入口**。AI 助手在任意项目中都应首先加载本文件，然后按项目类型按需加载对应子技能。

---

## 始终激活：全局通用工程纪律

**`engineering-discipline`** 是全局基准技能，**所有项目、所有任务**都必须无条件遵循。它定义了：

| 准则 | 要义 |
|:---|:---|
| 事实查验与官方标准优先 | 拒绝凭空臆想，4 级执行序查证 |
| 客观直率，杜绝谄媚 | 禁用迎合套话，直陈架构缺陷 |
| 需求争议主动对齐 | 存疑即停，提供 2~3 个合规备选 |
| 源码 500 行红线 | 全语言单文件 ≤ 500 行，主动拆分 |
| 目标平台优先级与架构基准 | 明确主攻端，禁止无关平台妥协 |
| 架构文档维护规约 | 根目录/模块 README 与 `docs/explain/` 同步 |
| UI 资产规范（条件触发） | 有设计源禁字符拟态，无源用标准矢量 |
| 需求默认二次核对 | 三步核对（复述+推演+改动清单）后动工 |
| 代码注释完整性 | 解释"为什么"而非"做什么" |

> 详细规则参见 [`./engineering-discipline/SKILL.md`](./engineering-discipline/SKILL.md)

---

## 始终激活：AI 高效工具链与选型路由

**`toolchain`** 也是全局基准技能，**所有项目、所有任务**都必须无条件遵循。它定义了：

| 规则 | 要义 |
|:---|:---|
| 工具存在性前置检查 | **使用工具前必须先检查是否存在**，不存在则降级或提示安装 |
| 场景选型决策树 | 找文件→`fd`、搜代码→`rg`、改结构→`ast-grep`、析JSON→`jq`、截日志→`rtk` |
| 禁止低效工具 | 🚫 `find /`、🚫 `grep -r` 全量递归、🚫 裸跑 `gradlew`、🚫 原始 JSON 灌入 |
| Scoop 环境初始化 | 按需引导安装 Scoop 及核心工具包 |

> 详细规则参见 [`./toolchain/SKILL.md`](./toolchain/SKILL.md)

### 🔴 工具存在性前置检查（强制）

在执行任何 CLI 命令前，AI 必须遵循以下检查流程：

```text
[准备使用高效工具 (fd/rg/rtk/jq/ast-grep/bat/delta)]
   │
   ├──► 1. 快速检查工具是否存在（任选其一）：
   │       Windows:  Get-Command <tool> -ErrorAction SilentlyContinue
   │       Unix:     which <tool> || command -v <tool>
   │
   ├──► 2. ✅ 存在 → 直接使用高效工具
   │
   └──► 3. ❌ 不存在 → 按降级策略执行：
           ├── fd 缺失     → 降级用 find（必须加 -maxdepth + 排除 .git/build/.gradle）
           ├── rg 缺失     → 降级用 grep -r（必须限定路径 + --include 过滤）
           ├── rtk 缺失    → 降级用 --quiet 或 | tail -20 手动截断
           ├── jq 缺失     → 降级用 read + 手工定位关键字段
           ├── ast-grep 缺失 → 降级用 rg 正则（需人工复核边界）
           ├── bat 缺失    → 降级用 read 切片
           └── delta 缺失  → 降级用 git diff 原生输出
           
           同时提示用户可一键安装：
           scoop install ripgrep fd jq bat ast-grep rtk 7zip
```

> ⚠️ **绝对禁止**：在不检查工具是否存在的情况下，直接假设工具可用并调用，导致命令失败浪费交互轮次。

---

## 按项目类型激活：领域专项技能

根据当前工作区的项目特征，按以下决策树加载对应的专项技能：

### 项目类型识别规则

| 检测条件 | 激活技能 | 说明 |
|:---|:---|:---|
| 构建脚本含 `org.jetbrains.kotlin.multiplatform` 或 `org.jetbrains.compose`；<br>源码目录含 `commonMain/`、`composeApp/`、`shared/` | **`kmp-compose`** | KMP 跨端开发规范 |
| 项目含 `AndroidManifest.xml`、`androidApp/` 或 `com.android.application` 插件；<br>源码使用 `androidx.compose.*`、`androidx.activity.compose` 等 | **`android-compose`** | Android 原生 Compose 规范 |
| 同时满足 KMP + Android 条件 | **`kmp-compose`** + **`android-compose`** | 两者同时激活 |
| 以上均不匹配 | 仅 `engineering-discipline` | 通用准则即可 |

### 各技能速览

**`kmp-compose`** — KMP 跨端规范：
- 反模式黑名单（禁 `_state.value=`、禁 ViewModel 中 `mutableStateOf`、列表必带 `key`）
- `commonMain` 纯粹性、接口 DI 优于 `expect/actual`
- Compose 重组性能优化（`@Immutable`、`derivedStateOf`）
- `StateFlow<UiState>` + `_state.update { }` 原子 MVI
- Composable 组件设计契约（Slot API、`modifier` 首参）

> 详见 [`./kmp-compose/SKILL.md`](./kmp-compose/SKILL.md)

**`android-compose`** — Android 原生 Compose 规范：
- Android 15+ `enableEdgeToEdge()` 与 WindowInsets
- 副作用精准管理（`LaunchedEffect`/`DisposableEffect`）
- Context 内存防泄漏
- Modifier 顺序与 48dp 触摸热区
- Type-Safe 导航（`@Serializable`）

> 详见 [`./android-compose/SKILL.md`](./android-compose/SKILL.md)

---

## 加载流程总结

```text
                    ┌──────────────────────────┐
                    │  加载 SKILL.md (本文件)    │
                    └──────────┬───────────────┘
                               │
          ┌────────────────────┼────────────────────┐
          ▼                    ▼                    │
┌──────────────────┐  ┌──────────────────┐          │
│ engineering-      │  │    toolchain     │          │
│ discipline        │  │ （无条件始终激活） │          │
│ （无条件始终激活）  │  │ 工具选型+存在性   │          │
│ 工程纪律+代码规范  │  │ 检查+降级策略    │          │
└──────────────────┘  └──────────────────┘          │
                               │                    │
              ┌────────────────┼────────────────┐
              ▼                ▼                ▼
      ┌──────────────┐ ┌──────────────┐
      │ kmp-compose  │ │android-compose│
      │ （KMP项目）   │ │（Android项目） │
      └──────────────┘ └──────────────┘
```