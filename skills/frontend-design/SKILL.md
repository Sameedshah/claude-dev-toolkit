---
name: frontend-design
description: Frontend component architecture for React and Next.js projects. Use when scaffolding new pages, building component hierarchies, choosing state management, structuring folder layouts, or deciding the server/client boundary. Covers file organisation, component composition, data fetching (Server Components, SWR, React Query), state selection, and the loading/empty/error contract. Pairs with hooked-ui for visual quality and playwright-audit for post-build verification.
license: See LICENSE
metadata:
  author: Hooked Labs
  version: "2.0.0"
---

# Frontend Design

Opinionated structure for React and Next.js. Decide hierarchy, state, and the server/client
boundary **before** writing components, so the visual layer has a stable skeleton to sit on.

**Does NOT cover:** visual design (use `hooked-ui`), UI verification (use `playwright-audit`),
database schema, or API design.

---

## Before Generating

| Source | Gather | Required? |
|--------|--------|-----------|
| `package.json` | Framework (Next.js App Router / Pages Router / Vite / Remix), package manager | Required |
| `tsconfig.json` | Path aliases (`@/*`), strictness | Required |
| Existing `src/` or `app/` tree | Conventions already in use — follow them over this document | Required |
| `CLAUDE.md`, `AGENTS.md`, `README.md`, or a design charter | Stack constraints, forbidden dependencies | If present |
| The request itself | Component purpose, data requirements, auth needed? | Required |

**If the project already has a folder convention, it wins.** This skill describes a good
default for greenfield work, not a mandate to restructure someone's codebase.

If the routing strategy (App Router vs Pages Router) is not clear from `package.json` and the
directory tree, ask before generating.

---

## File Organisation

```
src/
  app/                    # Next.js App Router routes
    (marketing)/          # Route groups for distinct layouts
    (app)/
    api/
  components/
    ui/                   # Pure presentational. Props only. No data fetching.
    features/             # Feature-coupled. Owns its own data fetching.
    layouts/              # Page and section shells
  hooks/                  # Custom React hooks
  lib/                    # Utilities, API clients, constants
  types/                  # Shared TypeScript interfaces
```

For Vite or Remix, keep `components/`, `hooks/`, `lib/`, `types/` identical and swap `app/`
for that framework's route directory.

**Scaling rule.** Under roughly 30 components, the flat `ui/ features/ layouts/` split is
correct. Past that, group `features/` by domain (`features/billing/`, `features/inbox/`) and
keep `ui/` flat, because `ui/` should stay small enough to scan.

---

## Component Rules

1. **Presentational** (`components/ui/`) — props in, JSX out. No data fetching, no router access, no global store reads. This is what makes them testable and reusable.
2. **Feature** (`components/features/`) — owns its data fetching and may read the router or a store. Composes `ui/` components.
3. **One component per file.** No barrel `index.ts` re-exports that defeat tree-shaking.
4. **Co-locate styles.** Tailwind classes inline, or CSS Modules beside the file. No global overrides outside `app/globals.css`.
5. **Props over configuration objects.** `<Button variant="primary" size="sm">`, not `<Button config={{variant:'primary'}}>`.
6. **Composition over boolean explosion.** When a component has more than about four booleans, split it or expose slots (`<Card.Header>`, `children`).

---

## The Server/Client Boundary (App Router)

This is the decision that most often goes wrong. Get it right first.

| Put it in a Server Component | Put it in a Client Component |
|---|---|
| Initial data load | `useState`, `useReducer`, `useEffect` |
| Secrets, API keys, direct DB access | Event handlers (`onClick`, `onChange`) |
| Large formatting or parsing dependencies | Browser APIs (`window`, `localStorage`, `IntersectionObserver`) |
| Static or rarely-changing markup | Animation libraries, charts, maps |

**Rules:**
- Default to Server. Add `'use client'` only at the leaf that actually needs it.
- Never put `'use client'` at the top of a layout or page to "make it work". That opts the whole subtree into the client bundle.
- Pass server-fetched data **down** into client components as props rather than refetching on the client.
- A client component can render `children` that were built on the server. Use this to keep heavy content out of the bundle.

---

## State Management

Choose the narrowest scope that works. Escalate only when you hit a real wall.

| Scope | Solution |
|-------|----------|
| Server state / API data | Server Components first; SWR or React Query when client-side revalidation is needed |
| Local UI state | `useState` / `useReducer` |
| URL-shaped state (filters, tabs, pagination) | Search params, not React state |
| Cross-component UI state | React Context, provider placed as close to consumers as possible |
| Global app state | Zustand, only when Context causes measurable re-render problems |

**Never** introduce Redux or MobX without an explicit user request.

**Do not put server data in a global store.** Cache invalidation is the hard part, and SWR
and React Query already solve it.

---

## Data Fetching

**App Router (preferred):**
- Server Components for initial load. No client-side waterfall.
- `use server` actions for mutations, with `revalidatePath` or `revalidateTag` afterwards.
- SWR or React Query only for polling, infinite scroll, or optimistic UI.

**Pages Router:**
- `getServerSideProps` for auth-gated pages.
- `getStaticProps` + `revalidate` for public content.
- SWR for client-side mutation and real-time updates.

**Always:** fetch in parallel with `Promise.all` when requests are independent. Sequential
`await`s are the most common cause of a slow page.

---

## The Loading / Empty / Error Contract

Every component that fetches data ships four states, not one. A component that only handles
the happy path is not finished.

| State | Requirement |
|-------|-------------|
| **Loading** | Skeleton matching the real layout's dimensions. Never a centered spinner for content that has a known shape, and never a layout that shifts when data lands. |
| **Empty** | Explain what would appear here and give the action that creates the first item. Never a bare "No data". |
| **Error** | Say what failed in plain language and offer a retry. Never surface a raw exception string. |
| **Success** | The happy path. |

In App Router, `loading.tsx` and `error.tsx` cover route-level states. Component-level states
are still your responsibility.

---

## TypeScript Requirements

- Props interfaces exported and named `<ComponentName>Props`.
- No `any`. Use `unknown` and narrow explicitly.
- API response types in `src/types/api.ts`, derived from the schema where one exists (Zod, OpenAPI, generated DB types) rather than hand-written.
- Discriminated unions for variant props, so invalid combinations fail at compile time.

---

## Accessibility Baseline

Not a full audit, just the parts that are architectural and expensive to retrofit:

- Interactive elements are `<button>` or `<a>`, never a `<div>` with `onClick`.
- Every input has an associated `<label>`, not just a placeholder.
- Focus is visible and never removed without a replacement.
- Modals and drawers trap focus and restore it on close.
- Icon-only buttons carry `aria-label`.

---

## Anti-Patterns

- `'use client'` at the root of a layout or page.
- Barrel files that re-export an entire directory.
- Data fetching inside presentational components.
- `useEffect` used to derive state that could be computed during render.
- Prop drilling more than three levels instead of composition or Context.
- A global store holding server data.
- Components over roughly 200 lines. Split by responsibility, not by line count.

---

## Checklist (Run Before Output)

- [ ] Followed the project's existing conventions where they exist
- [ ] Component in the correct directory (`ui/` vs `features/` vs `layouts/`)
- [ ] `'use client'` at the narrowest possible leaf, or absent
- [ ] Props interface defined and exported
- [ ] No `any` types
- [ ] Data fetching at the correct layer, parallel where independent
- [ ] Loading, empty, and error states all handled
- [ ] Interactive elements are real buttons and links, labelled inputs, visible focus
- [ ] Applied `hooked-ui` for the visual layer
