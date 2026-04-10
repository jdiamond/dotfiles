#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

links=(
  "$DOTFILES/bat/config"         "$HOME/.config/bat/config"
  "$DOTFILES/bat/themes"         "$HOME/.config/bat/themes"
  "$DOTFILES/bin/check-updates"  "$HOME/.local/bin/check-updates"
  "$DOTFILES/bin/ghostty-tab"   "$HOME/.local/bin/ghostty-tab"
  "$DOTFILES/bin/tip"            "$HOME/.local/bin/tip"
  "$DOTFILES/ghostty/config"     "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  "$DOTFILES/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
  "$DOTFILES/lazygit/themes"     "$HOME/Library/Application Support/lazygit/themes"
  "$DOTFILES/git/hooks/pre-commit" "$DOTFILES/.git/hooks/pre-commit"
  "$DOTFILES/npm/npmrc"            "$HOME/.npmrc"
  "$DOTFILES/nvim"                 "$HOME/.config/nvim"
  "$DOTFILES/yazi"                 "$HOME/.config/yazi"
  "$DOTFILES/television/config.toml" "$HOME/.config/television/config.toml"
  "$DOTFILES/zsh/zshrc"            "$HOME/.zshrc"
)

for ((i=0; i<${#links[@]}; i+=2)); do
  src="${links[i]}"
  dst="${links[i+1]}"
  mkdir -p "$(dirname "$dst")"
  current="$(readlink "$dst" 2>/dev/null || true)"
  if [ "$current" = "$src" ]; then
    echo "Already linked: $dst -> $src"
  elif [ -n "$current" ] || [ -e "$dst" ]; then
    echo "ERROR: $dst -> $current (expected $src)" >&2
    exit 1
  else
    ln -s "$src" "$dst"
    echo "Linked: $dst -> $src"
  fi
done

