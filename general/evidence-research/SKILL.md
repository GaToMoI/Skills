---
name: evidence-research
description: >-
  Fact-checking and data-acquisition integrity: verify before asserting, the 4-tier low-token lookup order,
  web search via free no-key tools instead of scraping search engines, structured-data parsing that preserves
  value-to-field mapping, and cross-source verification with traceability.
  Use when you need to confirm an API, library, framework, or version behavior; when researching or comparing
  technologies; when scraping or parsing web pages, JSON, tables, or logs; or when a number or fact must be cited.
---

# Evidence & Research

**Core prohibition: never assert technical facts from memory.** The behaviour of build systems, language standards, and framework APIs must rest on official documentation or a real local project.

---

## 1 · Four-tier low-token lookup order

Escalate in order; stop at the first hit:

| Tier | Means | Constraint |
|:--|:--|:--|
| **①** | Search the local project (`fd` / `rg`) | Scoped paths; **never a full-disk `find /`** |
| **②** | Read a targeted slice of local SDK / dependency source | Read the needed files and line ranges, never the whole artifact |
| **③** | Targeted community search | Must pass the **4-step check** (below) |
| **④** | Minimal sandbox experiment | Filter the logs; **never dump full output into context** |

**Tier ③ 4-step check**: version alignment → side-effect review → minimal local verification → transparent disclosure.
**Every conclusion needs a chain of evidence**: code reference, file line number, or official spec — verifiable and reproducible.

> Full SOP: [`references/token-optimization-sop.md`](references/token-optimization-sop.md) (zh)
> Detailed criteria: [`references/fact-checking.md`](references/fact-checking.md) (zh)

---

## 2 · Web data acquisition: free options first

| Scenario | Prefer | Forbidden |
|:--|:--|:--|
| Search / fetch page body | `websearch` / `ddgs` (**free, no key**) | 🚫 `curl` against a search engine's HTML |
| REST API | `curl` + `jq` | 🚫 raw JSON piped straight into context |

> Tool list and usage: [`references/web-data-search-free.md`](references/web-data-search-free.md) (zh)

---

## 3 · Structured-data integrity

- Structured data (HTML tables / JSON / logs) must **never be flattened by linear extraction**; preserve the **value ↔ field** mapping to prevent wholesale misalignment.
- Cross-check multiple sources immediately; when they disagree, **official sources win**, and say so to the user.
- Anomalous numbers (off by orders of magnitude) require **stopping to re-verify** — never accept them with a preconception.
- Conclusions must be **traceable**: source URL / captured file, plus timestamp.

> Cases and counter-examples: [`references/data-acquisition-integrity.md`](references/data-acquisition-integrity.md) (zh)
