# Parse Claude CLI JSON output to show important information
# Usage: cat output.json | jq -f parse-claude-output.jq -r

# Skip system init messages
select(.type != "system") |

# Process different message types
if .type == "assistant" and (.message.content // null) then
  .message.content[] |

  # Extract text messages
  if .type == "text" then
    "[\u001b[1;36mASSISTANT\u001b[0m] \(.text)"

  # Extract tool uses
  elif .type == "tool_use" then
    if .name == "Bash" then
      "[\u001b[1;33mTOOL\u001b[0m] \(.name): \(.input.description // "no description")\n  Command: \(.input.command)"
    elif .name == "Task" then
      "[\u001b[1;35mSUBAGENT\u001b[0m] \(.input.subagent_type): \(.input.description)\n  Prompt: \(.input.prompt | split("\n")[0] + (if (.input.prompt | split("\n") | length) > 1 then "..." else "" end))"
    elif .name == "Read" then
      "[\u001b[1;33mTOOL\u001b[0m] \(.name): \(.input.file_path | split("/")[-1])"
    elif .name == "Write" then
      "[\u001b[1;33mTOOL\u001b[0m] \(.name): \(.input.file_path | split("/")[-1]) (\(.input.content | length) bytes)"
    elif .name == "Edit" then
      "[\u001b[1;33mTOOL\u001b[0m] \(.name): \(.input.file_path | split("/")[-1])"
    elif .name == "Glob" then
      "[\u001b[1;33mTOOL\u001b[0m] \(.name): \(.input.pattern)"
    elif .name == "Grep" then
      "[\u001b[1;33mTOOL\u001b[0m] \(.name): \(.input.pattern)\(.input.path // "")"
    elif .name == "TodoWrite" then
      "[\u001b[1;33mTOOL\u001b[0m] \(.name): \(.input.todos | length) todos"
    else
      "[\u001b[1;33mTOOL\u001b[0m] \(.name)"
    end
  else
    empty
  end

# Extract tool results (condensed)
elif .type == "user" and (.message.content // null) then
  .message.content[] |
  if .type == "tool_result" then
    # Show truncated content for tool results
    if .content then
      if (.content | type) == "string" then
        if (.content | length) > 200 then
          "[\u001b[1;32mRESULT\u001b[0m] \(.content[0:200])...\n"
        else
          "[\u001b[1;32mRESULT\u001b[0m] \(.content)\n"
        end
      else
        "[\u001b[1;32mRESULT\u001b[0m] \(.content | tostring | .[0:200])...\n"
      end
    else
      empty
    end
  else
    empty
  end
else
  empty
end
