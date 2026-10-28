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
  # Homebrew ignores third-party taps until they are trusted (Tap-Trust, 2026)
  if brew trust --help >/dev/null 2>&1; then
    awk -F'"' '/^tap /{print $2}' "$DOTFILES_DIR/Brewfile" | xargs -n1 brew trust
  fi
  brew bundle --file="$DOTFILES_DIR/Brewfile"

  # For mermaid diagrams which is used by LazyVim
  if command -v npm &> /dev/null; then
    mkdir -p "$HOME/.npm-global"
    npm config set prefix "$HOME/.npm-global"
    export PATH="$HOME/.npm-global/bin:$PATH"
    # npm blocks puppeteer's postinstall (Chromium download) unless allowed
    npm install -g --allow-scripts=puppeteer @mermaid-js/mermaid-cli
  else
    echo "npm not found, skipping mermaid-cli install"
  fi

  # For colorscripts which is used by the LazyVim Github dashboard
  if [ ! -d "$HOME/shell-color-scripts" ]; then
    git clone https://gitlab.com/dwt1/shell-color-scripts.git "$HOME/shell-color-scripts"
  fi
  cd "$HOME/shell-color-scripts"
  sudo mkdir -p /usr/local/bin # absent on a fresh Apple Silicon Mac; the Makefile copies into it
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

  # oh-my-zsh: zsh stays the login shell (ssh lands here); .zshrc is symlinked from the repo
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

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

# Claude Code writes a machine-specific, repo-harvested autoMode block into the
# user settings file. Keep it out of the repo: the clean filter drops it on add.
git -C "$DOTFILES_DIR" config filter.stripAutoMode.clean 'jq "del(.autoMode)"'

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

source "$DOTFILES_DIR/links.sh"
for entry in "${MAPPINGS[@]}"; do
  link_into_home "${entry%%|*}" "${entry##*|}"
done

# seed the theme file and the live-reloaded Claude theme through the one writer
[ -f "$HOME/.config/theme" ] || "$HOME/.local/bin/theme" mocha
