#!/usr/bin/env bash
#
if [[ -d ~/.oh-my-zsh ]]; then
    echo Oh-My-Zsh already installed, ignoring...
else
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    rm -rf ~/.oh-my-zsh
    pushd ~
    git clone git@github.com:Dillonb/oh-my-zsh.git .oh-my-zsh
    pushd ~/.oh-my-zsh
    git remote add upstream git@github.com:robbyrussell/oh-my-zsh.git
    popd
    popd
fi
