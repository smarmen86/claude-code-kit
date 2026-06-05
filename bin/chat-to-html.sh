#!/usr/bin/env bash
# chat-to-html.sh -- Convert Claude Code transcript JSONL to styled HTML.
# Uses jq for JSON extraction, writes HTML directly.
#
# Usage:
#   chat-to-html.sh <transcript.jsonl> [output.html]
#   echo '{"transcript_path":"..."}' | chat-to-html.sh --hook

set -uo pipefail
export PATH="${HOME}/bin:${PATH}"

HTML_DIR="${HOME}/.claude/logs/chats"
mkdir -p "$HTML_DIR"

command -v jq >/dev/null 2>&1 || { echo "jq required" >&2; exit 1; }

# Resolve input
if [[ "${1:-}" == "--hook" ]]; then
  PAYLOAD="$(cat)"
  TRANSCRIPT="$(echo "$PAYLOAD" | jq -r '.transcript_path // empty')"
  SESSION_ID="$(echo "$PAYLOAD" | jq -r '.session_id // "unknown"')"
  [[ -z "$TRANSCRIPT" || ! -f "$TRANSCRIPT" ]] && exit 0
  OUTPUT="$HTML_DIR/${SESSION_ID}.html"
else
  TRANSCRIPT="${1:?'Usage: chat-to-html.sh <transcript.jsonl> [output.html]'}"
  SESSION_ID="$(basename "$TRANSCRIPT" .jsonl)"
  OUTPUT="${2:-$HTML_DIR/${SESSION_ID}.html}"
fi

[[ -f "$TRANSCRIPT" ]] || { echo "Not found: $TRANSCRIPT" >&2; exit 1; }

