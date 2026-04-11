# Dotfiles

Personal configuration files for macOS.

## Usage

```bash
./sync.sh
```

Links files from this directory to their destinations. Safe to run multiple times - skips existing links and removes orphaned symlinks.

## Configuration

Edit `links.conf` to add or remove links:

```
nvim:~/.config/nvim
bat/*:~/.config/bat
television/**:~/.config/television
```

Paths are colon-separated. Source is relative to dotfiles directory.
Destination uses `~` for home or `/` for absolute.

Append `/*` to link directory contents, or `/**` for recursive linking.
Orphan symlinks are automatically removed for `/*` and `/**` patterns.

## Status output

| Symbol | Meaning |
|--------|---------|
| `=` | Already linked |
| `+` | Newly linked |
| `-` | Orphan removed |
| `✗` | Error (file exists, not a symlink) |
