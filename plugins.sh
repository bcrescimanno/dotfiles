#!/bin/bash

# Plugins.sh
# author: Brian Crescimanno <brian.crescimanno@gmail.com>
# license: MIT License http://www.opensource.org/licenses/mit-license.php
#
# Basic Shell script to download the plugins that I use with Vim
#
# The script detects if a plugin already exists and attempts to pull
# the latest version of that plugin. Otherwise, it will clone the git
# repository.
#
# This script is currently very "happy path." I've never done much bash
# scripting so I'm not up on good error handling.
#
# You'll need pathogen to use these scripts within Vim. Be sure to run
# :Helptags
# after installations and updates from within Vim to update the helpfiles
#
# You can add plugins simply by calling the clone_or_pull function
#
# clone_or_pull git://some.git.repo/repo plugin-name
#
# Possible future improvements:
# 1) Support systems using rvm for Ruby (currently command-t will fail)
# 2) Only build command-t when it's actually updated
# 3) Create a report of what plugins were added / updated

PATHOGEN_DIR="vimtest/autoload"
DIRECTORY="vimtest/bundle"
START_DIR=$(pwd)

clone_or_pull() {
    echo "*************************"
    if [ ! -d $2 ]
    then
        echo "Downloading plugin $2\n"
        git clone $1 $2
    else
        echo "Updating plugin $2\n"
        cd $2
        git pull
        cd ..
    fi

    echo "\nFinished $2\n************************\n"
}

dependencies() {
    ERROR=0;
    ERR_STR="Error - Missing Dependency: "
    if  ! command -v jshint &> /dev/null;
    then
        echo $ERR_STR"JSHint"
        ERROR=1
    fi

    if  ! command -v curl &> /dev/null;
    then
        echo $ERR_STR"curl"
        ERROR=1
    fi

    if  ! command -v git &> /dev/null;
    then
        echo $ERR_STR"git"
        ERROR=1
    fi

    if  ! command -v rake &> /dev/null;
    then
        echo $ERR_STR"rake"
        ERROR=1
    fi

    if  ! command -v ack &> /dev/null;
    then
        echo $ERR_STR"ack"
        ERROR=1
    fi

    if [ $ERROR -eq 1 ]
    then
        echo "Missing dependencies - Installation Aborted"
        exit 1
    fi
}

pathogen() {
    echo "*************************"
    echo "Determining if Pathogen is set up"
    if [ ! -f $PATHOGEN_DIR/pathogen.vim ]
    then
        echo "Installing Pathogen"
        mkdir -p $PATHOGEN_DIR
        curl -so $PATHOGEN_DIR/pathogen.vim https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim
        echo "Pathogen Installed"
    else
        echo "Pathogen already installed - skipping"
    fi
    echo "*************************"
}

command_t() {
    clone_or_pull $1 $2
    echo "*************************"
    echo "Building Command-T Plugin:"
    cd $2
    rake make
    cd ..
    echo "Command-T Plugin Built"
    echo "*************************"
}

dependencies
pathogen

echo "Installing Vim Plugins to: $DIRECTORY"

if [ ! -d "$DIRECTORY" ]; then
    echo "Creating plugin directory\n"
    mkdir -p $DIRECTORY
fi

cd $DIRECTORY

clone_or_pull git://github.com/mileszs/ack.vim.git ack.vim
clone_or_pull git://github.com/vim-scripts/YankRing.vim.git YankRing.vim
clone_or_pull git://github.com/mattn/gist-vim.git gist-vim
clone_or_pull git://github.com/sjl/gundo.vim.git gundo
clone_or_pull git://github.com/scrooloose/nerdcommenter.git nerdcommenter
clone_or_pull git://github.com/scrooloose/nerdtree.git nerdtree
clone_or_pull git://github.com/msanders/snipmate.vim.git snipmate.vim
clone_or_pull git://github.com/scrooloose/syntastic.git syntastic.vim
clone_or_pull git://github.com/vim-scripts/taglist.vim.git taglist.vim
clone_or_pull git://github.com/vim-scripts/AutoClose.git vim-autoclose
clone_or_pull git://github.com/Lokaltog/vim-easymotion.git vim-easymotion
clone_or_pull git://github.com/tpope/vim-endwise.git vim-endwise
clone_or_pull git://github.com/tpope/vim-haml.git vim-haml
clone_or_pull git://github.com/pangloss/vim-javascript.git vim-javascript
clone_or_pull git://github.com/tpope/vim-markdown.git vim-markdown
clone_or_pull git://github.com/tpope/vim-surround.git vim-surround
clone_or_pull git://github.com/robgleeson/hammer.vim.git hammer.vim

# Command-T uses a special function because it must be built
command_t git://github.com/wincent/Command-T.git command-t

cd $START_DIR
echo "\nPlugin installation / update complete\n"

exit 0;
