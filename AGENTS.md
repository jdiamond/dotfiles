# Dotfiles

Personal configuration files for macOS development environment.

**Never commit sensitive files** (SSH keys, API tokens, credentials, etc.). If in doubt, ask before committing.

## Tools

- **bat** - Syntax-highlighting cat replacement
- **ghostty** - GPU-accelerated terminal emulator
- **lazygit** - Terminal UI for git
- **nvim** - Neovim editor
- **television (tv)** - Fuzzy finder tool
- **yazi** - Terminal file manager
- **zsh** - Zsh shell configuration

## Tool Documentation

Each tool directory may contain a `README.md` with references to official documentation, debugging notes, or tool-specific tips. Check the tool's subdirectory for details.

## Working with Files

This repo uses symlinks. After adding/modifying files:

1. Update `links.conf` if adding new files
2. Run `./sync.sh` to apply changes

See `README.md` for details on the symlink setup.

### Custom Scripts

Custom scripts go in `bin/` and are linked to `~/.local/bin/`.

## Tips

Tips for tools are stored in `TIPS.md`.
