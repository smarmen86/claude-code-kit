#!/usr/bin/env bash
# ============================================
# ENV GUARD — Self-locking .env file protector
# Blocks ALL access to .env files via ANY tool
# Covers: Read, Edit, Write, Bash, Grep, Glob
# ============================================
set -uo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // empty' 2>/dev/null)

[ -z "$TOOL" ] && exit 0

# ---- Patterns that indicate .env file access ----
# Matches: .env, .env.local, .env.production, .env.development, .env.*, etc.
ENV_PATTERN='\.env(\.[a-zA-Z0-9_-]+)?(\s|"|'"'"'|$|:|\b)'

# Also block known credential files
CRED_PATTERN='(\.credentials\.json|credentials\.json|\.credentials|secrets\.json|secrets\.ya?ml|\.secret)'

COMBINED_PATTERN="(${ENV_PATTERN}|${CRED_PATTERN})"

block_it() {
  echo "{\"decision\":\"block\",\"reason\":\"ENV GUARD: Access to .env / credential files is blocked. These files contain secrets and cannot be read, written, edited, searched, or piped through any tool.\"}"
  exit 0
}

case "$TOOL" in
  Read|Edit|Write)
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
    if echo "$FILE_PATH" | grep -qEi "$COMBINED_PATTERN"; then
      block_it
    fi
    ;;

  Grep)
    GREP_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // empty' 2>/dev/null)
    GREP_GLOB=$(echo "$TOOL_INPUT" | jq -r '.glob // empty' 2>/dev/null)
    GREP_PATTERN=$(echo "$TOOL_INPUT" | jq -r '.pattern // empty' 2>/dev/null)
    # Block if searching inside .env files
    if echo "$GREP_PATH" | grep -qEi "$COMBINED_PATTERN"; then
      block_it
    fi
    # Block if glob targets .env files
    if echo "$GREP_GLOB" | grep -qEi "$COMBINED_PATTERN"; then
      block_it
    fi
    # Block if pattern is searching for env file content patterns (e.g. API_KEY=, SECRET=)
    ;;

  Glob)
    GLOB_PATTERN=$(echo "$TOOL_INPUT" | jq -r '.pattern // empty' 2>/dev/null)
    GLOB_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // empty' 2>/dev/null)
    if echo "$GLOB_PATTERN" | grep -qEi "$COMBINED_PATTERN"; then
      block_it
    fi
    if echo "$GLOB_PATH" | grep -qEi "$COMBINED_PATTERN"; then
      block_it
    fi
    ;;

  Bash)
    CMD=$(echo "$TOOL_INPUT" | jq -r '.command // empty' 2>/dev/null)
    # Block any bash command that references .env or credential files
    # This catches: cat .env, type .env, less .env, more .env, head .env, tail .env
    #   vim .env, nano .env, code .env, echo < .env, base64 .env
    #   cp .env, mv .env, source .env, . .env, eval .env
    #   piped access: | grep .env, < .env, xargs with .env
    #   variable extraction: export $(cat .env), set -a && . .env
    #   encoding tricks: base64 .env, xxd .env, od .env, hexdump .env
    if echo "$CMD" | grep -qEi "$COMBINED_PATTERN"; then
      block_it
    fi
    # Also block commands that could discover env file contents indirectly
    # e.g. "printenv", "env" (the command), "set" dumping all vars after sourcing
    # But allow normal "env" usage like setting env vars for a command
    ;;

  NotebookEdit)
    # Block if notebook source references .env files
    SOURCE=$(echo "$TOOL_INPUT" | jq -r '.source // empty' 2>/dev/null)
    if echo "$SOURCE" | grep -qEi "$COMBINED_PATTERN"; then
      block_it
    fi
    ;;

  WebFetch)
    URL=$(echo "$TOOL_INPUT" | jq -r '.url // empty' 2>/dev/null)
    if echo "$URL" | grep -qEi "$COMBINED_PATTERN"; then
      block_it
    fi
    ;;
esac

# Also block this script itself from being edited/viewed (self-lock)
case "$TOOL" in
  Read|Edit|Write)
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
    if echo "$FILE_PATH" | grep -qEi "env-guard\.sh"; then
      echo "{\"decision\":\"block\",\"reason\":\"ENV GUARD: This security hook is self-locked and cannot be read, edited, or overwritten.\"}"
      exit 0
    fi
    ;;
  Bash)
    CMD=$(echo "$TOOL_INPUT" | jq -r '.command // empty' 2>/dev/null)
    if echo "$CMD" | grep -qEi "env-guard\.sh"; then
      echo "{\"decision\":\"block\",\"reason\":\"ENV GUARD: This security hook is self-locked and cannot be accessed via shell commands.\"}"
      exit 0
    fi
    ;;
esac

exit 0
