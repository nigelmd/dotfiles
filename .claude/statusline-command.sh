#!/bin/bash
# Catppuccin statusline for Claude Code; palette follows ~/.config/theme (latte|mocha)
input=$(cat)

# ── data ────────────────────────────────────────────────────────────────────
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model_full=$(echo "$input" | jq -r '.model.display_name')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
worktree_raw=$(echo "$input" | jq -r '.workspace.git_worktree // empty')

dir=$(basename "$cwd")

# Abbreviate model name: strip "Claude " prefix and shorten known suffixes
model=$(echo "$model_full" \
  | sed 's/^Claude //' \
  | sed 's/ Sonnet$/ Son/' \
  | sed 's/ Haiku$/ Hai/' \
  | sed 's/ Opus$/ Opus/')

# Git info (skip optional lock to avoid blocking)
git_branch=$(cd "$cwd" 2>/dev/null && git -c gc.auto=0 branch --show-current 2>/dev/null)
git_dirty=""
if [ -n "$git_branch" ]; then
  git_dirty=$(cd "$cwd" 2>/dev/null && git -c gc.auto=0 status --porcelain 2>/dev/null)
fi

# Worktree: prefer JSON field, fall back to path heuristic
worktree_name=""
if [ -n "$worktree_raw" ]; then
  worktree_name="$worktree_raw"
else
  case "$cwd" in
    */.claude/worktrees/*)
      worktree_name=$(echo "$cwd" | sed 's|.*/.claude/worktrees/||' | cut -d'/' -f1) ;;
    */.worktrees/*)
      worktree_name=$(echo "$cwd" | sed 's|.*/.worktrees/||' | cut -d'/' -f1) ;;
  esac
fi

# ── palette: ~/.config/theme is written by ~/.local/bin/theme ───────────────
RESET="\033[0m"
if [ "$(cat "$HOME/.config/theme" 2>/dev/null)" = latte ]; then
  MAUVE="\033[38;2;136;57;239m"    # cwd / folder
  SKY="\033[38;2;4;165;229m"       # git branch
  GREEN="\033[38;2;64;160;43m"     # model / ctx 0-50%
  YELLOW="\033[38;2;223;142;29m"   # worktree / ctx 50-75%
  PEACH="\033[38;2;254;100;11m"    # ctx 75-90%
  RED="\033[38;2;210;15;57m"       # dirty marker / ctx 90-100%
  SURFACE2="\033[38;2;172;176;190m" # ctx bar empty cells
  SUBTEXT="\033[38;2;92;95;119m"   # separators / brackets
else # mocha
  MAUVE="\033[38;2;203;166;247m"
  SKY="\033[38;2;137;220;235m"
  GREEN="\033[38;2;166;227;161m"
  YELLOW="\033[38;2;249;226;175m"
  PEACH="\033[38;2;250;179;135m"
  RED="\033[38;2;243;139;168m"
  SURFACE2="\033[38;2;88;91;112m"
  SUBTEXT="\033[38;2;166;173;200m"
fi

# ── assemble segments ────────────────────────────────────────────────────────

# 1. folder  dir
printf "${SUBTEXT} ${MAUVE}%s${RESET}" "$dir"

# 2. git branch  branch [*]
if [ -n "$git_branch" ]; then
  if [ -n "$git_dirty" ]; then
    printf " ${SUBTEXT}•${RESET} ${SKY} %s${RED}*${RESET}" "$git_branch"
  else
    printf " ${SUBTEXT}•${RESET} ${SKY} %s${RESET}" "$git_branch"
  fi
fi

# 3. worktree indicator (only when inside a worktree)
if [ -n "$worktree_name" ]; then
  printf " ${SUBTEXT}•${RESET} ${YELLOW}⎇ %s${RESET}" "$worktree_name"
fi

# 4. model
printf " ${SUBTEXT}•${RESET} ${GREEN}%s${RESET}" "$model"

# 5. context window usage — colored block bar (only after first API call)
if [ -n "$ctx_used" ]; then
  ctx_int=$(printf "%.0f" "$ctx_used")

  # Pick fill color based on usage bracket
  if   [ "$ctx_int" -ge 90 ]; then bar_color="$RED"
  elif [ "$ctx_int" -ge 75 ]; then bar_color="$PEACH"
  elif [ "$ctx_int" -ge 50 ]; then bar_color="$YELLOW"
  else                              bar_color="$GREEN"
  fi

  # Build 10-cell bar: filled = round(ctx_int / 10), rest empty
  # Shell arithmetic truncates; add 5 before dividing to round properly.
  filled=$(( (ctx_int + 5) / 10 ))
  [ "$filled" -gt 10 ] && filled=10
  empty=$(( 10 - filled ))

  filled_str=""
  i=0
  while [ "$i" -lt "$filled" ]; do filled_str="${filled_str}█"; i=$((i+1)); done

  empty_str=""
  i=0
  while [ "$i" -lt "$empty" ]; do empty_str="${empty_str}░"; i=$((i+1)); done

  printf " ${SUBTEXT}[${bar_color}%s${SURFACE2}%s${SUBTEXT}]${RESET} ${bar_color}%d%%${RESET}" \
    "$filled_str" "$empty_str" "$ctx_int"
fi
