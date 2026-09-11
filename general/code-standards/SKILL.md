---
name: code-standards
description: >-
  Cross-language code delivery standards: the 500-line single-file redline and how to split by responsibility,
  comment hygiene (why-not-what), README/docs/explain sync policy, and temp-artifact discipline.
  Use when writing, modifying, refactoring, splitting, or reviewing source files; when creating or renaming
  modules; when adding comments or public APIs; or when producing debug logs, scratch scripts, or temp captures.
---

# 代码交付准则 (Code Standards)

跨语言（Kotlin / Java / C++ / Swift / TS / C# 等）通用的源码体量、注释、文档与产物纪律。

---

## 一 · 全语言 500 行红线

- 所有源码文件**单文件 ≤ 500 行**，健康区间 **100~300 行**。
- 逼近 **400~500 行即主动拆分**，按单一职责切分，杜绝 God Class。
- 拆分手法随语言选择：

| 语言 | 手法 |
|:--|:--|
| Kotlin / Swift | UI 组件解耦、扩展函数提炼、状态容器剥离 |
| Java / C# | 组合优于继承、内部类外提 |
| C++ | 头文件 ≤ 300 行、Pimpl、算法独立翻译单元 |

> 详表（含各语言拆分判例）：[`references/universal-code-redline.md`](references/universal-code-redline.md)

---

## 二 · 注释与文档完整性

- 注释解释 **「为什么」** 而非复述「做什么」；严禁 `// 将 index 加 1` 类语法复述。
- **保护既有注释铁律**：修改代码时严禁删除 / 篡改与本次变更无关的业务注释与 TODO。
- **公共 API 强制 KDoc / Javadoc**（`@param` 约束 / `@return` 语义 / `@throws` 分支）。
- 魔法数字与复杂算法必须注明公式来源或物理意义。
- TODO 格式：`// TODO(责任人/日期): 事项`。

> 细则：[`references/code-commenting-guidelines.md`](references/code-commenting-guidelines.md)

---

## 三 · 架构文档同步

- 工程根 README 维护：全局架构 / 技术栈 / 模块索引 / 构建指南。
- 有独立构建脚本的模块**必须**维护模块级 README。
- 深度设计文档归档至 `docs/explain/`，严禁散落。
- **新增 / 重命名 / 移动 / 拆分 / 删除文件，必须在同次任务中同步更新对应 README。**

> 细则：[`references/doc-sync-policy.md`](references/doc-sync-policy.md)

---

## 四 · 临时产物纪律

- 调试日志、一次性脚本、临时截图等**无引用价值的产物**，输出到对应仓库的 `tempCache/`（整体不入版本库）。
- 严禁散落仓库根、模块根或实验区目录。
- `tempCache/` 内部同样遵循所在仓库的文件架构规范：按用途分子目录、语义化命名，严禁序号副本式堆叠。
- `tempCache/` 可随时整体清理，不得留下悬空引用。
- 实验区目录只保留**有引用价值的产物**（被文档引用的演示稿、试验模块、调研溯源证据）。

> 细则：[`references/temp-artifacts-discipline.md`](references/temp-artifacts-discipline.md)
