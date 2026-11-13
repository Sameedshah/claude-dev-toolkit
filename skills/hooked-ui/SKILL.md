---
name: hooked-ui
description: Unified UI/UX design skill for any website, web app, landing page, or component. Reads whatever project context exists (agent instructions, README, design charter, existing tokens) to detect domain and page type before writing a single line of UI. Produces domain-specific, premium, non-AI-looking designs in three modes: Cinematic (marketing/landing), Product (app/dashboard), Component (isolated). Includes the anti-slop Taste Engine: design read, three dials, AI-tell bans, and a pre-flight check. Use for landing pages, dashboards, portfolios, component work, and redesigns.
license: See LICENSE
metadata:
  author: Hooked Labs
  version: "2.0.0"
  attribution: Contains material derived from design-taste-frontend v2 (github.com/Leonxlnx/taste-skill). See NOTICE.md.
---

# Hooked UI

Design that is built FROM the project — not generic templates applied TO it.

Before writing any UI code, you must know what the project is, who it's for, and what emotion it needs to produce. The code comes last.

---

## The Taste Engine

`design-taste-frontend` (Leonxlnx/taste-skill) is folded into this skill as the **Taste Engine** —
the anti-slop layer that stops output from reading as templated AI work. It lives in six reference
files, loaded per phase below:

| Reference | Holds | Loaded at |
|---|---|---|
| `references/taste-read-and-dials.md` | Design Read, three dials, brief → design-system map | Phase 1-3 |
| `references/taste-directives.md` | Architecture, type, color, layout, imagery, motion, perf, a11y, dark mode | Phase 4-5 |
| `references/taste-ai-tells.md` | Forbidden AI signatures, em-dash ban | Phase 6 |
| `references/taste-redesign.md` | Redesign audit + preservation protocol | Phase 2 (redesigns only) |
| `references/taste-preflight.md` | Final pre-flight matrix | Phase 6 |
| `references/taste-reference.md` | Pattern vocabulary, block schema, install commands, doc links | On demand |

**Scope note.** The Taste Engine was written for landing pages, portfolios, and redesigns. Its
layout, imagery, and content-density rules are authoritative in **Cinematic** mode. In **Product**
mode, apply only its universal rules (Sections 3, 4.1, 4.2, 4.5, 4.6, 4.11, 6, 8, 9) and ignore the
hero / bento / marquee / scroll-hijack sections. See Section 13 in `taste-reference.md`.

### Precedence on conflict

Where the Taste Engine and an older hooked-ui reference disagree, **the Taste Engine wins.** The
three known conflicts, already resolved:

| Topic | Old hooked-ui rule | Resolved rule |
|---|---|---|
| Custom cursor | Mandatory in Cinematic mode | **Banned by default** (a11y- and perf-hostile, Section 9.A). `hover-system.md` keeps the implementation for the rare brief that explicitly asks for one. |
| Font loading | Google Fonts via `<link>` in `design-tokens.md` | **`next/font` or self-hosted `@font-face` + `font-display: swap`** (Section 3.A). The `<link>` snippets are prototype-only. |
| Inter as body font | Suggested for several domains in `domain-aesthetics.md` | Allowed where those domains call for it (Section 4.1 grants the neutral / Linear-style / accessibility-first override), but never the unexamined default. |

---

## Phase 1 — Read Context (always, no exceptions)

Gather project context before writing anything. Read whichever of these exist, in priority
order, and stop as soon as you have enough signal. Most projects only have two or three of
them, and that is normal.

