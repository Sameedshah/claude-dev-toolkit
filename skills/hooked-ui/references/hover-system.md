# Hover System

Every interactive element gets a hover state. This file is the complete catalogue — pick what fits the context.

## Rule

If an element is `<a>`, `<button>`, or has `onClick` / `cursor-pointer` — it MUST have a hover state with a visible transform, color shift, or border change. Never static.

---

## Buttons

### Primary — Lift + Glow
```css
.btn-primary {
  display: inline-flex; align-items: center; gap: 0.5rem;
  padding: 0.75rem 1.75rem;
  background: var(--brand);
  color: #fff;
  border: none; border-radius: var(--radius-full);
  font: 500 0.9375rem var(--font-body);
  cursor: pointer;
  transition: transform var(--dur-base) var(--ease-out-expo),
              box-shadow var(--dur-base) var(--ease-out-expo);
}
.btn-primary:hover {
  transform: translateY(-3px);
  box-shadow: 0 16px 40px color-mix(in srgb, var(--brand) 40%, transparent),
              0 4px 12px color-mix(in srgb, var(--brand) 25%, transparent);
}
.btn-primary:active { transform: translateY(-1px); }
```

### Ghost — Border Brighten
```css
.btn-ghost {
  display: inline-flex; align-items: center; gap: 0.5rem;
  padding: 0.75rem 1.75rem;
  background: transparent;
  color: var(--text-pri);
  border: 1px solid var(--border);
  border-radius: var(--radius-full);
  font: 500 0.9375rem var(--font-body);
  cursor: pointer;
  transition: border-color var(--dur-base) ease,
              background var(--dur-base) ease,
              transform var(--dur-base) var(--ease-out-expo);
}
.btn-ghost:hover {
  border-color: var(--border-hover);
  background: rgba(255,255,255,0.04);
  transform: translateY(-2px);
}
```

### Icon Button — Scale + Background
```css
.btn-icon {
  width: 40px; height: 40px;
  display: grid; place-items: center;
  background: transparent;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  color: var(--text-sec);
  cursor: pointer;
  transition: background var(--dur-fast) ease,
              color var(--dur-fast) ease,
              border-color var(--dur-fast) ease,
              transform var(--dur-base) var(--ease-out-expo);
}
.btn-icon:hover {
  background: var(--bg-elevated);
  color: var(--text-pri);
  border-color: var(--border-hover);
  transform: scale(1.08);
}
```

---

## Cards — Spotlight + Lift

```css
.card {
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-xl);
  padding: 2rem;
  position: relative;
  overflow: hidden;
  transition: transform var(--dur-slow) var(--ease-out-expo),
              border-color var(--dur-slow) ease,
              box-shadow var(--dur-slow) ease;
}

/* Mouse-tracked spotlight */
.card::before {
  content: '';
  position: absolute; inset: 0;
  background: radial-gradient(
    500px circle at var(--mx, 50%) var(--my, 50%),
    rgba(255,255,255,0.05),
    transparent 50%
  );
  opacity: 0;
  transition: opacity 0.4s ease;
  pointer-events: none;
}

.card:hover { transform: translateY(-5px); border-color: var(--border-hover); }
.card:hover::before { opacity: 1; }
```

```js
// Attach to all cards
document.querySelectorAll('.card').forEach(card => {
  card.addEventListener('mousemove', e => {
    const { left, top, width, height } = card.getBoundingClientRect();
    card.style.setProperty('--mx', `${((e.clientX - left) / width) * 100}%`);
    card.style.setProperty('--my', `${((e.clientY - top) / height) * 100}%`);
  });
});
```

---

## Links / Nav — Underline Slide

```css
.nav-link {
  position: relative;
  color: var(--text-sec);
  text-decoration: none;
  font: 500 0.9375rem var(--font-body);
  transition: color var(--dur-fast) ease;
}
.nav-link::after {
  content: '';
  position: absolute; bottom: -2px; left: 0;
  width: 100%; height: 1px;
  background: var(--text-pri);
  transform: scaleX(0); transform-origin: right;
  transition: transform 0.3s var(--ease-out-expo);
}
.nav-link:hover { color: var(--text-pri); }
.nav-link:hover::after { transform: scaleX(1); transform-origin: left; }
```

---

## Magnetic (Cinematic only — CTAs, logo, social icons)

