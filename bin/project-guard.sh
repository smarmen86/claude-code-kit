#!/usr/bin/env bash
# Cross-project keyword guard — warns when QCI terms appear in Nattrly repo and vice versa.
# Runs as a UserPromptSubmit hook; reads JSON from stdin.

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# Nothing to check
[ -z "$PROMPT" ] && exit 0

# Lowercase for matching
LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')
CWD=$(pwd)

# Detect which project we're in
IN_NATTRLY=false
IN_QCI=false
[[ "$CWD" == *garirre* ]] && IN_NATTRLY=true
[[ "$CWD" == *qci-tonner* || "$CWD" == *qcitoner* ]] && IN_QCI=true

# QCI keywords that shouldn't appear in Nattrly
QCI_KEYWORDS="qci|tonner|toner|qcitoner|warehouse|quickbooks"
# Nattrly keywords that shouldn't appear in QCI
NATTRLY_KEYWORDS="nattrly|companion|wallet|elderly|session.*booking|firebase.*auth|cardknox|affiliate"

MATCHED=""

if $IN_NATTRLY; then
  MATCHED=$(echo "$LOWER" | grep -oEi "$QCI_KEYWORDS" | head -1)
  if [ -n "$MATCHED" ]; then
    echo "{\"decision\":\"block\",\"reason\":\"WRONG PROJECT — You mentioned '${MATCHED}' but you're in the Nattrly (garirre) repo. Switch to qci-tonner if this is QCI work.\"}"
    exit 0
  fi
fi

if $IN_QCI; then
  MATCHED=$(echo "$LOWER" | grep -oEi "$NATTRLY_KEYWORDS" | head -1)
  if [ -n "$MATCHED" ]; then
    echo "{\"decision\":\"block\",\"reason\":\"WRONG PROJECT — You mentioned '${MATCHED}' but you're in the QCI Tonner repo. Switch to garirre if this is Nattrly work.\"}"
    exit 0
  fi
fi

exit 0
