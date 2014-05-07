Dotfiles
========

Currently, I'm tracking my Vim configuration and plugins as well as my JSHint configuration

Dependencies
------------

A few of the plugins the plugin script will install require some dependencies; hopefully
I can modify the included plugins.sh script to handle some of these. I've only tested this
on OS X but it should work in any linux / unix  environment. It won't work on Windows and I won't be
adding support for it--feel free to fork if you want!

* Ack
* Exuberant-ctags
* JSHint (if you want Javascript syntax checking)
* curl

Quick Install
-------------

    git clone git://github.com/bcrescimanno/dotfiles.git
    cd dotfiles
    ./install.sh
