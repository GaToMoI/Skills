---
name: file-architecture
description: >-
  File and package architecture design — how to plan file/directory layout so a codebase
  stays navigable: the two-hop lookup model, self-describing names and one-word-per-concept,
  the feature-first / responsibility-second splitting order, planning-time pre-judgement
  with size heuristics (≤2 files stay flat; ≥3 UI files form a directory), the change-reason
  (CCP), information-hiding (Parnas) and reuse-scope criteria, dependency-direction discipline,
  and fake-splitting antipatterns.
  Use when planning a new feature's file layout, deciding whether to create a folder or package,
  reviewing a crowded directory, or judging whether an existing structure needs adjustment.
---

# File Architecture

**Design-time** criteria aimed at "humans find files" and "features stay movable". **Existing-code thresholds and migration discipline** live in [`code-standards`](../code-standards/SKILL.md) §5; this skill covers **how to think while planning, what to split along, and how to re-check incrementally**.

---

## 1 · The readability target model

Exactly one criterion: **can a person reach the target file by the shortest path?**

- **Two-hop lookup**: intent → module/layer → feature directory → file. Every hop is answered by a name describing *what is inside*, never by memorised paths.
- **Directory and file names are a keyword index**: the person looking usually does not know what the file is called, only **what it does** — so names must describe the *doing* (domain word), not the *type*.
- **One word, one concept**: one name per concept across the whole codebase. Synonym drift (e.g. "card" and "work item" used interchangeably) makes keyword search miss half the hits; the project's design docs are the single source for concept words.
- **One file, one topic**: mixed files scatter the lines of a single trait across unrelated contexts — found, but unreadable.

## 2 · Splitting priority order

1. **First cut: by feature** — a feature (a set of files that jointly implement one concept) is the unit of packaging;
2. **Second cut: within a feature, by responsibility** — UI / state / data.

Dimension details (sort by responsibility surface or domain; never slice by type) are in [`code-standards`](../code-standards/SKILL.md) §5.

**Size heuristics** (pre-judgement triggers, only answering "is a package worth creating?"):

| Situation | Handling |
|:--|:--|
| Feature totals ≤ 2 files | No package; keep them flat |
| Predicted UI side (after honouring the 500-line rule) ≥ 3 files | Create a feature directory; name files by responsibility |
| State / data classes | Decide by reuse scope — single-feature use travels with the feature; multi-feature use is lifted into a shared layer |

The numbers are only triggers; **whether to split is decided by the next section**.

## 3 · The three-part test

1. **Reason to change (CCP · Common Closure Principle)**: things that change together belong together. "Feature" is merely the most common shape of "changes together" — the criterion itself is *who always changes with whom*. Two halves of a feature that never change together deserve another split; a frequently changing block shared by two features should be lifted.
2. **Information hiding (Parnas) self-check**: before acting, ask **"what secret is this package hiding?"** If you can answer (e.g. the zone package hides hit-testing and zoom algorithms), it is a module. If you cannot (you merely grouped similar files), it is a classification, and the payoff is near zero.
3. **Reuse scope (CRP · Common Reuse Principle)**: things reused together belong together; never force a consumer to depend on unrelated material. This is what decides whether "copy the whole directory out" holds.

## 4 · Three-phase process

1. **Planning**: design file placement alongside the feature — predict size, settle the package structure;
2. **Implementation**: place as planned; split when needed rather than cramming into one file "to split later";
3. **Incremental**: judge the landing spot for every new feature, and simultaneously re-check whether the existing structure needs adjustment.

**Re-checking weighs no less than pre-judgement**: predictions tend to underestimate — dialogs, overlays, probes, and readouts usually grow during the incremental phase.

## 5 · Dependency-direction discipline

Package boundaries only hold together with dependency discipline; otherwise "package by feature" is flat layout with new names.

- Cross-package dependencies are **one-directional and acyclic** — no reverse imports;
- Shared pieces are lifted the moment they appear (multi-feature reuse → shared/contract layer); never leave two copies;
- **Directory boundary ≈ dependency boundary**: if files inside a directory reach back to private files outside it, "move the whole directory" no longer holds.

## 6 · Antipatterns (fake splits)

| Antipattern | Symptom |
|:--|:--|
| Splitting by count | A directory for 1–2 files, only because "it feels like there should be one" |
| Splitting by symmetry | Every feature gets a package for visual symmetry, though the common-closure case does not hold |
| Junk drawer | `utils/` `helpers/` `common/` `misc/` — the most heterogeneous content, a search black hole |
| Classify without hiding | The directory exists, but every file must be `public` to collaborate — the package encloses no secret |

## 7 · Theory behind these rules

| Statement here | Concept | Source |
|:--|:--|:--|
| Package by feature first | Package by Feature | [javapractices, *Package by feature, not layer*](http://www.javapractices.com/topic/TopicAction.do?Id=205) |
| Directories should shout what the system does | Screaming Architecture | [Uncle Bob, 2011](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html) |
| A slice includes UI and cuts across layers | Vertical Slice Architecture | [Jimmy Bogard, 2018](https://www.jimmybogard.com/vertical-slice-architecture/) |
| Group what changes together | Common Closure Principle | Package cohesion principles (Uncle Bob, *Agile Software Development*, ch. 13) |
| Group what is reused together | Common Reuse Principle | Same as above |
| Decompose modules around hidden change | Information Hiding | [Parnas, 1972](https://dl.acm.org/doi/10.1145/361598.361623) |
| Split trigger for existing large packages | — | [`code-standards`](../code-standards/SKILL.md) §5; aligned with the [Android modularization guide](https://developer.android.com/topic/modularization) |

**The numeric thresholds (≤2 / ≥3) have no authoritative source** — they are empirical heuristics. Mainstream literature gives only qualitative criteria (high cohesion, low coupling), so this skill marks them as *triggers*, not as the rule itself.
