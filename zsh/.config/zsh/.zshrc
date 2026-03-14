# Module aus conf.d laden
if [ -d "$ZDOTDIR/conf.d" ]; then
  for file in "$ZDOTDIR/conf.d"/*.zsh; do
    source "$file"
  done
fi

# Lokale Anpassungen (nicht in Git)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
