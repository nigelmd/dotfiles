#!/bin/bash
# mac_install.sh — bootstrap and/or relink dotfiles on macOS.
#
# Usage:
#   mac_install.sh              # full install: brew + fonts + caches + symlinks
#   mac_install.sh --links-only # only re-run the symlink loop (no brew/fonts/caches)
#
# --links-only is for machines that already have everything installed and
# just need symlinks (re)created — e.g. migrating an existing machine from
# the old cp-based flow, or picking up new entries after a git pull.

set -e
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

LINKS_ONLY=false
if [[ "${1:-}" == "--links-only" ]]; then
  LINKS_ONLY=true
fi

if ! $LINKS_ONLY; then
  # Install Homebrew if not present
  if ! command -v /opt/homebrew/bin/brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Install Brewfile dependencies
  echo "Installing Brewfile dependencies..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"

  # For mermaid diagrams which is used by LazyVim
  if command -v npm &> /dev/null; then
    mkdir -p "$HOME/.npm-global"
    npm config set prefix "$HOME/.npm-global"
    export PATH="$HOME/.npm-global/bin:$PATH"
    npm install -g @mermaid-js/mermaid-cli
  else
    echo "npm not found, skipping mermaid-cli install"
  fi

  # For colorscripts which is used by the LazyVim Github dashboard
  if [ ! -d "$HOME/shell-color-scripts" ]; then
    git clone https://gitlab.com/dwt1/shell-color-scripts.git "$HOME/shell-color-scripts"
  fi
  cd "$HOME/shell-color-scripts"
  sudo make install
  cd "$DOTFILES_DIR"

  # Clone nu_scripts for nushell themes
  if [ ! -d "$HOME/.config/nu_scripts" ]; then
    git clone https://github.com/nushell/nu_scripts.git "$HOME/.config/nu_scripts"
  fi

  # Install Operator Mono Lig font for wezterm
  if [ ! -d "$HOME/vscode_operator_mono_lig" ]; then
    git clone https://github.com/willfore/vscode_operator_mono_lig.git "$HOME/vscode_operator_mono_lig"
  fi
  mkdir -p "$HOME/Library/Fonts"
  # `|| true` so unmatched globs don't trip `set -e` if the upstream repo
  # only ships one of {otf, ttf} (or restructures).
  cp "$HOME/vscode_operator_mono_lig/fonts/"*.otf "$HOME/Library/Fonts/" 2>/dev/null || true
  cp "$HOME/vscode_operator_mono_lig/fonts/"*.ttf "$HOME/Library/Fonts/" 2>/dev/null || true

  # Starship init for nushell — auto-generated, not symlinked
  if command -v starship &> /dev/null; then
    mkdir -p "$HOME/Library/Application Support/nushell/vendor/autoload"
    starship init nu > "$HOME/Library/Application Support/nushell/vendor/autoload/starship.nu"
  else
    echo "starship not found, skipping starship init"
  fi

  # Zoxide init for nushell — auto-generated, not symlinked
  if command -v zoxide &> /dev/null; then
    zoxide init nushell > "$HOME/.zoxide.nu"
  else
    echo "zoxide not found, skipping zoxide init"
  fi

  # Carapace cache regen — auto-generated, not symlinked
  if command -v carapace &> /dev/null; then
    mkdir -p ~/.cache/carapace
    carapace _carapace nushell > ~/.cache/carapace/init.nu
  else
    echo "carapace not found, skipping carapace init"
  fi
fi

# Symlink dotfiles into $HOME. Existing real files at destinations are
# backed up with a timestamp before being replaced by the symlink. Each
# call is idempotent and safe to re-run.
link_into_home() {
  local src="$1"
  local dst="$2"
  local src_full="$DOTFILES_DIR/$src"
  local dst_full="$HOME/$dst"

  mkdir -p "$(dirname "$dst_full")"

  if [ -e "$dst_full" ] && [ ! -L "$dst_full" ]; then
    local backup="$dst_full.backup-$(date +%Y%m%d%H%M%S)"
    mv "$dst_full" "$backup"
    echo "Backed up existing $dst_full to $backup"
  fi

  ln -sfn "$src_full" "$dst_full"
  echo "Linked $src -> $dst_full"
}

link_into_home ".tmux.conf"                    ".tmux.conf"
link_into_home ".wezterm.lua"                  ".wezterm.lua"
link_into_home ".config/starship.toml"         ".config/starship.toml"
link_into_home ".config/sesh"                  ".config/sesh"
link_into_home ".config/nvim"                  ".config/nvim"
link_into_home "bin/get-secret"                ".local/bin/get-secret"
link_into_home ".claude/settings.json"         ".claude/settings.json"
link_into_home ".claude/CLAUDE.md"             ".claude/CLAUDE.md"
link_into_home ".claude/statusline-command.sh" ".claude/statusline-command.sh"

# Nushell config — OS-aware destination (macOS doesn't follow XDG)
case "$(uname -s)" in
  Darwin)
    link_into_home ".config/nushell/config.nu" "Library/Application Support/nushell/config.nu"
    ;;
  *)
    link_into_home ".config/nushell/config.nu" ".config/nushell/config.nu"
    ;;
esac
