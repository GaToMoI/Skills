# btop-lhm 温度监控与 WezTerm 权限继承 (btop-lhm Temperature Monitor)

> 归属 `terminal-dotfiles` 技能的判例细节。机器级终端配置，非项目专属。
> 实配时间 2026-08-27 · 环境 Windows 11 + Scoop + WezTerm。

---

## 目标

在 WezTerm 内显示 CPU/GPU/主板/硬盘温度，且**保持窗口透明**不脱离终端。

---

## 组件

| 组件 | 说明 |
|:--|:--|
| `btop-lhm` | Scoop 包，替代普通 btop，集成 LibreHardwareMonitor 读取硬件温度（CPU/GPU/主板/硬盘） |
| `wezterm-gui.exe` | 需以管理员权限运行才能继承给子进程 |
| `btop.conf` | `theme_background = False`（配合透明） |

---

## 关键坑（这是本方案的核心价值）

### ❌ 错误做法：给 btop.exe 设 RUNASADMIN

会导致 **UAC 提权开新窗口**，btop 脱离 WezTerm 独立运行 → WezTerm 的透明度失效，视觉割裂。

### ✅ 正确做法：给 wezterm-gui.exe 设 RUNASADMIN

在注册表给 WezTerm 本身设提权标志，则：

- WezTerm 内启动的**所有控制台程序继承管理员权限**
- btop 留在 WezTerm 里，**同时**能读 CPU 温度（Intel MSR 寄存器在 Ring 0 保护下，非管理员读不到）

```powershell
# 注册表位置：HKC<system-drive>:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers
# 键名 = exe 的完整路径，值 = "RUNASADMIN"
$key = "HKC<system-drive>:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
Set-ItemProperty -Path $key -Name "C:\Users\<user>\scoop\apps\wezterm\current\wezterm-gui.exe" -Value "RUNASADMIN"
```

---

## 配套配置

| 项 | 位置 | 值 |
|:--|:--|:--|
| btop 背景透明 | `~/scoop/persist/btop-lhm/btop.conf` | `theme_background = False` |
| WezTerm 透明度 | `~/.wezterm.lua` | `window_background_opacity = 0.75` |
| WezTerm 主题 | `~/.wezterm.lua` | Kasugano 冷色调 |

> WezTerm 配置模板见本技能 `templates/wezterm.lua`；分发脚本见 `scripts/setup-terminal-themes.ps1`。

---

## 排查速查

| 症状 | 根因 | 处置 |
|:--|:--|:--|
| btop 温度显示为 0 / 无数据 | 未以管理员运行 | 给 `wezterm-gui.exe` 设 RUNASADMIN（而非 btop.exe） |
| 弹 UAC 且 btop 在新窗口 | 误给 btop.exe 设了 RUNASADMIN | 移除 btop 的该项，改设 wezterm-gui.exe |
| btop 背景不透明 | 未关 `theme_background` | `btop.conf` 设 `False` |
| RUNASADMIN 不生效 | 键名路径不完整 | 必须用 exe 完整路径作键名 |
