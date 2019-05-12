alias o="open ."
alias e="exit"
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
alias ll='ls -la'
alias G='| grep '
alias F=' find . -name '

alias ys='yarn start'
alias yi='yarn install'
alias gdu='git diff -u'
alias gpd='git pull origin develop'

alias rerun='behave @rerun.txt'

# Get the real path
realpath() { for f in "$@"; do echo ${f}(:A); done }

alias dsm="docker start $(docker ps -a |grep mobility|awk '{print $1;}')"
alias dkm="docker stop $(docker ps -a |grep mobility|awk '{print $1;}')"
