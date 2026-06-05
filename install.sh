#!/usr/bin/env bash
# ============================================
# Claude Code Agent Kit (KIT) — Installer
# Klugman IT | klugmans.com
# ============================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${HOME}/.claude"

echo "============================================"
echo "  Claude Code Agent Kit (KIT) — Installer"
echo "  Klugman IT | klugmans.com"
echo "============================================"
echo ""

# Create target if it doesn't exist
mkdir -p "$TARGET"

# --- Agents ---
echo "[1/5] Installing 276 agents..."
mkdir -p "$TARGET/agents"
cp -r "$SCRIPT_DIR/agents/"*.md "$TARGET/agents/"
echo "      Done."

# --- Skills ---
if [ -d "$SCRIPT_DIR/skills" ]; then
    echo "[2/5] Installing skills..."
    cp -r "$SCRIPT_DIR/skills/" "$TARGET/skills/"
    echo "      Done."
else
    echo "[2/5] No skills directory found, skipping."
fi

# --- Bin scripts ---
if [ -d "$SCRIPT_DIR/bin" ]; then
    echo "[3/5] Installing bin scripts..."
    mkdir -p "$TARGET/bin"
    cp -r "$SCRIPT_DIR/bin/"* "$TARGET/bin/"
    chmod +x "$TARGET/bin/"*.sh 2>/dev/null || true
    echo "      Done."
else
    echo "[3/5] No bin directory found, skipping."
fi

# --- CLAUDE.md (agent routing) ---
if [ -f "$TARGET/CLAUDE.md" ]; then
    echo "[4/5] CLAUDE.md already exists — skipping (won't overwrite your config)."
    echo "      To use KIT's routing, manually merge or replace:"
    echo "      cp $SCRIPT_DIR/CLAUDE.md $TARGET/CLAUDE.md"
else
    echo "[4/5] Installing CLAUDE.md (agent routing index)..."
    cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
    echo "      Done."
fi

# --- settings.json (hooks, MCPs) ---
if [ -f "$TARGET/settings.json" ]; then
    echo "[5/5] settings.json already exists — skipping (won't overwrite your config)."
    echo "      Review $SCRIPT_DIR/settings.json for hooks and MCP config to merge manually."
else
    echo "[5/5] Installing settings.json (hooks, MCPs, permissions)..."
    cp "$SCRIPT_DIR/settings.json" "$TARGET/settings.json"
    echo "      Done."
fi

echo ""
echo "============================================"
echo "  KIT installed to $TARGET"
echo "  276 agents ready. Start Claude Code and go."
echo "============================================"
