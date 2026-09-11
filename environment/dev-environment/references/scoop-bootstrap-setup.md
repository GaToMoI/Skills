# 规则一：Scoop 环境检测、用户路径确认与初始化 (Scoop Bootstrap & Setup)

## 1. 核心原则与红线

1. **用户目录确认铁律（禁止私自硬编码）**：
   * 在系统未安装 Scoop 时，**严禁私自默认安装到 C 盘（如 `C:\Users\<User>\scoop`）**；
   * **必须在安装前明确向用户询问安装路径**（推荐向用户提议例如 `D:\Scoop` 或 `D:\Software\Scoop`，由用户最终确认或指定）。
2. **幂等性检查**：
   * 安装任何工具前，必须先探测 `scoop` 命令是否已可用，已安装则直接跳过安装流程。
3. **环境变量即时生效**：
   * 写入用户级环境变量后，必须在当前 PowerShell 会话中同步刷新 `$env:SCOOP` 和 `$env:Path`，确保后续指令立即可用。

---

## 2. 标准初始化执行流程 (SOP)

### 第 1 步：探测当前系统 Scoop 状态

AI 应首先在 PowerShell 终端执行轻量级探测命令：
```powershell
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "SCOOP_INSTALLED: $(scoop --version)"
} else {
    Write-Host "SCOOP_NOT_FOUND"
}
```

### 第 2 步：若未安装，向用户询问并确认安装目录

当检测到 `SCOOP_NOT_FOUND` 时，AI **必须主动向用户发起确认**，例如：
> “检测到当前系统尚未安装 Scoop 包管理器。为了避免占用 C 盘系统空间，请问您希望将 Scoop 安装到哪个目录？（推荐：`D:\Scoop` 或您指定的自定义目录）”

### 第 3 步：配置环境变量并执行安装

在获得用户指定的安装目录（例如 `$targetDir = "D:\Scoop"`）后，执行以下标准安装脚本：

```powershell
# 1. 允许 PowerShell 脚本执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 2. 设置用户级与当前会话 SCOOP 环境变量
$scoopPath = "D:\Scoop" # 替换为用户指定的实际路径
$globalScoopPath = Join-Path (Split-Path $scoopPath -Parent) "ScoopGlobal"

$env:SCOOP = $scoopPath
$env:SCOOP_GLOBAL = $globalScoopPath
[Environment]::SetEnvironmentVariable('SCOOP', $scoopPath, 'User')
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $globalScoopPath, 'User')

# 3. 执行官方/镜像静默安装
# 方案 A (官方源):
irm get.scoop.sh | iex

# 方案 B (若国内网络受限，可选用 Gitee 加速源):
# irm https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1 | iex -ScoopDir "$scoopPath"
```

### 第 4 步：初始化常用 Bucket 软件源与加速配置

安装完成后，为 Scoop 补充常用软件源（尤其是 `extras` 和 `versions`），以便能够安装丰富的开发工具：

```powershell
# 刷新当前会话 PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")

# 1. 优先安装 git (管理 bucket 必需)
scoop install git

# 2. 添加核心扩展 Bucket
scoop bucket add extras
scoop bucket add versions

# 3. (可选) 安装 aria2 开启多线程下载加速
# scoop install aria2
# scoop config aria2-enabled true
```
