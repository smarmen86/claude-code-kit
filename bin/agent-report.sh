#!/usr/bin/env bash
# agent-report.sh -- Quick summary of agent/tool activity from logs.
#
# Usage:
#   agent-report.sh              # Today's summary
#   agent-report.sh --full       # All-time summary
#   agent-report.sh --agents     # Agent-only breakdown
#   agent-report.sh --tail N     # Last N log entries
#   agent-report.sh --session ID # Filter by session

set -euo pipefail

export PATH="${HOME}/bin:${PATH}"

LOG_DIR="${HOME}/.claude/logs"
MODE="${1:---today}"

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required. Install it: winget install jqlang.jq" >&2
  exit 1
fi

C_GREEN=$'\033[0;32m'
C_YELLOW=$'\033[1;33m'
C_CYAN=$'\033[0;36m'
C_BOLD=$'\033[1m'
C_DIM=$'\033[2m'
C_RESET=$'\033[0m'

header() { printf "\n${C_BOLD}%s${C_RESET}\n" "$*"; }
row()    { printf "  ${C_CYAN}%-30s${C_RESET} %s\n" "$1" "$2"; }

case "$MODE" in
  --today)
    TODAY="$(date -u +%Y-%m-%d)"
    header "Activity Report: $TODAY"

    if [[ ! -f "$LOG_DIR/all.jsonl" ]]; then
      echo "  No logs yet."; exit 0
    fi

    TOTAL=$(grep -c "\"$TODAY" "$LOG_DIR/all.jsonl" 2>/dev/null || echo 0)
    AGENT_COUNT=$(grep -c "\"$TODAY" "$LOG_DIR/agents.jsonl" 2>/dev/null || echo 0)
    TOOL_COUNT=$(grep -c "\"$TODAY" "$LOG_DIR/tools.jsonl" 2>/dev/null || echo 0)
    SESSION_COUNT=$(grep -c "\"$TODAY" "$LOG_DIR/session.jsonl" 2>/dev/null || echo 0)

    row "Total events" "$TOTAL"
    row "Agent invocations" "$AGENT_COUNT"
    row "Tool calls" "$TOOL_COUNT"
    row "Session events" "$SESSION_COUNT"

    if [[ -f "$LOG_DIR/agents.jsonl" ]]; then
      header "Agents Used Today"
      grep "$TODAY" "$LOG_DIR/agents.jsonl" 2>/dev/null \
        | jq -r '.payload.tool_input.prompt // .payload.tool_input.description // "unknown"' 2>/dev/null \
        | sort | uniq -c | sort -rn | head -20 \
        | while read -r count name; do
            row "$name" "$count calls"
          done
    fi

    if [[ -f "$LOG_DIR/tools.jsonl" ]]; then
      header "Tools Used Today"
      grep "$TODAY" "$LOG_DIR/tools.jsonl" 2>/dev/null \
        | jq -r '.tool' 2>/dev/null \
        | sort | uniq -c | sort -rn | head -20 \
        | while read -r count name; do
            row "$name" "$count calls"
          done
    fi
    ;;

  --full)
    header "All-Time Activity Summary"
    if [[ ! -f "$LOG_DIR/all.jsonl" ]]; then
      echo "  No logs yet."; exit 0
    fi

    TOTAL=$(wc -l < "$LOG_DIR/all.jsonl")
    row "Total events" "$TOTAL"

    header "Events by Type"
    jq -r '.event' "$LOG_DIR/all.jsonl" 2>/dev/null \
      | sort | uniq -c | sort -rn \
      | while read -r count name; do
          row "$name" "$count"
        done

    header "Tools by Frequency"
    jq -r '.tool' "$LOG_DIR/all.jsonl" 2>/dev/null \
      | sort | uniq -c | sort -rn | head -20 \
      | while read -r count name; do
          row "$name" "$count"
        done

    header "Failures"
    FAILS=$(jq -r 'select(.event == "PostToolUseFailure") | .tool' "$LOG_DIR/all.jsonl" 2>/dev/null | wc -l)
    row "Total failures" "$FAILS"
    if (( FAILS > 0 )); then
      jq -r 'select(.event == "PostToolUseFailure") | .tool' "$LOG_DIR/all.jsonl" 2>/dev/null \
        | sort | uniq -c | sort -rn \
        | while read -r count name; do
            row "  $name" "$count failures"
          done
    fi
    ;;

  --agents)
    header "Agent Invocation Log"
    if [[ ! -f "$LOG_DIR/agents.jsonl" ]]; then
      echo "  No agent logs yet."; exit 0
    fi

    jq -r '[.timestamp, .event, (.payload.tool_input.description // .payload.tool_input.prompt // "?" | .[0:60])] | @tsv' \
      "$LOG_DIR/agents.jsonl" 2>/dev/null \
      | while IFS=$'\t' read -r ts event desc; do
          printf "  ${C_DIM}%s${C_RESET}  %-20s  %s\n" "$ts" "$event" "$desc"
        done
    ;;

  --tail)
    N="${2:-20}"
    header "Last $N Events"
    tail -n "$N" "$LOG_DIR/all.jsonl" 2>/dev/null \
      | jq -r '[.timestamp, .event, .tool] | @tsv' 2>/dev/null \
      | while IFS=$'\t' read -r ts event tool; do
          printf "  ${C_DIM}%s${C_RESET}  %-22s  %s\n" "$ts" "$event" "$tool"
        done
    ;;

  --session)
    SID="${2:?'Usage: agent-report.sh --session <session_id>'}"
    header "Session: $SID"
    jq -r "select(.session_id == \"$SID\") | [.timestamp, .event, .tool] | @tsv" \
      "$LOG_DIR/all.jsonl" 2>/dev/null \
      | while IFS=$'\t' read -r ts event tool; do
          printf "  ${C_DIM}%s${C_RESET}  %-22s  %s\n" "$ts" "$event" "$tool"
        done
    ;;

  *)
    echo "Usage: agent-report.sh [--today|--full|--agents|--tail N|--session ID]"
    ;;
esac

printf "\n"
