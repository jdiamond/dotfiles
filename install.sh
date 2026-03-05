#!/bin/sh
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES/nvim" ~/.config/nvim
echo "Linked nvim config"

mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
ln -sf "$DOTFILES/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
echo "Linked ghostty config"
