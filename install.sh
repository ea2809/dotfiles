#!/usr/bin/env bash

# Install vim-plug
if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

checklink() {
  # Link $1 to $2 if $2 does not exist
  IN=$1
  OUT=$2
  if [ ! -f $OUT ]; then
    echo "Linking file $OUT"
    ln -s $IN $OUT
  elif [ -L $OUT ]; then
    # Check both files are the same
    if [ $IN -ef $OUT ]; then
      echo "File is linked as we expected ($IN -> $OUT)"
    else
      echo "File is linked to other file"
      movefile $IN $OUT
    fi
  else
    echo "File $OUT exists and is not linked"
    movefile $IN $OUT
  fi
}

movefile() {
  # Create file $1 with $2 link, if file exists a backup file will be created
  local FILE=$IN
  local CONTENT=$OUT
  if [ -f $FILE ]; then
    echo "File $FILE moved with extension backup."
    mv $FILE $FILE.backup
  fi
  checklink $IN $OUT
}

checkfile() {
  # Create file $1 with $2 data, if file exists a backup file will be created
  local FILE=$1
  local CONTENT=$2
  if [ -f $FILE ]; then
    echo "File $FILE moved with extension backup."
    mv $FILE $FILE.backup
  fi
  echo "Creating $FILE"
  echo $CONTENT >$FILE
}

createifno() {
  # Create file $1 with $2 data if file does not exists
  local FILE=$1
  local CONTENT=$2
  if [ -f $FILE ]; then
    echo "File $FILE exists"
    grep -q "$CONTENT" "$FILE" || {
      echo "Appending $FILE"
      echo $CONTENT >>$FILE
    }
  else
    echo "Creating $FILE"
    echo $CONTENT >$FILE
  fi
}

createdir() {
  # Create dir if it does not exists
  local DIR=$1
  if [ ! -d $DIR ]; then
    echo "Creating directory $DIR"
    mkdir -p $DIR
  fi
}

# case "$OSTYPE" in
#   linux*) bash ~/dotfiles/scripts/ubuntu/install.sh;;
#   darwin*)  echo "No more install" ;; 
#   *)        echo "No configuration for $OSTYPE" ;;
# esac

echo "Install antigen"
curl -L git.io/antigen > antigen.zsh

echo "Move vim dictionary"
createdir ~/.vim/spell/
checklink ~/dotfiles/vim/es.utf-8.spl ~/.vim/spell/es.utf-8.spl
checklink ~/dotfiles/vim/es.utf-8.sug ~/.vim/spell/es.utf-8.sug

echo "Vim configuration"
createdir ~/.config/nvim/
checklink ~/dotfiles/vim/vimrc ~/.vimrc
checklink ~/dotfiles/vim/init.vim ~/.config/nvim/init.vim
checklink ~/dotfiles/vim/coc-settings.json ~/.config/nvim/coc-settings.json

echo "Tmux configuration"
checklink ~/dotfiles/tmux/tmux.conf ~/.tmux.conf

echo "ZSH configuration"
createifno ~/.zshrc "source ~/dotfiles/zsh/zshrc"
createifno ~/.zshrc "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh"

echo "Kitty configuration"
createdir ~/.config/kitty/
checklink ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf

# Change karabiner config file
echo "VIM section is needed in KARABINER"
python ./karabiner/spacefn.py

echo "Vifm configuration"
createdir ~/.config/vifm/
createdir ~/.config/vifm/colors
checklink ~/dotfiles/vifm/palenight.vifm ~/.config/vifm/colors/palenight.vifm
checklink ~/dotfiles/vifm/gruvbox.vifm ~/.config/vifm/colors/gruvbox.vifm
checklink ~/dotfiles/vifm/vifmrc ~/.config/vifm/vifmrc

echo "Bat configuration"
createdir ~/.config/bat/
checklink ~/dotfiles/bat/config ~/.config/bat/config

echo "Configure git configuration"
bash ./scripts/global/git.sh

echo "IdeaVim"
checklink ~/dotfiles/vim/ideavimrc ~/.ideavimrc

echo "We"
checklink ~/dotfiles/zsh/wezterm.lua ~/.wezterm.lua
#createdir ~/.firstinstall
#pushd ~/.firstinstall
#git clone git@github.com:ryanoasis/nerd-fonts.git
#cd nerd-fonts && ./install.sh
#popd
