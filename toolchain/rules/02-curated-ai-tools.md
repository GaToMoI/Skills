# 规则二：AI 效率神器精选矩阵 (Curated AI Tools Suite)

## 1. AI 专用工具精选矩阵

为最大化提升 AI 交互速度、降低单次交互 Token 开销并防止系统磁盘 I/O 阻塞，精选以下核心 CLI 工具：

| 工具名称 | 对应命令 | Scoop 安装包名 | 核心定位与 AI 提效收益 | Token / 性能收益 |
| :--- | :--- | :--- | :--- | :--- |
| **Rust Token Killer** | `rtk` | `rtk` (或手动/cargo) | CLI 输出过滤器，拦截并压缩构建/命令输出 | **节省 60% ~ 90% 上下文 Token** |
| **ripgrep** | `rg` | `ripgrep` | 极速多线程文本/代码检索，自动跳过 `.gitignore` | **比 grep 快 10x+，低 Token** |
| **fd** | `fd` | `fd` | 极速文件/目录查找，替代易卡死的 `find` 指令 | **防全盘扫描假死，耗时 < 0.2s** |
| **jq** | `jq` | `jq` | 命令行 JSON 流式解析与字段提取神器 | **避免将数十 KB 原始 JSON 灌入 Context** |
| **ast-grep** | `ast-grep` / `sg` | `ast-grep` | 基于 AST 语法树的代码搜索与结构化安全替换 | **解决纯正则无法处理的跨行复杂语法重构** |
| **bat** | `bat` | `bat` | 带行号与语法高亮的文本/代码预览工具 | **精准切片预览，结构清晰** |
| **delta** | `delta` | `delta` | 现代 Git Diff 与 Patch 差异比对分页器 | **代码变更 Diff 高可读性** |
| **GitHub CLI** | `gh` | `gh` | GitHub Issue、PR、Release 命令行交互 | **极简获取远端 Issue/PR 关键信息** |
| **7-Zip** | `7z` | `7zip` | 极速解压与打包各类压缩包（zip/tar/gz/7z） | **构建产物与源码包快速解压** |

---

## 2. 批量静默安装指令

AI 可以通过一行指令批量静默安装核心工具链：

```powershell
# 核心 AI 效率基础套件 (必装)
scoop install ripgrep fd jq bat ast-grep 7zip

# (可选) 进阶开发套件
scoop install git-delta gh fzf
```

---

## 3. 安装状态验证 SOP

批量安装完成后，执行以下指令快速验证工具就绪状态：

```powershell
$tools = @("rg", "fd", "jq", "bat", "ast-grep", "7z")
foreach ($t in $tools) {
    $cmd = Get-Command $t -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "✅ $t ready: $($cmd.Source)"
    } else {
        Write-Warning "❌ $t NOT found in PATH"
    }
}
```
