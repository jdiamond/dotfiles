# Zsh Config

`zshrc` is symlinked to `~/.zshrc` by `install.sh`.

## Local overrides

Two files can be created on each machine (not tracked in git):

- **`~/.zshrc.local`** — machine-specific config (aliases, tools, PATH additions, etc.)
- **`~/.zshrc.secrets`** — secrets and credentials (`chmod 600 ~/.zshrc.secrets`)
