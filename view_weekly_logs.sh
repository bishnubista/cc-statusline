#!/usr/bin/env bash

# View weekly usage logs from Claude Code statusline tracking

log_file="$HOME/.claude/weekly_usage_log.jsonl"
current_file="$HOME/.claude/weekly_usage.json"

echo "=== Claude Code Weekly Usage Logs ==="
echo ""

# Show current week (in progress)
if [ -f "$current_file" ]; then
    echo "📊 Current Week (In Progress):"
    cat "$current_file" | jq -r '"Week starting: \(.week_start) | Total tokens: \(.total_tokens | tostring) | Sessions: \(.sessions | length | tostring)"'
    echo ""
fi

# Show historical weeks
if [ -f "$log_file" ]; then
    echo "📚 Completed Weeks:"
    echo "─────────────────────────────────────────────────────"

    # Read and format each log entry
    while IFS= read -r line; do
        echo "$line" | jq -r '"Week: \(.week_start) to \(.completed_at // "ongoing") | Tokens: \(.total_tokens | tostring) | Sessions: \(.sessions | length | tostring)"'
    done < "$log_file"

    echo ""
    echo "─────────────────────────────────────────────────────"

    # Calculate total usage across all logged weeks
    total=$(jq -s 'map(.total_tokens) | add' "$log_file" 2>/dev/null || echo "0")
    weeks=$(wc -l < "$log_file" | tr -d ' ')

    if [ "$total" != "null" ] && [ "$total" -gt 0 ]; then
        avg=$((total / weeks))
        echo "📈 Statistics:"
        echo "   Total weeks logged: $weeks"
        echo "   Total tokens used: $total"
        echo "   Average per week: $avg"
    fi
else
    echo "No completed weeks logged yet."
    echo "Logs will appear here when a week completes (Monday reset)."
fi

echo ""
echo "Log file location: $log_file"
