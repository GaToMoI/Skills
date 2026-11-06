---
name: terminal-dotfiles
description: >-
  Terminal appearance and shell config distribution: WezTerm Kasugano cool-tone theme (0.75 window opacity,
  UTF-8 no-mojibake for PowerShell, font fallback chain) and matching Zellij KDL color config, deployed
  reproducibly across machines via a single script.
  Use when configuring a terminal, syncing a shell theme to a new device, fixing garbled CJK output in
  PowerShell, or updating wezterm.lua / zellij config.kdl.
---

# 终端主题与配置分发 (Terminal Dotfiles)

> **非规范镜像**：本文件是 `SKILL.md`（英文，规范版）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。


目标：**一次配置，跨设备可复现**。所有配置以本技能内模板为唯一源，禁止手工散改多份。

---

## 部署目标

| 组件 | 目标路径 | 模板 | 关键点 |
|:--|:--|:--|:--|
| **WezTerm** | `$env:USERPROFILE\.wezterm.lua` | [`templates/wezterm.lua`](templates/wezterm.lua) | Kasugano 冷色调、0.75 窗口透明度、PowerShell UTF-8 防乱码、字体回退链 |
| **Zellij** | `$env:USERPROFILE\.config\zellij\config.kdl` | [`templates/zellij/config.kdl`](templates/zellij/config.kdl) | 与 Kasugano 匹配的 KDL 配色、鼠标支持、默认 shell = PowerShell |

---

## 部署流程

```powershell
# 一键安装终端工具并分发主题（含备份既有配置）
powershell -ExecutionPolicy Bypass -File "environment\terminal-dotfiles\scripts\setup-terminal-themes.ps1"
```

**顺序**：① 检测 WezTerm / Zellij 是否安装 → ② 备份既有配置 → ③ 复制模板到目标路径 → ④ 提示重启终端验证。

---

## 铁律

- 🚫 **禁止**在未确认的情况下覆盖用户既有配置——必须先备份（脚本内已含此步）。
- 🚫 **禁止**硬编码 `C:\Users\<名字>`；一律用 `$env:USERPROFILE`。
- ✅ 模板即唯一真相源：改配置先改这里的模板，再从模板分发到各设备，**不得反向手工改本机配置文件后失联**。

---

## 排查速查

| 症状 | 根因 | 处置 |
|:--|:--|:--|
| PowerShell 中文乱码 | 编码非 UTF-8 | 检查模板中 `chcp 65001` / `$OutputEncoding` 段 |
| 字体方块 / 缺字 | 字体回退链缺 CJK 项 | 补齐模板 `font_with_fallback` 列表 |
| Zellij 配色割裂 | KDL 未同步 Kasugano 色值 | 以模板 `config.kdl` 为准重新分发 |

> 完整配置说明：[`references/wezterm-zellij-theme-setup.md`](references/wezterm-zellij-theme-setup.md)
> btop-lhm 温度监控与 RUNASADMIN 权限继承：[`references/btop-lhm-temperature-monitor.md`](references/btop-lhm-temperature-monitor.md)
