# NixOS/nix-darwin verwalten Plugins nativ.
# Fallback-Sourcing nur für Debian und FreeBSD:
if [[ ! -d /nix ]]; then
  for base in "/usr/local/share" "/usr/share"; do
    [ -f "$base/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$base/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$base/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$base/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  done
fi

autoload -Uz compinit
compinit
