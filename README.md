# 通用工程与 AI 协作技能库 (Universal Skills Repository)

跨项目、跨语言通用的 **AI 协作技能（Skills）** 归档库。采用 **Agent Skills 标准**目录格式，按"**生效时机**"分层而非按主题堆叠。

---

## 三层架构

| 层 | 位置 | 加载时机 | 成本 |
|:--|:--|:--|:--|
| **L0 红线** | `~/.pi/agent/AGENTS.md`（全局） | **每次会话常驻** | 固定，约 800 token |
| **L1 技能** | 本仓库 `*/*/SKILL.md` | description 语义匹配后由模型 `read` | 0 直到触发 |
| **L2 载荷** | 各技能 `references/` `scripts/` `templates/` | 父技能指路后按需读取 | 0，且不注册为技能 |

> **判据**：一条规则该放哪层，只问一个问题——**「它在什么时机生效？」**
> 每次动作前都要判的（授权、边界、命令纪律）→ L0；领域知识 → L1；判例与模板 → L2。

---

## 技能索引

### general（通用工程纪律）

| 技能 | 覆盖内容 |
|:--|:--|
| [`collaboration-discipline`](general/collaboration-discipline/SKILL.md) | 授权粒度三档、诊断与修复权界、任务边界、存疑即停、客观直率、目标平台优先级 |
| [`code-standards`](general/code-standards/SKILL.md) | 500 行红线与拆分手法、注释规范（面向使用者；禁设计沿革/论证/变更史）、架构文档同步、临时产物纪律 |
| [`evidence-research`](general/evidence-research/SKILL.md) | 事实查验四级执行序、免费网络检索、结构化数据完整性、交叉核对与溯源 |

### environment（环境与工具链）

| 技能 | 覆盖内容 |
|:--|:--|
| [`dev-environment`](environment/dev-environment/SKILL.md) | Scoop 初始化、AI 提效 CLI 矩阵、场景选型决策树、已装工具清单 |
| [`terminal-dotfiles`](environment/terminal-dotfiles/SKILL.md) | WezTerm / Zellij 主题模板与跨设备分发脚本 |

### ui（界面交付）

| 技能 | 覆盖内容 |
|:--|:--|
| [`ui-delivery`](ui/ui-delivery/SKILL.md) | UI 资产分级判定、图标位铁律（设计源有无两条路径） |

### compose（Compose 开发）

| 技能 | 覆盖内容 |
|:--|:--|
| [`compose-foundations`](compose/compose-foundations/SKILL.md) | **KMP / Android 共用**：副作用生命周期、Modifier 顺序与触摸热区、重组性能、组件设计契约 |
| [`kmp-architecture`](compose/kmp-architecture/SKILL.md) | KMP 专项：commonMain 纯粹性、接口 DI > expect/actual、StateFlow MVI、反模式黑名单 |
| [`android-platform`](compose/android-platform/SKILL.md) | Android 专项：edge-to-edge 与 Insets、Context 泄漏、Type-Safe 导航、Preview |

---

## 目录结构

```text
D:\GTMI\Skills\
├── README.md                       # 本文件（非技能）
├── scripts\sync-agent-skills.ps1   # 同步全局技能到各 CLI agent（幂等）
├── general\
│   ├── collaboration-discipline\
│   │   ├── SKILL.md
│   │   └── references\             # 各准则展开判例
│   ├── code-standards\
│   │   ├── SKILL.md
│   │   └── references\
│   └── evidence-research\
│       ├── SKILL.md
│       └── references\
├── environment\
│   ├── dev-environment\
│   │   ├── SKILL.md
│   │   ├── references\
│   │   └── scripts\bootstrap-scoop.ps1
│   └── terminal-dotfiles\
│       ├── SKILL.md
│       ├── references\
│       ├── templates\              # wezterm.lua, zellij\config.kdl
│       └── scripts\setup-terminal-themes.ps1
├── ui\
│   └── ui-delivery\
│       ├── SKILL.md
│       └── references\
└── compose\
    ├── compose-foundations\        # KMP + Android 共用
    ├── kmp-architecture\
    └── android-platform\
```

**发现机制说明**：分类目录（`general\` `environment\` `ui\` `compose\`）**不含** `SKILL.md`，对加载器透明；扫描时递归下潜直到找到 `SKILL.md` 即止。
因此：**分类目录仅为人可读性而设，不影响加载**；但**严禁在技能目录内嵌套另一个含 `SKILL.md` 的目录**——外层会被发现，内层被静默吞掉。

---

## 挂载方式

**唯一挂载点**（Agent Skills 标准位置，多宿主通用）：

```powershell
# ~/.agents/skills 已软链至本仓库；无需逐技能挂载
New-Item -ItemType Junction -Path "$env:USERPROFILE\.agents\skills" -Target "D:\GTMI\Skills"
```

新增 / 改名 / 拆分技能后**无需重挂**——仓库结构即挂载结构。

> ⚠️ **不要**再把本仓库整体或逐个技能加入 pi 的 `settings.json` `skills` 数组：那会以 `mode=pi` 扫描，把根级 `README.md` 也当技能候选（产生无 frontmatter 的诊断警告）。标准位置 `~/.agents/skills` 以 `mode=agents` 扫描，根级 `.md` 被忽略。

### 同步到其他 CLI agent

其它 agent 自有技能目录，用脚本逐技能建 junction（深度 1，不依赖任何 agent 的递归行为）：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\sync-agent-skills.ps1          # 执行
powershell -ExecutionPolicy Bypass -File scripts\sync-agent-skills.ps1 -WhatIf  # 预演
```

当前目标：`~/.claude/skills`（Claude Code）、`~/.codex/skills`（Codex）、`~/.codewhale/skills`（CodeWhale）。
脚本**只删指向本仓库的旧链接**，绝不触碰 agent 自带技能（如 Codex 的 `.system/`、CodeWhale 的 bundled）。

### antigravity-cli（走共享位置，不靠脚本同步）

| 项 | 路径 |
|:--|:--|
| 技能目录 | `~/.agents/skills` → 本仓库（符号链接） |
| 技能目录（备用） | `~/.gemini/config/skills` → 本仓库（符号链接） |
| 技能注册 | `~/.gemini/config/skills.json` 的 `entries` 含 `D:/GTMI/Skills` |
| 规则加载 | `~/.agents/rules/*.md`（已有 `antigravity-rtk-rules.md`）、`~/.gemini/GEMINI.md` |
新增 / 改名技能后重跑一次即可。

---

## 编辑纪律

- **单真相源**：每条规则的规范性表述**只允许存在一处**。L0 放可执行判据，L1 放规则表，L2 放判例/模板——**三者不得互相复述同一段规范文本**。
- **禁止词表穷举**：行为判定用语义判据（如"授权 = 对具体动作的放行语义"），不得写成待匹配的关键词列表——词表必漏，且与语义判断冲突。
- **禁止双重容器**：同一份规则不得同时以"技能"和"AGENTS.md 条目"两种身份存在。
- 新增/删减技能时，同步更新本文件的技能索引。
- `tempCache/` 不入版本库（见 `.gitignore`）。
