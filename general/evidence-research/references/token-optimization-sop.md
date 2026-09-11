# 疑难技术排查与 Token 止损 SOP 手册 (Token-Optimization & Troubleshooting SOP)

## 1. 为什么需要低 Token 执行序？
在 AI 协同研发中，大范围全网搜索和盲目抓取网页不仅耗时长（3~10秒），还会迅速向 Context 注入数千至上万无用 Token，导致上下文臃肿、推理质量下降并产生记忆漂移。

因此，所有技术查验必须遵守**“本地近场优先、梯级逐步外延”**的原则。

---

## 2. 查验梯级速查表

```text
[未知 API / 报错]
   │
   ├──► 1. 本地工程检索 (grep_search) ──► 50~200 Tokens ──► 耗时 < 0.5s [命中率最高]
   │
   ├──► 2. 本地 SDK 源码 (view_file)  ──► 200~500 Tokens ──► 耗时 < 0.5s [官方契约]
   │
   ├──► 3. 精准社区 Issue (Web Search) ──► 1.5k~3k Tokens ──► 耗时 2~5s  [4步强制验证]
   │
   └──► 4. 最小沙盒/动态测试 (run_command) ──► 过滤日志 ──► 耗时 5~30s [动态实测]
```

---

## 3. 命令行输出过滤与防卡死（Token 与时延止损四诫）
1. **构建输出拦截**：运行 Gradle / CMake 构建时，优先使用 `rtk` 代理或附加 `--quiet` / `grep` 过滤，严禁将数万行编译 log 灌入上下文。
2. **日志抓取拦截**：抓取 Logcat 时必须带有明确的 tag 过滤（如 `adb logcat -s MyTag:D`）或指定行数（`adb logcat -t 100`）。
3. **文件读取按需切片**：阅读超大文件时必须指定 `StartLine` 与 `EndLine` 切片读取，避免单次读取超大文本。
4. **文件与依赖检索防卡死红线**：
   * **严禁全盘/全局泛查**：严禁在命令行执行 `find /`、`find ~` 等全盘遍历指令；搜索路径必须严格限定在工程根目录或具体子模块内（如 `find .` 或 `find shared/`）。
   * **高效现代工具优先**：优先使用 `fd` 或 `ripgrep` (`rg`) 替代原生 `find`/`grep`，利用其自动识别 `.gitignore` 特性跳过庞大构建目录，大幅降低 I/O 开销。
   * **降级携带深度与排除项**：降级使用 `find` 时必须指定最大深度（`-maxdepth <N>`）并显式排除 `.git`、`build`、`.gradle`、`node_modules` 等缓存与产物目录。
   * **依赖与 Jar 包排查规约**：严禁使用 `find ~/.gradle` 等方式暴力扫描系统缓存目录；排查依赖关系必须使用构建工具标准命令（如 `./gradlew :shared:dependencies`）或直接核对版本目录文件（`build.gradle.kts` / `libs.versions.toml`）。
