# 通用工程与 AI 协作技能库 (Universal Skills Repository)

**许可：** [MIT](LICENSE) —— 可自由使用、修改、分发、商用。

> **非规范镜像**：本文件是 [`README.md`](README.md)（英文）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。

**要在别的机器/别的 agent 上安装：**见 [`INSTALL.zh.md`](INSTALL.zh.md)——把它丢给你的 AI，它会问你各项目录放哪。

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

## 语言策略

| 文件 | 语言 | 规范性 | 是否注册为技能 |
|:--|:--|:--|:--|
| `SKILL.md` | 英文 | **是——唯一真相源** | 是（只有这个文件名会被发现） |
| `SKILL.zh.md` | 中文 | 否——仅作解释镜像 | **否**（加载器只认 `SKILL.md`） |
| `README.md` | 英文 | **是** | 否 |
| `README.zh.md` | 中文 | 否——仅作解释镜像 | 否 |
| `references/**` | **中英并存** | 载荷，由 L1 指路 | 否 |

- **索引成本不增加**：镜像永不注册，常驻的 description 集合不会翻倍。
- **改规则先改英文**，再同步镜像。镜像允许滞后，冲突时以英文为准。
- **`references/` 部分已英文化**：跨环境通用的规则已是英文（与 L1 同步）；高度本机化的载荷仍为中文，其链接标注 `(zh)`。

---

## 技能索引

### general（通用工程纪律）

| 技能 | 覆盖内容 |
|:--|:--|
| [`collaboration-discipline`](general/collaboration-discipline/SKILL.zh.md) | 授权粒度三档、诊断与修复权界、任务边界、存疑即停、客观直率、目标平台优先级 |
| [`code-standards`](general/code-standards/SKILL.zh.md) | 500 行红线与拆分手法、目录与包分层（分包规则：阈值触发 / 按职责分包 / 迁移纪律）、注释规范（面向使用者；禁设计沿革/论证/变更史）、架构文档同步（根/模块 README 逐文件职责模板）、临时产物纪律、计划文档生命周期（执行中/归档双目录 · 逐项状态 · 完成即删 · 目录 README 交接索引） |
| [`file-architecture`](general/file-architecture/SKILL.zh.md) | 文件架构设计判据：可读性模型（两跳定位 / 一名一义 / 自描述命名）、功能优先的切分序与规模启发式（≤2 平铺 / ≥3 建目录）、CCP·Parnas·复用范围判据、依赖方向纪律、假分反模式 |
| [`evidence-research`](general/evidence-research/SKILL.zh.md) | 事实查验四级执行序、免费网络检索、结构化数据完整性、交叉核对与溯源 |

### environment（环境与工具链）

| 技能 | 覆盖内容 |
|:--|:--|
| [`dev-environment`](environment/dev-environment/SKILL.zh.md) | Scoop 初始化、AI 提效 CLI 矩阵、场景选型决策树、已装工具清单 |
| [`terminal-dotfiles`](environment/terminal-dotfiles/SKILL.zh.md) | WezTerm / Zellij 主题模板与跨设备分发脚本 |

### ui（界面交付）

| 技能 | 覆盖内容 |
|:--|:--|
| [`ui-delivery`](ui/ui-delivery/SKILL.zh.md) | UI 资产分级判定、图标位铁律（设计源有无两条路径） |

### compose（Compose 开发）

| 技能 | 覆盖内容 |
|:--|:--|
| [`compose-foundations`](compose/compose-foundations/SKILL.zh.md) | **KMP / Android 共用**：副作用生命周期、Modifier 顺序与触摸热区、重组性能、组件设计契约 |
| [`kmp-architecture`](compose/kmp-architecture/SKILL.zh.md) | KMP 专项：commonMain 纯粹性、接口 DI > expect/actual、StateFlow MVI、反模式黑名单 |
| [`android-platform`](compose/android-platform/SKILL.zh.md) | Android 专项：edge-to-edge 与 Insets、Context 泄漏、Type-Safe 导航、Preview |

---

## 目录结构

```text
<repo>\
├── README.md                       # 本文件（英文 · 规范版）
├── README.zh.md                    # 中文镜像（非规范）
├── scripts\sync-agent-skills.ps1   # 同步全局技能到各 CLI agent（幂等）
├── general\
│   ├── collaboration-discipline\
│   │   ├── SKILL.md                # 英文 · 规范版
│   │   ├── SKILL.zh.md             # 中文镜像
│   │   └── references\             # 各准则展开判例
│   ├── code-standards\
│   │   ├── SKILL.md
│   │   ├── SKILL.zh.md
│   │   └── references\
│   ├── file-architecture\
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
New-Item -ItemType Junction -Path "$env:USERPROFILE\.agents\skills" -Target "<path-to-this-repo>"
```

新增 / 改名 / 拆分技能后**无需重挂**——仓库结构即挂载结构。

> ⚠️ **不要**再把本仓库整体或逐个技能加入 pi 的 `settings.json` `skills` 数组：那会以 `mode=pi` 扫描，把根级 `README.md` 也当技能候选（产生无 frontmatter 的诊断警告）。标准位置 `~/.agents/skills` 以 `mode=agents` 扫描，根级 `.md` 被忽略。

### 同步到其他 CLI agent

其它 agent 自有技能目录，用脚本逐技能建 junction（深度 1，不依赖任何 agent 的递归行为）：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\sync-agent-skills.ps1          # 执行
powershell -ExecutionPolicy Bypass -File scripts\sync-agent-skills.ps1 -WhatIf  # 预演
```

当前目标：`~/.claude/skills`（Claude Code）、`~/.codex/skills`（Codex）、`~/.codewhale/skills`（CodeWhale）、`~/.gemini/skills`（antigravity-cli 用户级）。
脚本**只删指向本仓库的旧链接**，绝不触碰 agent 自带技能（如 Codex 的 `.system/`、CodeWhale 的 bundled）。

### antigravity-cli（用户级逐技能 junction + 共享位置）

| 项 | 路径 |
|:--|:--|
| 技能目录（用户级） | `~/.gemini/skills/<skill>` —— 逐技能 junction，**已纳入 `sync-agent-skills.ps1`** |
| 技能目录（共享位置） | `~/.agents/skills` → 本仓库（符号链接）；工作区级 `<ws>/.agents/skills` 同形态 |
| 技能注册 | `~/.gemini/config/skills.json` 的 `entries` 含 `D:/GTMI/Skills`（**只保留仓库根条目**；历史重构留下的具体技能路径会悬空，需清理） |
| 规则加载 | `~/.agents/rules/*.md`（已有 `antigravity-rtk-rules.md`）、`~/.gemini/GEMINI.md` |

新增 / 改名 / 拆分技能后重跑一次脚本即可——用户级目录由脚本维护，不再手工挂链。

---

## 编辑纪律

- **单真相源**：每条规则的规范性表述**只允许存在一处**。L0 放可执行判据，L1 放规则表，L2 放判例/模板——**三者不得互相复述同一段规范文本**。
- **语言镜像不算重复**：非规范的译本（`*.zh.md`）不违反上条，因为它不承担规范效力；但文件头必须声明这一点，且英文改动后要同步。
- **禁止词表穷举**：行为判定用语义判据（如"授权 = 对具体动作的放行语义"），不得写成待匹配的关键词列表——词表必漏，且与语义判断冲突。
- **禁止双重容器**：同一份规则不得同时以"技能"和"AGENTS.md 条目"两种身份存在。
- 新增/删减技能时，同步更新本文件的技能索引。
- `.tempcache/` 不入版本库（见 `.gitignore`）。
