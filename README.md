# Claude Code Statusline

A clean, minimal statusline for Claude Code — model, directory, branch, session tokens, and output style.

![Claude Code Statusline](https://img.shields.io/badge/Claude_Code-Statusline-5436DA?style=for-the-badge)
![Version](https://img.shields.io/badge/version-3.2.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

## Features

- 🤖 **Model Display**: Shows current Claude model (e.g., Opus 4.7, Sonnet 4.6)
- 📁 **Current Directory**: Displays the basename of your working directory
- 🌿 **Git Integration**: Shows current git branch when in a git repository
- 🧠 **Session Tokens**: Cumulative input + output tokens for the session (auto-formats as `k` / `M`)
- 📝 **Output Style**: Shows your active Claude Code output style

## What's New in v3.2.0

- **Removed context percentage + progress bar**: The fixed green/yellow/red thresholds were tuned for a 200k window; with 1M context models (e.g., Opus 4.7 1M) the percentage no longer carries useful signal.
- **Kept absolute session token counter**: `format_k` already handles `M` suffix, so the display stays meaningful at any context size.
- **Simpler script**: Removed the `color_pct` and `progress_bar` helpers along with the `used_percentage` / `context_window_size` JSON reads.

## Quick Start

### One-Command Install

**Latest stable version (recommended):**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)
```

**Specific version:**

```bash
VERSION=v3.2.0 bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)
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

**Full example:**

```text
🤖 Opus 4.7 | 📁 cc-statusline | 🌿 main | 🧠 72.3k | 📝 Explanatory
```

**Breakdown of each section:**

| Section | Example | Description |
|---------|---------|-------------|
| 🤖 Model | `Opus 4.7` | Current Claude model |
| 📁 Folder | `cc-statusline` | Working directory basename |
| 🌿 Branch | `main` | Git branch (if in repo) |
| 🧠 Tokens | `72.3k` | Cumulative session tokens (input + output), auto-scales to `M` |
| 📝 Style | `Explanatory` | Output style setting |

**Session tokens at different levels:**

```text
Short session:   🧠 12.3k
Medium session:  🧠 89.2k
Long session:    🧠 1.2M
```

## Why This Statusline?

This statusline focuses on **staying oriented**:

- **Model, directory, branch at a glance**: the three things that answer "where am I?"
- **Absolute token counter**: context-window-size agnostic — works whether you're on 200k or 1M
- **Clean & Minimal**: no percentage, no bar, no color — just the facts

## Repository Structure

```text
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

- **Claude Code 2.0+** (uses newer JSON fields)
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

The statusline is configurable by editing `~/.claude/statusline.sh` after installation.

### Reorder / remove sections

The final output is built near the bottom of `statusline.sh`:

```bash
output="🤖 $model_name | 📁 $folder"
[ -n "$branch" ] && output="$output | 🌿 $branch"
output="$output | 🧠 $session_formatted | 📝 $output_style"
```

Drop or reorder pieces as you like.

### Available JSON Fields

The script receives this JSON from Claude Code (only the fields actually used are shown below; more are available — see `context_window.used_percentage`, `remaining_percentage`, `context_window_size` if you want to re-add a percent display):

```json
{
  "model": { "display_name": "Opus 4.7" },
  "workspace": { "current_dir": "/path/to/project" },
  "output_style": { "name": "Explanatory" },
  "context_window": {
    "total_input_tokens": 45000,
    "total_output_tokens": 12000
  }
}
```

## Version History

Current version: **v3.2.0**

See [CHANGELOG.md](CHANGELOG.md) for detailed release history and changes.

## Troubleshooting

See [INSTALLATION.md](INSTALLATION.md#troubleshooting) for detailed troubleshooting steps.

Common issues:

- **Statusline not appearing**: Check `~/.claude/settings.json` syntax
- **"jq: command not found"**: Install jq via your package manager
- **Git branch not showing**: Make sure you're in a git repository
- **Colors not showing**: Your terminal may not support ANSI colors

## How It Works

1. Claude Code calls `statusline.sh` and passes JSON data via stdin
2. Script extracts model, directory, and token data from JSON
3. Sums `total_input_tokens` + `total_output_tokens` for the session counter
4. Checks if the current directory is a git repository
5. Formats tokens with `k` / `M` suffix and returns the assembled string

## License

MIT License - Feel free to modify and distribute

## Contributing

Issues and pull requests welcome! This is a personal project, so feel free to fork and customize for your needs.

## Acknowledgments

Built for the Claude Code community. Not affiliated with Anthropic.
