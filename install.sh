#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

source "$DOTFILES/links.conf"

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
        [[ -e "$target" ]] || { rm "$f" && echo "Removed orphan: $f"; }
      done
    fi

    # Link all files from src_dir
    mkdir -p "$dst"
    if [[ "$pattern" == "**" ]]; then
      find "$src_dir" -type f | while read -r f; do
        relpath="${f#$src_dir/}"
        dst_path="$dst/$relpath"
        src_path="$src_dir/$relpath"
        mkdir -p "$(dirname "$dst_path")"
        current="$(readlink "$dst_path" 2>/dev/null || true)"
        if [[ "$current" == "$src_path" ]]; then
          echo "Already linked: $dst_path -> $src_path"
        elif [[ -n "$current" ]] || [[ -e "$dst_path" ]]; then
          echo "ERROR: $dst_path -> $current (expected $src_path)" >&2
          exit 1
        else
          ln -s "$src_path" "$dst_path"
          echo "Linked: $dst_path -> $src_path"
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
          echo "Already linked: $dst_path -> $src_path"
        elif [[ -n "$current" ]] || [[ -e "$dst_path" ]]; then
          echo "ERROR: $dst_path -> $current (expected $src_path)" >&2
          exit 1
        else
          ln -s "$src_path" "$dst_path"
          echo "Linked: $dst_path -> $src_path"
        fi
      done
    fi
  else
    # Direct link (file or directory)
    mkdir -p "$(dirname "$dst")"
    current="$(readlink "$dst" 2>/dev/null || true)"
    if [[ "$current" == "$src" ]]; then
      echo "Already linked: $dst -> $src"
    elif [[ -n "$current" ]] || [[ -e "$dst" ]]; then
      echo "ERROR: $dst -> $current (expected $src)" >&2
      exit 1
    else
      ln -s "$src" "$dst"
      echo "Linked: $dst -> $src"
    fi
  fi
done
