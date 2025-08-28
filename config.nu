# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

use std/util "path add"
path add '/opt/homebrew/bin'
path add '/usr/local/bin'

use ~/.config/nu_scripts/themes/nu-themes/frontend-galaxy.nu
$env.config.color_config = (frontend-galaxy)

$env.config.buffer_editor = "/opt/homebrew/bin/nvim"
$env.config.show_banner = false

# $env.LS_COLORS = (vivid generate catppuccin-macchiato)
# $env.LS_COLORS = (nu-themes generate frontend-galaxy)

# $env.FZF_DEFAULT_COMMAND = 'rg --hidden'
$env.FZF_DEFAULT_COMMAND = 'rg --files --glob "!{.git/*}"'
$env.FZF_DEFAULT_OPTS = "--tmux 80%,80% --preview 'bat --style=numbers --color=always {}' | xargs -n 1 nvim"

alias legin = ssh legindaryphotos
alias olegin = ssh oraclegindary
alias personal = cd ~/Data/personal/
alias gs = git status
alias claude = ~/.claude/local/claude

# alias fzz = [] { fzf --preview 'bat --style=numbers --color=always {}' | lines | each { |file| nvim $file } }
# alias fzz = fzf --preview 'bat --style=numbers --color=always {}' | str trim | xargs -n 1 nvim
# def fzz [] { fzf --ansi --preview 'bat --style=numbers --color=always {}' | str trim | nvim $in }
# alias tm = tmux attach -t init; if $env.LAST_EXIT_CODE != 0 { tmux -2 new-session -s init }
# alias tm = (tmux attach -t init) or (tmux -2 new-session -s init)
# alias tm = try { tmux attach -t init } catch { tmux -2 new-session -s init }

# for direnv
$env.config = {
  hooks: {
      pre_prompt: [{ ||
          if (which direnv | is-empty) { return }
          direnv export json | from json | default {} | load-env
          if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
              $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
          }
      }]
  }
}

# should be at end of file
source ~/.zoxide.nu
