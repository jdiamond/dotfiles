#!/bin/sh
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES/nvim" ~/.config/nvim
echo "Linked nvim config"
