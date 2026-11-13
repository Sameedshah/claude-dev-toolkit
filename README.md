# Claude Dev Toolkit

The Claude Code skills, plugins, subagents and rules I use for production-grade software development.

| Folder | What's in it |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | My global engineering workflow: requirements → implement → verify → security review → safe deploy |
| [`skills/`](skills) | 27 local skills (full source) |
| [`agents/`](agents) | 9 custom subagents |
| [`rules/`](rules) | Global rules (mobile testing with ARTEMIS) |
| [`statusline-command.sh`](statusline-command.sh) | Status line showing model, context % and rate limits |

---

## The workflow (`CLAUDE.md`)

Every change goes through five steps, scaled to its size:

1. **Requirements & acceptance criteria**: expected behavior, edge cases, security constraints
2. **Implement**: focused, reviewable changes that follow existing conventions
3. **Verify**: unit, integration, negative and regression tests that are actually run
4. **Security & failure review**: authz, input validation, secrets, timeouts/retries, transactions
5. **Diff review & safe deploy**: CI green, staging first, rollback path known, no prod push without confirmation

---

## Skills

### Architecture & code quality
| Skill | Use it for |
|---|---|
| [clean-architecture](skills/clean-architecture) | Dependency Rule, layers, use cases and entities |
| [clean-code](skills/clean-code) | Naming, small functions, error handling, code review |
| [pragmatic-programmer](skills/pragmatic-programmer) | DRY, orthogonality, tracer bullets, design by contract |
| [refactoring-patterns](skills/refactoring-patterns) | Named refactorings and code smells |
| [software-design-philosophy](skills/software-design-philosophy) | Deep modules, information hiding, managing complexity |
| [domain-driven-design](skills/domain-driven-design) | Bounded contexts, aggregates, ubiquitous language |

### Systems, reliability & performance
| Skill | Use it for |
|---|---|
| [system-design](skills/system-design) | Load balancing, caching, DB scaling, queues |
| [ddia-systems](skills/ddia-systems) | Storage engines, replication, partitioning, consistency |
| [release-it](skills/release-it) | Circuit breakers, bulkheads, timeouts, retries |
| [high-perf-browser](skills/high-perf-browser) | Core Web Vitals, network protocols, rendering |

### Frontend, UI & UX
| Skill | Use it for |
|---|---|
| [frontend-design](skills/frontend-design) | React/Next.js component architecture and state |
| [hooked-ui](skills/hooked-ui) | Domain-aware, non-generic UI with an anti-slop pre-flight check |
| [ux-heuristics](skills/ux-heuristics) | Heuristic usability audits |
| [design-everyday-things](skills/design-everyday-things) | Affordances, signifiers, feedback, conceptual models |
| [ios-hig-design](skills/ios-hig-design) | Apple Human Interface Guidelines (SwiftUI/UIKit) |
| [framer-code-components](skills/framer-code-components) | Framer code components and property controls |

### Backend & database
| Skill | Use it for |
|---|---|
| [supabase](skills/supabase) | Any Supabase task: DB, Auth, Edge Functions, Storage, Realtime |
| [supabase-patterns](skills/supabase-patterns) | Auth, queries, RLS policies, realtime subscriptions |
| [supabase-postgres-best-practices](skills/supabase-postgres-best-practices) | Schema, migrations, RLS, indexes, query tuning |

### Testing & QA
| Skill | Use it for |
|---|---|
| [playwright-audit](skills/playwright-audit) | Post-implementation desktop + mobile screenshots and console-error check |
| [browsing-with-playwright](skills/browsing-with-playwright) | Browser automation through Playwright MCP |

### Deployment
| Skill | Use it for |
|---|---|
| [vps-deploy](skills/vps-deploy) | Node/Next.js to a VPS: pre-deploy checklist, rsync, PM2, Nginx, rollback |

### Tooling & knowledge
| Skill | Use it for |
|---|---|
| [fetch-library-docs](skills/fetch-library-docs) | Pull current library docs before writing library code |
| [find-skills](skills/find-skills) | Discover and install more skills |
| [skill-creator-pro](skills/skill-creator-pro) | Build production-grade skills |
| [skill-validator](skills/skill-validator) | Score skills against a 9-category rubric |
| [obsidian-memory](skills/obsidian-memory) | Read/write a project Obsidian vault for session context |

