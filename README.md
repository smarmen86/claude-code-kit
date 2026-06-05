# Claude Code Agent Kit (KIT)

**276 specialist agents + 115 skills + hooks + logging** for Claude Code.

Drop-in multi-agent system that turns Claude Code into a full virtual engineering org. Every domain covered — engineering, design, marketing, sales, finance, healthcare, legal, game dev, SEO, and more.

Built and maintained by [Klugman IT](https://klugmans.com) | 347-722-1555

---

## What's Inside

| Component | Count | Description |
|-----------|-------|-------------|
| `agents/` | 276 | Specialist agent definitions (`.md` files) |
| `skills/` | 115 | Slash-command skills (gstack) |
| `bin/` | 4 | Utility scripts (logging, chat export, project guard) |
| `CLAUDE.md` | 1 | Agent routing index + instructions |
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
# All agents
cp -r agents/ ~/.claude/agents/

# All skills
cp -r skills/ ~/.claude/skills/

# Utility scripts
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

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI or Desktop app
- Anthropic API key configured
- Node.js (for MCP servers)

## License

MIT License — see [LICENSE](LICENSE)

---

**Klugman IT** — AI-powered business tools
