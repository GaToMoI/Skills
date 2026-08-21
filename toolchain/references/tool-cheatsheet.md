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
