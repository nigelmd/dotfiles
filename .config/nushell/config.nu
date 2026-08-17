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
path add '~/.local/bin'
path add '~/.npm-global/bin'

use ~/.config/nu_scripts/themes/nu-themes/frontend-galaxy.nu
$env.config.color_config = (frontend-galaxy)

$env.config.buffer_editor = "/opt/homebrew/bin/nvim"
$env.config.show_banner = false
$env.config.edit_mode = 'vi'

# $env.LS_COLORS = (vivid generate catppuccin-macchiato)
# $env.LS_COLORS = (nu-themes generate frontend-galaxy)

# $env.FZF_DEFAULT_COMMAND = 'rg --hidden'
$env.FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --glob "!{.git/*}"'
$env.FZF_DEFAULT_OPTS = "--tmux 80%,80% --preview 'bat --style=numbers --color=always {}' | xargs -n 1 nvim"

# for npm
let NVM_DIR = ($nu.home-dir | path join ".nvm")
$env.NVM_DIR = $NVM_DIR

alias gs = git status
# alias claude = ~/.claude/local/claude

# alias fzz = [] { fzf --preview 'bat --style=numbers --color=always {}' | lines | each { |file| nvim $file } }
# alias fzz = fzf --preview 'bat --style=numbers --color=always {}' | str trim | xargs -n 1 nvim
# def fzz [] { fzf --ansi --preview 'bat --style=numbers --color=always {}' | str trim | nvim $in }
# alias tm = tmux attach -t init; if $env.LAST_EXIT_CODE != 0 { tmux -2 new-session -s init }
# alias tm = (tmux attach -t init) or (tmux -2 new-session -s init)
# alias tm = try { tmux attach -t init } catch { tmux -2 new-session -s init }

# for direnv
$env.config.hooks = {
    pre_prompt: [{ ||
        if (which direnv | is-empty) { return }
        direnv export json | from json | default {} | load-env
        if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
            $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
        }
    }]
}


# let HOSTNAME = (hostname)
# $env.HOSTNAME = $HOSTNAME


# $env.ARGC_COMPLETIONS_ROOT = '/Users/nigeldsouza/argc-completions'
# $env.ARGC_COMPLETIONS_PATH = ($env.ARGC_COMPLETIONS_ROOT + '/completions/macos:' + $env.ARGC_COMPLETIONS_ROOT + '/completions')
# $env.PATH = ($env.PATH | prepend ($env.ARGC_COMPLETIONS_ROOT + '/bin'))
# argc --argc-completions nushell | save -f '/Users/nigeldsouza/argc-completions/tmp/argc-completions.nu'
# source '/Users/nigeldsouza/argc-completions/tmp/argc-completions.nu'

#~/.config/nushell/config.nu

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

$env.config.completions.external = {
    enable: true
    max_results: 100
    completer: {|spans: list<string>|
        let result = (do { ^carapace $spans.0 nushell ...$spans } | complete)
        if $result.exit_code != 0 { return null }
        let parsed = (try { $result.stdout | from json } catch { null })
        if $parsed == null or ($parsed | is-empty) { return null }
        $parsed | each {|row|
            let v = ($row | get --optional value)
            # carapace (1.7.0) emits tilde paths with the `~` outside the quotes, e.g.
            # `~"/Library/Application Support/"`. Nushell parses neither that nor
            # `"~/Library/Application Support"` -- only an expanded, quoted path works.
            # So expand the tilde first, then quote. Everything else carapace quotes
            # is already valid nushell (absolute paths, names with `&`) and is left
            # alone -- rewriting those turned relative paths into quoted absolute ones.
            if $v != null and (($v | describe) starts-with 'string') and ($v | str starts-with '~') and ('"' in $v) {
                # carapace appends a trailing space to signal a finished completion
                let trailing = if ($v | str ends-with ' ') { ' ' } else { '' }
                let cleaned = ($v | str replace --all '"' '' | str trim | path expand --no-symlink)
                let quoted = if (' ' in $cleaned) { $"'($cleaned)'" } else { $cleaned }
                $row | upsert value $"($quoted)($trailing)"
            } else {
                $row
            }
        }
    }
}

source ~/.cache/carapace/init.nu

def --env load-secret [name: string, env_var: string] {
    # Call get-secret by absolute path so this works regardless of PATH ordering.
    let bin = ($env.HOME | path join ".local/bin/get-secret")
    if ($bin | path exists) {
        let result = (do { ^$bin $name } | complete)
        if $result.exit_code == 0 {
            load-env { ($env_var): ($result.stdout | str trim) }
        }
    }
}

load-secret "github_token" "GITHUB_PERSONAL_ACCESS_TOKEN"

# should be at end of file
source ~/.zoxide.nu
