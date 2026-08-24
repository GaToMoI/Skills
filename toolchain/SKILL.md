---
name: toolchain
description: >-
  Universal environment configuration and automated toolchain setup skill.
  Guides AI to detect, configure, and install development toolchains (Scoop package manager,
  curated AI efficiency CLI tools, SDKs, and runtimes), enforce user-specified installation paths,
  and route tool selection to optimal tools for maximum speed and token efficiency.
---

# 开发工具链配置与 AI 高效 CLI 选型技能 (Universal Toolchain Setup & Router)

本技能为 AI 提供开发环境自动化检测、环境初始化、工具链静默配置与精准调度的通用工程规范。支持通过包管理器（如 Scoop）快速搭建 AI 效率工具链与各类 SDK / 运行时环境，并提供可扩展的工具链扩充机制。

---

## 核心设计哲学

1. **用户目录主权优先**：严禁私自硬编码默认安装路径至系统盘（如 C 盘），所有工具链与包管理器初始化前，必须由用户确认或指定目标安装目录。
2. **Token 与时延极客**：优先选用专为极致性能与低 Token 消耗打造的现代原生工具（如 `fd`、`ripgrep`、`ast-grep`、`rtk`、`jq`）。
3. **精准选型路由**：针对不同工程任务建立结构化选型决策树，在合适场景调用最适配工具，彻底规避全盘扫描、慢速 I/O 与 Token 溢出。
4. **高度可扩展性**：支持横向扩展包管理器、语言运行时（Node/Python/Rust/JDK）以及移动端构建工具链（Android SDK/Cmdline-tools/NDK）。
5. **工具变更需用户手动激活**：检查新工具、安装新工具、替换既有工具，**均不得自动执行**，必须由用户明确发起指令后才执行，且安装/替换前必须向用户确认。

---

## 🔴 工具安装/替换/检查：手动激活流程（强制）

**本技能默认不主动检查、不主动安装、不主动替换任何工具。** 以下所有操作**必须由用户明确要求**后才执行：

### 触发条件（仅当用户说以下类似的话时）

- “检查一下最近有没有推出好用的工具”
- “有没有同功能更好用的工具”
- “帮我安装/替换 XX 工具”
- “更新一下工具链”

### 执行流程（用户触发后）

```text
[用户明确要求检查/安装/替换工具]
   │
   ├──► 1. 检索 Scoop 桶 + GitHub 社区数据
   │       ├── 用 scoop-search 快速检索候选工具
   │       ├── 查询 GitHub API 获取 Stars / 活跃度 / 是否归档
   │       └── 对比同功能已有工具（社区共识强度）
   │
   ├──► 2. 整理候选清单，向用户汇报（不安装！）
   │       ├── 新工具：名称 / 功能 / Stars / 活跃度 / 相对已有工具的优势
   │       ├── 替换建议：旧工具 → 新工具，理由
   │       └── 标注社区共识强度（王者级 / 优秀级 / 备选级）
   │
   └──► 3. 等待用户明确确认
           ├── ✅ 用户同意 → 执行 scoop install / scoop uninstall
           └── ❌ 用户拒绝 → 不执行任何变更
```

### 铁律

- 🚫 **禁止**：未经用户要求主动搜索新工具、主动安装、主动替换。
- 🚫 **禁止**：用户未确认前执行任何 scoop install / uninstall / update。
- ✅ **允许**：日常开发中直接使用已安装工具（无需询问）。
- ✅ **允许**：用户明确要求时，先调研汇报，等确认后再安装。

---

## 核心规则与指南路由 (Rules & Guides Index)

| 模块名称 | 核心职责与要义 | 细化文件路径 |
| :--- | :--- | :--- |
| **01. Scoop 环境初始化与配置** | 检测安装状态、**向用户询问并确认安装目录**、配置环境变量、静默安装 Scoop 与 Bucket 源（`extras`/`versions`）。 | [`./rules/01-scoop-bootstrap-setup.md`](./rules/01-scoop-bootstrap-setup.md) |
| **02. AI 效率神器精选矩阵** | 精选 `fd`, `ripgrep`, `rtk`, `jq`, `ast-grep`, `bat`, `delta` 等工具清单、选型理由、收益对比与一键安装指令。 | [`./rules/02-curated-ai-tools.md`](./rules/02-curated-ai-tools.md) |
| **03. 场景选型决策树与时机指引** | 详细指引 AI 在“找文件”、“查代码”、“改结构”、“析数据”、“截日志”等场景中何时精准调用何种工具。 | [`./rules/03-tool-selection-router.md`](./rules/03-tool-selection-router.md) |
| **04. 终端主题配置一键分发** | WezTerm 与 Zellij 的 **Kasugano 冷色调主题（0.75 微透明、UTF-8 编码、蓝绿紫系）** 跨设备自动部署与复现。 | [`./rules/04-wezterm-zellij-theme-setup.md`](./rules/04-wezterm-zellij-theme-setup.md) |

---

## 当前已安装工具状态（2026-08 实测）

以下工具已通过 Scoop 安装并验证可用（命令名以 `command -v` 实测为准）：

| 类别 | 已安装工具 |
|:---|:---|
| 核心搜索 | `fd`, `rg`, `sg` (ast-grep), `ug` (ugrep), `rga`, `ig` (igrep) |
| 数据解析 | `jq`, `yq`, `xsv`, `csview`, `choose`, `mlr` (miller) |
| HTTP/网络 | `curl`, `xh`, `curlie`, `wget2`, `httpstat`, `websocat`, `aria2c` |
| 构建/日志 | `rtk`, `watchexec`, `just` |
| 预览/Diff | `bat`, `delta`, `glow`, `hexyl` |
| 系统/磁盘 | `dust`, `duf`, `dua`, `gdu`, `procs`, `bandwhich`, `broot`, `btm` (bottom) |
| 导航/文件 | `zoxide` (z), `eza`, `yazi`, `lf` |
| 文本处理 | `sd`, `grex` |
| 知识查询 | `tldr` (tealdeer), `navi` |
| 其他 | `hyperfine`, `tokei`, `fastfetch`, `onefetch`, `fzf`, `gh`, `7z`, `cb` (clipboard) |

> ⚠️ **注意**：部分工具的命令名与包名不同（`tealdeer`→`tldr`、`miller`→`mlr`、`bottom`→`btm`、`clipboard`→`cb`、`igrep`→`ig`、`aria2`→`aria2c`）。

---

## 辅助脚本与参考手册

* **Scoop 与 AI 工具链初始化脚本**：[`./scripts/bootstrap-scoop.ps1`](./scripts/bootstrap-scoop.ps1)
* **WezTerm 与 Zellij 主题一键分发脚本**：[`./scripts/setup-terminal-themes.ps1`](./scripts/setup-terminal-themes.ps1)
* **常用工具高频参数与防坑速查**：[`./references/tool-cheatsheet.md`](./references/tool-cheatsheet.md)

