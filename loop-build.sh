#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide the number of times to run step-build.sh"
    echo "Usage: $0 <number>"
    exit 1
fi

# Check if argument is a positive integer
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be a positive integer"
    echo "Usage: $0 <number>"
    exit 1
fi

count=$1

# Check if step-build.sh exists
if [ ! -f "step-build.sh" ]; then
    echo "Error: step-build.sh not found in current directory"
    exit 1
fi

# Loop and call step-build.sh
echo "Running step-build.sh $count times..."
for ((i=1; i<=count; i++)); do
    echo ""
    echo "=== Iteration $i of $count ==="
    ./step-build.sh
    if [ $? -ne 0 ]; then
        echo "Error: step-build.sh failed on iteration $i"
        exit 1
    fi
done

echo ""
echo "=== Completed all $count iterations successfully ==="
