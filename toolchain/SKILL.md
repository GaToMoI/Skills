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

---

## 核心规则与指南路由 (Rules & Guides Index)

| 模块名称 | 核心职责与要义 | 细化文件路径 |
| :--- | :--- | :--- |
| **01. Scoop 环境初始化与配置** | 检测安装状态、**向用户询问并确认安装目录**、配置环境变量、静默安装 Scoop 与 Bucket 源（`extras`/`versions`）。 | [`./rules/01-scoop-bootstrap-setup.md`](./rules/01-scoop-bootstrap-setup.md) |
| **02. AI 效率神器精选矩阵** | 精选 `fd`, `ripgrep`, `rtk`, `jq`, `ast-grep`, `bat`, `delta` 等工具清单、选型理由、收益对比与一键安装指令。 | [`./rules/02-curated-ai-tools.md`](./rules/02-curated-ai-tools.md) |
| **03. 场景选型决策树与时机指引** | 详细指引 AI 在“找文件”、“查代码”、“改结构”、“析数据”、“截日志”等场景中何时精准调用何种工具。 | [`./rules/03-tool-selection-router.md`](./rules/03-tool-selection-router.md) |
| **04. 终端主题配置一键分发** | WezTerm 与 Zellij 的 **Kasugano 冷色调主题（0.75 微透明、UTF-8 编码、蓝绿紫系）** 跨设备自动部署与复现。 | [`./rules/04-wezterm-zellij-theme-setup.md`](./rules/04-wezterm-zellij-theme-setup.md) |

---

## 辅助脚本与参考手册

* **Scoop 与 AI 工具链初始化脚本**：[`./scripts/bootstrap-scoop.ps1`](./scripts/bootstrap-scoop.ps1)
* **WezTerm 与 Zellij 主题一键分发脚本**：[`./scripts/setup-terminal-themes.ps1`](./scripts/setup-terminal-themes.ps1)
* **常用工具高频参数与防坑速查**：[`./references/tool-cheatsheet.md`](./references/tool-cheatsheet.md)

