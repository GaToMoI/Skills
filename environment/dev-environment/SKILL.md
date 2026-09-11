---
name: dev-environment
description: >-
  Development environment bootstrap and CLI tool routing: detect and install Scoop with user-confirmed
  install paths, the curated AI-efficiency CLI matrix (fd, rg, ast-grep, jq, rtk, bat, delta), scenario-based
  tool selection, and verified command-name aliases. Use when setting up a machine, installing or checking
  tools, choosing which CLI to use for finding files, searching code, parsing JSON, or trimming logs.
---

# 开发环境与工具选型 (Dev Environment)

---

## 铁律

- 🚫 **禁止**：用户未确认前执行任何 `scoop install` / `uninstall` / `update`。
- ✅ **允许**：日常开发中直接使用**已安装**工具（无需询问）。
- ✅ **允许**：用户明确要求时，先调研汇报，等确认后再安装。
- **用户目录主权优先**：严禁硬编码默认安装路径至系统盘；包管理器初始化前必须由用户确认目标目录。

---

## 场景选型决策树

| 场景 | 工具 | 备选 |
|:--|:--|:--|
| 找文件 | `fd` | `eza` / `yazi` |
| 搜代码 | `rg` | `ug` (ugrep) / `rga` |
| 改结构（语法级重构） | `sg` (ast-grep) | `rg` + 人工复核边界 |
| 析 JSON / YAML | `jq` / `yq` | `csview` / `mlr` |
| 截日志 | `rtk` | `--quiet` / `\| tail -20` |
| 预览 / Diff | `bat` / `delta` | `glow` / `hexyl` |
| 网页数据 | `websearch` / `ddgs` | 见 `evidence-research` 技能 |
| 系统 / 磁盘 | `dust`, `duf`, `procs`, `btm` | `gdu` / `dua` |

**禁止项**：🚫 `find /` 全盘、🚫 `grep -r` 全量递归、🚫 裸跑 `gradlew`、🚫 原始 JSON 灌入上下文、🚫 `curl` 抓引擎页面解析。

> 详细时机指引：[`references/tool-selection-router.md`](references/tool-selection-router.md)

---

## 已安装工具清单（2026-08 实测）

| 类别 | 工具 |
|:---|:---|
| 核心搜索 | `fd`, `rg`, `sg`, `ug`, `rga`, `ig` |
| 数据解析 | `jq`, `yq`, `xsv`, `csview`, `choose`, `mlr` |
| HTTP / 网络 | `curl`, `xh`, `curlie`, `wget2`, `httpstat`, `websocat`, `aria2c` |
| 网页数据 | **`websearch`**（ddgs 封装，`~/.pi/agent/bin`） |
| 构建 / 日志 | `rtk`, `watchexec`, `just` |
| 预览 / Diff | `bat`, `delta`, `glow`, `hexyl` |
| 系统 / 磁盘 | `dust`, `duf`, `dua`, `gdu`, `procs`, `bandwhich`, `broot`, `btm` |
| 导航 / 文件 | `zoxide` (`z`), `eza`, `yazi`, `lf` |
| 文本处理 | `sd`, `grex` |
| 知识查询 | `tldr`, `navi` |
| 其他 | `hyperfine`, `tokei`, `fastfetch`, `onefetch`, `fzf`, `gh`, `7z`, `cb` |

> ⚠️ **包名 ≠ 命令名**：`tealdeer`→`tldr`、`miller`→`mlr`、`bottom`→`btm`、`clipboard`→`cb`、`igrep`→`ig`、`aria2`→`aria2c`。
> 批量安装：`scoop install ripgrep fd jq bat ast-grep rtk 7zip`

---

## 资产

- **环境初始化脚本**：[`scripts/bootstrap-scoop.ps1`](scripts/bootstrap-scoop.ps1) — 检测、安装、配环境变量、装 Bucket
- **高频参数与防坑速查**：[`references/tool-cheatsheet.md`](references/tool-cheatsheet.md)
- **工具矩阵与选型理由**：[`references/curated-ai-tools.md`](references/curated-ai-tools.md)
- **Scoop 投递细则**：[`references/scoop-bootstrap-setup.md`](references/scoop-bootstrap-setup.md)
- **本机安装坑位与版本快照**：[`references/local-install-quirks.md`](references/local-install-quirks.md)（7zip shim / eza 残留 / bandwhich Npcap / fd 来源）
