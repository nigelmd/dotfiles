# dotfiles

## Prerequisites

- macOS (Apple Silicon)
- Node.js (for mermaid-cli used by LazyVim)

## For Mac

    git clone https://github.com/nigelmd/dotfiles.git
    cd dotfiles
    ./mac_install.sh

The install script handles:

- Installing Homebrew (if not present)
- Installing all Brewfile dependencies (nushell, neovim, starship, zoxide, carapace, wezterm, etc.)
- Installing Operator Mono Lig font
- Copying configs for nvim, wezterm, tmux, nushell, and starship
- Setting up zoxide and carapace init files for nushell
- Installing shell-color-scripts for the LazyVim dashboard
- Installing nu_scripts for nushell themes

## For Linux (legacy)

    git clone https://github.com/nigelmd/dotfiles.git
    cd dotfiles
    ./setup.sh
