#!/bin/bash
# Sync current Omarchy/user config into the dotfiles repo and commit changes.
# Usage: ~/.dotfiles/save.sh [commit-message]

set -euo pipefail

REPO="${DOTFILES_REPO:-$HOME/.dotfiles}"
cd "$REPO"

sync_tree() {
  local src="$1" dst="$2"
  shift 2
  mkdir -p "$dst"
  rsync -a --delete "$@" "$src/" "$dst/"
}

# ~/.config trees -> repo/config/...
sync_tree "$HOME/.config/hypr" "$REPO/config/hypr" \
  --exclude='*.bak.*' --exclude='*.tmp'
sync_tree "$HOME/.config/omarchy" "$REPO/config/omarchy" \
  --exclude='*.bak.*' --exclude='plugins/*/.git' --exclude='.git'

# Custom scripts and launcher entry -> repo/local/...
mkdir -p "$REPO/local/bin" "$REPO/local/share/applications"
for bin in omarchy-monitor-settings omarchy-hyprland-window-move-monitor; do
  if [[ -f $HOME/.local/bin/$bin ]]; then
    cp -a "$HOME/.local/bin/$bin" "$REPO/local/bin/"
  fi
done
[[ -f "$HOME/.local/share/applications/Monitor Settings.desktop" ]] &&
  cp -a "$HOME/.local/share/applications/Monitor Settings.desktop" "$REPO/local/share/applications/"

git add -A
if git diff --cached --quiet; then
  echo "Nothing changed since last backup."
else
  git commit -m "${1:-backup $(date --iso-8601=seconds)}"
  echo "Committed."
fi
