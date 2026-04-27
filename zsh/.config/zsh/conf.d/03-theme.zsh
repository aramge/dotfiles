# Farben definieren
local c_blue="#89b4fa"
local c_green="#a6e3a1"
local c_red="#f38ba8"
local c_text="#cdd6f4"
local c_subtext="#a6adc8"

# Eingebautes Git-Modul laden
# autoload -Uz vcs_info
# zstyle ':vcs_info:*' enable git
# zstyle ':vcs_info:git:*' formats "%F{$c_blue}git:(%b)%f"

# Wird nur einmal vor jedem Prompt-Zeichnen ausgeführt
# precmd() {
#   vcs_info
# }

# Prompt-Design (KISS)
if [ "$UID" -eq 0 ]; then
  COLOR="%F{$c_red}"
  SYMBOL="#"
else
  COLOR="%F{$c_green}"
  SYMBOL="$"
fi

PROMPT="${COLOR}%n%f@%F{$c_subtext}%m%f:%F{$c_text}%~ ${COLOR}${SYMBOL}%f "
# RPROMPT='${vcs_info_msg_0_}'

# Tmux Fenster-Rename
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
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec tmux_preexec
fi
