#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAGE=${1:-all}

checklink() {
  local source=$1 destination=$2 backup index=0
  [[ -e "$source" ]] || { echo "Missing source: $source" >&2; return 1; }
  mkdir -p "$(dirname "$destination")"
  if [[ -L "$destination" && "$source" -ef "$destination" ]]; then
    echo "Already linked: $destination"
    return
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    backup="$destination.backup"
    while [[ -e "$backup" || -L "$backup" ]]; do
      index=$((index + 1)); backup="$destination.backup.$index"
    done
    mv "$destination" "$backup"
    echo "Backed up: $destination -> $backup"
  fi
  ln -s "$source" "$destination"
}

createifno() {
  local file=$1 content=$2
  mkdir -p "$(dirname "$file")"
  touch "$file"
  if ! grep -Fqx -- "$content" "$file"; then
    # Start on a fresh line even when the existing file has no final newline.
    [[ ! -s "$file" ]] || printf '\n' >> "$file"
    printf '%s\n' "$content" >> "$file"
  fi
}

packages() {
  if ! command -v brew >/dev/null 2>&1; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    else
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    fi
  fi
  brew update
  # Bundle upgrades its declared dependencies and leaves unrelated packages alone.
  brew bundle install --file="$DOTFILES_DIR/Brewfile"
}

config() {
  checklink "$DOTFILES_DIR/vim/es.utf-8.spl" "$HOME/.vim/spell/es.utf-8.spl"
  checklink "$DOTFILES_DIR/vim/es.utf-8.sug" "$HOME/.vim/spell/es.utf-8.sug"
  checklink "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
  checklink "$DOTFILES_DIR/vim/init.vim" "$HOME/.config/nvim/init.vim"
  checklink "$DOTFILES_DIR/vim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"
  checklink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
  checklink "$DOTFILES_DIR/vifm/palenight.vifm" "$HOME/.config/vifm/colors/palenight.vifm"
  checklink "$DOTFILES_DIR/vifm/gruvbox.vifm" "$HOME/.config/vifm/colors/gruvbox.vifm"
  checklink "$DOTFILES_DIR/vifm/vifmrc" "$HOME/.config/vifm/vifmrc"
  checklink "$DOTFILES_DIR/bat/config" "$HOME/.config/bat/config"
  checklink "$DOTFILES_DIR/vim/ideavimrc" "$HOME/.ideavimrc"
  checklink "$DOTFILES_DIR/zsh/wezterm.lua" "$HOME/.wezterm.lua"
  createifno "$HOME/.zshrc" 'if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi'
  createifno "$HOME/.zshrc" 'source ~/dotfiles/zsh/zshrc'
  createifno "$HOME/.zshrc" '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'
  createifno "$HOME/.zshrc" 'command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"'
  mkdir -p "$HOME/.nvm"
  createifno "$HOME/.zshrc" 'export NVM_DIR="$HOME/.nvm"'
  createifno "$HOME/.zshrc" '[ ! -s "$(brew --prefix nvm)/nvm.sh" ] || source "$(brew --prefix nvm)/nvm.sh"'
  bash "$DOTFILES_DIR/scripts/global/git.sh"
}

keyboard() {
  if ! python3 "$DOTFILES_DIR/scripts/mac/check-karabiner-app.py"; then
    if brew list --cask karabiner-elements >/dev/null 2>&1; then
      brew upgrade --cask karabiner-elements
    else
      brew install --cask karabiner-elements
    fi
  fi
  if ! command -v karabiner-configurator >/dev/null 2>&1; then
    # Homebrew Python disallows global pip installs; isolate the external tool.
    python3 -m venv "$HOME/.local/share/dotfiles/karabiner-venv"
    source "$HOME/.local/share/dotfiles/karabiner-venv/bin/activate"
    python3 -m pip install karabiner-configurator
  fi
  python3 "$DOTFILES_DIR/scripts/mac/check-karabiner.py"
  karabiner-configurator "$DOTFILES_DIR/karabiner/" --no-html -v
}

check() {
  if [[ -x "$HOME/.local/share/dotfiles/karabiner-venv/bin/karabiner-configurator" ]]; then
    source "$HOME/.local/share/dotfiles/karabiner-venv/bin/activate"
  fi
  brew bundle check --verbose --file="$DOTFILES_DIR/Brewfile"
  python3 "$DOTFILES_DIR/scripts/mac/check-karabiner-app.py"
  python3 "$DOTFILES_DIR/scripts/mac/check-karabiner.py" --exact
  "$HOME/venvs/nvim3/bin/python" -c 'import pynvim'
  local entry source destination failed=0
  while IFS='|' read -r source destination; do
    if [[ ! -L "$HOME/$destination" || ! "$DOTFILES_DIR/$source" -ef "$HOME/$destination" ]]; then
      echo "Missing/wrong link: $HOME/$destination" >&2; failed=1
    fi
  done <<'LINKS'
vim/es.utf-8.spl|.vim/spell/es.utf-8.spl
vim/es.utf-8.sug|.vim/spell/es.utf-8.sug
vim/vimrc|.vimrc
vim/init.vim|.config/nvim/init.vim
vim/coc-settings.json|.config/nvim/coc-settings.json
tmux/tmux.conf|.tmux.conf
vifm/palenight.vifm|.config/vifm/colors/palenight.vifm
vifm/gruvbox.vifm|.config/vifm/colors/gruvbox.vifm
vifm/vifmrc|.config/vifm/vifmrc
bat/config|.config/bat/config
vim/ideavimrc|.ideavimrc
zsh/wezterm.lua|.wezterm.lua
LINKS
  return "$failed"
}

main() {
  case "$STAGE" in
    all|packages|config|python|plugins|shell|keyboard|check) ;;
    *) echo "Usage: $0 [all|packages|config|python|plugins|shell|keyboard|check]" >&2; return 2 ;;
  esac
  [[ $(uname -s) == Darwin ]] || { echo 'Use scripts/ubuntu/install.sh on Ubuntu.' >&2; return 1; }
  # Existing configurations assume this canonical checkout location.
  [[ "$DOTFILES_DIR" -ef "$HOME/dotfiles" ]] || { echo 'Clone this repository at ~/dotfiles before installing.' >&2; return 1; }
  case "$STAGE" in
    all) packages; config; bash "$DOTFILES_DIR/scripts/global/python-nvim.sh"; bash "$DOTFILES_DIR/scripts/global/editor-plugins.sh"; zsh "$DOTFILES_DIR/scripts/global/shell-plugins.zsh"; keyboard; check ;;
    shell) zsh "$DOTFILES_DIR/scripts/global/shell-plugins.zsh" ;;
    plugins) bash "$DOTFILES_DIR/scripts/global/editor-plugins.sh" ;;
    python) bash "$DOTFILES_DIR/scripts/global/python-nvim.sh" ;;
    *) "$STAGE" ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
