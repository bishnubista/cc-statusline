# Claude Code Simple Statusline

A simple, clean statusline for Claude Code that displays essential context: model, directory, git branch, context usage, and output style.

![Claude Code Statusline](https://img.shields.io/badge/Claude_Code-Statusline-5436DA?style=for-the-badge)
![Version](https://img.shields.io/badge/version-2.2.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

## Features

- 🤖 **Model Display**: Shows current Claude model (e.g., Claude Opus 4.5)
- 📁 **Current Directory**: Displays the basename of your working directory
- 🌿 **Git Integration**: Shows current git branch when in a git repository
- 🧠 **Context Usage**: Shows token usage vs context window size (e.g., 5.2k/200k)
- 📝 **Output Style**: Shows your active Claude Code output style

## Quick Start

### One-Command Install

**Latest stable version (recommended):**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)
```

**Specific version:**
```bash
VERSION=v2.2.0 bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)
```

Then restart Claude Code!

### Manual Install

<details>
<summary>Click to expand manual installation steps</summary>

```bash
# Download the statusline script
curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/statusline.sh -o ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# Configure Claude Code (create or update ~/.claude/settings.json)
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

</details>

## What You'll See

**Example in action:**

![Statusline Screenshot](assets/statusline-example.png)

**In a git repository:**
```
🤖 Claude Opus 4.5 | 📁 cc-statusline | 🌿 main | 🧠 5.2k/200k | 📝 Explanatory
```

**Outside a git repository:**
```
🤖 Claude Sonnet 4 | 📁 my-project | 🧠 1.5k/200k | 📝 default
```

## Why This Statusline?

This statusline focuses on **context awareness**:

- **Model**: Know which Claude model you're using for the current conversation
- **Directory**: Quick reference to confirm you're in the right project
- **Git Branch**: Avoid making changes on the wrong branch
- **Context Usage**: Monitor how much of the context window you've used
- **Output Style**: See your current communication style at a glance

## Repository Structure

```
cc-statusline/
├── scripts/
│   ├── statusline.sh    # Main statusline script
│   ├── install.sh       # One-command installer
│   └── uninstall.sh     # One-command uninstaller
├── assets/
│   └── statusline-example.png  # Screenshot
├── CHANGELOG.md         # Version history
├── README.md            # This file
├── INSTALLATION.md      # Detailed setup guide
└── settings.json        # Example configuration
```

## Requirements

- **Claude Code 2.0+**
- **jq** (JSON processor) - Install before running the installer:
  ```bash
  # macOS
  brew install jq

  # Ubuntu/Debian
  sudo apt-get install jq
  ```
- **curl** or **wget** (for installation only, usually pre-installed)
- **bash** (pre-installed on macOS/Linux)
- **Git** (optional, for branch display)

## Uninstall

**One-Command Uninstall:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/uninstall.sh)
```

**Manual Uninstall:**
```bash
rm ~/.claude/statusline.sh
# Then manually remove the statusLine section from ~/.claude/settings.json
```

## Customization

The statusline is intentionally minimal, but you can customize it by editing `~/.claude/statusline.sh` after installation:

### Change Display Icons

```bash
# In the "Build output with emojis" section:
output="🤖 $model_name | 📁 $folder"   # Change emojis as desired
```

### Add Additional Fields

The `$input` JSON contains other data you can extract:
```bash
# Example: Add timestamp
timestamp=$(date +%H:%M)
output="🤖 $model_name | 🕐 $timestamp | 📁 $folder | ..."
```

## Version History

Current version: **v2.2.0**

See [CHANGELOG.md](CHANGELOG.md) for detailed release history and changes.

## Troubleshooting

See [INSTALLATION.md](INSTALLATION.md#troubleshooting) for detailed troubleshooting steps.

Common issues:
- **Statusline not appearing**: Check `~/.claude/settings.json` syntax
- **"jq: command not found"**: Install jq via your package manager
- **Git branch not showing**: Make sure you're in a git repository
- **Context showing 0/200k**: Normal at conversation start, updates as you chat

## How It Works

1. Claude Code calls `statusline.sh` and passes JSON data via stdin
2. Script extracts model name, directory, output style, and token counts from JSON
3. Checks if the current directory is a git repository
4. If in a git repo, extracts the current branch name
5. Formats context usage (tokens used / context window size)
6. Returns formatted statusline string to Claude Code

## License

MIT License - Feel free to modify and distribute

## Contributing

Issues and pull requests welcome! This is a personal tracking tool, so feel free to fork and customize for your needs.

## Acknowledgments

Built for the Claude Code community. Not affiliated with Anthropic.
