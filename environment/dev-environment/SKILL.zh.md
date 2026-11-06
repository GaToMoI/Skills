---
name: dev-environment
description: >-
  Windows-only (Scoop / PowerShell) optional efficiency kit and CLI routing: detect and install Scoop with
  user-confirmed install paths, the curated AI-efficiency CLI matrix (fd, rg, ast-grep, jq, rtk, bat, delta),
  scenario-based tool selection with silent fallbacks, and verified command-name aliases. Nothing here is
  required — the kit is an optional upgrade that asks at most once on first use. Use when setting up a Windows
  machine, checking which CLI to use for finding files, searching code, parsing JSON, or trimming logs; skip on
  macOS/Linux unless you specifically want the equivalent mapping.
---

# 开发环境与工具选型 (Dev Environment)

> **仅 Windows**（Scoop / PowerShell）。macOS / Linux 可直接跳过本技能——任何技能都不依赖这些工具；它们只是可选的提效包，装了更好，缺了就静默降级。

> **非规范镜像**：本文件是 `SKILL.md`（英文，规范版）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。


---

## 铁律

- 🚫 **禁止**：用户未确认前执行任何 `scoop install` / `uninstall` / `update`。
- ✅ **允许**：日常开发中直接使用**已安装**工具（无需询问）。
- ✅ **允许**：用户明确要求时，先调研汇报，等确认后再安装。
- **用户目录主权优先**：严禁硬编码默认安装路径至系统盘；包管理器初始化前必须由用户确认目标目录。

---

## 工具包：全部可选

下表没有任何一项是必需的。每个工具都有替代；缺失时**静默降级、继续干活**，绝不把缺工具变成报错或阻塞。

| 分组 | 工具 | 缺失时的替代 |
|:--|:--|:--|
| 搜索 | `fd`、`rg`、`sg`、`ug`、`rga` | `ls` / `Select-String` / `grep`（限定路径）；用 `rg` + 人工复核代替 `sg` |
| 数据 | `jq`、`yq`、`xsv`、`csview`、`choose`、`mlr` | `python -c` |
| 网络 | `websearch`（ddgs）、`xh`、`curlie`、`httpstat` | 下方检索阶梯 |
| 日志 / 构建 | `rtk`、`watchexec`、`just` | `tail` / `head` / `grep` |
| 预览 / Diff | `bat`、`delta`、`glow`、`hexyl` | `cat` / `diff` |
| 系统 / 磁盘 | `dust`、`duf`、`dua`、`gdu`、`procs`、`bandwhich`、`broot`、`btm` | 任务管理器 / `df` / `ps` |
| 导航 | `zoxide`、`eza`、`yazi`、`lf` | `dir` / `ls` |

### 检索阶梯（网页数据）

1. **本工具包的 `websearch`** —— 首选路径：ddgs 封装，免费、无需 key。
2. **宿主 agent 自带的检索能力**（如果有）—— 可接受的替身，不取代第 1 优先。
3. **`curl` + 公开 API**，用 `jq` 或 `python` 解析。
4. **请用户直接粘贴内容。**

走到第 4 步是正常的。缺检索工具不算失败。

---

## 首次邀请（只问一次，之后永不再问）

**在本工作区首次使用本技能时**，若可选工具包尚未安装，提供一次性菜单。得到任何回答后，永不再提。

| 选项 | 安装内容 | 适用 |
|:--|:--|:--|
| **A · 最小** | `websearch`（ddgs 封装） | 只需要联网查证 |
| **B · 推荐** | `fd rg jq bat` + `websearch` | 日常开发 |
| **C · 全套** | 上表全部 | 一次配好，之后不再折腾 |
| **D · 跳过** | 什么都不装 | 可以——所有能力都会静默降级 |

**流程**

1. 探测环境。工具包已就绪 → 什么都别说，不出菜单。
2. 否则列出 A / B / C / D，每项写明装什么、为什么值得装，然后等用户选。
3. 把回答记进 `<skill-dir>/.tempcache/tool-prefs.json`。
4. **一辈子只问一次。** 无论用户选什么，本工作区都不再出这个菜单。
5. 选「跳过」→ 静默降级，不提醒、不唠叨。
6. 若某任务确实需要联网检索、而阶梯的每一级都不可用，说明一次并请求安装 `websearch` —— 这是唯一允许的第二次提示，且只此一次。
7. `.tempcache/` 可能被随时清理；状态文件没了，下次使用按首次处理（会再邀请一次）。

**状态文件** —— `<skill-dir>/.tempcache/tool-prefs.json`：

```json
{
  "askState": "answered",
  "choice": "B",
  "reaskUsed": false,
  "date": "2026-10-11",
  "tools": { "websearch": "installed", "rtk": "skipped" }
}
```

`askState`：`pending` / `answered` · `choice`：`A` / `B` / `C` / `D`

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
| 网页数据 | **`websearch`**（ddgs 封装，须在 `PATH` 上；pi 宿主默认装在 `~/.pi/agent/bin`） |
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
