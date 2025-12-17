#!/usr/bin/env bash

# Claude Code Status Line
# Format: 🤖 model | 📁 folder | 🌿 branch | 🧠 context | 📝 style

# Read JSON input from Claude Code
input=$(cat)

# Extract data from JSON
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')

# Get folder name (basename of current directory)
if [ -n "$current_dir" ]; then
    folder=$(basename "$current_dir")
else
    folder="~"
fi

# Get git branch (if in a git repo)
branch=""
if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
fi

# Format numbers in k (thousands)
format_k() {
    local num=$1
    if [ "$num" -ge 1000 ]; then
        # Convert to k with one decimal place
        awk "BEGIN {printf \"%.1fk\", $num/1000}"
    else
        echo "$num"
    fi
}

# Calculate context usage in compact format
total_tokens=$((total_input + total_output))
used_formatted=$(format_k "$total_tokens")
size_formatted=$(format_k "$context_size")
context="${used_formatted}/${size_formatted}"

# Build output with emojis
output="🤖 $model_name | 📁 $folder"
[ -n "$branch" ] && output="$output | 🌿 $branch"
output="$output | 🧠 $context | 📝 $output_style"

printf "%s\n" "$output"
