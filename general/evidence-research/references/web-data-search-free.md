# 规则五：网络数据获取 —— 免费方案优先 (Web Data Acquisition)

## 1. 核心原则

当 AI agent（Pi / Command Code / Codex / Claude Code 等）需要**获取互联网数据**（网页搜索、抓取网页正文）时，**优先使用完全免费、无需 API key 的方案**，按以下优先级：

```text
[准备获取网络数据 (搜索/抓取)]
   │
   ├──► 1. 检查 websearch CLI 是否存在（推荐）：Get-Command websearch
   │       ✅ 存在 → 使用 websearch（基于 ddgs 免费元搜索，无需 key）
   │
   ├──► 2. 检查 ddgs CLI：command -v ddgs
   │       ✅ 存在 → 使用 ddgs（原生 CLI，同样免费）
   │
   └──► 3. 均不可用 → 降级 curl --compressed + jq
           并提示用户安装：pip install -U ddgs
```

> ⚠️ **免费优先**：`websearch`/`ddgs` 完全免费、无需注册、无需 key，为默认首选。
> **curl 仅作降级**：curl 抓搜索引擎会被反爬拦截（CAPTCHA/验证码），只能用于通用 REST API 或直接抓取已知 URL。

## 2. 命令速查（websearch CLI，本项目首选）

```bash
# 网页搜索（JSON 输出，默认 5 条）
websearch search "kotlin multiplatform" --limit 5

# 指定后端引擎（默认 duckduckgo；可选 google/bing/brave/auto/...）
websearch search "android compose" --backend google --limit 3

# 时间过滤（d=天 w=周 m=月 y=年）
websearch search "AI agent news" --days w

# 新闻搜索（带日期+来源）
websearch news "AI coding" --limit 5

# 网页正文提取（markdown，去导航广告）
websearch get "https://example.com" --format markdown
```

### 直接使用 ddgs CLI

```bash
# 文本搜索（无颜色输出，便于 agent 解析）
ddgs text -q "query" -m 10 --no-color

# 网页内容提取
ddgs extract -u "https://example.com"
```

## 3. 与 curl 的行为对比

| 场景 | 免费方案（优先） | curl（仅降级） | 说明 |
|:---|:---|:---|:---|
| 网页搜索 | `websearch search "..."` → JSON | curl 抓搜索引擎页面 | 搜索引擎有反爬，curl 会验证码/被封锁 |
| 抓正文 | `websearch get <url>` → markdown | `curl <url> \| jq` | websearch 输出干净 markdown |
| 新闻 | `websearch news "..."` → JSON | 无可用方案 | ddgs 免费 |
| 通用 REST API | — | `curl` + `jq`（保持不变） | curl 的合理用途 |

## 4. 使用铁律

- ✅ **优先**：`websearch search` / `websearch get`（免费、无 key、JSON/markdown 输出）
- 🚫 **禁止**：用 `curl` 抓搜索引擎 HTML 再正则提取（反爬不稳定、Token 浪费）
- 🚫 **禁止**：完整原始 HTML / 完整 JSON 灌入上下文（websearch 默认 JSON 输出；`get` 用 markdown 模式）
- ✅ **降级**：`websearch`/`ddgs` 均不可用时用 `curl --compressed | jq`，提示 `pip install -U ddgs`
- ✅ **REST API 调用**（GitHub API、OpenRouter API 等）不属于本规则范围，继续 `curl`/`xh` + `jq`

## 5. 安装与维护

### 安装 ddgs（免费搜索库）

```bash
pip install -U ddgs
```

### 建议创建 websearch 包装脚本（干净 JSON 输出）

把 `websearch.py` 放到 `~/.pi/agent/bin/` 下，并创建 `websearch.cmd`（Windows）：

```cmd
@echo off
python "%~dp0websearch.py" %*
```

脚本支持：`search`（文本搜索）、`news`（新闻）、`get`（网页提取），均输出 JSON/markdown。
