#!/usr/bin/env bash
#
if [[ -d ~/.oh-my-zsh ]]; then
    echo Oh-My-Zsh already installed, ignoring...
else
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    pushd ~/.oh-my-zsh
    git remote rm origin
    git remote add origin git@github.com:Dillonb/oh-my-zsh.git
    git branch --set-upstream-to origin/master
    popd
fi
