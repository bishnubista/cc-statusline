# Claude Code Statusline

A feature-rich statusline for Claude Code with accurate token tracking, visual progress bar, cost monitoring, and cache efficiency display.

![Claude Code Statusline](https://img.shields.io/badge/Claude_Code-Statusline-5436DA?style=for-the-badge)
![Version](https://img.shields.io/badge/version-3.0.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

## Features

- 🤖 **Model Display**: Shows current Claude model (e.g., Opus 4.5, Sonnet 4)
- 📁 **Current Directory**: Displays the basename of your working directory
- 🌿 **Git Integration**: Shows current git branch when in a git repository
- 🧠 **Context Usage**: Color-coded percentage with visual progress bar
  - 🟢 Green: < 50% used
  - 🟡 Yellow: 50-80% used
  - 🔴 Red: > 80% used
- 💰 **Cost Tracking**: Real-time USD cost for the session
- 📦 **Cache Efficiency**: Shows tokens read from cache (saves money!)
- 📝 **Output Style**: Shows your active Claude Code output style

## What's New in v3.0.0

- **Accurate Context Tracking**: Uses `used_percentage` field for precise context usage after compaction
- **Visual Progress Bar**: 5-block bar (`█████`) shows context usage at a glance
- **Color-Coded Warnings**: Percentage changes color as you approach context limits
- **Cost Display**: Track your session spending in real-time
- **Cache Visibility**: See when prompt caching is saving you money

## Quick Start

### One-Command Install

**Latest stable version (recommended):**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)
```

**Specific version:**

```bash
VERSION=v3.0.0 bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)
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

**Full example with all features:**

```text
🤖 Opus 4.5 | 📁 cc-statusline | 🌿 main | 🧠 23% █░░░░ (65.2k) | 💰 $0.997 | 📦 44.9k↓ | 📝 Explanatory
```

**Breakdown of each section:**

| Section | Example | Description |
|---------|---------|-------------|
| 🤖 Model | `Opus 4.5` | Current Claude model |
| 📁 Folder | `my-project` | Working directory basename |
| 🌿 Branch | `main` | Git branch (if in repo) |
| 🧠 Context | `23% █░░░░ (65.2k)` | Usage %, visual bar, session tokens |
| 💰 Cost | `$0.997` | Session cost in USD |
| 📦 Cache | `44.9k↓` | Tokens read from cache |
| 📝 Style | `Explanatory` | Output style setting |

**Context usage at different levels:**

```text
Low usage:    🧠 15% ░░░░░ (12.3k)   ← Green
Medium usage: 🧠 65% ███░░ (89.2k)   ← Yellow
High usage:   🧠 92% ████░ (156.4k)  ← Red (warning!)
```

## Why This Statusline?

This statusline focuses on **context awareness** and **cost visibility**:

- **Accurate Percentage**: Uses Claude Code's `used_percentage` field which accounts for context compaction and sub-agent runs
- **Visual Feedback**: Progress bar and color coding let you see context state at a glance
- **Cost Awareness**: Know exactly what you're spending per session
- **Cache Efficiency**: See when prompt caching is working (lower costs!)
- **Git Branch**: Avoid making changes on the wrong branch

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

- **bc** (calculator for cost comparison - usually pre-installed)
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

The statusline is configurable by editing `~/.claude/statusline.sh` after installation:

### Change Color Thresholds

```bash
# In the color_pct() function, adjust thresholds:
if [ "$pct" -lt 50 ]; then      # Green threshold
    ...
elif [ "$pct" -lt 80 ]; then    # Yellow threshold
    ...
```

### Change Progress Bar Width

```bash
# In the progress_bar() function:
local width=5    # Change to 10 for a wider bar
```

### Remove Optional Sections

```bash
# Comment out sections you don't want:
# if (( $(echo "$total_cost > 0" | bc -l) )); then
#     output="$output | 💰 \$${cost_formatted}"
# fi
```

### Available JSON Fields

The script receives this JSON from Claude Code:

```json
{
  "model": { "display_name": "Opus 4.5" },
  "workspace": { "current_dir": "/path/to/project" },
  "output_style": { "name": "Explanatory" },
  "context_window": {
    "used_percentage": 28.5,
    "remaining_percentage": 71.5,
    "context_window_size": 200000,
    "total_input_tokens": 45000,
    "total_output_tokens": 12000,
    "current_usage": {
      "cache_read_input_tokens": 8500
    }
  },
  "cost": { "total_cost_usd": 0.0542 }
}
```

## Version History

Current version: **v3.0.0**

See [CHANGELOG.md](CHANGELOG.md) for detailed release history and changes.

## Troubleshooting

See [INSTALLATION.md](INSTALLATION.md#troubleshooting) for detailed troubleshooting steps.

Common issues:

- **Statusline not appearing**: Check `~/.claude/settings.json` syntax
- **"jq: command not found"**: Install jq via your package manager
- **Git branch not showing**: Make sure you're in a git repository
- **Colors not showing**: Your terminal may not support ANSI colors
- **Cost showing $0.000**: Normal at conversation start, updates after first response

## How It Works

1. Claude Code calls `statusline.sh` and passes JSON data via stdin
2. Script extracts model, directory, tokens, cost, and cache data from JSON
3. Uses `used_percentage` for accurate context window state (handles compaction)
4. Calculates visual progress bar and applies color coding
5. Checks if the current directory is a git repository
6. Returns formatted statusline string with ANSI color codes

## License

MIT License - Feel free to modify and distribute

## Contributing

Issues and pull requests welcome! This is a personal project, so feel free to fork and customize for your needs.

## Acknowledgments

Built for the Claude Code community. Not affiliated with Anthropic.
