# 常用 AI CLI 工具高频参数与防坑速查手册 (Tool Cheat Sheet)

## 1. ripgrep (`rg`) 极速检索速查

```bash
# 1. 仅列出匹配的文件名 (最低 Token 消耗)
rg -l "pattern" [path]

# 2. 区分大小写 / 不区分大小写
rg -s "ExactCase"       # 强制区分大小写
rg -i "ignorecase"      # 强制忽略大小写
rg -S "smartcase"       # 智能大小写 (包含大写时区分，全小写时不区分)

# 3. 限定文件类型
rg -t kotlin "interface"
rg -t json "version"
rg -T md "TODO"         # 排除 Markdown 文件

# 4. 显示匹配行前后上下文行数 (谨慎使用，控制 Token)
rg -C 2 "fatal error" log.txt
```

---

## 2. fd 极速文件查找速查

```bash
# 1. 按扩展名搜索
fd -e kt -e java "Activity"

# 2. 限定搜索深度
fd --max-depth 3 "build.gradle.kts"

# 3. 仅搜索目录或仅搜索文件
fd -t d "compose"       # 目录
fd -t f "settings"      # 文件

# 4. 包含被 gitignore 忽略的文件 (在特殊排查构建产物时使用)
fd -I "libshared.so"
```

---

## 3. jq 结构化数据解析速查

```bash
# 1. 格式化并美化输出
cat data.json | jq '.'

# 2. 提取特定字段
cat data.json | jq '.user.id'

# 3. 遍历数组并挑选部分键
cat list.json | jq '.items[] | {id: .id, name: .title}'

# 4. 过滤条件筛选
cat packages.json | jq '.dependencies[] | select(.version | startswith("^2."))'
```

---

## 4. ast-grep (`sg`) 语法树模式速查

```bash
# 1. 交互式模式匹配检索
ast-grep -p '$VAR.equals($OTHER)' -l java

# 2. 结构化替换 (Dry-run 预览)
ast-grep -p 'console.log($$$A)' -r 'logger.info($$$A)' -l typescript

# 3. 代码重写落地
ast-grep -p 'println($$$A)' -r 'Log.d("Tag", $$$A)' -l kotlin --inline-rules
```

---

## 5. 命令执行与 Token 防坑四诫

| 违规/高危反模式 | 致命危害 | 合规替代方案 |
| :--- | :--- | :--- |
| `find / -name "*.kt"` | 遍历系统全盘，导致 Windows I/O 假死 90s+ | `fd -e kt "name" ./` |
| `find ~/.gradle -name "*.jar"` | 遍历数十万哈希缓存文件，耗时极高 | `./gradlew :shared:dependencies` |
| `cat 5000-lines.json` | 瞬间向上下文灌入数万 Token，引发遗忘漂移 | `jq '.target_field' 5000-lines.json` |
| 跨行复杂语法直接使用 `sed` 正则替换 | 容易破坏 AST 嵌套括号或误伤注释 | `ast-grep` 语法树精确重写 |

---

## 6. 新增工具速查

### 6.1 HTTP 请求 (`xh` / `curlie` / `httpstat`)

```bash
# xh: Rust 版 HTTPie，JSON 自动高亮
xh GET https://api.example.com/users
xh POST https://api.example.com/users name=John age:=30   # := 表示 JSON 数字

# curlie: curl 语法 + httpie 风格输出
curlie https://api.example.com/users

# httpstat: 可视化请求各阶段耗时
httpstat https://api.example.com/users
```

### 6.2 网络数据获取（websearch / ddgs —— 免费优先，无需 API key）

```bash
# websearch CLI（ddgs 封装，默认 JSON 输出，省 Token）
websearch search "kotlin multiplatform" --limit 5          # 文本搜索
websearch search "android compose" --backend google        # 指定引擎
websearch search "AI agent news" --days w                  # 近一周
websearch news "AI coding" --limit 5                       # 新闻(带日期/来源)
websearch get "https://example.com"                        # 网页正文 markdown

# ddgs 原生 CLI（pip install -U ddgs）
ddgs text -q "query" -m 10 --no-color                      # 文本搜索
ddgs extract -u "https://example.com"                      # 网页提取
```

> ⚠️ **优先免费方案**：websearch/ddgs 完全免费、无需注册、无需 key；禁止 curl 抓搜索引擎 HTML。
> 安装：`pip install -U ddgs`；websearch 包装脚本位于 `~/.pi/agent/bin/websearch.py`。

### 6.3 数据解析 (`xsv` / `csview` / `choose` / `yq`)

```bash
# xsv: 极速 CSV 切片
xsv select name,version packages.csv
xsv stats packages.csv

# csview: CSV 对齐预览
csview packages.csv

# choose: 管道按列切分 (类 cut 但更人性化)
cat data.txt | choose -f '\t' 1 2

# yq: YAML/JSON/XML 统一处理
cat build.gradle.kts | yq eval '.version'
yq eval '.dependencies' pubspec.yaml
```

### 6.4 磁盘/系统 (`dust` / `duf` / `dua` / `gdu` / `procs` / `bandwho`)

```bash
dust -d 2 .          # 可视化磁盘占用 (2 层深度)
duf                   # 彩色磁盘分区概览
dua i .              # 交互式磁盘分析
gdu .                # 高速磁盘分析 (Go)
procs                # 彩色进程列表
bandwhich             # 实时网络带宽监控
```

### 6.5 导航/文件管理 (`zoxide` / `eza` / `yazi` / `lf` / `broot`)

```bash
z <dirname>          # 智能目录跳转 (自动学习常用路径)
eza -l --git .       # 彩色 ls + Git 状态
broot .              # 交互式目录树导航
```

### 6.6 搜索增强 (`ugrep` / `rga` / `igrep`)

```bash
ugrep -i "pattern" .        # 超 grep (模糊匹配)
rga "keyword" .             # 万能搜索 (PDF/Office/压缩包/图片)
ig "pattern" .              # 交互式 grep
```

### 6.7 构建/自动化 (`watchexec` / `just`)

```bash
watchexec -e kt ./gradlew :shared:compileDebugKotlin   # 文件变动自动重跑
just build          # 现代化任务运行器 (Justfile)
```

### 6.8 其他 (`sd` / `grex` / `tldr` / `navi` / `hyperfine` / `tokei` / `fastfetch` / `onefetch` / `hexyl` / `glow` / `btm` / `mlr` / `ig` / `cb`)

```bash
sd 'old' 'new' file.txt        # 直观查找替换
sd -g 'foo' 'bar'              # 全局替换 (类 sed s/foo/bar/g)

grex "2024-01-01" "2024-12-31"   # 从示例生成正则

tldr rg                        # 命令速查 (简化 man)
navi                           # 交互式命令速查

hyperfine 'rg foo' 'grep -r foo'   # 性能基准对比

tokei .                        # 代码行数统计
fastfetch                      # 系统信息
onefetch                       # Git 仓库信息

hexyl file.bin                 # 彩色十六进制查看

glow README.md                 # # Markdown 终端渲染

btm                            # 系统监控 (bottom)
mlr --csv cat data.csv         # CSV 处理 (miller)
cb copy "text"                 # 剪贴板
```
