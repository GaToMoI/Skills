---
name: terminal-dotfiles
description: >-
  Terminal appearance and shell config distribution: WezTerm Kasugano cool-tone theme (0.75 window opacity,
  UTF-8 no-mojibake for PowerShell, font fallback chain) and matching Zellij KDL color config, deployed
  reproducibly across machines via a single script.
  Use when configuring a terminal, syncing a shell theme to a new device, fixing garbled CJK output in
  PowerShell, or updating wezterm.lua / zellij config.kdl.
---

# Terminal Themes and Config Distribution

Goal: **configure once, reproduce on every device.** Templates inside this skill are the only source; never hand-edit divergent copies.

---

## Deployment targets

| Component | Target path | Template | Key points |
|:--|:--|:--|:--|
| **WezTerm** | `$env:USERPROFILE\.wezterm.lua` | [`templates/wezterm.lua`](templates/wezterm.lua) | Kasugano cool palette, 0.75 window opacity, PowerShell UTF-8 anti-mojibake, font fallback chain |
| **Zellij** | `$env:USERPROFILE\.config\zellij\config.kdl` | [`templates/zellij/config.kdl`](templates/zellij/config.kdl) | KDL palette matching Kasugano, mouse support, default shell = PowerShell |

---

## Deployment

```powershell
# Install terminal tools and distribute themes in one shot (backs up existing config)
powershell -ExecutionPolicy Bypass -File "environment\terminal-dotfiles\scripts\setup-terminal-themes.ps1"
```

**Order**: ① detect whether WezTerm / Zellij are installed → ② back up existing config → ③ copy templates to target paths → ④ tell the user to restart the terminal and verify.

---

## Iron rules

- 🚫 **Never** overwrite the user's existing config without confirmation — back up first (the script already does this).
- 🚫 **Never** hardcode `C:\Users\<name>`; always use `$env:USERPROFILE`.
- ✅ The template is the single source of truth: change the template here first, then distribute to devices. **Never hand-edit a machine's config and lose track of it.**

---

## Troubleshooting

| Symptom | Root cause | Fix |
|:--|:--|:--|
| Garbled CJK in PowerShell | Encoding is not UTF-8 | Check the `chcp 65001` / `$OutputEncoding` block in the template |
| Missing glyphs / tofu boxes | Font fallback chain lacks a CJK entry | Complete the `font_with_fallback` list in the template |
| Zellij colours feel disconnected | KDL palette out of sync with Kasugano | Re-distribute from the template `config.kdl` |

> Full setup notes: [`references/wezterm-zellij-theme-setup.md`](references/wezterm-zellij-theme-setup.md) (zh)
> btop-lhm temperature monitor and RUNASADMIN inheritance: [`references/btop-lhm-temperature-monitor.md`](references/btop-lhm-temperature-monitor.md) (zh)
