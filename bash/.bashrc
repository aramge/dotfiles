case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=2000
HISTFILESIZE=2000
shopt -s checkwinsize
shopt -s globstar

set -o emacs

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export EDITOR='emacsclient -t -a ""'
export VISUAL='emacsclient -t -a ""'
export LANG=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_CTYPE=de_DE.UTF-8
export SUDO_EDITOR='emacsclient -t -a ""'

alias sha256="shasum -a 256"
alias jail='echo "STOPP: Nutze stattdessen -> service jail [start|stop|restart] <name>"'
alias vi='vim'
alias e='emacsclient -t -a ""'
alias ssh='TERM=xterm-256color ssh'
alias se='sudo -e'

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

if [ "$UID" -eq 0 ]; then
  PS1='\[\e[31m\]\u\[\e[0m\]@\h:\w \[\e[31m\]#\[\e[0m\] '
else
  PS1='\[\e[32m\]\u\[\e[0m\]@\h:\w \[\e[32m\]$\[\e[0m\] '
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f "$HOME/.bashrc.local" ]; then
  source "$HOME/.bashrc.local"
fi
