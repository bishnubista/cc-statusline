# Claude Code Custom Statusline

A custom statusline for Claude Code that displays real-time token usage, git branch, and personal weekly usage tracking.

![Claude Code Statusline](https://img.shields.io/badge/Claude_Code-Statusline-5436DA?style=for-the-badge)

## Features

- 🤖 **Model Display**: Shows current Claude model (e.g., Sonnet 4.5)
- 🌿 **Git Integration**: Displays current git branch or indicates non-git directories
- 🧠 **Session Tracking**: Real-time token usage for current conversation (out of 200K context limit)
- 📊 **Weekly Tracking**: Personal usage tracking with Monday reset (not an official Claude limit)
- 📚 **Historical Logs**: Automatic weekly usage database for long-term tracking
- 🎨 **Visual Indicators**: Color-coded alerts (✅ ⚠️ 🔴) based on usage levels

## Quick Start

```bash
# Clone or download this repo
cd cc-statusline

# Install
cp statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# Configure Claude Code
cat > ~/.claude/settings.json << 'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
EOF

# Restart Claude Code
```

## What You'll See

```
🤖 Sonnet 4.5 | 🌿 main | 🧠 Session: 45000/200000 (22%) | 📊 Weekly: 45000 tokens
```

- **Session**: Current conversation's token usage out of 200K context limit (resets on new conversation)
- **Weekly**: Cumulative tokens this week (personal tracking, resets Monday)

## Usage Log Viewer

Track your Claude Code usage over time:

```bash
bash view_weekly_logs.sh
```

Output:
```
=== Claude Code Weekly Usage Logs ===

📊 Current Week (In Progress):
Week starting: 2025-10-13 | Total tokens: 27064 | Sessions: 1

📚 Completed Weeks:
─────────────────────────────────────────────────────
Week: 2025-10-06 to 2025-10-13 | Tokens: 4500000 | Sessions: 23
Week: 2025-09-29 to 2025-10-06 | Tokens: 3200000 | Sessions: 18
─────────────────────────────────────────────────────
📈 Statistics:
   Total weeks logged: 2
   Total tokens used: 7700000
   Average per week: 3850000
```

## Important Notes

### Weekly Tracking is Personal, Not Official

The 5M weekly token limit shown in the statusline is **for personal tracking only**. Claude Code doesn't impose hard weekly token limits - it charges based on actual API usage.

This feature helps you:
- Monitor your own usage patterns
- Set personal budgets/goals
- Track costs over time
- Identify usage spikes

You can adjust the limit in `statusline.sh`:
```bash
weekly_limit=5000000  # Change to your personal goal
```

### Token Counting

- Only **input tokens** are counted (what you send to Claude)
- Output tokens (Claude's responses) are not tracked
- Session tokens reset when you start a new conversation
- Weekly tokens accumulate across all sessions, reset every Monday

## Files

- `statusline.sh` - Main statusline script
- `view_weekly_logs.sh` - Usage log viewer
- `INSTALLATION.md` - Detailed installation and troubleshooting guide
- `settings.json` - Example Claude Code configuration

### Auto-Created Files

- `~/.claude/weekly_usage.json` - Current week's data
- `~/.claude/weekly_usage_log.jsonl` - Historical weekly logs (JSONL database)

## Requirements

- Claude Code 2.0+
- `jq` (JSON processor)
  ```bash
  # macOS
  brew install jq

  # Ubuntu/Debian
  sudo apt-get install jq
  ```
- `bash` 4.0+
- Git (optional, for branch display)

## Customization

### Color Thresholds

Edit `statusline.sh` around line 116:

```bash
if [ "$weekly_percentage" -lt 50 ]; then
    weekly_color="✅"  # Green zone
elif [ "$weekly_percentage" -lt 80 ]; then
    weekly_color="⚠️"  # Warning zone
else
    weekly_color="🔴"  # Critical zone
fi
```

### Weekly Limit

```bash
weekly_limit=5000000  # Adjust to your personal goal
```

### Session Display Format

Edit around line 42:

```bash
token_display="🧠 Session: $tokens (${percentage}%)"
```

## Troubleshooting

See [INSTALLATION.md](INSTALLATION.md#troubleshooting) for detailed troubleshooting steps.

Common issues:
- **Statusline not appearing**: Check `~/.claude/settings.json` syntax
- **"jq: command not found"**: Install jq via your package manager
- **Token showing N/A**: Transcript file may not be accessible

## How It Works

1. Claude Code calls `statusline.sh` and passes JSON data via stdin
2. Script extracts session ID, model name, and transcript path
3. Parses token usage from system reminder messages in transcript
4. Tracks tokens per session to avoid double-counting
5. Maintains weekly totals in `~/.claude/weekly_usage.json`
6. Logs completed weeks to `~/.claude/weekly_usage_log.jsonl`
7. Returns formatted statusline string to Claude Code

## License

MIT License - Feel free to modify and distribute

## Contributing

Issues and pull requests welcome! This is a personal tracking tool, so feel free to fork and customize for your needs.

## Acknowledgments

Built for the Claude Code community. Not affiliated with Anthropic.
