# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[1.0.1]: https://github.com/bishnubista/cc-statusline/releases/tag/v1.0.1
[1.0.0]: https://github.com/bishnubista/cc-statusline/releases/tag/v1.0.0
