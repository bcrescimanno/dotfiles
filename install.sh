#!/bin/bash

# Create the backup and undo directories
mkdir -p vim/backup
mkdir -p vim/undo

# Create symlinks
ln -s jshintrc $HOME/.jshintrc
ln -s vim $HOME/.vim
ln -s gvimrc $HOME/.gvimrc
ln -s vimrc $HOME/.vimrc
ln -s tmux.conf $HOME/.tmux.conf
ln -s ackrc $HOME/.ackrc

# Download Vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install plugins
vim -i NONE -c VundleInstall -c quitall
