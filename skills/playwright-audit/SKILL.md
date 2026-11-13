---
name: playwright-audit
description: Post-implementation UI quality check using Playwright MCP for any web project. Use after a frontend implementation to capture screenshots at desktop and mobile, detect console errors, check for mobile overflow, and write a pass/fail report. Defines exact viewports, output paths, file naming, pass/fail criteria, and report format so the check is identical every run.
license: See LICENSE
metadata:
  author: Hooked Labs
  version: "2.0.0"
---

# Playwright Audit

A fast, repeatable visual check after a frontend change. Always the same two viewports, the
same output paths, and a written verdict. Deterministic by design: do not improvise viewports,
paths, or criteria.

**Does NOT cover:** full regression testing, pixel diffing, WCAG audits, performance
profiling, or cross-browser testing. This is the check you run before every commit, not the
suite you run before every release.

**Required tools:** a Playwright MCP server exposing `browser_navigate`, `browser_resize`,
`browser_take_screenshot`, `browser_console_messages`, `browser_evaluate`, `browser_close`.
See `references/playwright-mcp-tools.md` for exact parameters and tool-name prefixes.

---

## Viewports (Non-Negotiable)

| Label | Size | File name |
|-------|------|-----------|
| Desktop | 1440x900 | `desktop-<route>-YYYY-MM-DD.png` |
| Mobile | 375x812 | `mobile-<route>-YYYY-MM-DD.png` |

Never add or substitute viewports. No tablet, no 1280, no 1920. Two viewports is what makes
this check fast enough to run every time, which is the entire point.

`<route>` is the route slug with `/` replaced by `-`, and the site root written as `home`.
So `/` is `home`, `/pricing` is `pricing`, `/blog/first-post` is `blog-first-post`.

---

## Output Paths

Artifacts go to `.qa/` at the project root:

```
.qa/
  screenshots/
    desktop-home-2026-09-22.png
    mobile-home-2026-09-22.png
  console-errors-2026-09-22.txt   <- "None" if clean
  report-2026-09-22.md
```

**Path override.** If the project already has a QA convention, use it instead and say so in
the report. Common cases: a spec-driven repo using `.specify/qa/`, a `tests/screenshots/`
directory, or a path set in `CLAUDE.md` or `AGENTS.md`. Add `.qa/` to `.gitignore` unless the
user wants screenshots committed.

---

## Before Execution

1. Read `package.json` to identify the package manager (`npm` / `pnpm` / `yarn` / `bun`) and the dev script name. It is not always `dev`.
2. Determine the port. Check, in order: an explicit port in the dev script, `PORT` in `.env`, then the framework default (Next.js and Remix 3000, Vite 5173, Astro 4321).
3. Try `browser_navigate` to that URL. If it responds, a dev server is already running: skip Step 1 of the workflow and do not kill it at the end.
4. Create the output directory if absent.
5. Decide the route list. Default is the site root only. If the user named routes, or the change clearly touched specific routes, audit those instead. Cap at five routes per run.

---

## Workflow

1. **Start the dev server** (skip if already running)
   - Run `<package-manager> run <dev-script>` in the background.
   - Poll the URL for up to 30 seconds rather than sleeping a fixed amount. Large projects routinely take more than 10 seconds to become ready.
   - **Error:** if no dev script exists, stop and report: "Dev script not found in package.json, cannot start server."

2. **For each route, desktop capture** (1440x900)
   - `browser_navigate` to `http://localhost:<port><route>`
   - **Error:** connection refused after the 30s poll window, report "Server failed to start" and stop.
   - `browser_resize` to `width: 1440, height: 900`
   - `browser_take_screenshot` to `.qa/screenshots/desktop-<route>-YYYY-MM-DD.png`

3. **For each route, mobile capture** (375x812)
   - `browser_resize` to `width: 375, height: 812`
   - `browser_take_screenshot` to `.qa/screenshots/mobile-<route>-YYYY-MM-DD.png`
   - While at mobile width, check for horizontal overflow with `browser_evaluate`:
     `() => document.documentElement.scrollWidth > document.documentElement.clientWidth`
     This catches the single most common mobile break, and a screenshot alone will not show it.
     If the MCP server does not expose `browser_evaluate`, skip this check and record it as
     "not checked" in the report rather than silently passing it.

4. **Collect console errors**
   - `browser_console_messages`, keep entries where `type === "error"`, plus uncaught exceptions.
   - Write to `.qa/console-errors-YYYY-MM-DD.txt`, or the literal string `None` if clean.
   - Ignore known-benign noise: React DevTools suggestions, HMR and websocket chatter, and third-party analytics blocked by an ad blocker. Note anything ignored in the report rather than dropping it silently.

5. **Write the report** (template below)

6. **Clean up**
   - `browser_close`
   - Kill the dev server **only if you started it** in Step 1.

---

## Pass / Fail Criteria

| Check | PASS | FAIL |
|-------|------|------|
| HTTP status | 200 | 4xx / 5xx |
| Console errors | None, or only ignored noise | Any uncaught error or application error |
| Page renders | Real content visible | Blank page, white screen, or error boundary |
| Mobile overflow | `scrollWidth <= clientWidth` | Horizontal scroll at 375px |
| Layout integrity | No overlapping or clipped text | Content collides or is cut off |
| Primary nav | All links resolve | Any 404 from primary nav |

Any single FAIL makes the run FAIL. Do not report a partial pass.

---

## Report Template

Write to `.qa/report-YYYY-MM-DD.md`:

```markdown
# QA Report - YYYY-MM-DD

## Status: PASS / FAIL

## Scope
Routes audited: /, /pricing
Dev server: http://localhost:3000 (started by this run / already running)
Output path: .qa/  (or: project convention at <path>)

## Screenshots
- Desktop 1440x900: screenshots/desktop-home-YYYY-MM-DD.png
- Mobile 375x812: screenshots/mobile-home-YYYY-MM-DD.png

## Console Errors
<!-- paste from the console-errors file, or "None" -->

## Ignored Noise
<!-- list anything filtered out as benign, or "None" -->

## Issues Found
<!-- one line per issue: route, viewport, what is wrong. Or "None" -->

## Recommendation
<!-- "Safe to commit" OR "Fix before commit: <specific issue>" -->
```

---

## Notes

- Screenshots are evidence, not the verdict. Actually look at them before writing PASS.
- If a screenshot shows a layout problem the criteria table does not name, report it anyway under Issues Found.
- Re-run after fixes rather than editing the previous report, so each run's artifacts stay intact.
