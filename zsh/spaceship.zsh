SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_TIME_SHOW=true

# Char
# SPACESHIP_CHAR_SYMBOL=%3{"  "%} # Terminal
# SPACESHIP_CHAR_SYMBOL=%3{"  "%} # Big line
# SPACESHIP_CHAR_SYMBOL=%3{"  "%} # Fire
SPACESHIP_CHAR_SYMBOL="%F{154}ﴡ 壟%f"


# SPACESHIP_GOLF="%F{green} ﴡ %f"
SPACESHIP_GOLF=""
SPACESHIP_VI_MODE_INSERT="%F{154} %k%f $SPACESHIP_GOLF" # \uf8ea
SPACESHIP_VI_MODE_NORMAL="%F{red} %k%f $SPACESHIP_GOLF" # \uf023
SPACESHIP_VI_MODE_PREFIX=""
SPACESHIP_VI_MODE_SUFFIX=""

# Battery
SPACESHIP_BATTERY_THRESHOLD=25
SPACESHIP_BATTERY_SYMBOL_CHARGING=" "
SPACESHIP_BATTERY_SYMBOL_DISCHARGING=" "
SPACESHIP_BATTERY_PREFIX=""
SPACESHIP_BATTERY_SUFFIX=""



# Dir
SPACESHIP_DIR_COLOR=cyan
SPACESHIP_DIR_PREFIX='%F{$SPACESHIP_DIR_COLOR} ' #\ue5fe

# Time
SPACESHIP_TIME_COLOR="yellow"
# SPACESHIP_TIME_PREFIX='ﴡ '
SPACESHIP_EXEC_TIME_PREFIX='%F{$SPACESHIP_TIME_COLOR}祥' # \ufa1a
SPACESHIP_EXEC_TIME_SUFFIX=" "

# Git
SPACESHIP_GIT_BRANCH_COLOR='green' #\ue725
SPACESHIP_GIT_BRANCH_PREFIX=' ' #\ue725
SPACESHIP_GIT_SYMBOL=' ' #\ue725
SPACESHIP_GIT_PREFIX=""
SPACESHIP_GIT_STATUS_PREFIX=""
SPACESHIP_GIT_STATUS_SUFFIX=""

# Pyenv
SPACESHIP_PYENV_SYMBOL=' ' #\ue73c
SPACESHIP_PYENV_PREFIX=""
SPACESHIP_PYENV_SUFFIX=" "

# Python
SPACESHIP_VENV_SYMBOL=' ' #\ue73c
SPACESHIP_VENV_PREFIX=""
SPACESHIP_VENV_SUFFIX=" "

# Golang
SPACESHIP_GOLANG_SYMBOL='ﳑ ' #\ufcd1
SPACESHIP_GOLANG_PREFIX=""
SPACESHIP_GOLANG_SUFFIX=" "

# Exit code
SPACESHIP_EXIT_CODE_SYMBOL=' ' #\uf705

#Jobs
SPACESHIP_JOBS_SYMBOL='省 ' #\uf96d
SPACESHIP_JOBS_AMOUNT_THRESHOLD=0

# Node
SPACESHIP_NODE_PREFIX=""
SPACESHIP_NODE_SUFFIX=" "

# Package
SPACESHIP_PACKAGE_SYMBOL=' ' #\uf487
SPACESHIP_PACKAGE_PREFIX=""
SPACESHIP_PACKAGE_SUFFIX=" "

# Docker e7b0
SPACESHIP_DOCKER_SYMBOL=' ' #\uf308
SPACESHIP_DOCKER_PREFIX=""
SPACESHIP_DOCKER_SUFFIX=" "

# Change
SPACESHIP_PROMPT_ORDER=(
	time          # Time stamps section
	user          # Username section
	dir           # Current directory section
	host          # Hostname section
	git           # Git section (git_branch + git_status)
	# hg            # Mercurial section (hg_branch  + hg_status)
	package       # Package version
	node          # Node.js section
	# ruby          # Ruby section
	# elixir        # Elixir section
	# xcode         # Xcode section
	# swift         # Swift section
	golang        # Go section
	# php           # PHP section
	# rust          # Rust section
	# haskell       # Haskell Stack section
	# julia         # Julia section
	docker        # Docker section
	# aws           # Amazon Web Services section
	venv          # virtualenv section
	conda         # conda virtualenv section
	pyenv         # Pyenv section
	# dotnet        # .NET section
	# ember         # Ember.js section
	# kubecontext   # Kubectl context section
	# terraform     # Terraform workspace section
	exec_time     # Execution time
	jobs          # Background jobs indicator
	exit_code     # Exit code section
	# === === === === 
	line_sep      # Line break
	# === === === === 
	battery       # Battery level and status
	vi_mode       # Vi-mode indicator
	char          # Prompt character
)
