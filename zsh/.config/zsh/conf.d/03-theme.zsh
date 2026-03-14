autoload -U colors && colors

function git_prompt_info() {
  local ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  local branch=${ref#refs/heads/}
  local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)

  local status_info=""
  [ "$ahead" -gt 0 ] && status_info+="↑${ahead}"
  [ "$behind" -gt 0 ] && status_info+="↓${behind}"

  echo "%{$fg[blue]%}git:(${branch}${status_info})%{$reset_color%}"
}

if [ "$UID" -eq 0 ]; then
  COLOR="%{$fg[red]%}"
  SYMBOL="#"
else
  COLOR="%{$fg[green]%}"
  SYMBOL="$"
fi

PROMPT="${COLOR}%n%{$reset_color%}%f@%m:%~ ${COLOR}${SYMBOL}%{$reset_color%} "
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
