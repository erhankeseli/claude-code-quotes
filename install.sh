#!/bin/sh
# Installs the claude-code-quotes Stop hook for Claude Code.
# No dependencies: only POSIX sh, cp, chmod and mkdir.
# The script does not change ~/.claude/settings.json.

set -eu

SRC_DIR=$(cd "$(dirname "$0")" && pwd)
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"

for f in quote.sh quotes.txt; do
  if [ ! -f "$SRC_DIR/$f" ]; then
    echo "Error: $SRC_DIR/$f does not exist." >&2
    exit 1
  fi
done

mkdir -p "$HOOKS_DIR"

if [ -e "$HOOKS_DIR/quote.sh" ]; then
  echo "Replaced $HOOKS_DIR/quote.sh."
else
  echo "Copied quote.sh to $HOOKS_DIR/quote.sh."
fi
cp "$SRC_DIR/quote.sh" "$HOOKS_DIR/quote.sh"
chmod +x "$HOOKS_DIR/quote.sh"

# Keep the quotes file of the user. Never overwrite it.
if [ -e "$CLAUDE_DIR/quotes.txt" ] || [ -L "$CLAUDE_DIR/quotes.txt" ]; then
  echo "$CLAUDE_DIR/quotes.txt exists. The script did not overwrite it."
else
  cp "$SRC_DIR/quotes.txt" "$CLAUDE_DIR/quotes.txt"
  echo "Copied quotes.txt to $CLAUDE_DIR/quotes.txt."
fi

cat <<'EOF'

Next steps:

1. Open ~/.claude/settings.json and add this block:

  "hooks": {
    "Stop": [
      { "hooks": [ { "type": "command", "command": "sh \"$HOME/.claude/hooks/quote.sh\"", "timeout": 5 } ] }
    ]
  }

   If the file already has a "hooks" key, do not add a second "hooks" key.
   Merge the "Stop" entry into the existing "hooks" object.

2. Start a new Claude Code session.
EOF
