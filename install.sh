#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

links=(
  "$DOTFILES/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  "$DOTFILES/nvim"           "$HOME/.config/nvim"
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
