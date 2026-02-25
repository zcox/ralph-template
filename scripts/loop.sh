#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DETECT_DONE=false
DONE_TOKEN="<promise>DONE</promise>"
DONE_INSTRUCTION="When all tasks are complete and there is no more work to do, output exactly: ${DONE_TOKEN}"

# Parse flags
while [[ "$1" == -* ]]; do
    case "$1" in
        -d|--detect-done)
            DETECT_DONE=true
            shift
            ;;
        *)
            echo "Error: Unknown option: $1"
            echo "Usage: $0 [-d] <number>"
            exit 1
            ;;
    esac
done

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide the number of times to run step.sh"
    echo "Usage: $0 [-d] <number>"
    exit 1
fi

# Check if argument is a positive integer
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be a positive integer"
    echo "Usage: $0 [-d] <number>"
    exit 1
fi

count=$1

# Check if step.sh exists
if [ ! -f "$SCRIPT_DIR/step.sh" ]; then
    echo "Error: step.sh not found in scripts directory"
    exit 1
fi

# Loop and call step.sh
echo "Running step.sh $count times..."
for ((i=1; i<=count; i++)); do
    echo ""
    echo "=== Iteration $i of $count ==="

    if [ "$DETECT_DONE" = true ]; then
        TMPFILE=$(mktemp)
        "$SCRIPT_DIR/step.sh" "$DONE_INSTRUCTION" | tee "$TMPFILE"
        EXIT_CODE=${PIPESTATUS[0]}
        if grep -qF "$DONE_TOKEN" "$TMPFILE"; then
            rm -f "$TMPFILE"
            echo ""
            echo "=== Agent signaled completion. Exiting after $i iteration(s). ==="
            exit 0
        fi
        rm -f "$TMPFILE"
    else
        "$SCRIPT_DIR/step.sh"
        EXIT_CODE=$?
    fi

    if [ $EXIT_CODE -ne 0 ]; then
        echo "Error: step.sh failed on iteration $i"
        exit 1
    fi
done

echo ""
echo "=== Completed all $count iterations successfully ==="
