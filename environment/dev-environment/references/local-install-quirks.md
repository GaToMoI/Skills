# 本机工具链安装坑位 (Local Install Quirks)

> 归属 `dev-environment` 技能的判例细节。本机（GTMI Windows + Scoop）实测记录。
> 首录 2026-08-27 · 工具清单与选型见 `SKILL.md`。

---

## 已装版本快照（2026-08-27 实测）

| 类别 | 版本 |
|:--|:--|
| 搜索 | `fd` 10.4.2 · `rg` 15.2.0 · `sg`(ast-grep) 0.45.2 · `rga` · `ug`(ugrep) |
| 数据 | `jq` 1.8.2 · `yq` 4.53.6 · `xsv` · `csview` · `choose` |
| HTTP | `xh` · `curlie` · `wget2` · `httpstat` · `websocat` |
| 构建 | `rtk` 0.45.0 · `watchexec` · `just` |
| 预览 | `bat` 0.26.1 · `delta` 0.19.2 · `glow` · `hexyl` |
| 系统 | `dust` · `duf` · `dua` · `gdu` · `procs` · `bandwhich` · `broot` |
| 导航 | `zoxide` · `eza` 0.23.5 · `yazi` · `lf` |
| 文本 | `sd` · `grex` |
| 知识 | `tldr`(tealdeer) · `navi` |
| 其他 | `hyperfine` · `tokei` · `fastfetch` · `onefetch` · `fzf` 0.74.3 · `gh` 2.98.0 · `7z` |

---

## 踩过的坑（附处置）

### 1. Scoop 的 `7zip` 包不创建 `7z` 命令 shim

`===> 现象`：装完 `7zip` 后 `7z` 不可用。
`===> 处置`：手动在 `~/scoop/shims` 建 `7z.shim` + `7z.exe`（本机已做）。

### 2. `eza` 可能是残留空目录

`===> 现象`：`eza` 命令存在但无 `current` 链接（旧安装残留）。
`===> 处置`：`rm -rf` 后重装修复。**判断方法**：检查 `~/scoop/apps/<pkg>/current` 是否存在。

### 3. `bandwhich` 需要 Npcap 驱动

`===> 现象`：无 Npcap 时 `bandwhich` 无法抓流量。
`===> 处置`：安装 Npcap 驱动（本机**未装**，已知不可用）。

### 4. `fd` 来自 pi 而非 Scoop

`===> 说明`：本机 `fd` 位于 `~/.pi/agent/bin/fd`（pi 附带），不是 scoop 装的。
`===> 影响`：排查 `fd` 版本/升级问题时别去 scoop 找。

---

## 通用的「装完不可用」排查顺序

1. `command -v <cmd>` —— 命令是否存在
2. `ls ~/scoop/apps/<pkg>/current` —— 是否有 `current` 链接（无则安装残留/损坏）
3. `ls ~/scoop/shims/ | grep <pkg>` —— shim 是否创建
4. 若 shim 缺失但程序在 → 手动补 shim（见坑 1）
5. 若 `current` 缺失 → `rm -rf` 该包目录后重装（见坑 2）
