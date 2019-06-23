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
