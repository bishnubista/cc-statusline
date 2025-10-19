# Claude Code Simple Statusline Setup

## Features
- 🤖 Model name display
- 📂 Current directory name
- 🌿 Git branch (when in a git repository)
- 📝 Output style display

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

### Change Display Format

You can customize the statusline by editing `~/.claude/statusline.sh`:

```bash
# Change emojis
dir_display="📂 $dir_name"    # Directory emoji
git_info="🌿 $branch"         # Git branch emoji

# Modify output format (lines 33-37)
echo "🤖 $model | $dir_display | $git_info | 📝 $output_style"
```

### Add Additional Information

The JSON input from Claude Code contains other fields you can use:
```bash
# Example additions:
session_id=$(echo "$input" | jq -r '.session_id // ""')
timestamp=$(date +%H:%M)
```

## Testing

Test your statusline before using it:

```bash
echo '{
  "model": {"display_name": "Claude Sonnet 4.5"},
  "workspace": {"current_dir": "/Users/you/projects/my-app"},
  "output_style": {"name": "Educational"}
}' | ~/.claude/statusline.sh
```

Expected output (if in a git repo):
```
🤖 Claude Sonnet 4.5 | 📂 my-app | 🌿 main | 📝 Educational
```

## Example Output

**In a git repository:**
```
🤖 Sonnet 4.5 | 📂 cc-statusline | 🌿 main | 📝 Educational
```

**Outside a git repository:**
```
🤖 Sonnet 4.5 | 📂 Documents | 📝 Concise
```

Explanation:
- **🤖 Sonnet 4.5**: Current Claude model
- **📂 cc-statusline**: Current directory (basename only)
- **🌿 main**: Git branch (only shown when in a git repo)
- **📝 Educational**: Active output style

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

### Output style not showing
- Make sure you're using Claude Code 2.0+ (output styles were added in v2.0)
- The output style reflects your current `/output-style` setting
- If it shows "default", no custom output style is active

## Files Created

- `~/.claude/statusline.sh` - The statusline script (you create this during installation)
- `~/.claude/settings.json` - Claude Code configuration (you create this during installation)

## Notes

- **Lightweight**: This statusline intentionally avoids tracking metrics or writing files
- **Context-focused**: Displays information to help you stay oriented in your work
- **Git-aware**: Automatically detects git repositories and shows branch info
- **Output style**: Useful when switching between different Claude Code communication styles
