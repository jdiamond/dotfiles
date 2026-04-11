#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

links=()
while IFS=: read -r src dst || [[ -n "$src" ]]; do
  [[ "$src" =~ ^[[:space:]]*# ]] && continue
  [[ -z "$src" ]] && continue
  dst="${dst/#\~/$HOME}"
  links+=("$DOTFILES/$src" "$dst")
done < "$DOTFILES/links.conf"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Format path for display
fmt_src() {
  echo "${1#"$DOTFILES"/}"
}

fmt_dst() {
  echo "${1/#$HOME/~}"
}

for ((i = 0; i < ${#links[@]}; i += 2)); do
  src="${links[i]}"
  dst="${links[i + 1]}"

  # Handle /* and /** patterns
  if [[ "$src" == *"/*" ]]; then
    src_dir="${src%/*}"
    pattern="*"
  elif [[ "$src" == *"/**" ]]; then
    src_dir="${src%/**}"
    pattern="**"
  else
    pattern=""
  fi

  if [[ -n "$pattern" ]]; then
    # Clean orphan symlinks pointing to deleted files in DOTFILES
    if [[ -d "$dst" ]]; then
      find "$dst" -type l | while read -r f; do
        target="$(readlink "$f" 2>/dev/null || true)"
        [[ "$target" == "$DOTFILES/"* ]] || continue
        [[ -e "$target" ]] || {
          rm "$f"
          printf "${YELLOW}-${RESET}  %s  →  %s\n" "$(fmt_src "$target")" "$(fmt_dst "$f")"
        }
      done
    fi

    # Link all files from src_dir
    mkdir -p "$dst"
    if [[ "$pattern" == "**" ]]; then
      find "$src_dir" -type f | while read -r f; do
        relpath="${f#"$src_dir"/}"
        dst_path="$dst/$relpath"
        src_path="$src_dir/$relpath"
        mkdir -p "$(dirname "$dst_path")"
        current="$(readlink "$dst_path" 2>/dev/null || true)"
        if [[ "$current" == "$src_path" ]]; then
          printf "${CYAN}=${RESET}  %s  →  %s\n" "$(fmt_src "$src_path")" "$(fmt_dst "$dst_path")"
        elif [[ -n "$current" ]] || [[ -e "$dst_path" ]]; then
          printf "${RED}✗${RESET}  %s  →  %s  ${RED}${BOLD}already exists${RESET}\n" "$(fmt_src "$src_path")" "$(fmt_dst "$dst_path")"
          exit 1
        else
          ln -s "$src_path" "$dst_path"
          printf "${GREEN}+${RESET}  %s  →  %s\n" "$(fmt_src "$src_path")" "$(fmt_dst "$dst_path")"
        fi
      done
    else
      for f in "$src_dir"/*; do
        [[ -e "$f" ]] || continue
        filename="$(basename "$f")"
        dst_path="$dst/$filename"
        src_path="$f"
        current="$(readlink "$dst_path" 2>/dev/null || true)"
        if [[ "$current" == "$src_path" ]]; then
          printf "${CYAN}=${RESET}  %s  →  %s\n" "$(fmt_src "$src_path")" "$(fmt_dst "$dst_path")"
        elif [[ -n "$current" ]] || [[ -e "$dst_path" ]]; then
          printf "${RED}✗${RESET}  %s  →  %s  ${RED}${BOLD}already exists${RESET}\n" "$(fmt_src "$src_path")" "$(fmt_dst "$dst_path")"
          exit 1
        else
          ln -s "$src_path" "$dst_path"
          printf "${GREEN}+${RESET}  %s  →  %s\n" "$(fmt_src "$src_path")" "$(fmt_dst "$dst_path")"
        fi
      done
    fi
  else
    # Direct link (file or directory)
    mkdir -p "$(dirname "$dst")"
    current="$(readlink "$dst" 2>/dev/null || true)"
    if [[ "$current" == "$src" ]]; then
      printf "${CYAN}=${RESET}  %s  →  %s\n" "$(fmt_src "$src")" "$(fmt_dst "$dst")"
    elif [[ -n "$current" ]] || [[ -e "$dst" ]]; then
      printf "${RED}✗${RESET}  %s  →  %s  ${RED}${BOLD}already exists${RESET}\n" "$(fmt_src "$src")" "$(fmt_dst "$dst")"
      exit 1
    else
      ln -s "$src" "$dst"
      printf "${GREEN}+${RESET}  %s  →  %s\n" "$(fmt_src "$src")" "$(fmt_dst "$dst")"
    fi
  fi
done