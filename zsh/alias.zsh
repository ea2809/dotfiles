alias o="open ."
alias n="nvim"
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
alias ls='ls -G'
alias ll='ls -la'
alias f='find . -name '

alias -g G='| grep '
alias -g L='| less '
alias -g N='| nvim'
alias -g F='| fzf'

alias ys='yarn start'
alias yi='yarn install'
alias gdu='git diff -u'
alias gpd='git pull origin develop'

alias rerun='behave @rerun.txt'

alias fzfp="fzf --preview 'bat --color=always {}'"
alias bwip="behave -t @wip"
alias in="source .in"
