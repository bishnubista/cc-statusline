#!/usr/bin/env bash

# Claude Code Simple Statusline Uninstaller
# One-command uninstall: bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/uninstall.sh)

set -e

CLAUDE_DIR="$HOME/.claude"
STATUSLINE_SCRIPT="$CLAUDE_DIR/statusline.sh"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

echo "🗑️  Uninstalling Claude Code Simple Statusline..."
echo ""

# Remove statusline script
if [ -f "$STATUSLINE_SCRIPT" ]; then
    rm "$STATUSLINE_SCRIPT"
    echo "✅ Removed $STATUSLINE_SCRIPT"
else
    echo "ℹ️  Statusline script not found (already removed?)"
fi

# Handle settings.json
if [ -f "$SETTINGS_FILE" ]; then
    if grep -q '"statusLine"' "$SETTINGS_FILE" 2>/dev/null; then
        echo ""
        echo "⚠️  Found statusLine configuration in $SETTINGS_FILE"
        echo ""
        read -p "   Remove statusLine section from settings.json? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup settings
            cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
            echo "   Created backup: $SETTINGS_FILE.backup"

            # Remove statusLine section
            if command -v jq &> /dev/null; then
                jq 'del(.statusLine)' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
                echo "   ✅ Removed statusLine configuration"
            else
                echo "   ⚠️  jq not found - please manually edit $SETTINGS_FILE"
                echo "      to remove the statusLine section"
            fi
        else
            echo "   Skipped settings update. You can manually edit $SETTINGS_FILE"
        fi
    fi
fi

echo ""
echo "✨ Uninstall complete!"
echo ""
echo "Please restart Claude Code to see the changes."
echo ""
