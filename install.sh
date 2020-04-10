#!/bin/bash
# Install plug
if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

copyifnot() {
  # Link $1 to $2 if $2 does not exist
  IN=$1
  OUT=$2
  if [ ! -f $OUT ]; then
    echo "Linking file $OUT"
    ln -s $IN $OUT
  else
    echo "File $OUT exists"
  fi
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

# Vim languages
createdir ~/.vim/spell/
copyifnot ~/dotfiles/vim/es.utf-8.spl ~/.vim/spell/es.utf-8.spl
copyifnot ~/dotfiles/vim/es.utf-8.sug ~/.vim/spell/es.utf-8.sug

# Vim configuration
createdir ~/.config/nvim/
copyifnot ~/dotfiles/vim/vimrc ~/.vimrc
copyifnot ~/dotfiles/vim/init.vim ~/.config/nvim/init.vim

# TMUX configuration
copyifnot ~/dotfiles/tmux/tmux.conf ~/.tmux.conf

# ZSH configuration
createifno ~/.zshrc "source ~/dotfiles/zsh/zshrc"

# Kitty config
copyifnot ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf

# Change karabiner config file
echo "VIM section is needed"
python ./karabiner/spacefn.py

# Vimf
createdir ~/.config/vifm/
createdir ~/.config/vifm/colors
copyifnot ~/dotfiles/vifm/palenight.vifm ~/.config/vifm/colors/palenight.vifm
copyifnot ~/dotfiles/vifm/vifmrc ~/.config/vifm/vifmrc

# Bat
createdir ~/.config/bat/
copyifnot ~/dotfiles/bat/config ~/.config/bat/config

#createdir ~/.firstinstall
#pushd ~/.firstinstall
#git clone git@github.com:ryanoasis/nerd-fonts.git
#cd nerd-fonts && ./install.sh
#popd
