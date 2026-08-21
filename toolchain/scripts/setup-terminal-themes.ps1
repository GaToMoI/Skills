<#
.SYNOPSIS
    Automated WezTerm & Zellij Theme and Configuration Deployment Script.
.DESCRIPTION
    Installs WezTerm and Zellij via Scoop if missing, and deploys the unified
    Kasugano cold palette theme configurations to user profile paths.
#>

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$toolchainRoot = Split-Path -Parent $scriptDir
$templatesDir = Join-Path $toolchainRoot "templates"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  🎨 WezTerm & Zellij Kasugano Theme Deployment           " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. 检测与安装 WezTerm & Zellij
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "`n[1/3] 检查终端工具安装状态..." -ForegroundColor Yellow
    
    $installedBuckets = scoop bucket list
    if ($installedBuckets -notcontains "extras") {
        Write-Host "  ➕ 添加 extras bucket..." -ForegroundColor Cyan
        scoop bucket add extras
    }

    foreach ($app in @("wezterm", "zellij")) {
        if (-not (Get-Command $app -ErrorAction SilentlyContinue)) {
            Write-Host "  ⬇️ 正在通过 Scoop 安装 $app..." -ForegroundColor Cyan
            scoop install $app
        } else {
            Write-Host "  ✅ $app 已安装。" -ForegroundColor Green
        }
    }
} else {
    Write-Warning "⚠️ 未检测到 Scoop，跳过自动安装。请确保 WezTerm 与 Zellij 已手动安装并在 PATH 中。"
}

# 2. 分发 WezTerm 配置文件
Write-Host "`n[2/3] 分发 WezTerm 配置文件 (.wezterm.lua)..." -ForegroundColor Yellow
$weztermSrc = Join-Path $templatesDir "wezterm.lua"
$weztermDest = Join-Path $env:USERPROFILE ".wezterm.lua"

if (Test-Path $weztermSrc) {
    Copy-Item -Path $weztermSrc -Destination $weztermDest -Force
    Write-Host "  ✅ WezTerm 配置已写入 -> $weztermDest" -ForegroundColor Green
} else {
    Write-Error "❌ 未找到 WezTerm 模板文件: $weztermSrc"
}

# 3. 分发 Zellij 配置文件
Write-Host "`n[3/3] 分发 Zellij 配置文件 (config.kdl)..." -ForegroundColor Yellow
$zellijConfigDir = Join-Path $env:USERPROFILE ".config\zellij"
if (-not (Test-Path $zellijConfigDir)) {
    New-Item -ItemType Directory -Path $zellijConfigDir -Force | Out-Null
}

$zellijSrc = Join-Path $templatesDir "zellij\config.kdl"
$zellijDest = Join-Path $zellijConfigDir "config.kdl"

if (Test-Path $zellijSrc) {
    Copy-Item -Path $zellijSrc -Destination $zellijDest -Force
    Write-Host "  ✅ Zellij 配置已写入 -> $zellijDest" -ForegroundColor Green
} else {
    Write-Error "❌ 未找到 Zellij 模板文件: $zellijSrc"
}

Write-Host "`n🎉 WezTerm & Zellij 主题配置分发完毕！直接运行 'wezterm' 即可体验。" -ForegroundColor Cyan
