---
name: code-standards
description: >-
  Code delivery standards: the 500-line redline and how to split by responsibility, directory/package layering
  (split triggers, grouping by responsibility, migration discipline), comment hygiene (usage-first, no design
  history), README maintenance & structure policy, temp-artifact discipline (which files may land in a repo at
  all, and what belongs in .tempcache/), plan-document lifecycle (active vs archived, per-item status,
  delete-on-completion, README handoff index).
  Use when writing, refactoring, splitting or reviewing files; when a package grows crowded; when creating or
  renaming modules; when adding comments or public APIs; when drafting a multi-phase plan; or when about to
  create a non-source file (log, one-off script, screenshot, export, test package), when stray or unexplained
  files appear in a repo root or module dir, when the tree is cluttered and nobody dares delete
  (仓库根被不明文件污染 / 项目结构变乱 / 临时文件乱放), or when asking whether an artifact belongs in the repo.
---

# Code Standards

Cross-language (Kotlin / Java / C++ / Swift / TS / C# …) rules for source size, comments, documentation, and artifacts.

---

## 1 · The 500-line redline (all languages)

- Every source file stays **≤ 500 lines**; the healthy range is **100–300 lines**.
- Start splitting at **400–500 lines**, along a single responsibility. No god classes.
- Splitting tactics by language:

| Language | Tactics |
|:--|:--|
| Kotlin / Swift | Decouple UI components, extract extension functions, separate the state holder |
| Java / C# | Composition over inheritance, lift inner classes out |
| C++ | Headers ≤ 300 lines, Pimpl, move algorithms into their own translation unit |

> Full table with per-language examples: [`references/universal-code-redline.md`](references/universal-code-redline.md)

---

## 2 · Comments and documentation

- Comments are written **for callers**, shaped like official KDoc / Javadoc: what the method / class **does**, what the **parameters and return values** mean, **how to call it**. Never restate syntax (`// increment index by 1`).
- **Public APIs require KDoc / Javadoc** (`@param` constraints, `@return` semantics, `@throws` branches).
- **No design-history comments**: no "evolved from X", no "see discussion doc §x / ADR-xxx" provenance notes.
- **No design-rationale comments**: no "why this lives in A rather than B" deliberation — that belongs in the ADR / design doc.
- **No changelog-style comments**: no dates, versions, or "this change…". History is git's job.
- Exception: magic numbers and non-trivial algorithms must cite the formula's origin or physical meaning (there, the "origin" is necessary information).
- **Protect existing comments**: when changing code, never delete or rewrite business comments and TODOs unrelated to the change. Legacy comment styles are not retrofitted — these rules bind **newly written or newly edited** comments only.
- TODO format: `// TODO(owner/date): item`.

> Details: [`references/code-commenting-guidelines.md`](references/code-commenting-guidelines.md) (zh)

---

## 3 · Keeping architecture docs in sync

- The project-root README carries the global architecture, tech stack, module index, and build guide.
- A module with its own build script **must** keep a module README, at **per-file responsibility** granularity (annotated directory tree + a responsibility matrix for core files).
- **Adding / renaming / moving / splitting / deleting a file requires updating the corresponding README in the same task.**

> Details and structure template: [`references/doc-sync-policy.md`](references/doc-sync-policy.md) (zh)

---

## 4 · Temp-artifact discipline

> **Trigger**: **before writing the first non-source file to disk in a session**, and as a structure self-check before closing any task.

The only question to answer: **"Does this file belong in version control?"**

| Artifact class | Criterion | Destination |
|:--|:--|:--|
| Project artifact | Tracked: source, config, docs, resources | In place |
| Build output | Untracked but regenerable by the project: `build/`, `.gradle/`, `node_modules/`, jars/zips produced directly by the build tool | In place + gitignored (**not** `.tempcache/`) |
| **Everything else** | Neither tracked nor regenerable: logs, one-off scripts, screenshots, scraping intermediates, packages copied or renamed for testing, exports | **`<repo>/.tempcache/<purpose>/`** |

- **Default-bucket principle**: it is not "only what is listed counts as temp" — **anything outside the first two classes is temp**. When in doubt, treat it as temp.
- Never dump into the repo root, a module root, or the experiment area — this is the most common source of structural pollution.
- `.tempcache/` follows the host repo's file-architecture rules: subdirectories by purpose (`logs/` / `scratch/` / `captures/`), semantic names, no numbered-copy stacking.
- `.tempcache/` may be deleted wholesale at any time; nothing may reference files inside it.
- The experiment area keeps only **referenced artifacts** (demos cited by docs, spike modules, research evidence).

> Details: [`references/temp-artifacts-discipline.md`](references/temp-artifacts-discipline.md)

---

## 5 · Directory and package layering

The 500-line redline governs *how big one file may get*; this section governs *where files go*.

> Design-time criteria (predicting splits while planning, feature/responsibility splitting order, the three-part test, dependency direction) live in [`file-architecture`](../file-architecture/SKILL.md). This section covers **the existing-code trigger** (≥ 8 files) and migration discipline.

- **Split trigger** (any one is enough — do not wait until it "feels messy"): a package holds ≥ **8** source files; or a package mixes two things that **should not know about each other** (e.g. a loop engine and a business toolset, a recorder and a renderer).
- **Split dimension**: by **responsibility surface / domain** (`engine/`, `prompt/`, `tools/`, `session/`). **Never split by type** (`model/`, `ports/`, `impl/`, `internal/`) — type-sliced packages have low density and enforce nothing.
- **Density and naming**: no one-file packages (exceptions must state why); package name = lowercase responsibility noun, matching the directory.
- **Visibility**: packages are **not** a visibility boundary (Kotlin's `internal` is module-scoped, unrelated to directories). Never create an `internal/` directory just to look encapsulated.
- **Module vs package**: a module boundary answers *who owns this*, package layering answers *how to find files inside the module* — two independent questions, both governed by this section's triggers.
- **Migration discipline**: one batch at a time (one module per batch); run that module's tests plus a full build immediately after; **a green build is not proof the tests ran** — check the test report for a non-zero case count; dry-run bulk import rewrites file by file.
- **Record the decision**: large re-layouts (cross-module, public package renames) get an ADR / decision record first; thresholds and naming conventions go into the project's standards, not into feel.

---

## 6 · Plan-document lifecycle

Document shape and close-out discipline for multi-phase plans (sliced plans, milestone plans, cross-session plans). **Sub-step checklists for a single task do not qualify** — no plan document, no index entry.

- **Two directories, two roles**: keep an **active-plan directory** (e.g. `docs/todo/`) and a **history archive** (e.g. `docs/plans/`). Multi-phase plans are drafted into the active directory and **never** into the archive; the archive is frozen and accepts no new entries.
- **Per-item status is the progress truth**: every task carries its status — open `- [ ]`, done `- [x] (date)` — **marked as each item completes**, never batch-backfilled.
- **Delete on completion**: once every task is done, **delete the plan document** and update the active directory's README index. Completion evidence lives in the changelog and git; the plan document is not an accomplishment record.
- **The directory README is the handoff index**: the active directory must keep a `README.md` as the **first thing read after clearing context**, with three parts — the **plan index** (plan link | status | note, with a "start here" continuation pointer at the top), a **carry-over table** (IDs `L1 / L2 …`, holding non-plan loose ends), and a **parking lot** (unsettled ideas go into a subdirectory, not into plan documents, and are promoted once settled).

> Template, status vocabulary, cases: [`references/plan-doc-lifecycle.md`](references/plan-doc-lifecycle.md) (zh)
