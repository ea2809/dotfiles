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
