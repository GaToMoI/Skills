# 规则四：WezTerm 与 Zellij 主题配置自动化部署 (WezTerm & Zellij Theme Setup)

## 1. 核心目标与定位

本规则旨在保证在任何新 Windows 电脑上，AI 能够通过一键化流程安装 `wezterm` 与 `zellij`，并将统一的高品质 **Kasugano 冷色调主题（0.75 微透明、UTF-8 中文编码优化、蓝绿紫系配色）** 自动分发到位，实现终端开发与演示环境的 100% 像素级复现。

---

## 2. 软件安装与 Bucket 依赖

通过 Scoop 包管理器静默安装两款核心终端神器：

```powershell
# 1. 确保已添加 extras 源 (wezterm 位于 extras bucket)
scoop bucket add extras

# 2. 静默安装 WezTerm 与 Zellij
scoop install wezterm zellij
```

---

## 3. 配置文件标准分发路径

在 Windows 环境下，配置文件必须分发至以下官方标准路径：

| 工具名称 | 目标文件路径 | 模板源文件路径 | 核心配置特性 |
| :--- | :--- | :--- | :--- |
| **WezTerm** | `$env:USERPROFILE\.wezterm.lua` | [`../templates/wezterm.lua`](../templates/wezterm.lua) | Kasugano 冷色调配色、0.75 窗口透明度、PowerShell UTF-8 防乱码、字体回退列表 |
| **Zellij** | `$env:USERPROFILE\.config\zellij\config.kdl` | [`../templates/zellij/config.kdl`](../templates/zellij/config.kdl) | 匹配 Kasugano 的 KDL 配色定义、鼠标支持、PowerShell 默认 Shell |

---

## 4. 自动化分发与验证 SOP

AI 在新设备上可直接运行内置部署脚本：

```powershell
# 运行自动化分发脚本
.\scripts\setup-terminal-themes.ps1
```

### 手动分发指令（备选）：
```powershell
# 1. 分发 WezTerm 配置文件
$weztermSrc = "<repo>\environment\terminal-dotfiles\templates\wezterm.lua"
Copy-Item -Force $weztermSrc "$env:USERPROFILE\.wezterm.lua"

# 2. 分发 Zellij 配置文件
$zellijConfigDir = "$env:USERPROFILE\.config\zellij"
if (-not (Test-Path $zellijConfigDir)) {
    New-Item -ItemType Directory -Path $zellijConfigDir -Force
}
$zellijSrc = "<repo>\environment\terminal-dotfiles\templates\zellij\config.kdl"
Copy-Item -Force $zellijSrc "$zellijConfigDir\config.kdl"
```

---

## 5. 效果验证

分发完成后，直接在终端执行 `wezterm` 启动，验证：
1. 窗口背景是否呈现 0.75 半透明深黑冷色调；
2. PowerShell 中文字符输入输出是否正常无乱码；
3. 输入 `zellij` 后，分屏与状态栏是否自动应用 Kasugano 青蓝配色。
