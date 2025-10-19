#!/usr/bin/env bash

# Claude Code Simple Statusline Installer
# One-command installation: bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)

set -e  # Exit on error

# Version can be set via environment variable: VERSION=v1.0.0 bash install.sh
VERSION="${VERSION:-main}"

CLAUDE_DIR="$HOME/.claude"
STATUSLINE_SCRIPT="$CLAUDE_DIR/statusline.sh"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
REPO_RAW_URL="https://raw.githubusercontent.com/bishnubista/cc-statusline/${VERSION}/scripts"

echo "🚀 Installing Claude Code Simple Statusline..."
if [ "$VERSION" = "main" ]; then
    echo "   Version: Latest (main branch)"
else
    echo "   Version: $VERSION"
fi
echo ""

# Check for jq
if ! command -v jq &> /dev/null; then
    echo "❌ Error: jq is not installed (required for JSON parsing)"
    echo ""

    # Detect OS and suggest installation
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "📦 Detected macOS. Installation command:"
        echo "   brew install jq"
        echo ""

        if command -v brew &> /dev/null; then
            read -p "   Would you like to install jq now using Homebrew? (y/n) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "   Installing jq..."
                brew install jq
                echo "   ✅ jq installed successfully"
                echo ""
            else
                echo "   Installation cancelled. Please install jq manually and run this script again."
                exit 1
            fi
        else
            echo "   Homebrew not found. Please install jq manually:"
            echo "   https://jqlang.github.io/jq/download/"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "📦 Detected Linux. Installation command:"

        if command -v apt-get &> /dev/null; then
            echo "   sudo apt-get install jq"
            echo ""
            read -p "   Would you like to install jq now using apt-get? (y/n) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "   Installing jq..."
                sudo apt-get update && sudo apt-get install -y jq
                echo "   ✅ jq installed successfully"
                echo ""
            else
                echo "   Installation cancelled. Please install jq manually and run this script again."
                exit 1
            fi
        elif command -v yum &> /dev/null; then
            echo "   sudo yum install jq"
            echo ""
            read -p "   Would you like to install jq now using yum? (y/n) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "   Installing jq..."
                sudo yum install -y jq
                echo "   ✅ jq installed successfully"
                echo ""
            else
                echo "   Installation cancelled. Please install jq manually and run this script again."
                exit 1
            fi
        else
            echo "   Package manager not detected. Please install jq manually:"
            echo "   https://jqlang.github.io/jq/download/"
            exit 1
        fi
    else
        echo "   OS not detected. Please install jq manually:"
        echo "   https://jqlang.github.io/jq/download/"
        exit 1
    fi
fi

# Create .claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Download statusline script
echo "📝 Downloading statusline script..."
if command -v curl &> /dev/null; then
    curl -fsSL "$REPO_RAW_URL/statusline.sh" -o "$STATUSLINE_SCRIPT"
elif command -v wget &> /dev/null; then
    wget -q "$REPO_RAW_URL/statusline.sh" -O "$STATUSLINE_SCRIPT"
else
    echo "❌ Error: Neither curl nor wget is available"
    exit 1
fi

chmod +x "$STATUSLINE_SCRIPT"
echo "   ✅ Installed to $STATUSLINE_SCRIPT"

# Handle settings.json
if [ -f "$SETTINGS_FILE" ]; then
    echo "⚠️  Settings file already exists at $SETTINGS_FILE"

    # Check if statusLine is already configured
    if grep -q '"statusLine"' "$SETTINGS_FILE" 2>/dev/null; then
        echo "ℹ️  Statusline configuration already exists in settings.json"
        echo "   Skipping settings update to preserve your configuration."
        echo ""
        echo "   If you want to update it, manually edit $SETTINGS_FILE"
        echo "   and ensure the statusLine section looks like this:"
        echo '   "statusLine": {'
        echo '     "type": "command",'
        echo '     "command": "~/.claude/statusline.sh",'
        echo '     "padding": 0'
        echo '   }'
    else
        echo ""
        read -p "   Would you like to add statusline configuration? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup existing settings
            cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
            echo "   Created backup: $SETTINGS_FILE.backup"

            # Add statusLine to existing settings
            jq '. + {"statusLine": {"type": "command", "command": "~/.claude/statusline.sh", "padding": 0}}' \
                "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
            echo "   ✅ Added statusline configuration to existing settings"
        else
            echo "   Skipping settings update. You'll need to configure manually."
        fi
    fi
else
    echo "📋 Creating settings file at $SETTINGS_FILE..."
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
EOF
    echo "   ✅ Settings file created"
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart Claude Code"
echo "2. You should see the statusline at the bottom of your terminal"
echo ""
echo "Example output:"
echo "  🤖 Sonnet 4.5 | 📂 my-project | 🌿 main | 📝 Educational"
echo ""
echo "To customize, edit: $STATUSLINE_SCRIPT"
echo ""
echo "📚 Documentation: https://github.com/bishnubista/cc-statusline"
echo ""
echo "To uninstall:"
echo "  rm $STATUSLINE_SCRIPT"
echo "  # Then remove statusLine section from $SETTINGS_FILE"
echo ""
