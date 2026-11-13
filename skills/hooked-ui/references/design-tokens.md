# Design Tokens

Always define tokens as CSS custom properties at `:root` before any component code. Copy from domain-aesthetics.md for the project domain, then extend here.

## Base Token Structure (fill from domain-aesthetics.md)

```css
:root {
  /* === Backgrounds === */
  --bg-base:     ;   /* page background */
  --bg-surface:  ;   /* card, panel surface */
  --bg-elevated: ;   /* popover, modal, tooltip */

  /* === Text === */
  --text-pri:    ;   /* primary text */
  --text-sec:    ;   /* secondary / muted */
  --text-dis:    ;   /* disabled */

  /* === Brand === */
  --brand:       ;   /* single brand color */
  --brand-hover: ;   /* brand darkened 10% */
  --brand-glow:  ;   /* brand at 12–20% opacity */

  /* === Borders === */
  --border:      ;   /* default border */
  --border-hover:;   /* hover / focus border */

  /* === Semantic === */
  --success:  #22c55e;
  --warning:  #f59e0b;
  --danger:   #ef4444;
  --info:     #3b82f6;

  /* === Typography === */
  --font-display: ;  /* headline font family */
  --font-body:    ;  /* body font family */
  --font-mono:    ;  /* code font */

  /* === Spacing scale (8px base) === */
  --space-1:  0.25rem;  /*  4px */
  --space-2:  0.5rem;   /*  8px */
  --space-3:  0.75rem;  /* 12px */
  --space-4:  1rem;     /* 16px */
  --space-5:  1.25rem;  /* 20px */
  --space-6:  1.5rem;   /* 24px */
  --space-8:  2rem;     /* 32px */
  --space-10: 2.5rem;   /* 40px */
  --space-12: 3rem;     /* 48px */
  --space-16: 4rem;     /* 64px */
  --space-20: 5rem;     /* 80px */
  --space-24: 6rem;     /* 96px */

  /* === Radii === */
  --radius-sm:   4px;
  --radius-md:   8px;
  --radius-lg:   12px;
  --radius-xl:   16px;
  --radius-2xl:  24px;
  --radius-full: 9999px;

  /* === Type scale === */
  --text-xs:   0.75rem;
  --text-sm:   0.875rem;
  --text-base: 1rem;
  --text-lg:   1.125rem;
  --text-xl:   1.25rem;
  --text-2xl:  1.5rem;
  --text-3xl:  1.875rem;
  --text-4xl:  2.25rem;
  --text-5xl:  3rem;
  --text-6xl:  3.75rem;
  --text-7xl:  4.5rem;
  --text-8xl:  6rem;

  /* === Shadows === */
  --shadow-sm: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.08);
  --shadow-md: 0 4px 16px rgba(0,0,0,0.16);
  --shadow-lg: 0 16px 48px rgba(0,0,0,0.24);
  --shadow-xl: 0 32px 64px rgba(0,0,0,0.32);

  /* === Transitions === */
  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-out-back: cubic-bezier(0.34, 1.56, 0.64, 1);
  --dur-fast:   150ms;
  --dur-base:   250ms;
  --dur-slow:   400ms;
  --dur-cinema: 900ms;
}
```

## Font Loading (pick ONE pairing from domain-aesthetics.md)

### Dark Tech / SaaS (Geist)
```tsx
// next/font approach
import { GeistSans, GeistMono } from 'geist/font';
```
```css
--font-display: 'Geist', sans-serif;
--font-body:    'Geist', sans-serif;
--font-mono:    'Geist Mono', monospace;
```

### AI / Tech Product (Styrene A + Inter)
> **Prototype only.** In production load fonts via `next/font` or a self-hosted `@font-face` with
> `font-display: swap`. Never ship a Google Fonts `<link>` (`taste-directives.md` §3.A).

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
```
```css
/* Styrene A via Fontshare: */
@import url('https://api.fontshare.com/v2/css?f[]=styrene-a@700,800&display=swap');
--font-display: 'Styrene A', sans-serif;
--font-body:    'Inter', sans-serif;
```

### Bold Startup (Cabinet Grotesk + Satoshi)
```css
@import url('https://api.fontshare.com/v2/css?f[]=cabinet-grotesk@700,800&f[]=satoshi@400,500&display=swap');
--font-display: 'Cabinet Grotesk', sans-serif;
--font-body:    'Satoshi', sans-serif;
```

### Luxury / Editorial (Cormorant + DM Sans)
```html
<link href="https://fonts.googleapis.com/css2?family=Cormorant:ital,wght@0,300;0,600;1,300&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
```
```css
--font-display: 'Cormorant', serif;
--font-body:    'DM Sans', sans-serif;
```

### Developer Tool (JetBrains Mono + Inter)
```html
<link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@600&family=Inter:wght@400;500&display=swap" rel="stylesheet">
```
```css
--font-display: 'JetBrains Mono', monospace;
--font-body:    'Inter', sans-serif;
--font-mono:    'JetBrains Mono', monospace;
```

## Tailwind Config (if using Tailwind)

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        bg: {
          base:    'var(--bg-base)',
          surface: 'var(--bg-surface)',
          elevated:'var(--bg-elevated)',
        },
        brand:   'var(--brand)',
        border:  'var(--border)',
        text: {
          pri: 'var(--text-pri)',
          sec: 'var(--text-sec)',
        }
      },
      fontFamily: {
        display: ['var(--font-display)'],
        body:    ['var(--font-body)'],
        mono:    ['var(--font-mono)'],
      },
      transitionTimingFunction: {
        'expo-out': 'cubic-bezier(0.16, 1, 0.3, 1)',
        'back-out': 'cubic-bezier(0.34, 1.56, 0.64, 1)',
      },
    },
  },
}
```
