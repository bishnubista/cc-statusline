#!/usr/bin/env bash

# Claude Code Custom Statusline
# Shows: Model | Git Branch | Token Usage % | Weekly Limit

# Read JSON input from Claude Code
input=$(cat)

# Extract model name
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# Get git branch (if in a git repo)
if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-branch")
    git_info="🌿 $branch"
else
    git_info="📁 no-git"
fi

# Extract token usage from transcript
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')
context_limit=200000  # Claude Code context limit

if [ -f "$transcript_path" ]; then
    # Parse the most recent token usage from transcript
    tokens=$(tac "$transcript_path" | grep -m 1 '"usage"' | jq '.message.usage.input_tokens // 0' 2>/dev/null || echo "0")
else
    tokens=0
fi

# Calculate percentage
percentage=$((tokens * 100 / context_limit))
token_display="🧠 ${percentage}% ($tokens/$context_limit)"

# Weekly tracking
weekly_data_file="$HOME/.claude/weekly_usage.json"
mkdir -p "$HOME/.claude"

# Initialize weekly data file if it doesn't exist
if [ ! -f "$weekly_data_file" ]; then
    echo '{"week_start":"","total_tokens":0,"daily_tokens":{}}' > "$weekly_data_file"
fi

# Get current date info
current_date=$(date +%Y-%m-%d)
# Get Monday of current week (works on macOS)
day_of_week=$(date +%u)
week_start=$(date -v-"${day_of_week}"d -v+1d +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)

# Read weekly data
week_data=$(cat "$weekly_data_file")
stored_week_start=$(echo "$week_data" | jq -r '.week_start // ""')
total_tokens=$(echo "$week_data" | jq -r '.total_tokens // 0')

# Reset if new week
if [ "$stored_week_start" != "$week_start" ]; then
    week_data='{"week_start":"'$week_start'","total_tokens":0,"daily_tokens":{}}'
    total_tokens=0
fi

# Track highest token count for today (avoids duplicate counting)
daily_tokens=$(echo "$week_data" | jq -r ".daily_tokens[\"$current_date\"] // 0")

# Only update if current session has more tokens than stored for today
if [ "$tokens" -gt "$daily_tokens" ]; then
    # Calculate the difference to add to weekly total
    token_diff=$((tokens - daily_tokens))
    new_total=$((total_tokens + token_diff))

    # Update weekly data
    week_data=$(echo "$week_data" | jq \
        --arg date "$current_date" \
        --argjson daily "$tokens" \
        --argjson total "$new_total" \
        --arg week "$week_start" \
        '.week_start = $week | .total_tokens = $total | .daily_tokens[$date] = $daily')

    echo "$week_data" > "$weekly_data_file"
    total_tokens=$new_total
fi

# Calculate weekly percentage (assuming 5M tokens per week limit - adjust as needed)
weekly_limit=5000000  # Adjust this based on your plan
weekly_percentage=$((total_tokens * 100 / weekly_limit))

# Color code based on weekly usage
if [ "$weekly_percentage" -lt 50 ]; then
    weekly_color="✅"  # Green zone
elif [ "$weekly_percentage" -lt 80 ]; then
    weekly_color="⚠️"  # Warning zone
else
    weekly_color="🔴"  # Critical zone
fi

weekly_display="📊 Weekly: ${weekly_color} ${weekly_percentage}% (${total_tokens}/${weekly_limit})"

# Output the statusline
echo "🤖 $model | $git_info | $token_display | $weekly_display"
