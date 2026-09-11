# 规则二：AI 效率神器精选矩阵 (Curated AI Tools Suite)

## 1. AI 专用工具精选矩阵（按场景分类）

> **社区共识强度说明**（基于 2026-08 GitHub API 实时数据）：
> - 🏆 **王者级** = 同类中 star 最高 / 被大厂采用 / 社区事实标准（如 ripgrep 被 VS Code 采用）
> - ⭐ **优秀级** = 同类优秀选择，但有竞争者 / 维护活跃
> - 🔶 **备选级** = 功能好但小众 / 维护放缓 / 已归档

### 🔍 搜索与文件查找

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **ripgrep** | `rg` | `ripgrep` | 极速多线程文本搜索，自动 `.gitignore` | 比 grep 快 10x+ | 🏆 67.5k star，被 VS Code 采用 |
| **fd** | `fd` | `fd` | 极速文件/目录查找，替代 `find` | 防全盘扫描假死 | 🏆 44k star，find 替代标准 |
| **ast-grep** | `sg` | `ast-grep` | AST 语法树搜索+安全替换 | 跨行复杂重构 | ⭐ 15.6k star，维护活跃 |
| **ugrep** | `ug` | `ugrep` | 超 grep 增强（模糊匹配、PDF/Office 搜索） | 交互式翻页 | 🔶 3.2k star，小众但功能强 |
| **ripgrep-all** | `rga` | `rga` | 万能搜索（PDF/Office/压缩包/图片OCR） | 搜遍所有文件 | 🔶 9.8k star，维护放缓 |

### 📊 数据解析（JSON / CSV / 结构化）

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **jq** | `jq` | `jq` | JSON 流式解析与字段提取 | 避免原始 JSON 灌入 | 🏆 35.5k star，JSON 处理事实标准 |
| **yq** | `yq` | `yq` | YAML / JSON / XML 统一处理 | 多格式互转 | ⭐ 维护活跃，YAML 处理常用 |
| **xsv** | `xsv` | `xsv` | 极速 CSV 切片/统计/连接 | 避免完整 CSV 输出 | 🔶 10.7k star，**已归档**，建议用 mlr |
| **csview** | `csview` | `csview` | CSV 表格化对齐预览 | 可读性提升 | 🔶 小众，轻量预览用 |
| **choose** | `choose` | `choose` | 管道中按列切分（类 `cut` 但更人性化） | 精准字段提取 | 🔶 小众，功能可用 |

### 🌐 HTTP / 网络请求与网页数据

| 工具 | 命令 | 安装方式 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **websearch** | `websearch` | pip: `ddgs` + 包装脚本 | **AI agent 网页数据首选（免费）**：搜索、抓正文(markdown)、新闻 | 替代 curl 抓搜索引擎；JSON 输出省 Token | ⭐ 免费、无 key、多引擎（ddgs 2.9k star） |
| **xh** | `xh` | `xh` | Rust HTTPie 替代，自带语法高亮 JSON | 输出美观紧凑 | ⭐ HTTPie 的 Rust 现代替代 |
| **curlie** | `curlie` | `curlie` | curl + httpie 混合体，语法高亮 | 输出更易读 | 🔶 小众，curl 风格用户友好 |
| **wget2** | `wget2` | `wget2` | 多线程下载，Wget 继任者 | 下载更快 | ⭐ GNU 官方 Wget 继任者 |
| **httpstat** | `httpstat` | `httpstat` | 单行可视化 HTTP 请求耗时分析 | 定位瓶颈 | 🔶 小众，诊断用 |
| **websocat** | `websocat` | `websocat` | WebSocket 命令行客户端 | 调试 WS 接口 | ⭐ WebSocket CLI 首选 |

> ⚠️ **关于互联网搜索引擎 CLI**：Scoop 桶中暂无 `googler`/`ddgr`/`surfraw` 等互联网搜索 CLI（仅 Linux/macOS）。替代方案：**优先使用 `websearch`/`ddgs`（pip 安装，完全免费无 key）**，或 `gh search issues`（GitHub 搜索）、`curlie` 调 REST API 搜索接口。

### 🛠️ 构建与日志

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **Rust Token Killer** | `rtk` | `rtk` | 构建输出过滤器，拦截压缩 90% 冗余日志 | **节省 60%~90% Token** | ⭐ 本仓库特制，AI 场景专用 |
| **watchexec** | `watchexec` | `watchexec` | 文件变动自动执行命令 | 自动化反馈 | ⭐ 文件监听标准工具 |
| **just** | `just` | `just` | 现代化命令运行器（Makefile 替代） | 简洁任务编排 | ⭐ Makefile 替代首选 |

### 👀 预览与 Diff

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **bat** | `bat` | `bat` | 带行号+语法高亮的文本预览 | 精准切片可读 | 🏆 60.2k star，cat 替代标准 |
| **delta** | `delta` | `delta` | 现代 Git Diff 分页器 | 变更高可读 | 🏆 31.8k star，Git diff 首选 |
| **glow** | `glow` | `glow` | Markdown 终端渲染 | 文档直接预览 | 🏆 27k star，charmbracelet 出品 |
| **hexyl** | `hexyl` | `hexyl` | 带色彩的十六进制查看器 | 二进制分析 | ⭐ sharkdp 出品，稳定 |