### Referenced, not included
These are Anthropic's built-in skills under a proprietary license, so they're not redistributed here: `docx`, `pdf`, `pptx`, `xlsx`, `skill-creator`, `doc-coauthoring`.

---

## Subagents (`agents/`)

| Agent | Role |
|---|---|
| [project-bootstrap](agents/project-bootstrap.md) | Turns a project brief into CLAUDE.md, a constitution and a vault |
| [spec-curator](agents/spec-curator.md) | Writes specs with prior spec history and the constitution as context |
| [db-architect](agents/db-architect.md) | Supabase schema, migrations, RLS and TypeScript types |
| [ui-auditor](agents/ui-auditor.md) | Audits UI against hooked-ui rules and design tokens |
| [qa-playwright](agents/qa-playwright.md) | Post-implementation UI testing at 1440px and 375px |
| [error-hunter](agents/error-hunter.md) | Log analysis and root-cause investigation |
| [deploy-agent](agents/deploy-agent.md) | VPS deploy with pre-checks, build, sync, restart, verify |
| [phr-adr-curator](agents/phr-adr-curator.md) | Prompt History Records and Architecture Decision Records |
| [obsidian-scribe](agents/obsidian-scribe.md) | Session-start context load and session-end log in the vault |

---

## Plugins

Install from inside Claude Code with `/plugin marketplace add <repo>` and then `/plugin install <name>@<marketplace>`.

### Marketplaces
| Marketplace | Source |
|---|---|
| `claude-plugins-official` | `anthropics/claude-plugins-official` (built in) |
| `composio` | `https://github.com/ComposioHQ/composio-plugin-cc.git` |
| `elementalsouls` | `elementalsouls/Claude-BugHunter` |
| `remotion` | `remotion-dev/claude-code-plugin` |
| `mempalace` | `MemPalace/mempalace` |
| `secskills-marketplace` | `trilwu/secskills` |

### Dev & platform
| Plugin | Version | What it gives me |
|---|---|---|
| `github@claude-plugins-official` | f75f5b2 | GitHub MCP: issues, PRs, reviews, code search |
| `vercel@claude-plugins-official` | 0.50.0 | Vercel deploys, env, logs, Next.js / AI SDK skills |
| `supabase@claude-plugins-official` | 0.1.12 | Supabase MCP (project-scoped) |
| `cloudflare@claude-plugins-official` | 1.0.0 | Workers, Durable Objects, Wrangler, Agents SDK |
| `hostinger@claude-plugins-official` | 1.2.0 | Hostinger hosting deploys |
| `sanity@anthropic-plugin-directory` | 1.0.0 | Sanity CMS schemas, GROQ, content |
| `swift-lsp@claude-plugins-official` | 1.0.0 | Swift language server for iOS work |
| `composio@composio` | 0.2.3 | 1,000+ app integrations through one CLI |
| `remotion@remotion` | 4.0.508 | Programmatic video with Remotion |
| `mempalace@mempalace` | 3.7.1 | Long-term searchable project memory |

### Security
| Plugin | Version | What it gives me |
|---|---|---|
| `claude-security@anthropic-plugin-directory` | 0.11.0 | Multi-agent repo security scan plus verified patches |
| `secskills-core@secskills-marketplace` | 4.11.0 | Code audit, supply chain, crypto review, AI-system security |
| `secskills-defense@secskills-marketplace` | 4.3.0 | Incident response, detections, cloud hardening |
| `secskills-offense@secskills-marketplace` | 4.6.0 | Authorized web/API/cloud/mobile testing |
| `claude-bughunter@elementalsouls` | 2.1.0 | Authorized bug-bounty recon, hunting and reporting |

### Built-in commands I lean on
`/code-review` · `/security-review` · `/simplify` · `/init`

---

## Setup

```bash
git clone https://github.com/Sameedshah/claude-dev-toolkit.git
cp -r claude-dev-toolkit/skills/* ~/.claude/skills/
cp claude-dev-toolkit/agents/*.md ~/.claude/agents/
mkdir -p ~/.claude/rules && cp claude-dev-toolkit/rules/*.md ~/.claude/rules/
cp claude-dev-toolkit/CLAUDE.md ~/.claude/CLAUDE.md   # overwrites your global CLAUDE.md
```

Then add the marketplaces and plugins listed above. Keep secrets such as `GITHUB_PERSONAL_ACCESS_TOKEN` in env vars or your OS keychain, not in a committed `settings.json`.

Third-party skills keep their own licenses (most are MIT; see each `SKILL.md`).
