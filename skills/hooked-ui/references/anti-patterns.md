# Anti-Patterns

These are automatic failures. Fix before outputting any UI.

> **Run `taste-ai-tells.md` (§9) and `taste-preflight.md` (§14) alongside this file.** They cover the
> Taste Engine's forbidden signatures (em-dash ban, eyebrow spam, section-number labels, scroll cues,
> fake screenshots, locale strips, decorative dots) and the full pre-flight matrix. This file is the
> hooked-ui baseline; those two are the anti-slop layer on top. Where they disagree, they win.

## Hard Failures (fix immediately)

### Typography
- ❌ `font-family: system-ui` or `Arial` or `Helvetica` as the primary/display font
- ❌ Mixing more than 2 typefaces (display + body is the maximum)
- ❌ Hero headline smaller than `3rem` (`--text-5xl`)
- ❌ Body text smaller than `0.875rem` (`--text-sm`)
- ❌ Line-height below `1.5` on body text
- ❌ `font-weight: 400` on a headline (use 600 minimum, 700–800 preferred)

### Color
- ❌ More than 3 distinct colors in the palette (bg + text + brand)
- ❌ Rainbow or multi-stop gradient (e.g., `linear-gradient(to right, #f00, #0f0, #00f)`)
- ❌ Pure black (`#000000`) as background — use near-black (e.g. `#050505`, `#0a0a0a`, `#080808`)
- ❌ Pure white (`#ffffff`) as background on dark themes
- ❌ Default browser blue (`#0000ff` or `#007bff`) as the brand color without explicit project specification
- ❌ Low contrast text — WCAG AA minimum: 4.5:1 for normal text, 3:1 for large text

### Layout
- ❌ Generic centered hero with: headline → sub → two CTA buttons → hero image. This is the AI default.
- ❌ Three equal-width feature columns with icon on top, title, description. Generic.
- ❌ Flat cards with no depth, no border, no shadow — invisible surfaces
- ❌ `padding: 20px` everywhere — use the spacing scale
- ❌ Content touching viewport edges — always use container max-width + horizontal padding

### Animation
- ❌ CSS `transition: all` — transition specific properties only
- ❌ GSAP animations in Product mode layout/entrance (hover only)
- ❌ Scroll snap on Product/app pages — ruins the navigation experience
- ❌ Entrance animation delay > 300ms on the first visible content
- ❌ `animation-duration: 2s` or longer on reveals — users stop watching at 1.2s
- ❌ Animating `width`, `height`, or `top/left` — always use `transform` and `opacity`

### Interactions
- ❌ Button with no hover state
- ❌ Card with no hover state when clickable
- ❌ Link with no visual change on hover
- ❌ Icon-only button with no accessible label
- ❌ Missing focus states (`:focus-visible`)

## AI-Default Patterns to Avoid

These patterns instantly signal "AI wrote this." Avoid:

1. **The Symmetric Hero** — centered headline, centered sub-text, two buttons side by side, floating mockup image
2. **The Three-Column Feature Grid** — three cards, each with emoji/icon on top, bold title, 2-line description
3. **The Testimonial Carousel** — auto-scrolling quotes with profile pictures and star ratings
4. **The Pricing Table** — three columns (Basic / Pro / Enterprise) in identical pastel card boxes
5. **The Gradient Header** — text that goes from brand color to white via `background-clip: text`... on every heading
6. **The Sticky CTA Banner** — fixed bottom bar saying "Get started for free →"
7. **The Floating Blob** — `border-radius: 60% 40% 70% 30% / 50% 60% 40% 50%` animated in the background
8. **Section Divider Waves** — SVG wave between every section in a different pastel color
9. **The FAQ Accordion** — collapsed list of 8 questions with chevron icons, same design as every other site
10. **Dark mode with purple brand** — dark `#0f0f23` + `#7c3aed` + Inter. This is the default AI dark theme.

## What to Do Instead

- **Hero:** Use asymmetric layout, oversized display text (not centered), or split-screen with a real visual
- **Features:** Use a pinned narrative section, horizontal scroll, or a single large feature per section
- **Testimonials:** One full-bleed quote with a huge pull-quote, not a carousel
- **Pricing:** Single focused plan or interactive pricing calculator
- **Gradients:** One subtle radial glow behind the hero, not repeated on every heading
- **Dark theme:** Start from the domain aesthetic — pick the right dark palette for the industry, not the default purple
