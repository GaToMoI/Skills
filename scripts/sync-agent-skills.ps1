<#
.SYNOPSIS
    将本仓库（D:\GTMI\Skills）的全局技能同步挂载到各 CLI agent 的技能目录。

.DESCRIPTION
    本仓库是全局技能的唯一真相源。各 CLI agent 自有技能目录，逐一挂载为 junction（目录联接）。

    设计约束（实测依据，勿轻易改动）：
      1. 挂载粒度 = 逐技能、深度 1（<agentSkillsDir>\<skillName> -> <repo>\<category>\<skillName>）。
         Claude Code 实测技能模式为 skills/<name>/SKILL.md；Codex 为 skills/.system/<name>/SKILL.md。
         不依赖任何 agent 的"递归下潜"行为，故最稳妥。
         Antigravity 用户级 = ~/.gemini/skills/<name>/SKILL.md（该目录同时存放其自带技能，
         均为真实目录，脚本按第 3 条约束只动指向本仓库的链接）。
      2. 幂等：先清理指向本仓库的旧 junction，再重建。可反复执行。
      3. 只删"指向本仓库"的 junction —— 绝不触碰 agent 自带技能（如 Codex 的 .system、CodeWhale 的 bundled）。

.PARAMETER RepoRoot
    技能仓库根目录，默认 D:\GTMI\Skills

.PARAMETER WhatIf
    只打印将执行的操作，不实际改动。

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\sync-agent-skills.ps1
    powershell -ExecutionPolicy Bypass -File scripts\sync-agent-skills.ps1 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$RepoRoot
)

# 默认 = 本脚本的上级目录（即仓库根）。$PSScriptRoot 在 -File 调用下偶为空，需回退。
if (-not $RepoRoot) {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
    $RepoRoot = Split-Path -Parent $scriptDir
}

$ErrorActionPreference = 'Stop'

# ---- 目标：各 agent 的技能目录 ----
$Targets = @(
    @{ Agent = 'Claude Code'; Dir = Join-Path $env:USERPROFILE '.claude\skills' }
    @{ Agent = 'Codex';       Dir = Join-Path $env:USERPROFILE '.codex\skills' }
    @{ Agent = 'CodeWhale';   Dir = Join-Path $env:USERPROFILE '.codewhale\skills' }
    @{ Agent = 'Antigravity'; Dir = Join-Path $env:USERPROFILE '.gemini\skills' }
)

# ---- 从仓库结构推导技能清单（<category>\<skill>\SKILL.md，两段式）----
$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path

function Get-Reposkill {
    param([string]$Root)
    Get-ChildItem -LiteralPath $Root -Directory |
        Where-Object { $_.Name -notmatch '^[.\$]' } |
        ForEach-Object {
            $category = $_
            Get-ChildItem -LiteralPath $category.FullName -Directory |
                ForEach-Object {
                    $skillMd = Join-Path $_.FullName 'SKILL.md'
                    if (Test-Path -LiteralPath $skillMd -PathType Leaf) {
                        [pscustomobject]@{
                            Name     = $_.Name
                            Path     = $_.FullName
                            Category = $category.Name
                        }
                    }
                    else {
                        Write-Warning ("跳过（无 SKILL.md，非技能目录）: " + $_.FullName)
                    }
                }
        }
}

$skills = Get-Reposkill -Root $RepoRoot
Write-Host "仓库: $RepoRoot"
Write-Host "发现 $($skills.Count) 个技能: $($skills.Name -join ', ')"
Write-Host ''

if ($skills.Count -eq 0) { throw "仓库中未发现任何技能，终止（避免误建空目录）。" }

foreach ($target in $Targets) {
    $dir = $target.Dir
    Write-Host ("=== " + $target.Agent + "  ->  " + $dir)

    if (-not (Test-Path -LiteralPath $dir)) {
        if ($PSCmdlet.ShouldProcess($dir, '创建技能目录')) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Host '  [新建] 技能目录'
        }
    }

    # 1. 清理：仅删除"目标路径位于本仓库内"的 junction/符号链接
    if (Test-Path -LiteralPath $dir) {
        Get-ChildItem -LiteralPath $dir -Force | ForEach-Object {
            $linkTarget = $null
            if ($_.LinkType) {
                $linkTarget = @($_.Target)[0]
            }
            if ($linkTarget) {
                $resolved = $null
                try { $resolved = (Resolve-Path -LiteralPath $linkTarget -ErrorAction Stop).Path } catch { }
                if ($resolved -and $resolved.StartsWith($RepoRoot, [StringComparison]::OrdinalIgnoreCase)) {
                    if ($PSCmdlet.ShouldProcess($_.FullName, '移除旧链接')) {
                        [System.IO.Directory]::Delete($_.FullName, $false)
                        Write-Host ("  [移除旧链] " + $_.Name)
                    }
                }
            }
        }
    }

    # 2. 挂载：逐技能建 junction
    foreach ($s in $skills) {
        $link = Join-Path $dir $s.Name
        if (Test-Path -LiteralPath $link) {
            $existing = Get-Item -LiteralPath $link -Force
            if (-not $existing.LinkType) {
                Write-Warning ("  [冲突] 已存在同名真实目录，跳过: " + $link)
                continue
            }
        }
        if ($PSCmdlet.ShouldProcess($link, "挂载 -> $($s.Path)")) {
            New-Item -ItemType Junction -Path $link -Target $s.Path | Out-Null
            Write-Host ("  [挂载] " + $s.Name + "  <-  " + $s.Category + "\" + $s.Name)
        }
    }
    Write-Host ''
}

Write-Host '同步完成。'
