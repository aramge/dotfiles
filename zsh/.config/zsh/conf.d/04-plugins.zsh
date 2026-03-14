PLUGIN_PATHS=("/opt/homebrew/share" "/usr/local/share" "/usr/share")

for base in "${PLUGIN_PATHS[@]}"; do
  [ -f "$base/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$base/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$base/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$base/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
done

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit
compinit
