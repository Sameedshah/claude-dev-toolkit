# Domain Aesthetics

Each domain has a visual language that users already associate with trust and quality. Don't fight it — extend it.

---

## SaaS / Productivity Tool

**Emotional register:** Efficient. Capable. Worth the subscription.  
**Reference:** Linear, Vercel, Notion, Raycast

```css
:root {
  --bg-base:    #0a0a0a;
  --bg-surface: #111111;
  --bg-elevated:#1a1a1a;
  --text-pri:   #ededed;
  --text-sec:   #888888;
  --brand:      #6366f1;   /* or project-specific */
  --border:     rgba(255,255,255,0.07);
}
```

- **Font:** Geist (700 display) + Geist (400 body) — or Inter throughout
- **Layout:** Dense but breathable. Sidebar + main content. Data tables look good.
- **Motion:** Functional only. 150–200ms transitions. No scroll theatrics.
- **Cards:** Flat with thin borders. No heavy shadows.
- **Radius:** 8–12px. Nothing too round.

---

## AI / Tech Product

**Emotional register:** Intelligent. Cutting-edge. Quietly powerful.  
**Reference:** Claude.ai, Perplexity, Cursor, Anthropic

```css
:root {
  --bg-base:    #0d0d0d;
  --bg-surface: #141414;
  --bg-elevated:#1c1c1c;
  --text-pri:   #f0ede8;   /* warm white, not pure */
  --text-sec:   #8a8480;
  --brand:      #d97757;   /* warm terra — or purple/indigo */
  --border:     rgba(255,255,255,0.06);
  --glow:       rgba(217,119,87,0.12);
}
```

- **Font:** Styrene A (700) + Inter (400) — or Söhne + DM Sans
- **Layout:** Centered, generous margins. Single column for reading. The content IS the product.
- **Motion:** Extremely restrained. Fade only. Never distracting.
- **Depth:** Layered surfaces (base → surface → elevated). No harsh shadows.
- **Signature:** Warm off-whites. Never pure `#ffffff`. Never pure `#000000`.
- **Radius:** 6–10px. Subtle, not pill-shaped.

---

## Developer Tool / CLI / SDK

**Emotional register:** Precise. Fast. Trusted by the best engineers.  
**Reference:** GitHub, Supabase, Planetscale, Stripe docs

```css
:root {
  --bg-base:    #0d1117;
  --bg-surface: #161b22;
  --bg-elevated:#21262d;
  --text-pri:   #e6edf3;
  --text-sec:   #8b949e;
  --brand:      #58a6ff;
  --brand-alt:  #3fb950;  /* green for success/actions */
  --border:     rgba(48,54,61,1);
  --code-bg:    #161b22;
}
```

- **Font:** JetBrains Mono (600) for headings/brand + Inter (400) body. Monospace as an accent is deliberate — it signals craft.
- **Layout:** Information-dense. Sidebar navigation. Code blocks are first-class citizens.
- **Motion:** Near-zero. Instant or 100ms max. Engineers hate waiting.
- **Code blocks:** Syntax highlighted, copy button always present, line numbers optional.
- **Radius:** 6px. Square-ish. Precision aesthetic.

---

## Fintech / Finance

**Emotional register:** Trustworthy. Authoritative. Your money is safe here.  
**Reference:** Stripe, Mercury, Brex, Wise

```css
:root {
  --bg-base:    #ffffff;
  --bg-surface: #f9fafb;
  --bg-elevated:#f3f4f6;
  --text-pri:   #111827;
  --text-sec:   #6b7280;
  --brand:      #1d4ed8;   /* deep blue — authority */
  --brand-alt:  #059669;   /* green — positive values */
  --danger:     #dc2626;
  --border:     #e5e7eb;
}
```

- **Font:** Inter (700) + Inter (400). No display fonts — legibility is trust.
- **Layout:** Clean columns. Data is the UI. Numbers must be scannable (tabular numerals: `font-variant-numeric: tabular-nums`).
- **Motion:** Minimal. Loading states (skeleton screens), hover highlights, nothing dramatic.
- **Light mode default** — money on dark backgrounds feels untrustworthy to most users.
- **Data tables:** Zebra striping subtle, sortable headers, clear hierarchy.

---

## Healthcare / Wellness

**Emotional register:** Calm. Safe. You are in good hands.  
**Reference:** One Medical, Calm, Headspace, Oscar Health

```css
:root {
  --bg-base:    #ffffff;
  --bg-surface: #f0f7f4;
  --bg-elevated:#e0efe9;
  --text-pri:   #1a2e22;
  --text-sec:   #4a6358;
  --brand:      #2d7a5a;   /* health green */
  --brand-soft: #e0efe9;
  --border:     #c8ddd5;
}
```