| Priority | Look for | Extract |
|---|---|---|
| 1 | Agent instructions: `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `.github/copilot-instructions.md` | Tech stack (Next.js / React / Astro / vanilla), project phase, any design tokens already defined |
| 2 | Product brief: `README.md`, `docs/overview.md`, a PRD or vision doc | Product goals, differentiators, audience, open design questions |
| 3 | Design or engineering charter: `docs/design-principles.md`, `STYLEGUIDE.md`, `CONTRIBUTING.md` | Domain/industry, brand personality, target users, hard constraints, stated design principles |
| 4 | Existing code: `tailwind.config.*`, `app/globals.css`, `theme.*`, `package.json` | Tokens already in use, installed design system, fonts, framework |
| 5 | The current request itself | What is being built right now: full page, section, or component |

If the project uses a spec-driven layout (`.specify/memory/constitution.md`, `obsidian/overview.md`),
read those at priority 2 and 3 instead. The point is the signal, not the filename.

### If almost nothing exists

A brand-new or freshly scaffolded project is the normal case, not a failure. Infer before asking:

1. Project name and `package.json` dependencies imply the domain. Supabase plus Next.js suggests a SaaS product; Stripe plus a product catalog suggests e-commerce.
2. Existing route names imply the page type. `/pricing` and `/` are marketing; `/dashboard` and `/settings` are product.
3. Only if Mode is still genuinely ambiguous, ask exactly one question:

   > "Is this a marketing/landing page, or a product/app UI?"

   That single answer determines Mode, which is the most consequential decision in this skill.

### Declare the Design Read

Load `references/taste-read-and-dials.md` §0. Output the one-line Design Read before any code:

> *"Reading this as: \<page kind> for \<audience>, with a \<vibe> language, leaning toward \<design system or aesthetic family>."*

If the brief is genuinely ambiguous, ask **exactly one** question. If you can infer, do not ask.

---

## Phase 2 — Detect Mode

Based on what you read, classify the current task:

| Mode | When | Behaviour |
|---|---|---|
| **Cinematic** | Landing page, marketing page, homepage | Scroll-driven reveals, dramatic typography, full Taste Engine authority |
| **Product** | App UI, dashboard, SaaS product, admin panel, authenticated views | Claude-like restraint — functional beauty, subtle micro-interactions only, no scroll hijacking |
| **Component** | Isolated piece (button, card, nav, form) with no page context | Inherit mode from surrounding context, or default to Product if unknown |

**Rule:** When in doubt, ask. A payment dashboard built in Cinematic mode is wrong. A startup homepage built in Product mode is boring.

### Greenfield or redesign?

If an existing site or component is being modernised rather than built fresh, load
`references/taste-redesign.md` now and run its audit (§11.B) **before** proposing changes.
Classify as Preserve or Overhaul. Never change IA, slugs, nav labels, form field names, or brand
marks silently (§11.F).

---

## Phase 3 — Detect Domain and Set the Dials

Load `references/domain-aesthetics.md`. Map the project to a domain. The domain defines:
- Color palette direction
- Typography personality
- Layout density
- Animation intensity
- Emotional register

If the domain is ambiguous, default to **SaaS/Tech** aesthetic.

Then set the three dials from `references/taste-read-and-dials.md` §1, reasoned from the Design
Read (not silently left at baseline). State them explicitly:

`DESIGN_VARIANCE: n` · `MOTION_INTENSITY: n` · `VISUAL_DENSITY: n`

These gate every layout, motion, and density decision that follows. Product mode caps
`MOTION_INTENSITY` at 4 regardless of domain.

---

## Phase 4 — Build the Design System

First, check `references/taste-read-and-dials.md` §2: if the brief maps to a **real** design system
(Fluent, Material, Carbon, Polaris, Atlaskit, Primer, GOV.UK, USWDS, Radix Themes, shadcn/ui),
install and use the official package. Do not hand-recreate its CSS. One system per project.

Otherwise load `references/design-tokens.md` and define all tokens before writing any component:
- Font pairing (from domain aesthetic; loaded via `next/font` or self-hosted `@font-face`)
- Color palette (background, text, brand, border) — one accent, locked page-wide
- Spacing scale
- Border radius convention — one corner-radius system, locked page-wide
- Shadow / depth style

Write these as CSS custom properties at `:root` before any component code.

---

## Phase 5 — Implement

Load `references/taste-directives.md` (§3-§8) as the implementation spine, plus the mode-specific
hooked-ui references:

**Cinematic mode:** `references/motion-system.md` → `references/hover-system.md`
→ taste-directives §4.7 (layout discipline), §4.8 (imagery), §4.9 (content density), §5 (motion patterns + GSAP skeletons)

**Product mode:** `references/hover-system.md` (skip heavy motion)
→ taste-directives §3 (architecture), §4.5 (interactive states), §4.6 (forms), §6 (perf + a11y), §8 (dark mode)

**Component mode:** `references/hover-system.md` → relevant taste-directives section as context

**Source library:** before hand-building a showcase section (hero, 3D/shader background, pricing,
feature grid), check the ThreeUI MCP (`mcp__threeui__*`) per `references/threeui-mcp.md`, then
re-skin whatever you pull to the Phase 4 tokens. Skip it if the MCP is unauthenticated.

Reach into `references/taste-reference.md` when you need a named pattern (§10), the block-library
schema (§12), or a real install command / canonical doc link (Appendices A-B).

---

## Phase 6 — Anti-Pattern Check and Pre-Flight

Two filters, both mandatory, in order:

1. Load `references/anti-patterns.md` — the hooked-ui hard rules.
2. Load `references/taste-ai-tells.md` (§9) and `references/taste-preflight.md` (§14) — the Taste
   Engine's forbidden signatures and the full pre-flight matrix.

If the code fails any Hard Rule or any pre-flight box, fix it before returning the code.

---

## Quality Gate (run mentally before every output)

**Context**
- [ ] Read constitution / overview before writing anything
- [ ] Design Read declared as a one-liner
- [ ] Mode correctly identified (Cinematic / Product / Component)
- [ ] Greenfield vs Redesign-Preserve vs Redesign-Overhaul classified
- [ ] Domain aesthetic applied (not generic SaaS defaults unless confirmed)
- [ ] Dials stated and reasoned, not left silently at baseline

**Design**
- [ ] Real design system used if the brief maps to one; otherwise aesthetic labeled honestly
- [ ] Font is NOT system-ui / Arial / Helvetica for headings, and not an unexamined Inter
- [ ] Serif only where genuinely justified — never Fraunces or Instrument Serif
- [ ] Color palette ≤ 3 colors (bg + text + 1 brand), one accent locked page-wide
- [ ] One corner-radius system, one page theme (no section flips to inverted mode)
- [ ] Spacing uses the defined scale — no arbitrary `px` values
- [ ] No rainbow gradients, no AI-purple, no generic centered hero

**Cinematic only**
- [ ] Hero fits the viewport: headline ≤ 2 lines, subtext ≤ 20 words, CTA visible without scroll
- [ ] Hero has a real visual, not a gradient blob or a div-based fake screenshot
- [ ] Eyebrow count ≤ ceil(sectionCount / 3)
- [ ] No 3+ consecutive image+text zigzag sections; ≥ 4 layout families across 8 sections
- [ ] Real images sourced (gen tool → Picsum seed → labeled placeholder slots)
- [ ] Scroll-driven motion is motivated and honors `prefers-reduced-motion`

**Product only**
- [ ] No full-page scroll snap (ruins app UX)
- [ ] No entrance animations on interactive elements (delay hurts productivity)
- [ ] Hover states on every interactive element
- [ ] Focus states visible (accessibility)
- [ ] Loading / empty / error states provided, not just the happy path

**Always**
- [ ] **ZERO em-dashes (`—`) or separator en-dashes (`–`) in any user-visible string** (§9.G)
- [ ] Every button / link / card has a hover state; every CTA passes WCAG AA contrast
- [ ] No CTA label wraps at desktop; no two CTAs share the same intent
- [ ] Nav renders on one line at desktop, ≤ 80px tall
- [ ] Typography scale is applied consistently
- [ ] Copy self-audit done — no broken grammar, no AI-hallucinated cute phrasing, no fake-precise numbers
- [ ] Dark mode defined and checked in both modes
- [ ] `min-h-[100dvh]`, never `h-screen`; animate only `transform` and `opacity`
- [ ] The design could not have come from a default AI prompt
