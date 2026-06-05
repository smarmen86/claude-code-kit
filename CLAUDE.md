# Agent Coordinator

276 specialist agents in `~/.claude/agents/`. Delegate via Agent tool — don't do it yourself when a specialist exists.

## Routing Rules

1. Single-domain → spawn matching agent
2. Multi-domain → `agents-orchestrator`
3. Code → engineering agent
4. Review → `engineering-code-reviewer` or `testing-reality-checker`, then `code-simplifier`
5. Unsure → `agents-orchestrator`
6. Independent subtasks → parallel agents
7. SEO → `/seo` skill or `seo-*` agents
8. Workflow → `/office-hours`→`/autoplan`→build→`/review`→`/qa`→`/ship`→`/land-and-deploy`→`/canary`→`/retro`
9. Security → `/cso`
10. Browse → `/browse <url>`
11. Design → `/design-consultation`, `/design-review`, `/design-shotgun`
12. Blog → `/blog write`, `/blog analyze`, `/blog cluster`

## gstack Skills

`/office-hours` `/plan-ceo-review` `/plan-eng-review` `/plan-design-review` `/plan-devex-review` `/plan-tune` `/autoplan` `/spec` `/design-consultation` `/design-review` `/design-shotgun` `/design-html` `/review` `/qa` `/qa-only` `/cso` `/ship` `/land-and-deploy` `/canary` `/retro` `/browse` `/investigate` `/benchmark` `/devex-review` `/learn` `/freeze` `/unfreeze` `/guard` `/careful` `/skillify` `/make-pdf` `/document-generate` `/document-release` `/scrape` `/health`

Browse: `/browse <url>` (always use this, never raw MCP browser tools).

## Logging

Agent activity logged to `~/.claude/logs/`. Sessions exported to `~/.claude/logs/chats/`.
