# 规则三：AI 工具精准选型路由与时机指引 (Tool Selection Router)

## 1. 核心选型决策树 (Decision Tree)

AI 在执行命令前，必须根据当前任务类型走对应的高效选型路径，坚决杜绝低效、耗时且消耗海量 Token 的传统指令：

```text
[任务目标]
   │
   ├──► 查找文件 / 定位目录 ────► 【fd】(自动忽略 .git/build，耗时 < 0.2s)
   │                           └── 🚫 严禁：find / 、Get-ChildItem -Recurse
   │
   ├──► 搜索代码 / 文本特征 ────► 【ripgrep / rg】(多线程、低 Token、支持正则与类型过滤)
   │                           └── 🚫 严禁：原生 grep -r 全量递归
   │
   ├──► 语法级模式匹配/批量重构 ─► 【ast-grep / sg】(理解 AST 语法树，支持跨行精确匹配)
   │                           └── 🚫 严禁：脆弱的多行正则表达式粗暴替换
   │
   ├──► 处理 JSON 数据 / API 返回 ─► 【jq】(命令行完成切片提取，向 Context 仅返回关键字段)
   │                           └── 🚫 严禁：将数十 KB 原始 JSON 完整灌入上下文让 LLM 纯手工切词
   │
   ├──► 执行大型编译与构建 ────► 【rtk / --quiet】(自动压缩与拦截 90% 冗余构建日志)
   │                           └── 🚫 严禁：裸跑无过滤的 ./gradlew 或 cmake 命令
   │
   └──► 快速预览代码切片 ────► 【bat -r / view_file】(带行号与语法高亮定向切片)
```

---

## 2. 场景化时机与推荐命令范例

### 场景 1：文件与目录查找 (找文件)
* **何时使用**：需要根据文件名、扩展名或关键字定位工程内或指定路径下的文件。
* **推荐命令 (`fd`)**：
  ```bash
  # 在 shared 模块下查找所有包含 coil 的 kt 文件
  fd -e kt "coil" shared/

  # 仅查找目录
  fd -t d "feature" .
  ```
* **收益**：自动跳过 `.gitignore` 规则包含的 `build/`、`.gradle/`、`.git/` 等目录，防 I/O 卡死。

---

### 场景 2：代码与文本搜索 (搜代码)
* **何时使用**：在代码库中检索特定函数调用、常量定义、类名或注解。
* **推荐命令 (`rg`)**：
  ```bash
  # 仅列出包含该关键词的文件路径 (极省 Token)
  rg -l "rememberNavController" shared/

  # 显示匹配行与行号，限定 kotlin 文件
  rg -t kotlin -n "class .*ViewModel" shared/
  ```
* **收益**：速度比传统 `grep` 快 10 倍以上，输出紧凑，Token 消耗极低。

---

### 场景 3：结构化数据与 JSON 解析 (析数据)
* **何时使用**：读取配置文件（如 `package.json`、`app.json`）、Gradle 依赖导出产物或 HTTP 接口返回数据。
* **推荐命令 (`jq`)**：
  ```bash
  # 仅提取 JSON 中的特定版本号或关键数组元素
  cat build-report.json | jq '.dependencies[] | {name, version}'
  ```
* **收益**：避免将几千行冗余 JSON 数据全部输出到上下文，仅提取 AI 真正需要的 3~5 行字段。

---

### 场景 4：基于语法树的精准重构与分析 (改结构)
* **何时使用**：涉及跨行函数签名替换、特定注解修饰的代码块检索、废弃 API 批量安全升级。
* **推荐命令 (`ast-grep`)**：
  ```bash
  # 检索所有使用了特定注解的方法结构
  ast-grep -p '@Composable fun $NAME($$$ARGS) { $$$BODY }' -l kotlin
  ```
* **收益**：不受空格、换行、注释排版影响，提供 AST 级别安全语法匹配，避免正则替换导致的语法破坏。

---

### 场景 5：大型构建与命令输出拦截 (截日志)
* **何时使用**：运行 Gradle 任务、CMake 编译或运行测试用例。
* **推荐方案 (`rtk` / 过滤管道)**：
  ```bash
  # 使用 rtk 自动拦截压缩构建输出
  rtk gradlew :shared:assembleDebug

  # 或附加标准静默参数
  ./gradlew :shared:assembleDebug --quiet
  ```
* **收益**：将数万行编译进度日志压缩为几行核心状态与报错信息，杜绝 Token 溢出与上下文污染。
