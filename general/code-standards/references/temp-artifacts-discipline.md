# Temp Artifact Discipline

> Scope: this file expands on "4 · Temp-artifact discipline" in the `code-standards` skill.

---

## 1. Artifact tiers: the default bucket

**The only question: "Does this file belong in version control?"** Do not try to enumerate "what counts as temp" from memory — classify negatively; **everything outside the first two classes is temp**.

| Class | Criterion | Destination | Tracked |
|:--|:--|:--|:--|
| **Project artifact** | Part of the project: source, config, docs, resources | In place | ✅ |
| **Build output** | Regenerable by the project: `build/`, `.gradle/`, `node_modules/`, jars/zips produced directly by the build tool | In place | ❌ (gitignored) |
| **Temp artifact** | Neither tracked nor regenerable: logs, one-off scripts, temp screenshots, scraping intermediates, packages copied or renamed for testing, exports | `<repo>/.tempcache/` | ❌ (ignored wholesale) |
| **Experiment artifact** | Has reference value: demos cited by docs, spike modules, research evidence | The repo's experiment directory | ✅ as needed |

**Two boundaries that are easy to get wrong**:

- **Hand-made packages**: produced directly by the build tool under `build/` → build output, stays in place; copied or renamed out of it for testing or delivery verification → **temp artifact**, goes to `.tempcache/`.
- **Experiment vs temp**: only "already cited by a document" earns promotion to experiment artifact; uncited demos and scripts stay in `.tempcache/` and must not occupy the experiment area.

**When you cannot decide**: treat it as a temp artifact (default bucket — better to have it swept away with `.tempcache/` than to pollute the repo structure).

---

## 2. Inside `.tempcache/`

`.tempcache/` is not a bin; internally it follows the host repo's file-architecture rules:

- **Subdirectories by purpose**: `.tempcache/logs/`, `.tempcache/scratch/`, `.tempcache/captures/`.
- **Semantic names**: `login-timeout-repro-20260911.log`.
- 🚫 **Never** stack numbered copies: `test1.sh`, `test2.sh`, `test_new.sh`, `test_final.sh`.
- **Deletable wholesale at any time**, leaving no dangling references — i.e. no document, script, or config in the repo may **reference** a file inside `.tempcache/`.

---

## 3. Common violations

| Violation | Problem | Correct handling |
|:--|:--|:--|
| Debug script dropped in the repo root | Pollutes the project structure, risks being committed | Move to `.tempcache/scratch/` |
| Logs piling up in a module directory | The module README no longer matches reality | Move to `.tempcache/logs/` |
| Naming things `test_final_v2` | Nobody can tell what is valid, so nobody dares delete | Semantic name + timestamp |
| Docs referencing a temp screenshot | Docs break when `.tempcache/` is cleaned | Promote the screenshot to an experiment artifact |
| Moving `build/` output into `.tempcache/` | Mixes two classes and breaks build trust (the next build finds files gone) | Build output stays in place + gitignored |
| Dumping an "I don't know what this is" file into the repo root | Structural readability collapses and nobody dares delete it | Ask "tracked or not?" first; if undecidable, use `.tempcache/` |

---

## 4. Intersection with doc-sync rules

When deleting or moving a file that a README references, **update the reference in the same task** (see "3 · Keeping architecture docs in sync" in `code-standards`).
Conversely, any artifact referenced by a document **may no longer stay in `.tempcache/`** — promote it to an experiment artifact.
