#!/usr/bin/env bash
set -euo pipefail

# ralph-init.sh - Initialize a new project using ralph-template
#
# Usage:
#   ralph-init.sh <project-name> <idea-file>
#   ralph-init.sh <project-name> -        # read idea from stdin
#   ralph-init.sh <project-name> -m "idea text"  # idea as argument
#
# Examples:
#   ralph-init.sh my-app ideas/my-app.md
#   echo "Build a CLI tool for..." | ralph-init.sh my-cli -
#   ralph-init.sh my-api -m "REST API for managing widgets with authentication"

usage() {
    cat <<EOF
Usage: $(basename "$0") <project-name> <idea-source>

Arguments:
  project-name    Name of the project directory to create
  idea-source     One of:
                    <file>     Path to a markdown file containing the idea
                    -          Read idea from stdin
                    -m "text"  Idea text provided directly

Options:
  -h, --help           Show this help message
  -d, --dir DIR        Parent directory for project (default: current directory)
  -c, --claude-md FILE Custom CLAUDE.md file to use
  -t, --template DIR   Path to local ralph-template directory (default: clone from GitHub)

Examples:
  $(basename "$0") my-app ~/ideas/my-app.md
  echo "Build a todo app" | $(basename "$0") my-todo -
  $(basename "$0") my-api -m "REST API for user management"
  $(basename "$0") -d ~/projects my-app ideas.md
EOF
    exit 1
}

# Defaults
PARENT_DIR="$(pwd)"
CUSTOM_CLAUDE_MD=""
TEMPLATE_DIR=""
IDEA_TEXT=""
IDEA_MODE=""

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -d|--dir)
            PARENT_DIR="$2"
            shift 2
            ;;
        -c|--claude-md)
            CUSTOM_CLAUDE_MD="$2"
            shift 2
            ;;
        -t|--template)
            TEMPLATE_DIR="$2"
            shift 2
            ;;
        -m)
            IDEA_MODE="text"
            IDEA_TEXT="$2"
            shift 2
            ;;
        -*)
            if [[ "$1" == "-" ]]; then
                IDEA_MODE="stdin"
                shift
            else
                echo "Unknown option: $1" >&2
                usage
            fi
            ;;
        *)
            if [[ -z "${PROJECT_NAME:-}" ]]; then
                PROJECT_NAME="$1"
            elif [[ -z "${IDEA_SOURCE:-}" ]]; then
                IDEA_SOURCE="$1"
                if [[ "$IDEA_SOURCE" == "-" ]]; then
                    IDEA_MODE="stdin"
                else
                    IDEA_MODE="file"
                fi
            else
                echo "Unexpected argument: $1" >&2
                usage
            fi
            shift
            ;;
    esac
done

# Validate arguments
if [[ -z "${PROJECT_NAME:-}" ]]; then
    echo "Error: project-name is required" >&2
    usage
fi

if [[ -z "${IDEA_MODE:-}" ]]; then
    echo "Error: idea source is required (file, -, or -m)" >&2
    usage
fi

# Resolve paths
PROJECT_DIR="${PARENT_DIR}/${PROJECT_NAME}"

if [[ -d "$PROJECT_DIR" ]]; then
    echo "Error: Directory already exists: $PROJECT_DIR" >&2
    exit 1
fi

# Get idea content
case "$IDEA_MODE" in
    file)
        if [[ ! -f "$IDEA_SOURCE" ]]; then
            echo "Error: Idea file not found: $IDEA_SOURCE" >&2
            exit 1
        fi
        IDEA_CONTENT="$(cat "$IDEA_SOURCE")"
        ;;
    stdin)
        echo "Reading idea from stdin..." >&2
        IDEA_CONTENT="$(cat)"
        ;;
    text)
        IDEA_CONTENT="$IDEA_TEXT"
        ;;
esac

if [[ -z "$IDEA_CONTENT" ]]; then
    echo "Error: Idea content is empty" >&2
    exit 1
fi

echo "Creating project: $PROJECT_DIR"

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Get the ralph-template
if [[ -n "$TEMPLATE_DIR" ]]; then
    if [[ ! -d "$TEMPLATE_DIR" ]]; then
        echo "Error: Template directory not found: $TEMPLATE_DIR" >&2
        exit 1
    fi
    echo "Copying ralph-template from $TEMPLATE_DIR..."
    cp -r "${TEMPLATE_DIR}/." .
    rm -rf .git
else
    echo "Fetching ralph-template..."
    curl -sL https://github.com/zcox/ralph-template/archive/HEAD.tar.gz | tar xz --strip-components=1
fi

# Optional: agent-browser skill
echo "Adding agent-browser skill..."
mkdir -p .claude/skills/agent-browser
curl -so .claude/skills/agent-browser/SKILL.md \
    https://raw.githubusercontent.com/vercel-labs/agent-browser/main/skills/agent-browser/SKILL.md 2>/dev/null || true

# Clean up template files
rm -f ralph_factory.png README.md

# Remove template spec
rm -rf specs/spec-name

# Apply custom CLAUDE.md if provided
if [[ -n "$CUSTOM_CLAUDE_MD" && -f "$CUSTOM_CLAUDE_MD" ]]; then
    echo "Using custom CLAUDE.md..."
    cp "$CUSTOM_CLAUDE_MD" CLAUDE.md
fi

# Create the idea file
echo "Creating idea file..."
mkdir -p ideas
IDEA_FILENAME="$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-').md"
echo "$IDEA_CONTENT" > "ideas/${IDEA_FILENAME}"

# Initialize git
echo "Initializing git repository..."
git init -q
git add .
git commit -q -m "initial project setup from ralph-template"

echo ""
echo "=========================================="
echo "Project created at: $PROJECT_DIR"
echo "Idea file: ideas/${IDEA_FILENAME}"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "  cd $PROJECT_DIR"
echo ""
echo "  # Generate specs from the idea"
echo "  claude \"/specify-idea ideas/${IDEA_FILENAME}\""
echo ""
echo "  # Review and iterate on specs"
echo "  ls specs/"
echo ""
echo "  # Plan tasks for highest priority spec"
echo "  claude \"/plan-next-spec\""
echo ""
echo "  # Let Ralph implement one task"
echo "  ./scripts/step.sh"
echo ""
echo "  # Or let Ralph implement multiple tasks"
echo "  ./scripts/loop.sh 5"
echo ""
