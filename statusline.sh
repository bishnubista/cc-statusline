#!/usr/bin/env bash

# Claude Code Simple Statusline
# Shows: Model | Current Directory | Git Branch | Output Style

# Read JSON input from Claude Code
input=$(cat)

# Extract model name
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# Get current directory (show basename only)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
if [ -n "$current_dir" ]; then
    dir_name=$(basename "$current_dir")
    dir_display="📂 $dir_name"
else
    dir_display="📂 ~"
fi

# Get git branch (if in a git repo)
if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-branch")
    git_info="🌿 $branch"
else
    git_info=""
fi

# Extract output style
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')

# Output the statusline (show git branch only if in git repo)
if [ -n "$git_info" ]; then
    echo "🤖 $model | $dir_display | $git_info | 📝 $output_style"
else
    echo "🤖 $model | $dir_display | 📝 $output_style"
fi
