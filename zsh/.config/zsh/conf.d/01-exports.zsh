# Nur private Pfade hinzufügen, das OS liefert den Rest
path=(
  $HOME/bin
  $path
)
export PATH

export EDITOR='emacsclient -t -a ""'
export VISUAL='emacsclient -t -a ""'

# Lokalisierung
export LANG=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_CTYPE=de_DE.UTF-8

export SUDO_EDITOR='emacsclient -t -a ""'
