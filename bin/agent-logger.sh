#!/usr/bin/env bash
# agent-logger.sh -- Unified logger for all Claude Code hook events.
# Receives hook JSON on stdin, writes structured JSONL to ~/.claude/logs/
#
# Usage: echo '{"tool_name":"Agent",...}' | agent-logger.sh <event_type>
#
# Log files:
#   agents.jsonl    -- Agent spawns, completions, failures
#   tools.jsonl     -- Every tool invocation (Edit, Write, Bash, Grep, etc.)
#   session.jsonl   -- Session start, stop, compact events
#   all.jsonl       -- Unified firehose of every event

set -euo pipefail

# Ensure jq is on PATH (Git Bash on Windows)
export PATH="${HOME}/bin:${PATH}"

EVENT="${1:-unknown}"
LOG_DIR="${HOME}/.claude/logs"
mkdir -p "$LOG_DIR"

# Read stdin (hook payload)
PAYLOAD="$(cat)"

# Timestamp
TS="$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Extract fields safely via jq (fall back to raw if jq missing)
if command -v jq >/dev/null 2>&1; then
  TOOL_NAME="$(echo "$PAYLOAD" | jq -r '.tool_name // "none"')"
  SESSION_ID="$(echo "$PAYLOAD" | jq -r '.session_id // "unknown"')"

  # Build structured log entry
  LOG_ENTRY="$(jq -n \
    --arg ts "$TS" \
    --arg event "$EVENT" \
    --arg tool "$TOOL_NAME" \
    --arg session "$SESSION_ID" \
    --argjson payload "$PAYLOAD" \
    '{
      timestamp: $ts,
      event: $event,
      tool: $tool,
      session_id: $session,
      payload: $payload
    }'
  )"
else
  # No jq -- raw fallback
  TOOL_NAME="unknown"
  SESSION_ID="unknown"
  LOG_ENTRY="{\"timestamp\":\"$TS\",\"event\":\"$EVENT\",\"raw\":$(echo "$PAYLOAD" | head -c 4096)}"
fi

# ---- Write to firehose ----
echo "$LOG_ENTRY" >> "$LOG_DIR/all.jsonl"

# ---- Route to category log ----
case "$EVENT" in
  PreToolUse|PostToolUse|PostToolUseFailure)
    case "$TOOL_NAME" in
      Agent)
        echo "$LOG_ENTRY" >> "$LOG_DIR/agents.jsonl"
        ;;
      *)
        echo "$LOG_ENTRY" >> "$LOG_DIR/tools.jsonl"
        ;;
    esac
    ;;
  SessionStart|Stop|PreCompact|PostCompact)
    echo "$LOG_ENTRY" >> "$LOG_DIR/session.jsonl"
    ;;
  UserPromptSubmit)
    echo "$LOG_ENTRY" >> "$LOG_DIR/prompts.jsonl"
    ;;
  *)
    # Catch-all already in all.jsonl
    ;;
esac

# ---- Daily rotation ----
# If all.jsonl exceeds 50MB, rotate
ALL_LOG="$LOG_DIR/all.jsonl"
if [[ -f "$ALL_LOG" ]]; then
  SIZE=$(stat -f%z "$ALL_LOG" 2>/dev/null || stat -c%s "$ALL_LOG" 2>/dev/null || echo 0)
  if (( SIZE > 52428800 )); then
    ROTATED="$LOG_DIR/all.$(date -u +%Y%m%d-%H%M%S).jsonl"
    mv "$ALL_LOG" "$ROTATED"
    # Compress in background if gzip available
    command -v gzip >/dev/null 2>&1 && gzip "$ROTATED" &
  fi
fi
