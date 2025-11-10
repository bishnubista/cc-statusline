#!/usr/bin/env bash

# Claude Code Statusline
# Format: Sonnet 4.5 | 📂 cc-statusline | 🌿 main | 📝 Explanatory

# Read JSON input from Claude Code
input=$(cat)

# 1. Get Model Info
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# Extract version for Sonnet (e.g., "Claude 3.5 Sonnet" -> "Sonnet 3.5" or "Claude Sonnet 4.5" -> "Sonnet 4.5")
if [[ "$model_name" == *"Sonnet"* ]]; then
    # Extract version number (handles both "3.5" and "4.5" formats)
    if [[ "$model_name" =~ ([0-9]+\.?[0-9]*) ]]; then
        version="${BASH_REMATCH[1]}"
        model_display="Sonnet $version"
    else
        model_display="Sonnet"
    fi
elif [[ "$model_name" == *"Opus"* ]]; then
    if [[ "$model_name" =~ ([0-9]+\.?[0-9]*) ]]; then
        version="${BASH_REMATCH[1]}"
        model_display="Opus $version"
    else
        model_display="Opus"
    fi
elif [[ "$model_name" == *"Haiku"* ]]; then
    if [[ "$model_name" =~ ([0-9]+\.?[0-9]*) ]]; then
        version="${BASH_REMATCH[1]}"
        model_display="Haiku $version"
    else
        model_display="Haiku"
    fi
else
    model_display="$model_name"
fi

# 2. Get current directory (show basename only)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
if [ -n "$current_dir" ]; then
    dir_name=$(basename "$current_dir")
else
    dir_name="~"
fi

# 3. Get git branch (if in a git repo)
branch=""
if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-branch")
fi

# 4. Get output style (mode)
output_style=$(echo "$input" | jq -r '.output_style.name // "Default"')

# Build status line with pipe separators and emojis
# Format: Sonnet 4.5 | 📂 directory | 🌿 branch | 📝 mode
parts=("$model_display")
parts+=("📂 $dir_name")

if [ -n "$branch" ]; then
    parts+=("🌿 $branch")
fi

parts+=("📝 $output_style")

# Join parts with " | "
printf "%s" "${parts[0]}"
for ((i=1; i<${#parts[@]}; i++)); do
    printf " | %s" "${parts[$i]}"
done
