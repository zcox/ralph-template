#!/bin/bash

cat PROMPT_build.md | claude -p --output-format stream-json --verbose --dangerously-skip-permissions | ./parse-claude --compact
