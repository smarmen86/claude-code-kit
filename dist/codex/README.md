# KIT for Codex CLI

A faithful port of the Klugman IT Claude Code KIT to [OpenAI Codex CLI](https://developers.openai.com/codex).

| Claude Code | Codex CLI |
|---|---|
| `agents/*.md` subagents | `agents/*.toml` native subagents |
| `CLAUDE.md` | `AGENTS.md` |
| `settings.json` (JSON) | `config.toml` (TOML) |
| `mcpServers` (camelCase) | `[mcp_servers.*]` (snake_case) |
| skills (`SKILL.md`) | skills (same spec, copied 1:1) |

**Contents:** 276 subagents · 114 skills · router `AGENTS.md` · `config.toml`

## Install

```bash
# macOS / Linux / Git Bash
bash dist/codex/install.sh
```
```powershell
# Windows
powershell -ExecutionPolicy Bypass -File dist\codex\install.ps1
```

Installs to `~/.codex/` (or `$CODEX_HOME`). If you already have an `AGENTS.md`, the installer
writes `AGENTS.override.md` (which wins) instead of clobbering yours.

## Use

Start `codex`, then ask it to delegate, e.g.:

> Spawn `engineering_backend_architect` to design the payments API, then have `engineering_code_reviewer` review it.

Subagent names are the agent slugs with underscores. Each lives in `~/.codex/agents/<name>.toml`.

## Regenerating

These files are generated. Edit `agents/<slug>.md` (or `CLAUDE.md`) at the repo root and run:

```bash
node tools/build.mjs codex
```

_Opus-tier agents map to `model_reasoning_effort = "high"`, Sonnet-tier to `"medium"`._
