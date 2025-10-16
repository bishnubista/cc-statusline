#!/usr/bin/env bash

# Claude Code Simple Statusline
# Shows: Model | Git Branch | Output Style | Context tokens | Weekly tokens

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

# Extract output style
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')

# Extract token usage from transcript
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')

if [ -f "$transcript_path" ] && [ -s "$transcript_path" ]; then
    # Parse token usage from system reminders in the transcript
    # Look for "Token usage: X/Y" pattern in message content
    token_line=$(grep -o 'Token usage: [0-9]*/[0-9]*' "$transcript_path" 2>/dev/null | tail -1)

    if [ -n "$token_line" ]; then
        # Extract the current token count (first number)
        tokens=$(echo "$token_line" | grep -o '[0-9]*' | head -1)
    else
        tokens=0
    fi
else
    tokens=0
fi

# Weekly tracking (starts Monday, resets each week)
weekly_data_file="$HOME/.claude/weekly_usage.json"
weekly_log_file="$HOME/.claude/weekly_usage_log.jsonl"
mkdir -p "$HOME/.claude"

# Initialize weekly data file if it doesn't exist
if [ ! -f "$weekly_data_file" ]; then
    echo '{"week_start":"","total_tokens":0,"sessions":{},"last_session":""}' > "$weekly_data_file"
fi

# Get current date info
current_date=$(date +%Y-%m-%d)
# Calculate Monday of current week (week starts Monday, resets every Monday at midnight)
week_start=$(date -d "monday" +%Y-%m-%d 2>/dev/null || date -v-monday +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)

# Read weekly data
week_data=$(cat "$weekly_data_file")
stored_week_start=$(echo "$week_data" | jq -r '.week_start // ""')
total_tokens=$(echo "$week_data" | jq -r '.total_tokens // 0')

# Reset if new week
if [ "$stored_week_start" != "$week_start" ]; then
    # Log the completed week to the database before resetting
    if [ "$total_tokens" -gt 0 ] && [ -n "$stored_week_start" ]; then
        log_entry=$(echo "$week_data" | jq \
            --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
            '. + {completed_at: $timestamp}')
        echo "$log_entry" >> "$weekly_log_file"
    fi

    # Reset for new week
    week_data='{"week_start":"'$week_start'","total_tokens":0,"sessions":{},"last_session":""}'
    total_tokens=0
fi

# Track current session ID to avoid double-counting
session_id=$(echo "$input" | jq -r '.session_id // ""')
last_session=$(echo "$week_data" | jq -r '.last_session // ""')

# Add current session tokens to weekly total (track max for each session)
if [ "$tokens" -gt 0 ]; then
    # Get session-specific tracking
    session_tokens=$(echo "$week_data" | jq -r ".sessions[\"$session_id\"] // 0")

    # Only update if current session has more tokens than previously recorded
    if [ "$tokens" -gt "$session_tokens" ]; then
        token_diff=$((tokens - session_tokens))
        new_total=$((total_tokens + token_diff))

        # Update weekly data
        week_data=$(echo "$week_data" | jq \
            --arg session "$session_id" \
            --argjson tokens "$tokens" \
            --argjson total "$new_total" \
            --arg week "$week_start" \
            '.week_start = $week | .total_tokens = $total | .sessions[$session] = $tokens | .last_session = $session')

        echo "$week_data" > "$weekly_data_file"
        total_tokens=$new_total
    fi
fi

# Simple displays (no percentages, starts at 0)
context_display="🧠 Context: ${tokens}"
weekly_display="📊 Weekly: ${total_tokens}"

# Output the statusline
echo "🤖 $model | $git_info | 📝 $output_style | $context_display | $weekly_display"
