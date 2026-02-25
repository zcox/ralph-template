#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXTRA_INSTRUCTIONS="${1:-}"
PROMPT="/implement-next-task"

if [ -n "$EXTRA_INSTRUCTIONS" ]; then
    PROMPT="$PROMPT

$EXTRA_INSTRUCTIONS"
fi

echo "$PROMPT" | claude -p --output-format stream-json --verbose --dangerously-skip-permissions | "$SCRIPT_DIR/parse-claude" --compact | "$SCRIPT_DIR/show-turn-timing.sh"
