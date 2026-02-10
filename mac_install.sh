#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

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

# Clone nu_scripts for nushell themes
if [ ! -d "$HOME/.config/nu_scripts" ]; then
  git clone https://github.com/nushell/nu_scripts.git "$HOME/.config/nu_scripts"
fi

# Install Operator Mono Lig font for wezterm
if [ ! -d "$HOME/vscode_operator_mono_lig" ]; then
  git clone https://github.com/willfore/vscode_operator_mono_lig.git "$HOME/vscode_operator_mono_lig"
fi
mkdir -p "$HOME/Library/Fonts"
cp "$HOME/vscode_operator_mono_lig/fonts/"*.otf "$HOME/Library/Fonts/" 2>/dev/null
cp "$HOME/vscode_operator_mono_lig/fonts/"*.ttf "$HOME/Library/Fonts/" 2>/dev/null

# copy all configs to home directory
mkdir -p ~/.config
cp -r "$DOTFILES_DIR/.config" ~/

# copy starship config
if command -v starship &> /dev/null; then
  mkdir -p "$HOME/Library/Application Support/nushell/vendor/autoload"
  starship init nu > "$HOME/Library/Application Support/nushell/vendor/autoload/starship.nu"
else
  echo "starship not found, skipping starship init"
fi

# copy wezterm config
cp "$DOTFILES_DIR/.wezterm.lua" ~/

# copy tmux config
cp "$DOTFILES_DIR/.tmux.conf" ~/

# copy nushell config to correct path
mkdir -p "$HOME/Library/Application Support/nushell"
cp "$DOTFILES_DIR/config.nu" "$HOME/Library/Application Support/nushell/"

# generate zoxide init for nushell
if command -v zoxide &> /dev/null; then
  zoxide init nushell > "$HOME/.zoxide.nu"
else
  echo "zoxide not found, skipping zoxide init"
fi

# once nushell is installed and carapace
if command -v carapace &> /dev/null; then
  echo '$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"' >> "$HOME/Library/Application Support/nushell/env.nu"
  mkdir -p ~/.cache/carapace
  carapace _carapace nushell > ~/.cache/carapace/init.nu
else
  echo "carapace not found, skipping carapace init"
fi
