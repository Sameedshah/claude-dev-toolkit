# ThreeUI MCP (Pro source library)

ThreeUI (https://threeui.com) is a paid catalog of templates, components, implementation prompts,
and source files. Its authenticated MCP server is registered globally in Claude Code as `threeui`:

    claude mcp add --transport http --scope user threeui https://threeui.com/api/mcp

Tools show up as `mcp__threeui__*`. The server needs a verified ThreeUI **Pro** membership. It
signs in with OAuth through `/mcp` → `threeui` → Authenticate. If it reports "Needs authentication",
say so once and carry on without it. Never block a build on it.

## Free fallback (no Pro)

The gallery at https://threeui.com/browse also has free **Community** components; anything without
a Pro badge is free. Open one and use **Copy code**, **Copy SKILL.md**, or **Copy prompt**, then
paste the result into the project. The MCP and `npx @designcodeio/threeui-cli add <id>` both need
a sign-in. Free items get the same rules below: re-skin to the tokens and run Phase 6.

## When to use it

- **Phase 4 / 5, Cinematic and Component mode:** before you hand-build a hero, a 3D or shader
  background, a pricing block, a feature grid, or a nav, search ThreeUI for a matching template or
  component. Use its source and implementation prompt as a **starting point**.
- **Product mode:** use it only for isolated showcase pieces. App shells, tables, and forms still
  come from the project's own design system.

## Rules

1. **Hooked-ui wins.** Anything pulled from ThreeUI must be re-skinned to the tokens from Phase 4
   (fonts, the single accent, the radius system, spacing). Pasting a template verbatim is an AI tell.
2. **It still goes through Phase 6.** Pulled code gets the same anti-pattern and pre-flight pass as
   hand-written code.
3. **Performance:** WebGL/three.js pieces must lazy-load, respect `prefers-reduced-motion`, and
   fall back to a static image on low-power devices (taste-directives §6).
4. **Licensing:** ThreeUI source is licensed to the Pro member. Use it in projects you build. Do not
   redistribute it as a library, template pack, or skill content.
