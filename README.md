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
"$DOTFILES/nvim" "$HOME/.config/nvim"
"$DOTFILES/television/cable/*" "$HOME/.config/television/cable"
```

### Link patterns

| Pattern | Behavior |
|---------|----------|
| (none) | Direct link (file or directory) |
| `/*` | Link all items in directory, remove orphaned symlinks |
| `/**` | Recursive link, preserve directory structure |

## Status output

| Symbol | Meaning |
|--------|---------|
| `=` | Already linked |
| `+` | Newly linked |
| `-` | Orphan removed |
| `✗` | Error (file exists, not a symlink) |
