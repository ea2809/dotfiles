#!/bin/bash

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir ~/.vim/spell
ln -s ~/dotfiles/vim/es.utf-8.spl ~/.vim/spell/es.utf-8.spl
ln -s ~/dotfiles/vim/es.utf-8.sug ~/.vim/spell/es.utf-8.sug
