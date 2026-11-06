# Universal Engineering & AI Collaboration Skills

A cross-project, cross-language library of **AI collaboration skills**, following the **Agent Skills** directory standard. Skills are organised by **"when a rule takes effect"**, not by topic.

> English is the authoritative version. A Chinese mirror lives at [`README.zh.md`](README.zh.md) for reading convenience; where the two differ, this file wins.

---

## Three-layer architecture

| Layer | Location | When loaded | Cost |
|:--|:--|:--|:--|
| **L0 redlines** | `~/.pi/agent/AGENTS.md` (global) | **Every session, resident** | Fixed, ~800 tokens |
| **L1 skills** | `*/*/SKILL.md` in this repo | `read` by the model after description matches | 0 until triggered |
| **L2 payloads** | each skill's `references/` `scripts/` `templates/` | On demand, after the parent skill points to them | 0, and never registered as skills |

> **Deciding rule**: to place a rule, ask one question — **"when does it need to take effect?"**
> Needs to be judged before *every* action (authorisation, scope, command discipline) → L0; domain knowledge → L1; cases and templates → L2.

---

## Language policy

| File | Language | Normative? | Registered as a skill? |
|:--|:--|:--|:--|
| `SKILL.md` | English | **Yes — single source of truth** | Yes (only this filename is discovered) |
| `SKILL.zh.md` | Chinese | No — explanatory mirror | **No** (the loader only picks up `SKILL.md`) |
| `README.md` | English | **Yes** | No |
| `README.zh.md` | Chinese | No — explanatory mirror | No |
| `references/**` | **Chinese only for now** | Payload, referenced from L1 | No |

Consequences of this split:

- **No extra index cost.** Mirrors are never registered, so the resident description set does not double.
- **Rule changes land in English first**, then get synced to the mirror. A mirror may lag; the English text always wins.
- **`references/` are still Chinese-only.** The English L1 marks those links with `(zh)`. Translating payloads is staged separately and filtered by *"is this useful outside one person's machine?"* — not by file size.

---

## Skill index

### general (engineering discipline)

| Skill | Covers |
|:--|:--|
| [`collaboration-discipline`](general/collaboration-discipline/SKILL.md) | Three authorisation tiers, diagnosis-vs-repair boundary, task scope, stop-when-unsure, strict objectivity, target-platform priority |
| [`code-standards`](general/code-standards/SKILL.md) | 500-line redline and splitting tactics, directory/package layering (split triggers, grouping by responsibility, migration discipline), comment hygiene (usage-first; no design history/rationale/changelog), architecture docs sync (root/module README down to per-file responsibilities), temp-artifact discipline, plan-document lifecycle (active/archive dirs · per-item status · delete when done · directory README as handoff index) |
| [`file-architecture`](general/file-architecture/SKILL.md) | File-layout design criteria: readability model (two-hop lookup / one word per concept / self-describing names), feature-first splitting order with size heuristics (≤2 flat / ≥3 form a directory), CCP · Parnas · reuse-scope criteria, dependency-direction discipline, fake-splitting antipatterns |
| [`evidence-research`](general/evidence-research/SKILL.md) | Four-tier verification order, free web search, structured-data integrity, cross-source checking with traceability |

### environment (toolchain)

| Skill | Covers |
|:--|:--|
| [`dev-environment`](environment/dev-environment/SKILL.md) | Scoop bootstrap, high-leverage CLI matrix, scenario-based tool selection, installed-tool inventory |
| [`terminal-dotfiles`](environment/terminal-dotfiles/SKILL.md) | WezTerm / Zellij theme templates and cross-device distribution script |

### ui (interface delivery)

| Skill | Covers |
|:--|:--|
| [`ui-delivery`](ui/ui-delivery/SKILL.md) | UI asset tiering, icon-slot rule (design-source present vs absent) |

### compose (Compose development)

| Skill | Covers |
|:--|:--|
| [`compose-foundations`](compose/compose-foundations/SKILL.md) | **Shared by KMP / Android**: effect lifecycles, Modifier order and touch targets, recomposition performance, component design contract |
| [`kmp-architecture`](compose/kmp-architecture/SKILL.md) | KMP-specific: commonMain purity, interface DI over expect/actual, StateFlow MVI, banned-antipattern list |
| [`android-platform`](compose/android-platform/SKILL.md) | Android-specific: edge-to-edge and insets, Context leaks, type-safe navigation, Preview |

---

## Directory layout

