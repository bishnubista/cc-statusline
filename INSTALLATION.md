# Claude Code Custom Statusline Setup

## Features
- 🤖 Model name display
- 🌿 Git branch (or 📁 no-git if not in a repo)
- 🧠 Token usage with percentage (out of 200K context limit)
- 📊 Weekly token usage tracking with visual indicators

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

Edit line 61 in `statusline.sh`:

```bash
weekly_limit=5000000  # Change this to your desired weekly token limit
```

**Suggested limits based on Claude plans:**
- **Pro plan**: ~1,000,000 tokens/week
- **Max 5 plan**: ~5,000,000 tokens/week  
- **Max 20 plan**: ~20,000,000 tokens/week

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
🤖 Claude Sonnet 4.5 | 🌿 feature/statusline | 🧠 45000 tok (22%) | 📊 Weekly: ✅ 0% (45000/5000000)
```

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

## Files Created

- `~/.claude/statusline.sh` - The statusline script
- `~/.claude/weekly_usage.json` - Weekly token tracking data (auto-created)
- `~/.claude/settings.json` - Claude Code configuration

## Notes

- Weekly tracking resets every Monday
- Token counts are cumulative per conversation session
- The script creates `~/.claude/weekly_usage.json` to persist weekly data
- Adjust the `weekly_limit` variable to match your Claude plan
