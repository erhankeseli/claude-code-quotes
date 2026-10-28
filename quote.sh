#!/bin/sh
# Claude Code Stop hook: shows one random quote after each response.
# No dependencies: only sh + awk (both are part of macOS).

QUOTES="$HOME/.claude/quotes.txt"
[ -r "$QUOTES" ] || exit 0

awk -v seed="$(( $$ + $(date +%s) ))" '
  NF { q[++n] = $0 }
  END {
    if (!n) exit
    srand(seed)
    s = q[int(rand() * n) + 1]
    gsub(/\\/, "\\\\", s)   # escape backslash first
    gsub(/"/, "\\\"", s)    # then double quote
    printf "{\"systemMessage\": \"💡 %s\"}\n", s
  }
' "$QUOTES"

exit 0
