#!/bin/bash

# For mermaid diagrams which is used by LazyVim
npm install -g @mermaid-js/mermaid-cli

# For colorscripts which is used by the LazyVim Github dashboard
cd ~/
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install

# TODO: add cloning nuscripts to ~/.config dir

# copy all configs to home directory
mkdir -p ~/.config
cp -r .config ~/

# copy starship config
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# copy wezterm config
cp .wezterm.lua ~/

# copy tmux config
cp .tmux.conf ~/

# copy nushell config to correct path
cp config.nu ~/Library/Application Support/nushell/

# once nushell is installed and carapace
## ~/.config/nushell/env.nu
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
