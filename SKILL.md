---
name: universal-skills-router
description: >-
  Top-level skills router for the universal engineering skills repository.
  Always activates engineering-discipline as the global baseline, then conditionally
  loads project-type-specific skills (kmp-compose, android-compose) and toolchain
  on demand. Use for ALL projects — this is the single entry point.
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

## 按需激活：工具链与环境配置

**`toolchain`** 技能不自动激活，在以下场景手动加载：

- 用户要求配置/安装开发工具链
- 需要初始化 Scoop 包管理器或安装 CLI 工具
- 需要终端主题（WezTerm/Zellij）配置
- AI 需要选型决策（用 `fd` 还是 `find`、`rg` 还是 `grep`）

> 详见 [`./toolchain/SKILL.md`](./toolchain/SKILL.md)

---

## 加载流程总结

```text
                    ┌──────────────────────────┐
                    │  加载 SKILL.md (本文件)    │
                    └──────────┬───────────────┘
                               │
                    ┌──────────▼───────────────┐
                    │  engineering-discipline   │
                    │  （无条件始终激活）         │
                    └──────────┬───────────────┘
                               │
              ┌────────────────┼────────────────┐
              ▼                ▼                ▼
      ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
      │ kmp-compose  │ │android-compose│ │  toolchain   │
      │ （KMP项目）   │ │（Android项目） │ │ （按需手动）  │
      └──────────────┘ └──────────────┘ └──────────────┘
```