### 💻 系统 / 磁盘 / 进程

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **dust** | `dust` | `dust` | 可视化磁盘占用（`du` 替代） | 一目了然 | ⭐ 12k star，du 替代首选 |
| **duf** | `duf` | `duf` | 彩色磁盘使用概览（`df` 替代） | 输出紧凑 | ⭐ 15.2k star，维护放缓 |
| **dua** | `dua` | `dua` | 交互式磁盘占用分析 | 快速定位 | ⭐ 交互式 du 分析 |
| **gdu** | `gdu` | `gdu` | Go 实现的高速磁盘分析器 | 比 `ncdu` 更快 | ⭐ 高速磁盘分析 |
| **procs** | `procs` | `procs` | 彩色进程列表（`ps` 替代） | 输出更直观 | ⭐ 6.1k star，ps 替代 |
| **bandwhich** | `bandwhich` | `bandwhich` | 实时网络带宽监控 | 定位网络瓶颈 | ⭐ 网络监控 |
| **broot** | `broot` | `broot` | 交互式目录树导航 | 思路清晰 | ⭐ 12.9k star，交互式导航 |

### 🧭 导航与文件管理

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **zoxide** | `z` | `zoxide` | 智能目录跳转（自动学习常用路径） | 减少路径输入 | 🏆 38.8k star，cd 替代标准 |
| **eza** | `eza` / `ls` | `eza` | 美化 `ls`（图标、色彩、Git 状态） | 信息密度高 | ⭐ 23k star，exa 社区 fork |
| **yazi** | `yazi` / `ya` | `yazi` | 终端文件管理器（类 Ranger） | 交互式文件操作 | 🏆 41.6k star，增长最快 |
| **lf** | `lf` | `lf` | 极简终端文件管理器 | 快速文件浏览 | ⭐ 9.5k star，轻量选择 |

### ✏️ 文本处理与正则

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **sd** | `sd` | `sd` | 直观的查找替换（`sed` 替代） | 语法更友好 | 🔶 7.3k star，维护放缓 |
| **grex** | `grex` | `grex` | 自动从示例生成正则表达式 | 无需手写正则 | ⭐ 小众但实用 |

### 📚 知识查询

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **tealdeer** | `tldr` | `tealdeer` | 命令速查手册（简化 `man`） | 减少 man 翻页 | ⭐ 6.5k star，tldr 客户端 |
| **navi** | `navi` | `navi` | 交互式命令速查 + 自建知识库 | 速查常用命令 | ⭐ 17.5k star，交互式 |

### 🔧 其他

| 工具 | 命令 | Scoop 包 | 定位 | Token 收益 | 共识 |
|:---|:---|:---|:---|:---|:---|
| **hyperfine** | `hyperfine` | `hyperfine` | 命令行基准测试 | 性能对比 | 🏆 28.7k star，基准测试标准 |
| **tokei** | `tokei` | `tokei` | 极速代码行数统计 | 代码量概览 | ⭐ 14.8k star，代码统计 |
| **fastfetch** | `fastfetch` | `fastfetch` | 系统信息汇总（`neofetch` 继任） | 环境信息快照 | ⭐ neofetch 继任者 |
| **onefetch** | `onefetch` | `onefetch` | Git 仓库信息概览 | 项目信息快照 | ⭐ 小众但有趣 |
| **fzf** | `fzf` | `fzf` | 模糊搜索交互式过滤器 | 交互式筛选 | 🏆 模糊搜索事实标准 |

---

## 2. 批量静默安装指令

### 核心必装套件

```powershell
scoop install ripgrep fd jq bat ast-grep 7zip rtk delta gh fzf
```

### 扩展工具套件（按场景）

```powershell
# 搜索增强
scoop install ugrep rga

# 数据解析
scoop install yq xsv csview choose

# HTTP 网络
scoop install xh curlie wget2 httpstat websocat

# 构建自动化
scoop install watchexec just

# 预览查看
scoop install glow hexyl

# 系统监控
scoop install dust duf dua gdu procs bandwhich broot

# 导航
scoop install zoxide eza yazi lf

# 文本处理
scoop install sd grex

# 知识查询
scoop install tealdeer navi

# 其他
scoop install hyperfine tokei fastfetch onefetch
```

### 一键全部安装

```powershell
scoop install ripgrep fd jq bat ast-grep 7zip rtk delta gh fzf `
  ugrep rga yq xsv csview choose xh curlie wget2 httpstat websocat `
  watchexec just glow hexyl dust duf dua gdu procs bandwhich broot `
  zoxide eza yazi lf sd grex tealdeer navi hyperfine tokei fastfetch onefetch
```

---

## 3. 安装状态快速验证

```bash
# 一键批量检查所有工具（bash）
for t in fd rg sg rga ug jq yq xsv csview choose xh curlie wget2 httpstat websocat \
  rtk watchexec just bat delta glow hexyl dust duf dua gdu procs bandwhich broot \
  zoxide eza yazi lf sd grex tldr navi hyperfine tokei fastfetch onefetch fzf gh 7z; do
  command -v "$t" >/dev/null 2>&1 && echo "✅ $t" || echo "❌ $t"
done
```
