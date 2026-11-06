# UI Assets and Icons (conditional tiers)

## 1. Core principle

### Case A — a design source exists (Figma MCP, Lanhu MCP, or local design files)

1. **Export proper assets, strictly**:
   - Never substitute rich text (inline styled text, Unicode characters assembled into shapes, rich-text tag composition) for icons or vector graphics in the UI.
2. **Commit high-fidelity assets**:
   - Export proper PNG / SVG assets via the design source into the project's standard asset directory (e.g. `assets/icons/` or `res/drawable/`);
   - Load and render them through the standard image/icon components (`EditorIcon` / `Image` / `ImageView`) so every platform renders pixel-accurately.

### Case B — no design source / prototype phase (no external MCP or design files)

1. **Use the platform's standard vectors**:
   - Prefer the target platform's standard vector icon library (Material Icons, Jetpack VectorDrawable, SF Symbols).
2. **Ask for real assets**:
   - Tell the user explicitly that proper assets need to be supplied. Never fake complex business graphics with uncontrolled rich text.
