# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.3.0] - 2026-01-03

### Fixed
- **Context usage now shows accurate values after compaction/sub-agents**: Previously displayed cumulative tokens (e.g., `643.9k/200k`) which was confusing after context compaction or running multiple sub-agents. Now shows actual current context window usage.

### Changed
- Switched from `total_input_tokens`/`total_output_tokens` (cumulative) to `current_usage` object (actual context state)
- Context calculation now includes cache tokens (`cache_creation_input_tokens` + `cache_read_input_tokens`)
- Added fallback to cumulative totals for backward compatibility with older Claude Code versions

### Why This Change?
When Claude Code compacts context or runs sub-agents, the cumulative token counters keep growing even though the actual context window is smaller. This led to confusing displays like `643.9k/200k`. The new approach uses the `current_usage` object which reflects what's actually in the context window right now.

## [2.2.0] - 2025-12-17

### Added
- **Context usage display**: Added 🧠 context tracking showing tokens used vs context window size (e.g., `5.2k/200k`)
  - Uses Claude Code 2.0.17's `context_window` JSON data
  - Formats large numbers in compact `k` notation (e.g., 5200 → 5.2k)
- **Output style display**: Added back 📝 output style to statusline

### Changed
- Updated format to: `🤖 model | 📁 folder | 🌿 branch | 🧠 context | 📝 style`
- Changed folder emoji from 📂 to 📁
- Full model name display (e.g., "Claude Opus 4.5" instead of just "Opus 4.5")
- Updated all documentation to match new format

### Why This Change?
Claude Code 2.0.17 provides rich JSON data including context window usage. This version leverages that data to show how much of your context window you've used - helpful for long conversations where you want to monitor token usage.

## [2.1.0] - 2025-10-31

### Removed
- **Output style display**: Temporarily removed output style field from statusline

### Changed
- Simplified statusline to focus on core context: model, directory, and git branch

## [2.0.0] - 2025-10-18

### Changed - BREAKING CHANGES ⚠️
- **Repository structure reorganized**: All shell scripts moved to `scripts/` directory
- **Installation URL changed**: Update to new path `https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh`
- **Uninstall URL changed**: Update to new path `https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/uninstall.sh`

### Added
- Added "Repository Structure" section to README showing new organization
- Improved documentation with clearer installation paths

### Migration Guide
If you installed v1.0.x, the statusline will continue to work (it's already installed in `~/.claude/statusline.sh`).

For new installations or reinstalls, use the new URL:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/bishnubista/cc-statusline/main/scripts/install.sh)
```

### Why This Change?
Better project organization with scripts separated into their own directory, making the repository root cleaner with only documentation files (README, CHANGELOG) and configuration examples.

## [1.0.1] - 2025-10-18

### Removed
- **Token tracking feature**: Removed weekly and session token tracking to simplify the statusline
- **Weekly usage log files**: No longer creates `~/.claude/weekly_usage.json` or `~/.claude/weekly_usage_log.jsonl`
- **`view_weekly_logs.sh` script**: Removed as token tracking is no longer supported

### Changed
- Simplified statusline output to focus on context awareness only (model, directory, branch, output style)
- Updated INSTALLATION.md to reflect simplified feature set
- Reduced dependencies on transcript file parsing

### Why This Change?
This release fully embraces the "Simple Statusline" philosophy by removing metric tracking in favor of pure context awareness. The statusline now displays only what you need to stay oriented (what model, which directory, which branch, what output style) without writing any files or tracking usage.

## [1.0.0] - 2025-10-18

### Added
- Initial release of Claude Code Simple Statusline
- 🤖 Model display showing current Claude model (e.g., Sonnet 4.5)
- 📂 Current directory display (basename of working directory)
- 🌿 Git branch integration showing current branch when in a git repository
- 📝 Output style display showing active Claude Code output style
- One-command installation script with automatic dependency management
- One-command uninstall script
- Comprehensive README with installation and troubleshooting guides
- Manual installation instructions
- Example settings.json configuration
- Version pinning support (install specific versions via VERSION environment variable)

### Installation Features
- Automatic OS detection (macOS, Ubuntu/Debian, CentOS/RHEL)
- Interactive dependency installation for jq (asks for permission before installing)
- Graceful fallback with manual instructions if package manager not detected
- Smart settings.json handling (preserves existing configuration)
- Automatic backup creation when modifying settings

### Technical Details
- Bash-based statusline script using jq for JSON parsing
- Git integration for branch detection
- Cross-platform support (macOS/Linux)
- Minimal dependencies (bash, jq, git optional)
- Semantic versioning support

[2.3.0]: https://github.com/bishnubista/cc-statusline/releases/tag/v2.3.0
[2.2.0]: https://github.com/bishnubista/cc-statusline/releases/tag/v2.2.0
[2.1.0]: https://github.com/bishnubista/cc-statusline/releases/tag/v2.1.0
[2.0.0]: https://github.com/bishnubista/cc-statusline/releases/tag/v2.0.0
[1.0.1]: https://github.com/bishnubista/cc-statusline/releases/tag/v1.0.1
[1.0.0]: https://github.com/bishnubista/cc-statusline/releases/tag/v1.0.0
