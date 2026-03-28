# Catppuccin Mocha Farben für den Prompt
local c_blue="#89b4fa"
local c_green="#a6e3a1"
local c_red="#f38ba8"
local c_text="#cdd6f4"
local c_subtext="#a6adc8"

function git_prompt_info() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  local branch=${ref#refs/heads/}

  local upstream=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)
  local status_info=""
  
  if [[ -n "$upstream" ]]; then
    local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
    local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
    [ "$ahead" -gt 0 ] && status_info+="↑${ahead}"
    [ "$behind" -gt 0 ] && status_info+="↓${behind}"
  fi

  echo "%F{$c_blue}git:(${branch}${status_info})%f"
}

if [ "$UID" -eq 0 ]; then
  COLOR="%F{$c_red}"
  SYMBOL="#"
else
  COLOR="%F{$c_green}"
  SYMBOL="$"
fi

PROMPT="${COLOR}%n%f@%F{$c_subtext}%m%f:%F{$c_text}%~ ${COLOR}${SYMBOL}%f "
RPROMPT='$(git_prompt_info)'

if [[ -n "$TMUX" ]]; then
  tmux_preexec() {
    local cmd=(${(z)1})
    if [[ "$cmd[1]" == "ssh" ]]; then
      local target=$cmd[-1]
      tmux rename-window "ssh:${target#*@}"
    else
      tmux setw automatic-rename on
    fi
  }

  tmux_precmd() {
    tmux setw automatic-rename on
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec tmux_preexec
  add-zsh-hook precmd tmux_precmd
fi
