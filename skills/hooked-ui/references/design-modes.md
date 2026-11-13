# Design Modes

Three modes. Pick one before writing any code. The mode determines architecture, not just style.

---

## Mode 1: Cinematic (Marketing / Landing Pages)

**When:** Homepage, landing page, product marketing page, waitlist page, launch page.

**Architecture first — set this up before any content:**

```css
html {
  scroll-snap-type: y mandatory;
  overflow-y: scroll;
}

.section {
  scroll-snap-align: start;
  scroll-snap-stop: always;
  height: 100vh;
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
```

**Section sequence (one idea per section):**
1. Hero — hook in 3 seconds or lose them
2. Problem — state the pain, boldly
3. Solution — what you do, one sentence
4. Features — 3 max, each gets its own section if impactful enough
5. Social proof — one powerful stat or quote, full bleed
6. CTA — one action, no distractions

**GSAP setup (React/Next.js):**
```tsx
'use client';
import { useGSAP } from '@gsap/react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
gsap.registerPlugin(ScrollTrigger);

// In component:
useGSAP(() => {
  gsap.from('.reveal', {
    scrollTrigger: { trigger: '.reveal', start: 'top 85%', toggleActions: 'play none none reverse' },
    opacity: 0, y: 70, duration: 0.9, ease: 'power3.out', stagger: 0.12
  });
}, { scope: containerRef });
```

**Cinematic mandatories:**
- Scroll progress dots (right edge, fixed)
- Every non-hero section: fade + slide-up reveal
- Hero: timeline entrance sequence (eyebrow → headline → sub → CTA → visual)
- All CTA buttons: magnetic hover (GSAP)
- Typography: 6–8rem hero headline, tight tracking (-0.03em to -0.04em)

---

## Mode 2: Product (App / Dashboard / SaaS UI)

**When:** Authenticated views, dashboards, settings pages, data tables, forms, workspaces.

**This is Claude.ai's mode.** Restraint is the skill. Every pixel earns its place.

**Core principles:**
- No full-page scroll snap — ruins app navigation
- No entrance animations on interactive elements — delay hurts productivity
- Motion = feedback, not decoration
- Typography serves readability, not drama
- Sidebar + content layout is the default
- Dense but breathable — information without overwhelm

**Layout skeleton:**
```css
.app-shell {
  display: grid;
  grid-template-columns: 240px 1fr;
  grid-template-rows: 56px 1fr;
  height: 100vh;
  overflow: hidden;
  background: var(--bg-base);
}

.topbar {
  grid-column: 1 / -1;
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  padding: 0 1.5rem;
  gap: 1rem;
}

.sidebar {
  border-right: 1px solid var(--border);
  overflow-y: auto;
  padding: 1rem;
}

.main-content {
  overflow-y: auto;
  padding: 2rem 2.5rem;
}
```

**Motion in Product mode (CSS only, no GSAP for layout):**
```css
/* Everything transitions at 150ms */
* {
  transition-duration: 150ms;
  transition-timing-function: cubic-bezier(0.16, 1, 0.3, 1);
}

/* Modal / panel entrance — only movement allowed */
@keyframes slide-up {
  from { opacity: 0; transform: translateY(8px); }
  to   { opacity: 1; transform: translateY(0); }
}

.panel { animation: slide-up 0.2s ease forwards; }

/* Skeleton loading */
@keyframes shimmer {
  from { background-position: -200% 0; }
  to   { background-position: 200% 0; }
}

.skeleton {
  background: linear-gradient(90deg, var(--bg-surface) 25%, var(--bg-elevated) 50%, var(--bg-surface) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
}
```

**Product mode mandatories:**
- Focus rings visible on all interactive elements (`outline: 2px solid var(--brand); outline-offset: 2px`)
- ARIA labels on icon-only buttons
- Keyboard navigation works
- Loading states (skeleton, not spinner by default)
- Empty states designed (not just "No data")
- Error states designed (inline, not just toast)

---

## Mode 3: Component (Isolated)

**When:** Building a single component with no page context given.

**Protocol:**
1. Check if constitution mentions a mode or page context
2. If the component description implies marketing (hero, CTA section, pricing card) → inherit Cinematic token set, apply hover from hover-system.md
3. If the component description implies app (data table, form, nav, settings panel) → inherit Product token set
4. If truly ambiguous → ask one question: "Is this for a marketing page or inside the product?"

**Always produce:**
- The component in isolation with self-contained CSS/Tailwind
- A hover state
- A responsive variant (mobile-first)
- The import / usage snippet

---

## Mode Decision Tree

```
What are you building?
│
├── Full page or multi-section page?
│   ├── Homepage / landing / marketing → CINEMATIC
│   └── Dashboard / app / settings → PRODUCT
│
├── A section of a page?
│   ├── Hero / pricing / testimonials / CTA → CINEMATIC
│   └── Data table / form / sidebar / nav → PRODUCT
│
└── An isolated component?
    ├── Check parent page type from constitution/spec
    └── Ask if unknown
```
