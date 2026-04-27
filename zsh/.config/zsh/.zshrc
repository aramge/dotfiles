# Fallback für ZDOTDIR und sicheres Globbing mit (N)
local conf_dir="${ZDOTDIR:-$HOME/.config/zsh}/conf.d"

if [[ -d "$conf_dir" ]]; then
  for file in "$conf_dir"/*.zsh(N); do
    source "$file"
  done
fi

# Lokale Anpassungen (nicht in Git)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
