#!/usr/bin/env bash

# Claude Code Status Line v3.0.0
# Uses new Claude Code JSON fields for accurate token tracking
# Format: 🤖 model | 📁 folder | 🌿 branch | 🧠 context% [bar] | 💰 cost | 📦 cache | 📝 style

# Read JSON input from Claude Code
input=$(cat)

# Extract model info
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# Extract workspace info
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')

# ═══════════════════════════════════════════════════════════════
# TOKEN & CONTEXT METRICS (using new accurate fields)
# ═══════════════════════════════════════════════════════════════

# Use the pre-calculated percentage (most accurate after compaction)
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | awk '{printf "%.0f", $1}')

# Get context window size for display
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')

# Session totals (cumulative for entire session)
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
session_tokens=$((total_input + total_output))

# Cache efficiency metrics
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

# ═══════════════════════════════════════════════════════════════
# COST METRICS
# ═══════════════════════════════════════════════════════════════

total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
# Format cost to 3 decimal places
cost_formatted=$(awk "BEGIN {printf \"%.3f\", $total_cost}")

# ═══════════════════════════════════════════════════════════════
# VISUAL ELEMENTS
# ═══════════════════════════════════════════════════════════════

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

# Format numbers in k (thousands) with one decimal
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

# Create visual progress bar (5 chars wide)
# Uses filled/empty blocks for visual representation
progress_bar() {
    local pct=$1
    local width=5
    local filled=$((pct * width / 100))
    local empty=$((width - filled))

    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    echo "$bar"
}

# Color the percentage based on usage level
# Uses ANSI escape codes for terminal coloring
color_pct() {
    local pct=$1
    local reset="\033[0m"
    local green="\033[32m"
    local yellow="\033[33m"
    local red="\033[31m"

    if [ "$pct" -lt 50 ]; then
        echo -e "${green}${pct}%${reset}"
    elif [ "$pct" -lt 80 ]; then
        echo -e "${yellow}${pct}%${reset}"
    else
        echo -e "${red}${pct}%${reset}"
    fi
}

# ═══════════════════════════════════════════════════════════════
# BUILD OUTPUT
# ═══════════════════════════════════════════════════════════════

# Format context display with accurate percentage and visual bar
session_formatted=$(format_k "$session_tokens")
bar=$(progress_bar "$used_pct")
pct_colored=$(color_pct "$used_pct")

# Context display: shows percentage, bar, and session tokens consumed
context_display="${pct_colored} ${bar} (${session_formatted})"

# Build output string with emojis
output="🤖 $model_name | 📁 $folder"
[ -n "$branch" ] && output="$output | 🌿 $branch"
output="$output | 🧠 $context_display"

# Add cost if > 0
if (( $(echo "$total_cost > 0" | bc -l) )); then
    output="$output | 💰 \$${cost_formatted}"
fi

# Add cache indicator if cache is being used (shows efficiency)
if [ "$cache_read" -gt 0 ]; then
    cache_formatted=$(format_k "$cache_read")
    output="$output | 📦 ${cache_formatted}↓"
fi

# Add output style
output="$output | 📝 $output_style"

printf "%s\n" "$output"
