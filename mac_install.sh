#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# For mermaid diagrams which is used by LazyVim
if command -v npm &> /dev/null; then
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

# TODO: add cloning nuscripts to ~/.config dir

# Install Operator Mono Lig font for wezterm
if [ ! -d "$HOME/vscode_operator_mono_lig" ]; then
  git clone https://github.com/willfore/vscode_operator_mono_lig.git "$HOME/vscode_operator_mono_lig"
fi
cp "$HOME/vscode_operator_mono_lig/src/fonts/"*.otf "$HOME/Library/Fonts/" 2>/dev/null
cp "$HOME/vscode_operator_mono_lig/src/fonts/"*.ttf "$HOME/Library/Fonts/" 2>/dev/null

# copy all configs to home directory
mkdir -p ~/.config
cp -r "$DOTFILES_DIR/.config" ~/

# copy starship config
mkdir -p "$HOME/Library/Application Support/nushell/vendor/autoload"
starship init nu > "$HOME/Library/Application Support/nushell/vendor/autoload/starship.nu"

# copy wezterm config
cp "$DOTFILES_DIR/.wezterm.lua" ~/

# copy tmux config
cp "$DOTFILES_DIR/.tmux.conf" ~/

# copy nushell config to correct path
cp "$DOTFILES_DIR/config.nu" "$HOME/Library/Application Support/nushell/"

# once nushell is installed and carapace
## ~/.config/nushell/env.nu
echo '$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"' >> "$HOME/Library/Application Support/nushell/env.nu"
mkdir -p ~/.cache/carapace
carapace _carapace nushell > ~/.cache/carapace/init.nu
