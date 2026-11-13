# Context Detection

How to read the project and produce a Design Brief before touching code.

## Step-by-Step

### 1. Read the agent instructions

```
Look for: CLAUDE.md, AGENTS.md, .cursorrules, .github/copilot-instructions.md
```

Look for:
- **Stack signals** — Next.js App Router, Astro, Vite, plain HTML, React Native for web
- **Token signals** — a palette, font stack, or radius scale already committed
- **Phase signals** — prototype, MVP, production, rebrand

### 2. Read the product brief

```
Look for: README.md, docs/overview.md, a PRD, a vision doc, obsidian/overview.md
```

Look for:
- Product name and tagline (signals brand voice)
- Goals section (signals what the UI must make easy)
- Target users section (signals sophistication level, context of use)
- Open questions (signals unresolved design decisions)

### 3. Read the design or engineering charter

```
Look for: docs/design-principles.md, STYLEGUIDE.md, CONTRIBUTING.md,
          .specify/memory/constitution.md
```

Look for:
- **Industry signals** — words like "healthcare", "fintech", "e-commerce", "developer tool", "marketplace"
- **Audience signals** — "enterprise", "consumers", "developers", "SMBs", "B2B", "B2C"
- **Personality signals** — "trustworthy", "playful", "minimal", "bold", "professional", "innovative"
- **Constraint signals** — "WCAG AA required", "no external CDNs", "white-label", "dark mode only"

### 4. Read the existing code

```
Look for: tailwind.config.*, app/globals.css, theme.*, package.json
```

An installed design system (`@radix-ui/themes`, `shadcn/ui`, `@primer/react`) outranks
anything you would invent. An existing palette in `globals.css` is a constraint, not a
suggestion.

### 5. Read the current spec or task

Look for:
- Page name → determines Mode
- Feature list → determines layout density
- User journey step → determines emotional register

## Producing the Design Brief

After reading, produce a silent internal brief (you don't need to show this unless asked):

```
Project: [name]
Domain: [industry]
Audience: [who / sophistication]
Brand personality: [3 adjectives]
Page type: [landing page / dashboard / etc.]
Mode: [Cinematic / Product / Component]
Domain aesthetic: [which entry from domain-aesthetics.md]
Key constraint: [anything non-negotiable]
Emotional register: [what the user should feel on this page]
```

This brief drives every decision that follows.

## Domain Signal Examples

| The project says... | Likely domain | Aesthetic direction |
|---|---|---|
| "patients", "HIPAA", "clinical" | Healthcare | Calm, accessible, trustworthy |
| "traders", "portfolio", "returns" | Fintech | Precise, authoritative, navy |
| "developers", "CLI", "SDK", "API" | Dev tool | Dark, monospaced accents, technical |
| "shoppers", "cart", "product catalog" | E-commerce | Editorial, imagery-first, clean |
| "startup", "launch", "waitlist" | Startup marketing | High-energy, scroll-cinematic |
| "team", "workspace", "dashboard" | SaaS product | Functional, Claude-like restraint |
| "portfolio", "agency", "creative" | Creative | Experimental, bold, high motion |
| "restaurant", "menu", "reservation" | Hospitality | Warm, editorial, serif-forward |

## What to Do When Context Is Missing

A new or freshly scaffolded project is the normal case, not a failure. Infer before asking:

1. **Project name** — infer domain from it directly.
2. **`package.json` dependencies** — Next.js + Supabase suggests a SaaS product. Stripe + a catalog suggests e-commerce. `three` or `gsap` suggests a creative or cinematic brief.
3. **Route names already scaffolded** — `/pricing`, `/about`, `/` are marketing. `/dashboard`, `/settings`, `/admin` are product.
4. If still ambiguous, ask ONE targeted question:

   > "Is this a marketing/landing page or a product/app UI?"

   That single answer determines Mode, which is the most important decision.