- **Font:** DM Serif Display (700) + DM Sans (400). Serif headlines feel human and caring.
- **Layout:** Wide margins. Never cramped. White space is therapeutic.
- **Motion:** Slow and soft. `ease-in-out`, 400–600ms. Nothing startles.
- **Imagery:** Real people, diverse, not stock-photo-generic.
- **WCAG AA compliance mandatory** — large touch targets, clear contrast.

---

## E-Commerce / Fashion / Luxury

**Emotional register:** Desirable. Elevated. I want this.  
**Reference:** Mytheresa, Net-a-Porter, Aesop, Glossier

```css
:root {
  --bg-base:    #fafaf8;   /* warm off-white */
  --bg-surface: #f5f4f0;
  --text-pri:   #1a1a18;
  --text-sec:   #6b6860;
  --brand:      #1a1a18;   /* black as primary brand */
  --accent:     #c9a96e;   /* gold — use very sparingly */
  --border:     rgba(0,0,0,0.08);
}
```

- **Font:** Cormorant Garamond (300–700) headlines + Helvetica Neue / Aktiv Grotesk body. Or: Playfair Display + DM Sans.
- **Layout:** Product imagery dominates. Text is minimal, precise. Every word earns its place.
- **Motion:** Slow, deliberate. Image hover reveals at 600ms. Scroll-parallax on hero images.
- **White space:** Extremely generous. Luxury is expensive emptiness.
- **No CTAs screaming "BUY NOW"** — everything is calm invitation.

---

## Creative Agency / Portfolio

**Emotional register:** Audacious. Memorable. We made that.  
**Reference:** Awwwards winners, Fantasy, Resn, Active Theory

```css
:root {
  /* Pick ONE of these directions per project */
  
  /* Option A: Black canvas */
  --bg-base: #000000;
  --text-pri: #ffffff;
  /* --brand: whatever is bold and unexpected */

  /* Option B: Full color */
  /* --bg-base: #ff3b2f; (or another strong brand color) */
  /* --text-pri: #ffffff; */
}
```

- **Font:** Clash Display / PP Editorial / Syne (800) for massive headlines. The font IS the design.
- **Layout:** Break the grid intentionally. Overlapping elements, asymmetry, oversized type.
- **Motion:** Heavy. This is where Cinematic mode + GSAP is used at full intensity.
- **Cursor:** Custom cursors are banned by default (`taste-ai-tells.md` §9.A). Use one only when the brief explicitly asks.
- **Scroll:** Horizontal scroll sections, pinned storytelling, velocity-based effects.

---

## Startup / Launch / Waitlist

**Emotional register:** Exciting. This is going to change things. I need to be early.  
**Reference:** Early Loom, Linear launch, Arc Browser

```css
:root {
  --bg-base:    #050505;
  --bg-surface: #0f0f0f;
  --text-pri:   #f5f5f5;
  --text-sec:   #999999;
  --brand:      #7c3aed;   /* or whatever pops for the product */
  --brand-glow: rgba(124,58,237,0.2);
  --border:     rgba(255,255,255,0.08);
}
```

- **Font:** Cabinet Grotesk (800) or Satoshi (700) + Inter (400). Young, confident.
- **Layout:** Full-page sections. One idea per section. Social proof heavy.
- **Motion:** Cinematic mode, full intensity. This is where GSAP scroll snap belongs.
- **Conversion focus:** Every section leads toward the waitlist/signup CTA.
- **Eyebrow labels:** "Now in beta" / "Join 10,000+ on the waitlist" — urgency without desperation.

---

## Hospitality / Restaurant / Food

**Emotional register:** Warm. Inviting. I want to be there.  
**Reference:** Eleven Madison Park, Noma, Jose Andres restaurants

```css
:root {
  --bg-base:    #1a1209;   /* dark warm brown */
  --bg-surface: #241b0f;
  --text-pri:   #f5ede0;   /* warm cream */
  --text-sec:   #b8a48a;
  --brand:      #c4913a;   /* warm gold */
  --border:     rgba(196,145,58,0.15);
}
```

- **Font:** Cormorant (300 italic for ambiance) + Lato / DM Sans (400 body).
- **Layout:** Imagery-first. Full-bleed food photography. Minimal chrome.
- **Motion:** Slow parallax on images. Soft fade reveals. Nothing jarring.
- **Menu design:** Scannable, clear sections, readable in low light (apps must handle this).
