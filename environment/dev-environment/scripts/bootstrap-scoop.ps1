<#
.SYNOPSIS
    Automated Scoop Package Manager and AI CLI Tools Bootstrap Script for Windows.
.DESCRIPTION
    Checks if Scoop is installed; if not, requires user-provided installation directory,
    sets environment variables, installs Scoop, adds essential buckets (extras, versions),
    and batch installs curated AI efficiency CLI tools (ripgrep, fd, jq, bat, ast-grep, 7zip).
.PARAMETER ScoopDir
    User-specified directory where Scoop should be installed (e.g., "D:\Scoop").
    If omitted and Scoop is not installed, the script will interactively prompt for it.
.PARAMETER ScoopGlobalDir
    Optional custom directory for global Scoop apps. Defaults to "$ScoopDir\..\ScoopGlobal".
.EXAMPLE
    .\bootstrap-scoop.ps1 -ScoopDir "D:\Scoop"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$ScoopDir = "",

    [Parameter(Mandatory = $false)]
    [string]$ScoopGlobalDir = ""
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  🚀 AI CLI Toolchain & Scoop Bootstrap Setup (Windows)   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. 检查 Scoop 是否已安装
$isScoopInstalled = $null -ne (Get-Command scoop -ErrorAction SilentlyContinue)

if (-not $isScoopInstalled) {
    Write-Host "`n[1/4] 正在准备安装 Scoop 包管理器..." -ForegroundColor Yellow

    # 若未传参，则交互式请求用户输入
    while ([string]::IsNullOrWhiteSpace($ScoopDir)) {
        Write-Host "⚠️  注意：严禁默认安装到 C 盘系统目录。" -ForegroundColor Magenta
        $inputPath = Read-Host "请输入 Scoop 的目标安装路径 (推荐示例: D:\Scoop)"
        if (-not [string]::IsNullOrWhiteSpace($inputPath)) {
            $ScoopDir = $inputPath.Trim()
        }
    }

    # 规范化路径
    $ScoopDir = [System.IO.Path]::GetFullPath($ScoopDir)
    if ([string]::IsNullOrWhiteSpace($ScoopGlobalDir)) {
        $parentDir = Split-Path $ScoopDir -Parent
        if ([string]::IsNullOrWhiteSpace($parentDir)) {
            $ScoopGlobalDir = Join-Path $ScoopDir "Global"
        } else {
            $ScoopGlobalDir = Join-Path $parentDir "ScoopGlobal"
        }
    }

    Write-Host "  📁 用户指定安装路径: $ScoopDir" -ForegroundColor Green
    Write-Host "  📁 全局应用安装路径: $ScoopGlobalDir" -ForegroundColor Green

    # 配置环境变量
    $env:SCOOP = $ScoopDir
    $env:SCOOP_GLOBAL = $ScoopGlobalDir
    [Environment]::SetEnvironmentVariable('SCOOP', $ScoopDir, 'User')
    [Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $ScoopGlobalDir, 'User')

    # 设置执行策略
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

    # 执行官方安装
    Write-Host "`n  ⬇️ 正在下载并安装 Scoop..." -ForegroundColor Cyan
    try {
        Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
    } catch {
        Write-Warning "官方源访问异常，尝试使用镜像安装源..."
        Invoke-RestMethod -Uri "https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1" | Invoke-Expression -ScoopDir "$ScoopDir"
    }

    Write-Host "✅ Scoop 安装成功！" -ForegroundColor Green
} else {
    Write-Host "`n[1/4] ✅ 检测到系统已安装 Scoop: $(scoop --version)" -ForegroundColor Green
}

# 2. 刷新当前会话 PATH
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$env:Path = "$userPath;$machinePath"

# 3. 配置核心 Buckets
Write-Host "`n[2/4] 配置 Bucket 软件源 (extras, versions)..." -ForegroundColor Yellow
$installedBuckets = scoop bucket list

if ($installedBuckets -notcontains "extras") {
    Write-Host "  ➕ 添加 extras bucket..." -ForegroundColor Cyan
    scoop bucket add extras
}

if ($installedBuckets -notcontains "versions") {
    Write-Host "  ➕ 添加 versions bucket..." -ForegroundColor Cyan
    scoop bucket add versions
}

# 4. 批量安装 AI 核心效率工具套件
Write-Host "`n[3/4] 检查并批量安装 AI 效率工具套件..." -ForegroundColor Yellow

$coreTools = @(
    @{ Name = "git"; Package = "git" },
    @{ Name = "rg"; Package = "ripgrep" },
    @{ Name = "fd"; Package = "fd" },
    @{ Name = "jq"; Package = "jq" },
    @{ Name = "bat"; Package = "bat" },
    @{ Name = "ast-grep"; Package = "ast-grep" },
    @{ Name = "7z"; Package = "7zip" }
)

foreach ($tool in $coreTools) {
    $exists = $null -ne (Get-Command $tool.Name -ErrorAction SilentlyContinue)
    if ($exists) {
        Write-Host "  ⏩ $($tool.Name) 已安装，跳过。" -ForegroundColor Gray
    } else {
        Write-Host "  ⬇️ 正在安装 $($tool.Package)..." -ForegroundColor Cyan
        scoop install $tool.Package
    }
}

# 5. 校验就绪状态
Write-Host "`n[4/4] 最终工具链就绪状态校验：" -ForegroundColor Yellow
foreach ($tool in $coreTools) {
    $cmd = Get-Command $tool.Name -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "  ✅ $($tool.Name.PadRight(10)) 就绪 -> $($cmd.Source)" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $($tool.Name.PadRight(10)) 缺失" -ForegroundColor Red
    }
}

Write-Host "`n🎉 AI CLI 工具链初始化全部完成！" -ForegroundColor Green
