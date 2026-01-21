# Compact version - only shows assistant messages and tool names
# Usage: cat output.json | jq -f parse-claude-compact.jq -r

select(.type != "system") |

if .type == "assistant" and (.message.content // null) then
  .message.content[] |

  if .type == "text" then
    "[\u001b[1;36mASSISTANT\u001b[0m] \(.text)"
  elif .type == "tool_use" then
    if .name == "Bash" then
      "[\u001b[1;33m→\u001b[0m] \(.name): \(.input.description // .input.command[0:60])"
    elif .name == "Task" then
      "[\u001b[1;35m⚡\u001b[0m] Subagent: \(.input.subagent_type) - \(.input.description)"
    elif .name == "Write" then
      "[\u001b[1;33m→\u001b[0m] \(.name): \(.input.file_path | split("/")[-1])"
    elif .name == "Edit" then
      "[\u001b[1;33m→\u001b[0m] \(.name): \(.input.file_path | split("/")[-1])"
    elif .name == "Read" then
      "[\u001b[1;33m→\u001b[0m] \(.name): \(.input.file_path | split("/")[-1])"
    else
      "[\u001b[1;33m→\u001b[0m] \(.name)"
    end
  else
    empty
  end
else
  empty
end
