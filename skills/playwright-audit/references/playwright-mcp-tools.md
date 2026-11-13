# Playwright MCP Tool Reference
<!-- last-updated: 2026-04-02 | version: 1.0 -->

Quick reference for tools used in the playwright-audit workflow.

## Tools Used in This Skill

### browser_navigate
Navigate to a URL.
```json
{ "url": "http://localhost:3000" }
```
Returns: page snapshot or error. On connection refused → server not started.

### browser_resize
Set viewport dimensions.
```json
{ "width": 1440, "height": 900 }
```
Must be called before each screenshot when changing viewports.

### browser_take_screenshot
Capture current viewport.
```json
{ "filename": ".qa/screenshots/desktop-home-2026-09-22.png" }
```
No `savePng` flag needed — filename controls output path.

### browser_console_messages
Retrieve all console messages captured since navigation.
```json
{}
```
Returns array of `{ type, text, timestamp }`. Filter for `type === "error"`.

### browser_close
Close the browser session after audit.
```json
{}
```
Call after Step 6 (report written) to release resources.

## Tool Name Prefixes

The MCP server may be registered as either:
- `mcp__playwright__<tool>` (Claude Code native MCP)
- `mcp__plugin_playwright_playwright__<tool>` (plugin registry)

Use whichever prefix is available in the current session.

### browser_evaluate
Run a function in the page context.
```json
{ "function": "() => document.documentElement.scrollWidth > document.documentElement.clientWidth" }
```
Returns the function's return value. Used for the mobile horizontal-overflow check.
Some Playwright MCP builds omit this tool. If it is absent, record the overflow check as
"not checked" rather than passing it.
