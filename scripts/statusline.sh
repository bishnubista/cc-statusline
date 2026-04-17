#!/usr/bin/env bash

# Claude Code Status Line v3.2.0
# Format: 🤖 model | 📁 folder | 🌿 branch | 🧠 session tokens | 📝 style

# Read JSON input from Claude Code
input=$(cat)

# Extract model info
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# Extract workspace info
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')

# Session totals (cumulative for entire session)
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
session_tokens=$((total_input + total_output))

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

# Format numbers: k for thousands, M for millions (handles 1M+ context windows)
format_k() {
    local num=$1
    if [ "$num" -ge 1000000 ]; then
        awk "BEGIN {printf \"%.1fM\", $num/1000000}"
    elif [ "$num" -ge 1000 ]; then
        awk "BEGIN {printf \"%.1fk\", $num/1000}"
    else
        echo "$num"
    fi
}

session_formatted=$(format_k "$session_tokens")

output="🤖 $model_name | 📁 $folder"
[ -n "$branch" ] && output="$output | 🌿 $branch"
output="$output | 🧠 $session_formatted | 📝 $output_style"

printf "%s\n" "$output"
