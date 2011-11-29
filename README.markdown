Dotfiles
========

I've gotta keep dotfiles somewhere; why not github (you know, like everyone else)?

Currently, I'm tracking my Vim configuration and plugins as well as my JSHint configuration

Dependencies
------------

A few of the plugins the plugin script will install require some dependencies; hopefully
I can modify the included plugins.sh script to handle some of these. I've only tested this
on OS X but it should work in any *nix environment. It won't work on Windows and I won't be
adding support for it--feel free to fork if you want!

* Pathogen (this is required for any of this to work)
* Ack
* Exuberant-ctags
* JSHint (if you want Javascript syntax checking)
* Ruby
* GNU make

Usage
-----
Clone the dotfiles to your home directory:

    git clone git://github.com/bcrescimanno/dotfiles.git ~/bc-dotfiles

Create some symlinks:

    ln -s ~/bc-dotfiles/jshintrc ~/.jshintrc
    ln -s ~/bc-dotfiles/vimrc ~/.vimrc
    ln -s ~/bc-dotfiles/gvimrc ~/.gvimrc
    ln -s ~/bc-dotfiles/.vim ~/.vim

Install Pathogen (Maybe I'll automate this later) for Vim

Run plugins.sh:

    cd ~/bc-dotfiles
    sh plugins.sh

This will set up all of the plugins that I use. You can comment out any of them in the 
plugins.sh file if you don't want to install that particular plugin; however, you should
also check both the vimrc and gvimrc files and remove associated configuration to avoid
errors when loading vim.