```ts
function makeMagnetic(selector: string, strength = 0.35) {
  document.querySelectorAll<HTMLElement>(selector).forEach(el => {
    el.addEventListener('mousemove', e => {
      const { left, top, width, height } = el.getBoundingClientRect();
      const dx = (e.clientX - left - width / 2) * strength;
      const dy = (e.clientY - top - height / 2) * strength;
      gsap.to(el, { x: dx, y: dy, duration: 0.4, ease: 'power2.out' });
    });
    el.addEventListener('mouseleave', () => {
      gsap.to(el, { x: 0, y: 0, duration: 0.6, ease: 'elastic.out(1, 0.5)' });
    });
  });
}

makeMagnetic('.btn-primary');
makeMagnetic('.social-icon', 0.5);
```

---

## Image Hover — Zoom + Overlay

```css
.img-wrapper {
  position: relative; overflow: hidden;
  border-radius: var(--radius-lg);
}
.img-wrapper img {
  width: 100%; height: 100%; object-fit: cover;
  transition: transform 0.6s var(--ease-out-expo);
  display: block;
}
.img-wrapper:hover img { transform: scale(1.06); }

.img-overlay {
  position: absolute; inset: 0;
  background: rgba(0,0,0,0.35);
  display: flex; align-items: center; justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}
.img-wrapper:hover .img-overlay { opacity: 1; }
```

---

## Custom Cursor (opt-in only)

> **Superseded by the Taste Engine.** Custom cursors are banned by default
> (`taste-ai-tells.md` §9.A: accessibility-hostile and perf-hostile). Ship one ONLY when the brief
> explicitly asks for it. When you do, keep the `@media (hover: none)` guard below and honour
> `prefers-reduced-motion`.

```tsx
// components/Cursor.tsx
'use client';
import { useEffect, useRef } from 'react';
import { gsap } from '@/lib/gsap';

export function Cursor() {
  const dotRef = useRef<HTMLDivElement>(null);
  const ringRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const dot = dotRef.current!;
    const ring = ringRef.current!;

    const move = (e: MouseEvent) => {
      gsap.to(dot,  { x: e.clientX - 5,  y: e.clientY - 5,  duration: 0.08 });
      gsap.to(ring, { x: e.clientX - 18, y: e.clientY - 18, duration: 0.4, ease: 'power2.out' });
    };

    const expand = () => gsap.to(ring, { scale: 2.2, borderColor: 'var(--brand)', duration: 0.3 });
    const shrink = () => gsap.to(ring, { scale: 1, borderColor: 'rgba(255,255,255,0.3)', duration: 0.3 });

    window.addEventListener('mousemove', move);
    document.querySelectorAll('a, button, .card, .magnetic')
      .forEach(el => { el.addEventListener('mouseenter', expand); el.addEventListener('mouseleave', shrink); });

    return () => window.removeEventListener('mousemove', move);
  }, []);

  return (
    <>
      <div ref={dotRef}  className="cursor-dot"  />
      <div ref={ringRef} className="cursor-ring" />
    </>
  );
}
```

```css
.cursor-dot, .cursor-ring {
  position: fixed; top: 0; left: 0;
  border-radius: 50%; pointer-events: none; z-index: 9999;
}
.cursor-dot  { width: 10px; height: 10px; background: var(--brand); mix-blend-mode: difference; }
.cursor-ring { width: 36px; height: 36px; border: 1.5px solid rgba(255,255,255,0.3); }

@media (hover: none) { .cursor-dot, .cursor-ring { display: none; } }
```

---

## Focus States (Product mode mandatory)

```css
/* Apply globally — never remove outline */
:focus-visible {
  outline: 2px solid var(--brand);
  outline-offset: 3px;
  border-radius: var(--radius-sm);
}

/* Override browser default without removing entirely */
*:focus:not(:focus-visible) { outline: none; }
```

---

## Sidebar / Nav Item (Product mode)

```css
.nav-item {
  display: flex; align-items: center; gap: 0.625rem;
  padding: 0.5rem 0.75rem;
  border-radius: var(--radius-md);
  color: var(--text-sec);
  font: 500 0.9rem var(--font-body);
  text-decoration: none;
  transition: background var(--dur-fast) ease, color var(--dur-fast) ease;
}
.nav-item:hover { background: var(--bg-elevated); color: var(--text-pri); }
.nav-item.active {
  background: var(--bg-elevated);
  color: var(--text-pri);
}
```
