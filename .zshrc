# zsh is the login shell (ssh lands here); interactive work happens in nushell.
export PATH="$HOME/.local/bin:$PATH" # theme, pick-agent, colorscript, claude
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh" # absent until mac_install.sh has run

# gpg pinentry needs the tty
export GPG_TTY=$(tty)
