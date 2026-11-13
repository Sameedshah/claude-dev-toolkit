# Motion System

## When to Use GSAP vs CSS

| Situation | Use |
|---|---|
| Cinematic mode — scroll reveals, entrance sequences | GSAP + ScrollTrigger |
| Product mode — hover, focus, open/close | CSS transitions only |
| Cinematic hover (magnetic, cursor) | GSAP |
| Loading states, skeletons | CSS animations |
| Page transitions | GSAP (if Next.js, use `next-view-transitions` + GSAP) |

---

## GSAP Setup

```bash
npm install gsap @gsap/react
```

```tsx
// lib/gsap.ts — register once, import everywhere
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
gsap.registerPlugin(ScrollTrigger);
export { gsap, ScrollTrigger };

// In React components:
import { useGSAP } from '@gsap/react';
import { gsap, ScrollTrigger } from '@/lib/gsap';
```

---

## Cinematic Patterns

### Hero Entrance Timeline
```tsx
useGSAP(() => {
  const tl = gsap.timeline({ defaults: { ease: 'expo.out' } });
  tl.from('.hero-eyebrow',  { opacity: 0, y: 16, duration: 0.6 })
    .from('.hero-headline', { opacity: 0, y: 48, duration: 0.9 }, '-=0.35')
    .from('.hero-sub',      { opacity: 0, y: 24, duration: 0.7 }, '-=0.55')
    .from('.hero-cta',      { opacity: 0, y: 20, scale: 0.96, duration: 0.6 }, '-=0.45')
    .from('.hero-visual',   { opacity: 0, scale: 1.04, duration: 1.2 }, '-=0.7');
}, { scope: containerRef });
```

### Section Reveal (apply to every non-hero section)
```tsx
useGSAP(() => {
  gsap.utils.toArray<HTMLElement>('.reveal').forEach(el => {
    gsap.from(el, {
      scrollTrigger: { trigger: el, start: 'top 85%', toggleActions: 'play none none reverse' },
      opacity: 0,
      y: 64,
      duration: 0.85,
      ease: 'power3.out',
    });
  });
}, { scope: containerRef });
```

Add `.reveal` to any element that should animate in on scroll.

### Staggered Grid (cards, features, logos)
```tsx
gsap.from('.stagger-item', {
  scrollTrigger: { trigger: '.stagger-grid', start: 'top 80%', toggleActions: 'play none none reverse' },
  opacity: 0,
  y: 56,
  scale: 0.97,
  duration: 0.75,
  ease: 'power3.out',
  stagger: { amount: 0.45, from: 'start' },
});
```

### Pinned Feature Narrative (section stays while content changes)
```tsx
const steps = gsap.utils.toArray<HTMLElement>('.feature-step');
const tl = gsap.timeline({
  scrollTrigger: {
    trigger: '.features-pinned',
    pin: true,
    scrub: 1.5,
    start: 'top top',
    end: `+=${steps.length * 700}`,
  }
});
steps.slice(1).forEach(step => tl.from(step, { opacity: 0, y: 40 }));
```

### Counter Animate (stats section)
```tsx
ScrollTrigger.create({
  trigger: '.stats-section',
  start: 'top 72%',
  onEnter: () => {
    document.querySelectorAll<HTMLElement>('[data-count]').forEach(el => {
      const target = parseInt(el.dataset.count!);
      gsap.fromTo({ val: 0 }, { val: target }, {
        duration: 1.8,
        ease: 'power2.out',
        onUpdate: function () { el.textContent = Math.round(this.targets()[0].val).toLocaleString(); }
      });
    });
  }
});
```

### Parallax Background
```tsx
gsap.to('.parallax-bg', {
  scrollTrigger: { trigger: '.parallax-section', start: 'top bottom', end: 'bottom top', scrub: true },
  y: '30%',
  ease: 'none',
});
```

### Headline Character Split
```tsx
// Split without SplitText plugin
const splitChars = (el: HTMLElement) => {
  el.innerHTML = el.textContent!.split('').map(
    c => c === ' ' ? '<span class="char">&nbsp;</span>' : `<span class="char">${c}</span>`
  ).join('');
};

splitChars(headlineEl);

gsap.from('.char', {
  scrollTrigger: { trigger: headlineEl, start: 'top 85%' },
  opacity: 0, y: '110%', rotateX: -80,
  duration: 0.55, ease: 'back.out(1.5)', stagger: 0.022,
});
```

### Horizontal Marquee (logo strip / social proof)
```tsx
const marquee = gsap.to('.marquee-track', {
  x: '-50%', duration: 22, ease: 'none', repeat: -1,
});
wrapEl.addEventListener('mouseenter', () => marquee.pause());
wrapEl.addEventListener('mouseleave', () => marquee.play());
```

---

## Scroll Progress Indicator (Cinematic mandatory)

```tsx
// Fixed dots on right edge, one per section
function ScrollDots({ count, active }: { count: number; active: number }) {
  return (
    <div className="scroll-dots">
      {Array.from({ length: count }).map((_, i) => (
        <button
          key={i}
          className={`dot ${i === active ? 'active' : ''}`}
          onClick={() => sections[i].scrollIntoView({ behavior: 'smooth' })}
          aria-label={`Go to section ${i + 1}`}
        />
      ))}
    </div>
  );
}
```

```css
.scroll-dots {
  position: fixed; right: 1.5rem; top: 50%;
  transform: translateY(-50%);
  display: flex; flex-direction: column; gap: 10px;
  z-index: 100;
}
.dot {
  width: 7px; height: 7px; border-radius: 50%;
  background: rgba(255,255,255,0.25);
  border: none; cursor: pointer;
  transition: all 0.3s var(--ease-out-expo);
}
.dot.active {
  background: white;
  transform: scale(1.7);
}
```

---

## Easing Quick Reference

| Feel | Value | Use |
|---|---|---|
| Default reveal | `power3.out` | Slide-up section reveals |
| Hero / dramatic | `expo.out` | Headlines, hero entrance |
| Snappy / bouncy | `back.out(1.5)` | Char splits, badge pops |
| Mechanical scrub | `none` | Parallax, pinned |
| Elastic | `elastic.out(1, 0.5)` | Magnetic return |

## Duration Reference

| Element | Duration |
|---|---|
| Hero sequence total | 1.4–2.0s (timeline) |
| Section reveal | 0.75–0.95s |
| Stagger child | 0.6–0.75s |
| Char split per char | 0.04–0.06s stagger |
| Counter | 1.6–2.0s |
| CSS hover | 0.2–0.3s |
| CSS modal/panel | 0.15–0.25s |
