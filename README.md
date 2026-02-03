# namefix

A robust bash script for validating and sanitizing filenames to ensure compatibility across Windows, Linux, macOS, and Android. It detects and fixes reserved names, forbidden characters, and other filesystem issues.

## Key Features

- **Cross-Platform Safety**: Detects Windows reserved names (CON, PRN, etc.) and forbidden characters (`< > : " | ? * \ /`).
- **Flexible Modes**: Supports Interactive prompts, Batch processing, and Dry-run previews.
- **Undo Support**: Automatically backs up original filenames, allowing full rollback of changes.
- **Smart Sanitization**: Handles special characters, trailing spaces/dots, and Unicode issues (emojis, zero-width chars).
- **Automation Ready**: Includes JSON output support and silent operation modes.

## Installation

### Arch Linux (AUR)

```bash
yay -S namefix-git
# or
paru -S namefix-git
```

### Quick Install (One-liner)

```bash
curl -sL https://raw.githubusercontent.com/pinkorca/namefix/main/namefix.sh | sudo tee /usr/local/bin/namefix >/dev/null && sudo chmod +x /usr/local/bin/namefix
```

Or without sudo (installs to `~/.local/bin`):
```bash
mkdir -p ~/.local/bin && curl -sL https://raw.githubusercontent.com/pinkorca/namefix/main/namefix.sh -o ~/.local/bin/namefix && chmod +x ~/.local/bin/namefix
```

### Full Install (with man page and completions)

**System-wide** (may require sudo):
```bash
git clone https://github.com/pinkorca/namefix.git
cd namefix
./install.sh
```

**User-only** (no sudo needed):
```bash
git clone https://github.com/pinkorca/namefix.git
cd namefix
./install.sh --user
```

To uninstall:
```bash
./install.sh uninstall
```

### Manual Install

1. Download the script:
   ```bash
   curl -O https://raw.githubusercontent.com/pinkorca/namefix/main/namefix.sh
   ```

2. Make it executable:
   ```bash
   chmod +x namefix.sh
   ```

3. (Optional) Move to your path:
   ```bash
   sudo mv namefix.sh /usr/local/bin/namefix
   ```

## Quick Start

Test a directory for issues (without making changes):
```bash
namefix /path/to/files
```

Preview what would be renamed:
```bash
namefix --fix --dry-run /path/to/files
```

## Usage Examples

**Interactive Mode**: Review each change before applying
```bash
namefix --fix --interactive .
```

**Batch Mode**: Automatically fix all files in a directory (recursive)
```bash
namefix --fix --batch --recursive ~/Downloads
```

**JSON Output**: Integrate with other scripts or tools
```bash
namefix --check --json . > report.json
```

**Undo Changes**: Restore filenames from the last operation
```bash
namefix --undo .
```

## Options

| Option | Description |
|--------|-------------|
| `-c`, `--check` | Check for issues only (Default) |
| `-f`, `--fix` | Sanitise problematic filenames |
| `-u`, `--undo` | Restore original filenames from backup |
| `-d`, `--dry-run` | Preview changes without applying them |
| `-i`, `--interactive` | Prompt for confirmation before each rename |
| `-b`, `--batch` | Apply fixes automatically without prompting |
| `-r`, `--recursive` | Process subdirectories recursively |
| `-j`, `--json` | Output results in JSON format |
| `-v`, `--verbose` | Show detailed output |
| `-q`, `--quiet` | Suppress non-essential output |
| `-s`, `--strategy` | Sanitization strategy: `underscore` (default), `hyphen`, `remove` |

## Shell Completions

The installer automatically installs completions for:
- **Bash** (`~/.local/share/bash-completion/completions/` or `/etc/bash_completion.d/`)
- **Zsh** (`~/.oh-my-zsh/completions/` or system zsh site-functions)
- **Fish** (`~/.config/fish/completions/`)

## Dependencies

- **bash** >= 4.0
- **perl** (optional, for Unicode detection)

## License

This project is licensed under the [GPL-3.0 License](LICENSE).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
