#!/bin/bash
if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
copyifnot() {
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

createdir ~/.config/nvim/
copyifnot ~/dotfiles/vim/vimrc ~/.vimrc
copyifnot ~/dotfiles/vim/init.vim ~/.config/nvim/init.vim

createifno ~/.zshrc "source ~/dotfiles/zsh/zshrc"

copyifnot ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf

#createdir ~/.firstinstall
#pushd ~/.firstinstall
#git clone git@github.com:ryanoasis/nerd-fonts.git
#cd nerd-fonts && ./install.sh
#popd
