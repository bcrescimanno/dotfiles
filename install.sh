#!/bin/bash

HERE=$(pwd)

# Create necessary subdirectories
mkdir -p vim/backup
mkdir -p vim/undo
mkdir -p vim/bundle

# Create symlinks
ln -s $HERE/jshintrc $HOME/.jshintrc
ln -s $HERE/vim $HOME/.vim
ln -s $HERE/gvimrc $HOME/.gvimrc
ln -s $HERE/vimrc $HOME/.vimrc
ln -s $HERE/tmux.conf $HOME/.tmux.conf
ln -s $HERE/ackrc $HOME/.ackrc

# Download Vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install plugins
vim -i NONE -c VundleInstall -c quitall
