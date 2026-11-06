---
name: dev-environment
description: >-
  Development environment bootstrap and CLI tool routing: detect and install Scoop with user-confirmed
  install paths, the curated AI-efficiency CLI matrix (fd, rg, ast-grep, jq, rtk, bat, delta), scenario-based
  tool selection, and verified command-name aliases. Use when setting up a machine, installing or checking
  tools, choosing which CLI to use for finding files, searching code, parsing JSON, or trimming logs.
---

# Dev Environment and Tool Selection

---

## Iron rules

- 🚫 **Never** run `scoop install` / `uninstall` / `update` before the user confirms.
- ✅ **Allowed**: use **already installed** tools freely during normal development (no need to ask).
- ✅ **Allowed**: on an explicit request, research and report first, install only after confirmation.
- **User directory sovereignty first**: never hardcode a default install path onto the system drive; the target directory must be confirmed by the user before any package-manager bootstrap.

---

## Scenario-based selection tree

| Scenario | Tool | Alternatives |
|:--|:--|:--|
| Find files | `fd` | `eza` / `yazi` |
| Search code | `rg` | `ug` (ugrep) / `rga` |
| Structural edits (syntax-level refactor) | `sg` (ast-grep) | `rg` + manual boundary review |
| Parse JSON / YAML | `jq` / `yq` | `csview` / `mlr` |
| Trim logs | `rtk` | `--quiet` / `\| tail -20` |
| Preview / diff | `bat` / `delta` | `glow` / `hexyl` |
| Web data | `websearch` / `ddgs` | see the `evidence-research` skill |
| System / disk | `dust`, `duf`, `procs`, `btm` | `gdu` / `dua` |

**Forbidden**: 🚫 `find /` across the whole disk, 🚫 full recursive `grep -r`, 🚫 bare `gradlew`, 🚫 raw JSON into context, 🚫 `curl` against a search engine's HTML.

> Detailed timing guidance: [`references/tool-selection-router.md`](references/tool-selection-router.md) (zh)

---

## Installed tools (measured 2026-08)

| Category | Tools |
|:---|:---|
| Core search | `fd`, `rg`, `sg`, `ug`, `rga`, `ig` |
| Data parsing | `jq`, `yq`, `xsv`, `csview`, `choose`, `mlr` |
| HTTP / network | `curl`, `xh`, `curlie`, `wget2`, `httpstat`, `websocat`, `aria2c` |
| Web data | **`websearch`** (ddgs wrapper, must be on `PATH`; the pi host ships it under `~/.pi/agent/bin`) |
| Build / logs | `rtk`, `watchexec`, `just` |
| Preview / diff | `bat`, `delta`, `glow`, `hexyl` |
| System / disk | `dust`, `duf`, `dua`, `gdu`, `procs`, `bandwhich`, `broot`, `btm` |
| Navigation / files | `zoxide` (`z`), `eza`, `yazi`, `lf` |
| Text processing | `sd`, `grex` |
| Knowledge lookup | `tldr`, `navi` |
| Other | `hyperfine`, `tokei`, `fastfetch`, `onefetch`, `fzf`, `gh`, `7z`, `cb` |

> ⚠️ **Package name ≠ command name**: `tealdeer`→`tldr`, `miller`→`mlr`, `bottom`→`btm`, `clipboard`→`cb`, `igrep`→`ig`, `aria2`→`aria2c`.
> Bulk install: `scoop install ripgrep fd jq bat ast-grep rtk 7zip`

---

## Assets

- **Bootstrap script**: [`scripts/bootstrap-scoop.ps1`](scripts/bootstrap-scoop.ps1) — detect, install, set env vars, add buckets
- **Common flags and pitfalls**: [`references/tool-cheatsheet.md`](references/tool-cheatsheet.md) (zh)
- **Tool matrix and rationale**: [`references/curated-ai-tools.md`](references/curated-ai-tools.md) (zh)
- **Scoop delivery details**: [`references/scoop-bootstrap-setup.md`](references/scoop-bootstrap-setup.md) (zh)
- **Local install quirks and version snapshot**: [`references/local-install-quirks.md`](references/local-install-quirks.md) (zh) — 7zip shim / eza leftovers / bandwhich Npcap / fd source
