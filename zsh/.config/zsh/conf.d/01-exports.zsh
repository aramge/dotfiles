# Pfad-Handling: Einzigartige Einträge (U) und automatische Bindung an $PATH
typeset -U path
path=(
  $HOME/.local/bin
  $path
)

# Editor-Setup
export EDITOR='emacsclient -t -a ""'
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"

# Lokalisierung (Mixed-Setup: US-System, DE-Formatierung)
export LANG=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_CTYPE=de_DE.UTF-8
