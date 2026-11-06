---
name: evidence-research
description: >-
  Fact-checking and data-acquisition integrity: verify before asserting, the 4-tier low-token lookup order,
  web search via free no-key tools instead of scraping search engines, structured-data parsing that preserves
  value-to-field mapping, and cross-source verification with traceability.
  Use when you need to confirm an API, library, framework, or version behavior; when researching or comparing
  technologies; when scraping or parsing web pages, JSON, tables, or logs; or when a number or fact must be cited.
---

# 查证与数据获取 (Evidence & Research)

> **非规范镜像**：本文件是 `SKILL.md`（英文，规范版）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。


**核心禁令：严禁凭记忆下技术断言。** 构建系统 / 语言标准 / 框架 API 的行为必须以官方文档或本地真实工程为依据。

---

## 一 · 四级低 Token 执行序

按序升级，命中即停：

| 级别 | 手段 | 约束 |
|:--|:--|:--|
| **①** | 本地工程用例检索（`fd` / `rg`） | 限定路径；**严禁全盘 `find /`** |
| **②** | 本地 SDK / 依赖源码定向切片 | 直接读所需文件与行段，不整包通读 |
| **③** | 精准社区检索 | 须过 **4 步验证**（见下） |
| **④** | 最小沙盒实测 | 日志必须过滤，**严禁全量灌入上下文** |

**③ 级 4 步验证**：版本对齐 → 副作用审查 → 本地最小验证 → 透明披露。
**结论必须有证据链**：代码依据、文件行号或官方规范，可验证、可复现。

> SOP 全文：[`references/token-optimization-sop.md`](references/token-optimization-sop.md)
> 准则细则：[`references/fact-checking.md`](references/fact-checking.md)

---

## 二 · 网络数据获取：免费方案优先

| 场景 | 首选 | 禁止 |
|:--|:--|:--|
| 搜索 / 抓网页正文 | `websearch` / `ddgs`（**免费、无需 key**） | 🚫 `curl` 抓搜索引擎 HTML |
| REST API | `curl` + `jq` | 🚫 原始 JSON 直接灌入上下文 |

> 工具清单与用法：[`references/web-data-search-free.md`](references/web-data-search-free.md)

---

## 三 · 结构化数据完整性

- 结构化数据（HTML 表格 / JSON / 日志）**禁止线性化剥取**，必须保留 **「值 ↔ 字段」** 对应关系，防整体错位。
- 多来源数据第一时间交叉核对；不一致时**以官方为准**并向用户标注。
- 异常数字（数量级离谱）必须**停下回查**，严禁带先入为主采信。
- 结论必须**可溯源**：来源 URL / 抓取文件 + 时间。

> 判例与反例：[`references/data-acquisition-integrity.md`](references/data-acquisition-integrity.md)