# Use jq to produce a simple intermediate format: one JSON object per renderable block.
# This avoids complex jq string building -- bash handles the HTML templating.
BLOCKS_JSON="$(jq -c '
  select(.type == "user" or .type == "assistant") |
  {
    role: .type,
    ts: (.timestamp // ""),
    cwd: (.cwd // ""),
    content: (
      if (.message.content | type) == "string" then
        [{btype: "text", text: .message.content}]
      elif (.message.content | type) == "array" then
        [.message.content[] |
          if .type == "text" and ((.text // "") | length > 0) then
            {btype: "text", text: .text}
          elif .type == "thinking" and (((.thinking // .text // "") | length) > 0) then
            {btype: "thinking", text: ((.thinking // .text // "") | .[0:2000])}
          elif .type == "tool_use" then
            {btype: "tool_use", name: (.name // "tool"), input: ((.input // {}) | tostring | .[0:1500])}
          elif .type == "tool_result" then
            {btype: "tool_result", id: (.tool_use_id // "?"), is_error: (.is_error // false),
             text: (if (.content | type) == "string" then .content | .[0:2000]
                    elif (.content | type) == "array" then [.content[] | if .type == "text" then .text else (.type + ": [data]") end] | join("\n") | .[0:2000]
                    else "..." end)}
          else empty end
        ]
      else []
      end
    )
  }
' "$TRANSCRIPT" 2>/dev/null)"

[[ -z "$BLOCKS_JSON" ]] && { echo "No messages found" >&2; exit 1; }

# Metadata
FIRST_TS="$(echo "$BLOCKS_JSON" | head -1 | jq -r '.ts')"
LAST_TS="$(echo "$BLOCKS_JSON" | tail -1 | jq -r '.ts')"
CWD="$(echo "$BLOCKS_JSON" | head -1 | jq -r '.cwd')"
MSG_COUNT="$(echo "$BLOCKS_JSON" | wc -l | tr -d ' ')"

# Tool stats
TOOL_STATS="$(echo "$BLOCKS_JSON" | jq -r '.content[]? | select(.btype == "tool_use") | .name' 2>/dev/null | sort | uniq -c | sort -rn | head -15)"

esc() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'; }

# Write HTML
exec 3>"$OUTPUT"

cat >&3 << HEADER
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Chat ${SESSION_ID}</title>
<style>
:root{--bg:#0d1117;--surface:#161b22;--border:#30363d;--text:#e6edf3;--text-dim:#7d8590;--accent:#58a6ff;--user-bg:#1c2333;--asst-bg:#161b22;--tool-bg:#1a1e2a;--tool-bdr:#2d333b;--ok:#3fb950;--err:#f85149;--warn:#d29922;--code-bg:#0d1117;--think-bg:#1c1c0e}
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,"Segoe UI",Helvetica,Arial,sans-serif;background:var(--bg);color:var(--text);line-height:1.6}
.hdr{background:var(--surface);border-bottom:1px solid var(--border);padding:20px 32px;position:sticky;top:0;z-index:10}
.hdr h1{font-size:18px;font-weight:600;color:var(--accent)}
.hdr .meta{font-size:13px;color:var(--text-dim);margin-top:6px}
.hdr .meta span{margin-right:20px}
.wrap{max-width:960px;margin:0 auto;padding:24px 16px}
.msg{margin-bottom:16px;padding:16px 20px;border-radius:8px;border:1px solid var(--border)}
.msg.u{background:var(--user-bg);border-left:3px solid var(--accent)}
.msg.a{background:var(--asst-bg);border-left:3px solid var(--ok)}
.role{font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;margin-bottom:8px;color:var(--text-dim)}
.msg.u .role{color:var(--accent)}
.msg.a .role{color:var(--ok)}
.ts{float:right;font-size:11px;color:var(--text-dim)}
.txt{white-space:pre-wrap;word-wrap:break-word;font-size:14px}
.tc{background:var(--tool-bg);border:1px solid var(--tool-bdr);border-radius:6px;margin:8px 0;padding:10px 14px;font-size:13px}
.tc summary{cursor:pointer;font-weight:600;color:var(--warn);list-style:none;display:flex;align-items:center;gap:6px}
.tc summary::before{content:"\25B6";font-size:10px;transition:transform .15s}
.tc[open] summary::before{transform:rotate(90deg)}
.tc pre,.tr pre,.th pre{margin-top:8px;padding:10px;background:var(--code-bg);border-radius:4px;overflow-x:auto;font-size:12px;font-family:"Cascadia Code","Fira Code",Consolas,monospace;color:var(--text-dim);max-height:400px;overflow-y:auto;white-space:pre-wrap}
.tr{background:var(--tool-bg);border:1px solid var(--tool-bdr);border-radius:6px;margin:8px 0;padding:10px 14px;font-size:13px}
.tr summary{cursor:pointer;color:var(--ok);font-weight:600}
.tr.e summary{color:var(--err)}
.th{background:var(--think-bg);border:1px solid #3d3d1a;border-radius:6px;margin:8px 0;padding:10px 14px;font-size:13px;color:var(--text-dim);font-style:italic}
.th summary{cursor:pointer;color:#b0a050;font-weight:600}
.st{margin-top:32px;padding:16px 20px;background:var(--surface);border:1px solid var(--border);border-radius:8px;font-size:13px;color:var(--text-dim)}
.st h3{color:var(--text);margin-bottom:8px}
.st pre{margin-top:8px;font-family:"Cascadia Code",monospace;font-size:12px}
code{background:var(--code-bg);padding:2px 6px;border-radius:3px;font-size:13px;font-family:"Cascadia Code",monospace}
</style>
</head>
<body>
<div class="hdr">
  <h1>Claude Code Session</h1>
  <div class="meta">
    <span>Session: <code>${SESSION_ID}</code></span>
    <span>CWD: <code>$(echo "$CWD" | esc)</code></span>
    <span>Started: ${FIRST_TS}</span>
    <span>Messages: ${MSG_COUNT}</span>
  </div>
</div>
<div class="wrap">
HEADER

# Process each message block
echo "$BLOCKS_JSON" | while IFS= read -r msgline; do
  ROLE="$(echo "$msgline" | jq -r '.role')"
  TS="$(echo "$msgline" | jq -r '.ts')"

  if [[ "$ROLE" == "user" ]]; then
    echo "<div class=\"msg u\"><div class=\"role\">User <span class=\"ts\">$TS</span></div>" >&3
  else
    echo "<div class=\"msg a\"><div class=\"role\">Assistant <span class=\"ts\">$TS</span></div>" >&3
  fi

  # Process content blocks
  echo "$msgline" | jq -c '.content[]' 2>/dev/null | while IFS= read -r block; do
    BTYPE="$(echo "$block" | jq -r '.btype')"

    case "$BTYPE" in
      text)
        TEXT="$(echo "$block" | jq -r '.text' | esc)"
        echo "<div class=\"txt\">$TEXT</div>" >&3
        ;;
      thinking)
        TEXT="$(echo "$block" | jq -r '.text' | esc)"
        echo "<details class=\"th\"><summary>Thinking</summary><pre>$TEXT</pre></details>" >&3
        ;;
      tool_use)
        NAME="$(echo "$block" | jq -r '.name')"
        INPUT="$(echo "$block" | jq -r '.input' | esc)"
        echo "<details class=\"tc\"><summary>$NAME</summary><pre>$INPUT</pre></details>" >&3
        ;;
      tool_result)
        TID="$(echo "$block" | jq -r '.id' | head -c 20)"
        IS_ERR="$(echo "$block" | jq -r '.is_error')"
        TEXT="$(echo "$block" | jq -r '.text' | esc)"
        ERR_CLS=""
        [[ "$IS_ERR" == "true" ]] && ERR_CLS=" e"
        echo "<details class=\"tr${ERR_CLS}\"><summary>Result (${TID}...)</summary><pre>$TEXT</pre></details>" >&3
        ;;
    esac
  done

  echo "</div>" >&3
done

# Footer stats
cat >&3 << FOOTER
<div class="st">
  <h3>Session Stats</h3>
  <p><strong>Session:</strong> ${SESSION_ID}</p>
  <p><strong>Time:</strong> ${FIRST_TS} to ${LAST_TS}</p>
  <p><strong>Messages:</strong> ${MSG_COUNT}</p>
  <p><strong>Tool Usage:</strong></p>
  <pre>$(echo "$TOOL_STATS" | esc)</pre>
</div>
</div>
</body>
</html>
FOOTER

exec 3>&-

echo "[OK] HTML saved: $OUTPUT"
