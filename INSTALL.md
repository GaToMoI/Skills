# Installing These Skills

> English is authoritative. Chinese mirror: [`INSTALL.zh.md`](INSTALL.zh.md).

Two ways: **let your agent install it** (recommended), or do it by hand.

---

## 1 · Hand it to your agent

Open any agent that can run shell commands and paste this:

```text
Read INSTALL.md from <path-or-url> and install these skills for me.
Before touching anything, ask me one question at a time:
  1. which directory this repo should live in,
  2. which directory the skills should go into, or which agent this is for.
Do not assume defaults. Then run the steps, verify, and report every path you created or changed.
```

That is the whole instruction. The contract below is what the agent should follow.

---

## 2 · Agent contract

### Ask first — never default

Ask these **one at a time**, in order, and wait for each answer.

| # | Question | Why it cannot be defaulted |
|:--|:--|:--|
| 1 | Where should this repo live? | People keep code on different drives; a default lands somewhere unexpected |
| 2 | Where should the skills be installed — or which agent is this for? | Each agent reads its own directory, and a same-named skill may already exist |
| 3 | Copy or link? | Copy is simple but every update has to be redone; a link shares one source, which some users dislike |

**Skip question 3 when there is only one agent** — just copy, unless the user explicitly asks for a link.

### Then do

1. **Probe, do not assume.** Check which agent directories actually exist before proposing any path.
2. **Clone or locate the repo** at the path from question 1.
3. **Install per skill, not per repo root.** Every skill must end up as `<skillDir>/<name>/SKILL.md`.
4. **Prefer a link** — Windows `junction`, macOS/Linux `symlink` — so a single `git pull` updates everything. Fall back to copying when links are unsupported or the user asked for copies.
5. **Never overwrite** an existing skill directory. On a name collision, stop and ask.
6. **Be idempotent.** A second run must not create duplicate links or stale copies: remove links that point at this repo before recreating them, and touch nothing else.
7. **Verify** that every installed skill resolves to a readable `SKILL.md`.
8. **Report** which skills went where, copy or link, and what already existed.

### The Windows tool kit is optional

This repo also documents an optional Windows efficiency CLI kit. It is **not required** — nothing breaks without it. If the user wants it, follow the options defined in [`environment/dev-environment/SKILL.md`](environment/dev-environment/SKILL.md); do not invent a parallel install path.

---

## 3 · Manual install

```bash
# 1. put the repo somewhere outside any skills root
git clone <repo-url> ~/code/ai-skills

# 2. link each skill you want into your agent's skill directory
mkdir -p ~/.agents/skills
ln -s ~/code/ai-skills/general/code-standards ~/.agents/skills/code-standards
# ... repeat per skill

# 3. restart your agent and ask it: "which skills do you have?"
```

On Windows use `mklink /J` (junction) — it works without administrator rights where `mklink /D` would not.

### Where each agent looks

| Agent | Skill directory |
|:--|:--|
| Agent Skills standard (pi, generic) | `~/.agents/skills/<name>/SKILL.md` |
| Claude Code | `~/.claude/skills/<name>/SKILL.md` |
| Codex | `~/.codex/skills/<name>/SKILL.md` |
| Gemini / Antigravity | `~/.gemini/skills/<name>/SKILL.md` |
| CodeWhale | `~/.codewhale/skills/<name>/SKILL.md` |

> **Do not clone this repo into a skills root as-is.** Discovery rules differ between agents; some do not recurse, and the category directories (`general/`, `compose/`, …) would then be mistaken for skills. Clone it elsewhere and link the individual skill directories.

---

## 4 · Updating

With links in place, `git pull` inside the repo is the entire update. With copies, re-run the install for the skills you copied.
