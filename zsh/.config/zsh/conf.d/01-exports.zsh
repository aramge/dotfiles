# Universelle Basispfade
path=(
  $HOME/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $path
)
export PATH

export EDITOR='vim'
export VISUAL='vim'

# Lokalisierung
export LANG=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_CTYPE=de_DE.UTF-8

# Spezieller Editor für sudoedit (nutzt deinen Emacs-Alias)
export SUDO_EDITOR='emacsclient -t -a ""'
