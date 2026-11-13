# Vault Conventions Reference
<!-- last-updated: 2026-04-02 | version: 1.0 -->

## Expected Vault Structure

```
./obsidian/
  overview.md
  decisions.md
  spec-history.md
  session-logs/
    README.md
    .pending-sync          ← created by Stop hook, deleted on session end
    YYYY-MM-DD.md          ← one per session
  .obsidian/
    app.json
```

## decisions.md Header

When creating `decisions.md` from scratch, use this exact header:

```markdown
# Decisions Log

| Date | Decision | Rationale | ADR |
|------|----------|-----------|-----|
```

Never include a blank data row below the header.

## spec-history.md Entry Format

Each entry appended after a spec generation:

```markdown
## YYYY-MM-DD — <spec-title>

- **Spec file:** `specs/<feature>/spec.md`
- **Summary:** <one sentence>
- **Status:** draft | approved | superseded
```

## overview.md Structure

```markdown
# <Project Name>

## Goals
- <goal>

## Tech Stack
- <stack items>

## Open Questions
- <question>
```

## session-logs/README.md

Standard content (do not modify):

```markdown
# Session Logs

One file per working session. Format: `YYYY-MM-DD.md`.
Created automatically by the obsidian-memory skill at session end.
```
