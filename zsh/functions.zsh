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

