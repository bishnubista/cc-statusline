# Claude Code Simple Statusline Setup

## Features
- 🤖 Model name display (e.g., Claude Opus 4.5)
- 📁 Current directory name
- 🌿 Git branch (when in a git repository)
- 🧠 Context usage (tokens used / context window size)
- 📝 Output style display

## Installation

### Automated Installation (Recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)
```

The installer will:
- Check for required dependencies (jq) and offer to install if missing
- Download the statusline script to `~/.claude/statusline.sh`
- Configure your `~/.claude/settings.json` (with backup if it exists)

### Manual Installation

```bash
# Create the Claude config directory if it doesn't exist
mkdir -p ~/.claude

# Download the statusline script
curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/statusline.sh -o ~/.claude/statusline.sh

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
# Change emojis (in the "Build output with emojis" section)
output="🤖 $model_name | 📁 $folder"   # Model and folder
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
  "model": {"display_name": "Claude Opus 4.5"},
  "workspace": {"current_dir": "/Users/you/projects/my-app"},
  "output_style": {"name": "Explanatory"},
  "context_window": {"total_input_tokens": 5200, "total_output_tokens": 1000, "context_window_size": 200000}
}' | ~/.claude/statusline.sh
```

Expected output (if in a git repo):
```
🤖 Claude Opus 4.5 | 📁 my-app | 🌿 main | 🧠 6.2k/200k | 📝 Explanatory
```

## Example Output

**In a git repository:**
```
🤖 Claude Opus 4.5 | 📁 cc-statusline | 🌿 main | 🧠 5.2k/200k | 📝 Explanatory
```

**Outside a git repository:**
```
🤖 Claude Sonnet 4 | 📁 Documents | 🧠 1.5k/200k | 📝 default
```

Explanation:
- **🤖 Claude Opus 4.5**: Current Claude model
- **📁 cc-statusline**: Current directory (basename only)
- **🌿 main**: Git branch (only shown when in a git repo)
- **🧠 5.2k/200k**: Context usage (tokens used / context window size)
- **📝 Explanatory**: Active output style

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

### Context showing 0/200k
- This is normal at the start of a conversation
- The values update as you send messages and receive responses

## Files Created

- `~/.claude/statusline.sh` - The statusline script (you create this during installation)
- `~/.claude/settings.json` - Claude Code configuration (you create this during installation)

## Notes

- **Context-focused**: Displays information to help you stay oriented in your work
- **Git-aware**: Automatically detects git repositories and shows branch info
- **Token tracking**: Shows how much of the context window you've used
- **Output style**: Useful when switching between different Claude Code communication styles
