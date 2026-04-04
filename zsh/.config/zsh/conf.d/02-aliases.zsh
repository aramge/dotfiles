alias a='abduco -e "^t" -A main zsh'
alias jail='echo "STOPP: Nutze stattdessen -> service jail [start|stop|restart] <name>"'
alias se='sudo -e'
alias ssh='TERM=xterm-256color ssh'
alias todo="e ~/sync/gh/todo/todo.org"
alias vi='vim'
alias wd='sudo systemctl stop wg-quick-wg0'
alias wu='sudo systemctl start wg-quick-wg0'

# --- Emacs Multi-OS Alias (Bulletproof) ---
case "$OSTYPE" in
  linux*)
    alias e='emacsclient -nw --socket-name=/run/user/$(id -u)/emacs/server -a ""'
    ;;
  darwin*)  
    if [ -S "/tmp/emacs$(id -u)/server" ]; then
      alias e='emacsclient -nw --socket-name=/tmp/emacs$(id -u)/server -a ""'
    else
      alias e='emacsclient -nw --socket-name="${TMPDIR%/}/emacs$(id -u)/server" -a ""'
    fi
    ;;
  freebsd*)
    alias e='emacsclient -nw --socket-name=/tmp/emacs$(id -u)/server -a ""'
    ;;
esac
# ------------------------------------------
