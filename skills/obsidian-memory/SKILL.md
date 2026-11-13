---
name: obsidian-memory
description: Guides reading from and writing to a project Obsidian vault that follows the cod-dev-os vault convention. This skill should be used when loading project context at session start, writing session summaries at session end, logging architectural decisions, updating open questions, or appending spec history entries. The vault is always at ./obsidian/ relative to the project root — never search the filesystem for it.
---

# Obsidian Memory

## Overview

The project vault is always at `./obsidian/` — project-relative, never an absolute path. Do not search for vaults. Do not use the global Obsidian config path. Read and write files directly.

**Required tools:** Read, Write, Edit (or agent-equivalent file tools)

See `references/vault-conventions.md` for vault structure details and template formats.

## Before Acting

Before any read or write, confirm:

1. `./obsidian/` exists at project root — if absent, halt and report: "Vault not found at ./obsidian/ — run project bootstrap first."
2. Identify today's date (YYYY-MM-DD) for log and decision row naming
3. Identify which workflow to run: Session Start, Session End, or Direct Invocation (from user message)

## Vault File Map

| File | Purpose | When to read | When to write |
|------|---------|--------------|---------------|
| `./obsidian/overview.md` | Goals, stack, open questions | Session start | When adding a question |
| `./obsidian/decisions.md` | Decisions log table | Session start (last 10 rows) | After any architectural decision |
| `./obsidian/spec-history.md` | All generated specs | Before `/sp.specify-plus` | After each spec generation |
| `./obsidian/session-logs/YYYY-MM-DD.md` | Daily session summaries | Previous session summary only | Session end |
| `./obsidian/session-logs/.pending-sync` | Sync trigger marker | Check on start | Created by Stop hook |

## Session Start

1. Check for `./obsidian/session-logs/.pending-sync` — if present, a session ended without a summary
2. Read `./obsidian/overview.md` → load goals and open questions into context
3. Read `./obsidian/decisions.md` → load last 10 table rows
4. Read `./obsidian/spec-history.md` → load last 3 spec entries
5. Find most recent `./obsidian/session-logs/*.md` → summarise in 2 sentences
6. Output: `"Vault loaded. Project: <name>. Last session: <date> — <summary>."`

## Session End

1. Create `./obsidian/session-logs/YYYY-MM-DD.md` with this structure:

```markdown
# Session Log — YYYY-MM-DD

## What Was Done
- <bullet>

## Decisions Made
- <decision> or "None"

## Open Questions
- <question> or "None"

## Next Steps
1. <action>
```

2. Append any new decisions to `./obsidian/decisions.md` as a table row:
   `| YYYY-MM-DD | <decision> | <rationale> | <ADR link or "—"> |`
3. Delete `./obsidian/session-logs/.pending-sync` if it exists
4. Verify:
   - [ ] Session log file exists at correct path
   - [ ] Decisions appended (or confirmed "None")
   - [ ] `.pending-sync` deleted
5. Output: `"Session logged to obsidian/session-logs/YYYY-MM-DD.md"`

## Direct Invocation

| Invocation | Action |
|-----------|--------|
| `"log decision: <text>"` | Append new row to `decisions.md` with today's date |
| `"add question: <text>"` | Append under `## Open Questions` in `overview.md` |
| `"summarise session"` | Run Session End workflow |
| `"load context"` | Run Session Start workflow |

**If the invocation is ambiguous or not in the table above**, ask one clarifying question before proceeding.

## Edge Cases

| Situation | Action |
|-----------|--------|
| `./obsidian/` absent | Halt. Report: "Vault not found — run bootstrap first." |
| Session log already exists for today | Append a separator `---` and new content (do not overwrite) |
| `decisions.md` missing | Create it with the standard header from `references/vault-conventions.md` |
| `overview.md` empty on start | Continue — report "overview.md is empty" in the vault-loaded confirmation |

## Common Mistakes

| Mistake | Correct approach |
|---------|----------------|
| Searching `/home/` or global config for vault path | Always use `./obsidian/` |
| Writing session log to `overview.md` | Session logs go to `session-logs/YYYY-MM-DD.md` |
| Overwriting decisions table | Append rows, never rewrite the whole file |
| Using absolute paths | All paths relative to project root |
| Creating vault from scratch | Vault must come from bootstrap — halt if absent |
