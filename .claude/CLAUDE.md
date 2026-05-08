# Global Claude Code Instructions

## Search Tools

- **NEVER** use `grep` or `rg` as Bash commands. Always use the built-in `Grep` tool (which uses ripgrep internally) for all content searches.
- **NEVER** use `find` or the built-in `Glob` tool. Always use `fzf` for file pattern matching.
