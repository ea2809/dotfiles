alias o="open ."
alias n="nvim"
alias e="exit"
alias c="clear"
alias dvimrc='nvim ~/dotfiles/vim/vimrc'
alias dzshrc='nvim ~/dotfiles/zsh/zshrc'
alias dtmux='nvim ~/dotfiles/tmux/tmux.conf'
alias daliases='nvim ~/dotfiles/zsh/alias.zsh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias prettyjson='python -m json.tool'
alias dps='docker ps'
alias ls='lsd'
alias l='ls -l'
alias ll='ls -la'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias cat='bat'

alias f='find . -name '

alias -g G='| grep '
alias -g L='| less '
alias -g N='| nvim'
alias -g F='| fzf'

alias ys='yarn start'
alias yi='yarn install'
alias gdu='git diff -u'
alias gpd='git pull origin develop'

alias fzfp="fzf --preview 'bat --color=always {}'"
alias rerun='behave @rerun.txt'
alias bwip="behave -t @wip"

alias in="source .in"
alias tx="tmux attach || tmux"
alias fm="vifm ."
alias nupdate="nvim +PlugClean +PlugInstall +PlugUpdate +CocUpdate +qal"


case `uname` in
  Darwin)
    alias ssh="kitty +kitten ssh"
    alias ctags="$(brew --prefix)/bin/ctags"
  ;;
  Linux)
    alias bat=batcat
#    antigen bundle archlinux
  ;;
esac
