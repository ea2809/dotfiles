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


# From https://superuser.com/questions/419775/with-bash-iterm2-how-to-name-tabs
#setup terminal tab title
function title {
    if [ "$1" ]
    then
        unset PROMPT_COMMAND
        echo -ne "\033]0;${*}\007"
    else
        export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
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
	docker start $(docker ps -a | grep $1 | awk '{print $1;}')
}

dk() {
	docker stop $(docker ps -a | grep $1 | awk '{print $1;}')
}

drmf() {
	docker rm $2 $(docker ps -a | grep $1 | awk '{print $1;}')
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
    awk -v pwd=$(pwd) -F " *# " '/\s*(Given|When|Then|\*)/ {print $1"\t"pwd"/"$2}' | \
    fzf -d "\t" --with-nth=1 \
        --bind 'enter:execute(echo {} | cut -f1 | awk "{\$1=\$1};1" | pbcopy )' \
        --bind 'tab:execute(echo {} | cut -f2 | cut -d ":" -f1 | pbcopy )' \
        --bind 'shift-tab:execute(echo {} | cut -f2 | awk -F: "{printf \"e +%s %s\",\$2,\$1}" | pbcopy )' \
        --prompt='Step> '
}

_name(){
	print -P "%F{green}  ________ %f                                    ";
	print -P "%F{green} /  _____/ %f _____    _______    ____    ___.__.";
	print -P "%F{green}/   \\\  ___ %f \\\__  \\\   \\\_  __ \\\ _/ ___\\\  <   |  |";
	print -P "%F{green}\\\    \\\_\\\  \\\ %f / __ \\\_  |  | \\\/ \\\  \\\___   \\\___  |";
	print -P "%F{green} \\\______  / %f(____  /  |__|     \\\___  >  / ____|";
	print -P "%F{green}        \\\/  %f     \\\/                \\\/   \\\/     ";
	# Font Graffiti 
}

_golf(){
	print -P "     '\\\                   .  .               %F{white}%K{red} 18 %k%F{red}%f"
	print -P "   %F{green}'%f   \\\              .         ' .          ┊"
	print -P "      %F{172}O>>%f         .                 '        ┊"
	print -P "       %F{197}\\\%f       .                      卵     ┊"
	print -P "       %F{blue}/\\\%f    .                               ┊"
	print -P "      %F{blue}/ /%f  .'                                ┊"
	print -P -- "jgs%F{green}^^^^^^^%f%F{94}▀▀%f%F{green}^^^^^^^ GARCY ^^^^^^^^^^^^^^^^^^%F{white}╚═╝%f%F{green}^^^%f"

#  __      __  __    
# / _  /\ |__)/  \_/ 
# \__)/--\| \ \__ |  

}

banner() {
	clear
	echo ""
	# _name
	_golf
}
