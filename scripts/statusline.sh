#!/usr/bin/env bash

# Claude Code Status Line
# Format: 🤖 model | 📁 folder | 🌿 branch | 🧠 context | 📝 style

# Read JSON input from Claude Code
input=$(cat)

# Extract data from JSON
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')

# Try to get current context usage (accurate after compaction/sub-agents)
# Falls back to cumulative totals if current_usage is not available
current_usage=$(echo "$input" | jq '.context_window.current_usage // null')
if [ "$current_usage" != "null" ]; then
    # Use current_usage for accurate context window state
    input_tokens=$(echo "$current_usage" | jq -r '.input_tokens // 0')
    output_tokens=$(echo "$current_usage" | jq -r '.output_tokens // 0')
    cache_creation=$(echo "$current_usage" | jq -r '.cache_creation_input_tokens // 0')
    cache_read=$(echo "$current_usage" | jq -r '.cache_read_input_tokens // 0')
    total_tokens=$((input_tokens + output_tokens + cache_creation + cache_read))
else
    # Fallback to cumulative totals (older Claude Code versions)
    total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
    total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
    total_tokens=$((total_input + total_output))
fi

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
used_formatted=$(format_k "$total_tokens")
size_formatted=$(format_k "$context_size")
context="${used_formatted}/${size_formatted}"

# Build output with emojis
output="🤖 $model_name | 📁 $folder"
[ -n "$branch" ] && output="$output | 🌿 $branch"
output="$output | 🧠 $context | 📝 $output_style"

printf "%s\n" "$output"
