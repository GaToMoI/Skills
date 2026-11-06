# 准则七：UI 资产与图标规范（分级条件触发） (UI Asset & Icon Guidelines with Preconditions)

> **非规范镜像**：本文件是 `ui-asset-guidelines.md`（英文，规范版）的中文学译本，仅为阅读方便。两者不一致时，**以英文版为准**。


## 1. 核心原则（分级条件触发）

### 场景 A：具备设计源时（存在 Figma MCP、蓝湖 MCP 或本地设计文件）
1. **严格执行规范切图**：
   * 严禁使用富文本（如 inline styled text、Unicode 特殊字符拼凑图形、富文本标签拼接等）来替代界面中的图标或矢量图形；
2. **高清规范资产沉淀**：
   * 必须通过 Figma MCP（或蓝湖 MCP / 设计稿切图源）导出高清规范资产（PNG / SVG 格式）沉淀至工程的标准资产目录（如 `assets/icons/` 或 `res/drawable/`）；
   * 通过标准图片/图标组件（如 `EditorIcon` / `Image` / `ImageView`）统一加载与渲染，保证各端渲染像素级还原与高质量表现。

### 场景 B：无设计源 / 原型开发阶段（无外部 MCP 或设计源）
1. **采用平台标准矢量图**：
   * 优先使用目标平台标准矢量图标库（如 Material Icons、Jetpack VectorDrawable、SF Symbols）；
2. **主动提示补充资产**：
   * 明确向用户提示需要补充正规切图资产，严禁用不可控富文本伪造复杂业务图形。
