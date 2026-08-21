# 准则九：代码注释与文档完整性规范 (Code Commenting & Documentation Integrity)

## 1. 核心原则

### 1. 解释“为什么 (Why)”，而非复述“做什么 (What)”
* **严禁无意义的语法复述注释**：
  * *反模式 ❌*：`// 将 index 加 1` ➔ `index++`、`// 返回 user` ➔ `return user`；
* **重点记录业务意图、设计权衡与边界原因**：
  * *标准模式 ✅*：解释为什么采用该算法、为什么在此处加防抖、为什么该处需要做特殊规避、历史 Workaround 背景等。

---

### 2. 既有注释保护铁律 (Preserve Existing Comments)
* 在进行代码修改、局部重构或功能增补时，**严禁私自删除、截断或篡改与当前变更无关的原有业务注释、KDoc/Javadoc、版权声明或 TODO 标记**。

---

### 3. 公共接口与核心 API 强制文档化 (KDoc / Javadoc / Doxygen)
所有对外暴露的公共类、核心接口、顶层工具函数与复杂的领域数据模型，必须提供标准的文档注释：
* **功能描述**：说明其核心职责与适用场景；
* **参数说明 (`@param`)**：说明入参约束（如是否可空、取值范围、单位）；
* **返回值 (`@return`)**：说明返回结果的业务含义与空值代表的语义；
* **异常声明 (`@throws`)**：明确指出在何种异常分支下会抛出错误。

```kotlin
/**
 * 根据给定的项目数据与网格参数生成可绘制的色块矩阵。
 *
 * @param project 拼豆图纸项目实体，包含原始点阵数据与色板映射
 * @param targetGridSize 目标画布网格尺寸，必须大于 0
 * @return 转换后的二维渲染网格，若数据损坏则返回空矩阵
 * @throws IllegalArgumentException 当 targetGridSize 小于等于 0 时抛出
 */
fun generateRenderGrid(project: PatternProject, targetGridSize: Int): RenderGrid
```

---

### 4. 复杂算法与魔法数字（Magic Numbers）强制注释
* 凡涉及数学矩阵计算、贝塞尔曲线公式、位运算、状态机复杂跳转或硬编码的物理/经验常数，**必须在旁边显式注释其数学公式来源或物理意义**。

---

### 5. 规范技术债与待办注释 (TODO / FIXME / NOTE)
* 格式统一规范为：`// TODO(责任人/日期): 具体的待办事项与后续改进方案`；
* 严禁留下含糊不清的裸 `// TODO` 或 `// fix later`。