```text
Skills\
├── README.md                       # this file (English, normative)
├── README.zh.md                    # Chinese mirror (non-normative)
├── scripts\sync-agent-skills.ps1   # idempotent sync of skills to each CLI agent
├── general\
│   ├── collaboration-discipline\
│   │   ├── SKILL.md
│   │   ├── SKILL.zh.md
│   │   └── references\             # case studies behind each principle
│   ├── code-standards\
│   │   ├── SKILL.md
│   │   ├── SKILL.zh.md
│   │   └── references\
│   └── evidence-research\
│       ├── SKILL.md
│       ├── SKILL.zh.md
│       └── references\
├── environment\
│   ├── dev-environment\
│   │   ├── SKILL.md
│   │   ├── SKILL.zh.md
│   │   ├── references\
│   │   └── scripts\bootstrap-scoop.ps1
│   └── terminal-dotfiles\
│       ├── SKILL.md
│       ├── SKILL.zh.md
│       ├── references\
│       ├── templates\              # wezterm.lua, zellij\config.kdl
│       └── scripts\setup-terminal-themes.ps1
├── ui\
│   └── ui-delivery\
│       ├── SKILL.md
│       ├── SKILL.zh.md
│       └── references\
└── compose\
    ├── compose-foundations\        # shared by KMP + Android
    ├── kmp-architecture\
    └── android-platform\
```

**How discovery works**: category directories (`general\` `environment\` `ui\` `compose\`) **do not** contain a `SKILL.md` and are transparent to the loader; scanning recurses down until it finds a `SKILL.md` and stops there.

So: **category directories exist only for human readability and do not affect loading**; but **never nest one skill directory inside another** — the outer one is discovered and the inner one is silently swallowed.

The same mechanism is why `SKILL.zh.md` never gets registered: discovery is keyed on the exact filename `SKILL.md`.

---

## Mounting

**Single mount point** (Agent Skills standard location, portable across hosts):

```powershell
# ~/.agents/skills is already junctioned to this repo; no per-skill mounting needed
New-Item -ItemType Junction -Path "$env:USERPROFILE\.agents\skills" -Target "<path-to-this-repo>"
```

Adding / renaming / splitting a skill **needs no remount** — repo structure *is* the mount structure.

> ⚠️ **Do not** add this repo, or individual skills, to pi's `settings.json` `skills` array: that scans in `mode=pi` and treats root-level `README.md` as a skill candidate (producing a no-frontmatter diagnostic warning). The standard `~/.agents/skills` location scans in `mode=agents`, where root-level `.md` files are ignored.

### Syncing to other CLI agents

Other agents keep their own skill directories. The script junctions each skill individually (depth 1, relying on no agent's recursion behaviour):

```powershell
powershell -ExecutionPolicy Bypass -File scripts\sync-agent-skills.ps1          # run
powershell -ExecutionPolicy Bypass -File scripts\sync-agent-skills.ps1 -WhatIf  # dry run
```

Current targets: `~/.claude/skills` (Claude Code), `~/.codex/skills` (Codex), `~/.codewhale/skills` (CodeWhale), `~/.gemini/skills` (antigravity-cli user level).

The script **only removes stale links pointing at this repo**; it never touches an agent's bundled skills (Codex's `.system/`, CodeWhale's bundled set).

### antigravity-cli (per-skill user junctions + shared location)

| Item | Path |
|:--|:--|
| Skill dir (user level) | `~/.gemini/skills/<skill>` — one junction per skill, **maintained by `sync-agent-skills.ps1`** |
| Skill dir (shared) | `~/.agents/skills` → this repo (symlink); workspace-level `<ws>/.agents/skills` has the same shape |
| Skill registry | `entries` in `~/.gemini/config/skills.json` contains `D:/GTMI/Skills` (**keep only the repo-root entry**; per-skill paths left over from past refactors are dangling and must be cleaned) |
| Rule loading | `~/.agents/rules/*.md` (currently `antigravity-rtk-rules.md`), `~/.gemini/GEMINI.md` |

After adding / renaming / splitting a skill, re-run the script once — the user-level directory is script-maintained, never hand-linked.

---

## Editing discipline

- **Single source of truth**: every normative statement exists in **exactly one** place. L0 holds executable criteria, L1 holds rule tables, L2 holds cases/templates — **the three must never restate the same normative text**.
- **Language mirrors are not duplication**: a non-normative translation (`*.zh.md`) does not violate the rule above, because it carries no authority. It must say so at the top and must be re-synced when the English changes.
- **No keyword-list adjudication**: behavioural rules use semantic criteria (e.g. "authorisation = permissive semantics toward a concrete action"), never an enumerable keyword list — lists always leak and conflict with semantic judgement.
- **No dual containers**: the same rule must not exist both as a "skill" and as an "AGENTS.md entry".
- Update the skill index above whenever a skill is added, renamed, or removed.
- `.tempcache/` is never committed (see `.gitignore`).
