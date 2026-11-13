# Engineering Workflow (applies to every project)

Follow this workflow for every feature, bug fix, or new project. Scale it to the size of the change (see "Scaling" below), but never skip a step silently: if a step doesn't apply, say so in one line.

## 1. Define requirements and acceptance criteria
Before writing code, state:
- **Expected behavior**: what "done" means, as a short checklist of acceptance criteria.
- **Edge cases**: empty/invalid input, limits, concurrency, offline/slow network, permission-denied paths.
- **Security constraints**: who may do this, what data is touched, what must never leak.

If something is ambiguous and the answer changes the design, ask before implementing. For larger work, use Plan mode or the `spec-curator` agent.

## 2. Implement the feature
- Keep changes focused and reviewable: one concern per change, no drive-by refactors.
- Match the existing code's conventions, naming, and structure.

## 3. Verify behavior independently
Run the project's existing test suite, then add tests that prove the acceptance criteria:
- **Unit tests** for the new logic.
- **Integration tests** where the change crosses a boundary (API, DB, external service).
- **Negative tests**: invalid input, unauthorized access, failure of dependencies.
- **Regression tests**: for a bug fix, a test that fails before the fix and passes after.

Actually run the tests and the app, and report real results. If tests fail, say so with the output; never claim something works without having verified it. For UI work, use the `qa-playwright` agent; for mobile, follow `rules/artemis.md`.

## 4. Review security and failure handling
Check the change against:
- **Authorization**: every endpoint/action checks the caller's permissions server-side (and RLS for Supabase/Postgres).
- **Input validation**: validate and sanitize at trust boundaries; parameterized queries only.
- **Secrets**: none in code, logs, client bundles, or commits; use env vars.
- **Timeouts & retries**: external calls have timeouts; retries are bounded and only on idempotent operations.
- **Data consistency**: multi-step writes use transactions; partial failure leaves data in a valid state.

For non-trivial changes, run `/security-review` and `/code-review`.

## 5. Review the diff and deploy safely
- Review the full diff before declaring done; summarize what changed and why.
- Before deploying: CI/build/lint/typecheck pass, env vars are set in the target environment, and migrations are reversible or backed up.
- Deploy to preview/staging first when one exists; verify there before production.
- Know the rollback path before deploying (previous deployment, `git revert`, migration down). Use the `vps-deploy` skill / `deploy-agent` for VPS, `vercel:deploy` for Vercel.
- Never deploy to production, push, or run destructive migrations without explicit confirmation.

## Scaling
- **Trivial change** (typo, copy, config value): steps 2 and 5 only; mention that tests/security review were not needed.
- **Normal feature or bug fix**: all five steps, kept brief.
- **New project, auth, payments, data model, or public API**: all five steps in full, with acceptance criteria written down before code and `/security-review` before deploy.

## Final report
End each task with a short summary: acceptance criteria met (✅/❌), tests added and their results, security notes, and anything skipped or still open.
