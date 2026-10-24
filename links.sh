# links.sh — the repo-file -> $HOME symlink map, sourced by mac_install.sh and
# check-symlinks.sh so the two cannot drift. Format: "src-in-repo|dst-relative-to-HOME".
MAPPINGS=(
  ".tmux.conf|.tmux.conf"
  ".zshrc|.zshrc"
  ".wezterm.lua|.wezterm.lua"
  ".config/starship.toml|.config/starship.toml"
  ".config/sesh|.config/sesh"
  ".config/nvim|.config/nvim"
  "bin/get-secret|.local/bin/get-secret"
  "bin/theme|.local/bin/theme"
  "bin/pick-agent|.local/bin/pick-agent"
  ".claude/settings.json|.claude/settings.json"
  ".claude/CLAUDE.md|.claude/CLAUDE.md"
  ".claude/statusline-command.sh|.claude/statusline-command.sh"
  ".claude/themes|.claude/themes"
)
# nushell destination is OS-aware (macOS doesn't follow XDG)
if [[ "$(uname -s)" == "Darwin" ]]; then
  MAPPINGS+=(".config/nushell/config.nu|Library/Application Support/nushell/config.nu")
else
  MAPPINGS+=(".config/nushell/config.nu|.config/nushell/config.nu")
fi
