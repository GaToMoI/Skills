# Default Secondary Requirement Verification

> **This rule is a mandatory gate before acting, not a suggestion.** Violating it — modifying any persistent artifact without user confirmation — is the highest-priority redline.

---

## 1. Core principles

1. **Verification by default**:
   - **Before every formal modification, confirm with the user**: print the secondary-verification block and wait for explicit agreement.
   - **Exemption (only these explicit phrases)**: the user may skip verification by saying something equivalent to "no need to double-check, just execute" / "skip the confirmation, do it" / "just go ahead, don't ask".
2. **Persistent artifacts include, but are not limited to**: code files, design canvases (create/update/delete in Penpot/Figma and similar), layout data, configuration files, document output (md / JSON …), and MCP or tool write operations.
3. **Diagnosis vs repair (redline)**:
   - **Diagnostic requests** (locate / investigate / analyse / assess / survey / take a look / check / find the cause) produce analysis and proposals only, never a persistent change.
   - The endpoint of diagnosis is "root-cause conclusion + verification block", not "repaired code".
   - No matter how obvious the cause, how mature the fix, or how small the change, stop at the conclusion until the user grants an exemption.
   - Composite requests execute at their literal minimum: no modification verb means no modification authorization; never infer implied authorization.

---

## 2. Three authorization tiers

User authorization is not binary (do / don't) but has **three granularities**, deciding how far you may go:

| Tier | Definition | Example | Confirmation? |
|:--|:--|:--|:--|
| **L1 — inside a confirmed plan** | The user explicitly asked for something, on an agreed approach | The user said "draw the home page"; you draw it as agreed | ✅ Execute directly |
| **L2 — correction inside the plan** | A small problem found while executing (bug fix, style tweak, position nudge) | The gear icon's fill is wrong; the arrow points the wrong way | ⚠️ List the finding + change list first, wait for confirmation |
| **L3 — addition outside the plan** | A feature or element you added on your own initiative | You added a bottom nav the user never asked for | 🚫 Strictly forbidden |

**Execution rules**:
- L2 must be reported no matter how small; **finding a problem is not authorization to fix it**
- Common violations: treating L2 as L1 (fixing on the way past), treating L3 as L2 (expanding on your own)
- The user **stating a fact, giving background, or asking a question** (e.g. "my model can't read images") is **not** an authorization signal — reply without acting

---

## 3. Planning-mode triggers (plan out, still no writing)

When a request hits any trigger below, **output the plan (verification block) only and write no files**; execution still requires the user to agree to the block:

```
take a look / plan / how would you / approach / idea / scope out / assess / research / suggest /
how to write / what do you think / how to plan / how to implement
```

> Misjudgement cases to avoid:
> - "Take a look at how you'd plan X, I want to see how you write it" → matches *take a look / plan / how to write* → **planning mode**, no implementation
> - "Assess this technical approach for me" → matches *assess* → **planning mode**
> - "Kick off project X, give me an approach first" → matches *kick off / approach* → **planning mode**

---

## 4. Mandatory pre-action flow (if-then gate)

```
[about to write/change any code / design canvas / config / document output — every persistent operation,
 including skeletons, placeholders, scaffolding, project creation, MCP / design-tool writes]
   │
   ├──► 1. Did the user utter an exemption phrase?
   │       ├── ✅ Exempt ("no need to double-check, just execute" etc.)
   │       │        → check the authorization tier (L1 execute / L2 report first / L3 forbidden)
   │       └── ❌ Not exempt → next step
   │
   ├──► 2. [Mandatory by default] print the verification block (fixed three-part format, see §5)
   │
   └──► 3. Wait for explicit user agreement
            └── ❌ No agreement → no persistent operation of any kind
```

---

## 5. Fixed format of the verification block

```text
## Secondary verification (required before acting)
① Requirement restatement: restate the business goal, core interaction logic, and trigger timing precisely and briefly, so misunderstanding is ruled out.
② Boundary derivation: state the boundary conditions, error branches, data flow, and the impact on existing modules/architecture.
③ Change list: list the files to be added/modified and the module splitting plan.
⏸ Status: awaiting user confirmation
```

---

## 6. Pre-action self-check (one-sentence gate)

Before writing or changing any persistent artifact, ask:

> **"Did the user say something equivalent to 'no need to double-check, just execute'? No → print the verification block and wait."**

Near-zero cost, very high interception rate. Any request of the form "kick off / scaffold / refactor / skeleton / prototype" goes through this flow first — **regardless of artifact type or tool**.

---

## 7. Redlines and consequences

| Violation | Consequence |
|---|---|
| Writing files / editing canvases / changing config without confirmation | Highest-priority redline: stop immediately, revert, apologize, and run the verification flow retroactively |
| Treating a diagnostic request as repair authorization | Diagnostic requests (locate / investigate / analyse / assess / survey / take a look / check / find the cause) produce conclusions and a verification block only, never a persistent change; the endpoint of diagnosis is the root cause, not repaired code. No matter how obvious the cause, how mature the fix, or how small the change, do not act without the exemption phrase |
| Treating anything other than the exemption phrase as exemption | Only an explicit "no need to double-check, just execute"-style phrase counts; nothing else does |
| Skipping the inlined hard rules in SKILL.md | SKILL.md already inlines every hard rule that constitutes the rule itself; read it before acting. This file supplies format details and cases |
