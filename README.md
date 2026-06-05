# Claude Code Agent Kit (KIT)

**276 specialist agents + 115 skills + hooks + logging** — a curated, pre-configured multi-agent setup for Claude Code.

Packaged and configured by [Klugman IT](https://klugmans.com) | 347-722-1555

---

## Attribution

This kit bundles and configures components from multiple sources:

| Component | Source | Credit |
|-----------|--------|--------|
| `agents/` (276) | Based on [Claude Code](https://claude.com/claude-code) agent type definitions | [Anthropic](https://anthropic.com) |
| `skills/` (115) | [gstack](https://github.com/garrytan) engineering toolkit | [Garry Tan](https://github.com/garrytan) |
| `CLAUDE.md` | Agent routing index and orchestration logic | Klugman IT |
| `bin/` | Logging, chat export, project guard, env security hook | Klugman IT |
| `settings.json` | Hooks, MCPs, permissions configuration | Klugman IT |
| `install.sh` | One-command installer | Klugman IT |
| Security hooks | Self-locking env guard, KITNOCOMMIT lockbox | Klugman IT |

**Klugman IT's contribution:** The packaging, routing logic (`CLAUDE.md`), security hardening (env guard hook, KITNOCOMMIT personal lockbox), logging infrastructure, install system, and the curation of 276 agents into a working multi-agent setup with proper orchestration.

**We did not create the underlying agents or gstack skills.** We assembled, configured, and secured them into a ready-to-use kit.

---

## What's Inside

| Component | Count | Description |
|-----------|-------|-------------|
| `agents/` | 276 | Specialist agent definitions (`.md` files) — from Anthropic |
| `skills/` | 115 | Slash-command skills — from gstack |
| `bin/` | 5 | Utility scripts (logging, chat export, project guard, env security) |
| `CLAUDE.md` | 1 | Agent routing index + orchestration instructions |
| `settings.json` | 1 | Hooks, MCPs, permissions config |

## Agent Categories

- **Engineering** (30) — Frontend, backend, DevOps, security, mobile, AI/ML, embedded, blockchain
- **Testing & QA** (8) — Reality checker, API tester, performance, accessibility, evidence collector
- **Design & UX** (8) — UI, UX architecture, research, brand, visual storytelling
- **Marketing** (30+) — Content, SEO, social media, growth, all major platforms
- **China Marketing** (11) — Douyin, Xiaohongshu, WeChat, Bilibili, Baidu, Weibo, Zhihu
- **Paid Media** (7) — PPC, paid social, programmatic, tracking, creative strategy
- **SEO** (18) — Technical, content, schema, local, maps, e-commerce, drift monitoring
- **Blog** (5) — Writer, researcher, reviewer, SEO checker, translator
- **Sales** (10) — Outbound, discovery, deals, pipeline, proposals, coaching
- **Finance** (5+) — Financial analysis, FP&A, bookkeeping, tax, investments
- **Product** (5) — Product management, sprint planning, feedback, trends, behavioral nudges
- **Project Management** (6) — Senior PM, shepherd, studio producer, Jira, experiments
- **Healthcare** (5) — Health insights, medical research, insurance claims, intake, clinical protocols
- **Legal** (3) — Document review, client intake, billing
- **Game Dev** (16) — Unity, Unreal, Godot, Roblox, game design, audio, narrative, level design
- **XR / Spatial** (5) — WebXR, Vision Pro, Metal, cockpit interfaces
- **Data & Analytics** (6) — Visualization, SQL, extraction, cleaning, reports, scraping
- **Education** (5) — Tutoring, study partner, curriculum, research, essay grading
- **E-commerce** (5) — Product recommendations, pricing, inventory, listings
- **Creative** (6) — Book writing, screenplays, social posts, landing pages, recipes
- **Industry** (7) — Real estate, farming, energy, manufacturing, logistics, cybersecurity
- **Academic** (5) — History, anthropology, geography, psychology, narratology
- **Support & Ops** (6) — Customer support, analytics, executive summaries, compliance
- **Specialized** (12) — Workflow architect, MCP builder, Salesforce, civil engineering, and more

## Security

KIT includes a self-locking security system:

- **Env Guard Hook** — Blocks all agent access to `.env`, credential files, and secrets via any tool (Read, Edit, Write, Bash, Grep, Glob). Cannot be bypassed by piping, encoding, or indirect access.
- **KITNOCOMMIT Folder** — Personal lockbox (`~/.claude/KITNOCOMMIT/`) for API keys, client configs, and login details. Gitignored and agent-locked.
- **Self-Lock** — The guard hook protects itself from modification by any agent.

## Quick Install

```bash
git clone https://github.com/smarmen86/claude-code-kit.git
cd claude-code-kit
bash install.sh
```

The install script copies agents, skills, and bin scripts into your `~/.claude/` directory. It will **not** overwrite your existing `settings.json` or `CLAUDE.md` — it merges or skips.

## Manual Install

Copy what you need:

```bash
# All agents (from Anthropic)
cp -r agents/ ~/.claude/agents/

# All skills (from gstack)
cp -r skills/ ~/.claude/skills/

# Utility scripts (Klugman IT)
cp -r bin/ ~/.claude/bin/

# Agent routing (review before copying — may overwrite your own CLAUDE.md)
cp CLAUDE.md ~/.claude/CLAUDE.md
```

## How It Works

1. User gives Claude Code a task
2. `CLAUDE.md` routes the task to the right specialist agent(s)
3. Claude spawns the agent via the Agent tool
4. For multi-domain tasks, `agents-orchestrator` coordinates multiple agents in parallel
5. Hooks log all activity to `~/.claude/logs/`
6. Env guard blocks access to secrets at every layer

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI or Desktop app
- Anthropic API key configured
- Node.js (for MCP servers)

## License

MIT License applies to **Klugman IT's original contributions** (routing logic, security hooks, install script, bin scripts, packaging).

Agent definitions are from [Anthropic](https://anthropic.com). Skills are from [gstack](https://github.com/garrytan). Refer to their respective licenses for those components.

See [LICENSE](LICENSE) for details.

---

**Klugman IT** — AI-powered business tools | [klugmans.com](https://klugmans.com) | 347-722-1555
