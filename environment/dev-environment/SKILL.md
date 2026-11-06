---
name: dev-environment
description: >-
  Windows-only (Scoop / PowerShell) optional efficiency kit and CLI routing: detect and install Scoop with
  user-confirmed install paths, the curated AI-efficiency CLI matrix (fd, rg, ast-grep, jq, rtk, bat, delta),
  scenario-based tool selection with silent fallbacks, and verified command-name aliases. Nothing here is
  required — the kit is an optional upgrade that asks at most once on first use. Use when setting up a Windows
  machine, checking which CLI to use for finding files, searching code, parsing JSON, or trimming logs; skip on
  macOS/Linux unless you specifically want the equivalent mapping.
---

# Dev Environment and Tool Selection

> **Windows only** (Scoop / PowerShell). On macOS/Linux this skill can be skipped entirely — nothing in any
> skill depends on these tools. They are an optional efficiency kit, and every missing tool degrades silently.

---

## Iron rules

- 🚫 **Never** run `scoop install` / `uninstall` / `update` before the user confirms.
- ✅ **Allowed**: use **already installed** tools freely during normal development (no need to ask).
- ✅ **Allowed**: on an explicit request, research and report first, install only after confirmation.
- **User directory sovereignty first**: never hardcode a default install path onto the system drive; the target directory must be confirmed by the user before any package-manager bootstrap.

---

## Tool kit: all optional

Nothing in this list is required. Every entry has a fallback; when a tool is missing, degrade silently and keep working. Never turn a missing tool into an error or a blocker.

| Group | Tools | Fallback when missing |
|:--|:--|:--|
| Search | `fd`, `rg`, `sg`, `ug`, `rga` | `ls` / `Select-String` / `grep` on scoped paths; `rg` + manual review in place of `sg` |
| Data | `jq`, `yq`, `xsv`, `csview`, `choose`, `mlr` | `python -c` |
| Web | `websearch` (ddgs), `xh`, `curlie`, `httpstat` | the retrieval ladder below |
| Logs / build | `rtk`, `watchexec`, `just` | `tail` / `head` / `grep` |
| Preview / diff | `bat`, `delta`, `glow`, `hexyl` | `cat` / `diff` |
| System / disk | `dust`, `duf`, `dua`, `gdu`, `procs`, `bandwhich`, `broot`, `btm` | Task Manager / `df` / `ps` |
| Navigation | `zoxide`, `eza`, `yazi`, `lf` | `dir` / `ls` |

### Retrieval ladder (web data)

1. **`websearch` from this kit** — the preferred path: a free ddgs wrapper, no API key.
2. **The host agent's own web tool**, if it has one — an acceptable substitute, not a replacement for preference 1.
3. **`curl` + a public API**, parsed with `jq` or `python`.
4. **Ask the user to paste the content.**

Reaching step 4 is acceptable. A missing search tool is not a failure.

---

## First-run invitation (once, then never)

On the **first use of this skill in a workspace**, if the optional kit is not present, offer a one-time menu. After any answer, never raise it again.

| Option | Installs | For |
|:--|:--|:--|
| **A · minimal** | `websearch` (ddgs wrapper) | web research only |
| **B · recommended** | `fd rg jq bat` + `websearch` | day-to-day work |
| **C · full** | the whole curated matrix above | set up once, never revisit |
| **D · skip** | nothing | fine — everything degrades silently |

**Procedure**

1. Probe the environment. If the kit is already present → say nothing, no menu.
2. Otherwise print A / B / C / D, each with what it installs and why it is worth it, then wait.
3. Record the answer in `<skill-dir>/.tempcache/tool-prefs.json`.
4. **One ask, ever.** Never raise the menu again in this workspace, regardless of the answer.
5. On skip → fall back silently; no reminders, no nagging.
6. If a task genuinely needs web retrieval and every rung of the ladder is unavailable, say so once and ask permission to install `websearch` — the only permitted second prompt, once only.
7. `.tempcache/` may be cleaned at any time; if the state file is gone, the next use counts as a first run again.

**State file** — `<skill-dir>/.tempcache/tool-prefs.json`:

```json
{
  "askState": "answered",
  "choice": "B",
  "reaskUsed": false,
  "date": "2026-10-11",
  "tools": { "websearch": "installed", "rtk": "skipped" }
}
```

`askState`: `pending` / `answered` · `choice`: `A` / `B` / `C` / `D`

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
