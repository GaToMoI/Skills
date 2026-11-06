# 安装这些技能

> **非规范镜像**：本文件是 [`INSTALL.md`](INSTALL.md)（英文）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。

两种方式：**交给你的 AI 装**（推荐），或自己手动装。

---

## 1 · 丢给你的 AI

打开任意能执行命令的 agent，粘贴这段话：

```text
读取 <路径或链接> 下的 INSTALL.md，帮我安装这些技能。
动手之前，一次只问我一个问题：
  1. 这个仓库要放在哪个目录，
  2. 技能要装到哪个目录，或者这是给哪个 agent 装的。
不要用默认值。然后执行、验证，并把所有创建或修改过的路径汇报给我。
```

就这一句。下面这份契约是 AI 应该遵循的细则。

---

## 2 · AI 执行契约

### 先问，不许默认

按顺序**一次问一个**，每问都要等回答。

| 顺序 | 问什么 | 为什么不能默认 |
|:--|:--|:--|
| 1 | 本仓库放在哪个目录 | 有人放 D 盘、有人放 `~/code`，默认会落到用户没预期的地方 |
| 2 | 技能装到哪个目录，或这是给哪个 agent 装的 | 每个 agent 读自己的目录，且可能已存在同名技能 |
| 3 | 复制还是链接 | 复制简单，但每次更新都要重做；链接一份源共享，但有人不喜欢链接 |

**只有一个 agent 时跳过第 3 问**——直接复制，除非用户明确要链接。

### 然后执行

1. **先探测，别假设。** 先看哪些 agent 目录真实存在，再提出路径。
2. **按第 1 问的路径克隆或定位仓库。**
3. **逐技能安装，不是整仓塞入。** 每个技能都必须落在 `<skillDir>/<name>/SKILL.md`。
4. **优先用链接**——Windows 用 `junction`，macOS/Linux 用 `symlink`——这样一次 `git pull` 就更新全部。不支持链接或用户要复制时，退回复制。
5. **绝不覆盖**已存在的同名技能目录。撞名就停下问。
6. **幂等。** 再跑一次不得产生重复链接或残留副本：重建前先删掉指向本仓库的旧链接，其余一律不碰。
7. **验证**每个已装技能都能解析到可读的 `SKILL.md`。
8. **汇报**：哪些技能装到了哪里、用的是复制还是链接、哪些原本就已存在。

### Windows 工具包是可选的

本仓库还记录了一套可选的 Windows 提效 CLI 工具包，**不是必需的**——没有它什么都不会坏。用户想要的话，按 [`environment/dev-environment/SKILL.md`](environment/dev-environment/SKILL.md) 里定义的选项来，不要另造一套安装路径。

---

## 3 · 手动安装

```bash
# 1. 把仓库放到任意技能根目录之外的位置
git clone <repo-url> ~/code/ai-skills

# 2. 把想用的技能逐个链接进 agent 的技能目录
mkdir -p ~/.agents/skills
ln -s ~/code/ai-skills/general/code-standards ~/.agents/skills/code-standards
# …… 每个技能重复一次

# 3. 重启 agent，然后问它："你有哪些技能？"
```

Windows 上用 `mklink /J`（junction）——它在没有管理员权限时也能用，而 `mklink /D` 不行。

### 各 agent 的查找位置

| Agent | 技能目录 |
|:--|:--|
| Agent Skills 标准（pi、通用） | `~/.agents/skills/<name>/SKILL.md` |
| Claude Code | `~/.claude/skills/<name>/SKILL.md` |
| Codex | `~/.codex/skills/<name>/SKILL.md` |
| Gemini / Antigravity | `~/.gemini/skills/<name>/SKILL.md` |
| CodeWhale | `~/.codewhale/skills/<name>/SKILL.md` |

> **不要把本仓库直接克隆进技能根目录。** 各 agent 的发现规则不一致，有的不递归，那么分类目录（`general/`、`compose/` 等）会被误认成技能。请克隆到别处，再逐个技能目录建立链接。

---

## 4 · 更新

链接就位后，在仓库里执行 `git pull` 就是全部更新动作。若是复制安装，重跑一次你复制过的那几个技能的安装步骤。
