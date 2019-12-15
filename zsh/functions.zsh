#autoload
# alias gerritpush="git push origin HEAD:refs/for/master"
	gerritpush(){
		if [ "$1" = "" ];
		then
			echo "No topic provided"
		else
			echo "Topic $1"
			git push origin HEAD:refs/for/master/$1
			fi
		}
	## autoload -Uz gerritpush

	activate(){
		if [ "$1" = "" ];
		then
			echo "No virtualenv name provided"
		else
			echo "Activating virtualenv $1"
			source ~/venvs/$1/bin/activate
		fi
	}


workon(){
	if [ "$1" = "" ];
	then
		echo "Needs a proyect"
		return
	fi

	if [ "$1" = "help" ];
	then
		echo "workon [fleet|]"
	fi

	if [ "$1" = "fleet" ];
	then
		tmux new-window -n "fleet2" 
		tmux send-keys -t "fleet2" "cd ~/telefonica/repos/analytics-smart-mobility" "C-m"
		tmux send-keys -t "fleet2" "source .env" "C-m"
		return
	fi
}

# From: https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/git.zsh
# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

ds() {
	docker start $(docker ps -a |grep $1|awk '{print $1;}')
}

dk() {
	docker stop $(docker ps -a |grep $1|awk '{print $1;}')
}

drmf() {
	docker rm $2 $(docker ps -a |grep $1|awk '{print $1;}')
}

dsm() { ds mobility }
dkm() { dk mobility }
drmm() { drmf mobility ""}
drmmf() { drmf mobility "-f" }

dsc() { ds comms } 
dkc() { dk comms }
drmc() { drmf comms ""}
drmmc() { drmf comms "-f" }

# Get the real path
realpath() { for f in "$@"; do echo ${f}(:A); done }

fbehave() {
    behave "$@" -d -f steps 2> /dev/null | \
    awk -F " *# " '/\s*(Given|When|Then|\*)/ {print $1"\t"$2}' | \
    fzf -d "\t" --with-nth=1 \
        --bind 'enter:execute(echo {} | cut -f2 | pbcopy )' \
        --bind 'tab:execute(echo {} | cut -f1 | awk "{\$1=\$1};1" | pbcopy )' \
        --prompt='Step> '
}
