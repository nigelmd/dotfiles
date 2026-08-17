#!/bin/bash
# check-symlinks.sh — preview what mac_install.sh's symlink step would do.
# Read-only by default. Pass --backup to also copy every real destination to
# a timestamped .backup-* file before you run the real install.
#
# Mirrors the link_into_home mappings in mac_install.sh. Run from anywhere.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
DO_BACKUP=false
[[ "${1:-}" == "--backup" ]] && DO_BACKUP=true

# src-in-repo  ->  dst-relative-to-$HOME
MAPPINGS=(
  ".tmux.conf|.tmux.conf"
  ".wezterm.lua|.wezterm.lua"
  ".config/starship.toml|.config/starship.toml"
  ".config/sesh|.config/sesh"
  ".config/nvim|.config/nvim"
  "bin/get-secret|.local/bin/get-secret"
  ".claude/settings.json|.claude/settings.json"
  ".claude/CLAUDE.md|.claude/CLAUDE.md"
  ".claude/statusline-command.sh|.claude/statusline-command.sh"
)
# nushell dest is OS-aware
if [[ "$(uname -s)" == "Darwin" ]]; then
  MAPPINGS+=(".config/nushell/config.nu|Library/Application Support/nushell/config.nu")
else
  MAPPINGS+=(".config/nushell/config.nu|.config/nushell/config.nu")
fi

for entry in "${MAPPINGS[@]}"; do
  src="${entry%%|*}"
  dst="${entry##*|}"
  src_full="$DOTFILES_DIR/$src"
  dst_full="$HOME/$dst"

  echo "============================================================"
  echo "DEST: $dst_full"

  if [ ! -e "$dst_full" ] && [ ! -L "$dst_full" ]; then
    echo "  STATUS: missing — symlink will be created fresh (nothing to lose)"
    continue
  fi

  if [ -L "$dst_full" ]; then
    echo "  STATUS: already a symlink -> $(readlink "$dst_full")"
    echo "          (will be replaced by ln -sfn; harmless)"
    continue
  fi

  # A real file or dir lives here — this is what mac_install.sh would back up.
  if [ -d "$dst_full" ]; then
    echo "  STATUS: REAL DIRECTORY — will be backed up, then replaced by a symlink"
    echo "  files inside:"
    ls -la "$dst_full"
  else
    echo "  STATUS: REAL FILE — will be backed up, then replaced by a symlink"
    echo "  diff (< current live   |   > repo version):"
    if diff "$dst_full" "$src_full" >/dev/null 2>&1; then
      echo "    (identical — no content change)"
    else
      diff "$dst_full" "$src_full"
    fi
  fi

  if $DO_BACKUP; then
    backup="$dst_full.backup-$(date +%Y%m%d%H%M%S)"
    cp -R "$dst_full" "$backup"
    echo "  BACKED UP -> $backup"
  fi
done
echo "============================================================"
echo "Done. Nothing was changed${DO_BACKUP:+ except backups were created}."
