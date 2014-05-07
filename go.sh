#!/bin/bash

set -e 

STARTDIR=$(pwd)
REPO="git://github.com/bcrescimanno/dotfiles.git"
NAME="${1:-bc-dotfiles}"
INSTALLDIR=$HOME/$NAME

# Clone the git repo
git clone $REPO $INSTALLDIR

# Create the backup and undo directories
mkdir -p $INSTALLDIR/vim/backup
mkdir -p $INSTALLDIR/vim/undo

# Create symlinks
ln -s $INSTALLDIR/jshintrc $HOME/.jshintrc
ln -s $INSTALLDIR/vim $HOME/.vim
ln -s $INSTALLDIR/gvimrc $HOME/.gvimrc
ln -s $INSTALLDIR/vimrc $HOME/.vimrc
ln -s $INSTALLDIR/tmux.conf $HOME/.tmux.conf
ln -s $INSTALLDIR/ackrc $HOME/.ackrc
