#!/usr/bin/env bash
# Codex CLI installer — Klugman IT KIT
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TARGET="${CODEX_HOME:-$HOME/.codex}"

echo "Installing KIT for Codex CLI -> $TARGET"
mkdir -p "$TARGET/agents" "$TARGET/skills"

echo "[1/4] 276 subagents..."
cp -r "$SCRIPT_DIR/agents/"*.toml "$TARGET/agents/"

echo "[2/4] 114 skills (from repo root)..."
cp -r "$REPO_ROOT/skills/"* "$TARGET/skills/" 2>/dev/null || echo "      (no skills/ found at repo root — skipped)"

echo "[3/4] AGENTS.md..."
if [ -f "$TARGET/AGENTS.md" ]; then
  echo "      exists — writing AGENTS.override.md instead (wins over AGENTS.md)."
  cp "$SCRIPT_DIR/AGENTS.md" "$TARGET/AGENTS.override.md"
else
  cp "$SCRIPT_DIR/AGENTS.md" "$TARGET/AGENTS.md"
fi

echo "[4/4] config.toml..."
if [ -f "$TARGET/config.toml" ]; then
  echo "      exists — leaving it. Merge $SCRIPT_DIR/config.toml by hand."
else
  cp "$SCRIPT_DIR/config.toml" "$TARGET/config.toml"
fi

echo "Done. Start 'codex' and ask it to spawn a specialist subagent."
