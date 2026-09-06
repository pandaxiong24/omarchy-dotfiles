#!/bin/bash
# Restore dotfiles from this repo onto this machine (fresh Omarchy install).
# Usage: ~/.dotfiles/install.sh [--dry-run]

set -euo pipefail

REPO="${DOTFILES_REPO:-$HOME/.dotfiles}"
cd "$REPO"

RESTORE="cp -a --no-preserve=mode"
[[ "${1:-}" == "--dry-run" ]] && DRY="-n" || DRY=""

restore_tree() {
  local src="$1" dst="$2"
  mkdir -p "$dst"
  rsync -a $DRY "$src/" "$dst/"
}

restore_tree "$REPO/config/hypr" "$HOME/.config/hypr"
restore_tree "$REPO/config/omarchy" "$HOME/.config/omarchy"

mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
for bin in "$REPO"/local/bin/*; do
  [[ -e $bin ]] && cp -a "$bin" "$HOME/.local/bin/" && chmod +x "$HOME/.local/bin/$(basename "$bin")"
done
[[ -d $REPO/local/share/applications ]] &&
  rsync -a $DRY "$REPO/local/share/applications/" "$HOME/.local/share/applications/"

# Hyprland picks up config changes on save; restart the shell for shell.json.
if [[ $DRY != "-n" ]] && command -v hyprctl >/dev/null; then
  hyprctl reload >/dev/null 2>&1 || true
fi
echo "Restored. If the Omarchy shell was customized, run: omarchy restart shell"
