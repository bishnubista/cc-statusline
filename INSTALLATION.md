# Claude Code Custom Statusline Setup

## Features
- 🤖 Model name display
- 🌿 Git branch (or 📁 no-git if not in a repo)
- 🧠 Session token usage with percentage (out of 200K context limit)
- 📊 Weekly token usage tracking with visual indicators (personal tracking, not official Claude limit)
- 📚 Historical weekly usage log database

## Installation

### Step 1: Copy the statusline script

```bash
# Create the Claude config directory if it doesn't exist
mkdir -p ~/.claude

# Copy the statusline script
cp statusline.sh ~/.claude/statusline.sh

# Make it executable
chmod +x ~/.claude/statusline.sh
```

### Step 2: Configure Claude Code

Add this to your `~/.claude/settings.json` (create if it doesn't exist):

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
```

### Step 3: Restart Claude Code

The statusline will appear at the bottom of your Claude Code interface.

## Customization

### Adjust Weekly Limit

**NOTE:** The weekly limit is for **personal tracking only** - it's not an official Claude Code limit. Claude Code charges based on usage, not hard weekly token limits.

Edit the `weekly_limit` variable in `statusline.sh` (around line 113):

```bash
weekly_limit=5000000  # Change this to your personal tracking goal
```

**Suggested limits for personal tracking:**
- **Light usage**: ~1,000,000 tokens/week
- **Moderate usage**: ~5,000,000 tokens/week
- **Heavy usage**: ~10,000,000+ tokens/week

### Color Indicators

The weekly display shows:
- ✅ Green: < 50% of weekly limit
- ⚠️ Warning: 50-80% of weekly limit
- 🔴 Critical: > 80% of weekly limit

## Testing

Test your statusline before using it:

```bash
echo '{
  "model": {"display_name": "Claude Sonnet 4.5"},
  "workspace": {"current_dir": "/your/project"},
  "transcript_path": "/path/to/transcript.json",
  "session_id": "test"
}' | ~/.claude/statusline.sh
```

## Example Output

```
🤖 Sonnet 4.5 | 🌿 main | 🧠 Session: 45000/200000 (22%) | 📊 Weekly: 45000 tokens
```

Explanation:
- **🤖 Sonnet 4.5**: Current model
- **🌿 main**: Git branch (or 📁 no-git)
- **🧠 Session: 45000/200000 (22%)**: Current conversation using 45K out of 200K context limit (22%)
- **📊 Weekly: 45000 tokens**: This week's total usage (resets Monday)

## Troubleshooting

### Statusline not appearing
- Verify the script is executable: `ls -la ~/.claude/statusline.sh`
- Check settings.json syntax is valid
- Restart Claude Code completely

### "jq: command not found"
Install jq:
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Other systems
# See: https://jqlang.github.io/jq/download/
```

### Weekly tracking not updating
- Check permissions: `ls -la ~/.claude/weekly_usage.json`
- Verify the file exists and is writable
- Delete `~/.claude/weekly_usage.json` to reset tracking

## Viewing Usage Logs

View your historical weekly usage data:

```bash
# View all weekly logs
bash view_weekly_logs.sh

# Or install it globally
cp view_weekly_logs.sh ~/.claude/view_weekly_logs.sh
chmod +x ~/.claude/view_weekly_logs.sh
~/.claude/view_weekly_logs.sh
```

The log viewer shows:
- Current week in progress
- Completed weeks with token counts
- Statistics (total, average per week)

## Files Created

- `~/.claude/statusline.sh` - The statusline script
- `~/.claude/weekly_usage.json` - Current week's tracking data (auto-created)
- `~/.claude/weekly_usage_log.jsonl` - Historical weekly usage database (auto-created)
- `~/.claude/settings.json` - Claude Code configuration

## Notes

- **Session tokens**: Shows current conversation's token usage (resets when you start a new conversation)
- **Weekly tracking**: Resets every Monday at midnight
- **Personal tracking**: The 5M weekly limit is not an official Claude Code limit - it's for your personal usage tracking
- **Historical logs**: Each completed week is automatically logged to `weekly_usage_log.jsonl`
- Token counts exclude assistant output tokens, only input tokens are tracked
