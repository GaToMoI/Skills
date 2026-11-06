---
name: ui-delivery
description: >-
  UI asset and icon delivery rules with design-source preconditions: when a design source (Figma/Lanhu MCP)
  exists, export real assets instead of faking shapes with text; when none exists, use the platform's standard
  vector icon library and prompt the user for real assets. Use when implementing any screen, component, icon
  slot, empty state, badge, or navigation element.
---

# UI Assets and Icons

**Conditional**: decide the path from the table below — the two paths have different prohibitions.

---

## Tier decision

| Condition | Required | Forbidden |
|:--|:--|:--|
| **Design source exists** (Figma / Lanhu MCP, etc.) | Export proper assets (PNG / SVG) into the standard asset directory | Character mimicry, rich text assembled into shapes |
| **No design source** | Use the platform's standard vector icon library; **actively ask the user to supply real assets** | Character mimicry as a substitute |

---

## Icon-slot rule

- **Icon slots** (navigation / buttons / status / badges / empty states — **anywhere an icon is expected**) always use real icons from the **official icon library of the current stack**.
- **Never** use kaomoji, emoji, or special characters as icons.
- **Exception**: body copy and content-level character ornamentation are **not** icon slots and are exempt.

---

## Self-check

Before drawing any screen or icon, ask: **"Is this position an icon slot? If so — did the design source provide an asset? If not, is my icon from the official icon library?"**

> Full criteria: [`references/ui-asset-guidelines.md`](references/ui-asset-guidelines.md)
