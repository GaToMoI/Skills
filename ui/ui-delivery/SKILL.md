---
name: ui-delivery
description: >-
  UI asset and icon delivery rules with design-source preconditions: when a design source (Figma/Lanhu MCP)
  exists, export real assets instead of faking shapes with text; when none exists, use the platform's standard
  vector icon library and prompt the user for real assets. Use when implementing any screen, component, icon
  slot, empty state, badge, or navigation element.
---

# UI 资产与图标规范 (UI Delivery)

**条件触发**：按下表判定走哪条路，两条路的禁止项不同。

---

## 分级判定

| 条件 | 必须做 | 严禁 |
|:--|:--|:--|
| **有设计源**（Figma / 蓝湖 MCP 等） | 导出规范切图（PNG / SVG），入标准资产目录 | 字符拟态、富文本拼图形 |
| **无设计源** | 用平台标准矢量图标库；**主动提示用户补充正规切图资产** | 字符拟态替代 |

---

## 图标位铁律

- **图标位**（导航 / 按钮 / 状态 / 角标 / 空态等**任何需要图标的地方**）一律使用**当前技术栈官方图标库**提供的真实图标。
- **严禁**用颜文字、Emoji、特殊字符充当图标。
- **例外**：界面正文与内容性字符装饰**不属于**图标位，不受此限。

---

## 自检

动手画界面/图标前问一句：**「这个位置是图标位吗？如果是——设计源给了切图吗？没有的话，我用的图标来自官方图标库吗？」**

> 完整判定口径：[`references/ui-asset-guidelines.md`](references/ui-asset-guidelines.md)
