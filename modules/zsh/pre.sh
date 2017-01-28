#!/usr/bin/env bash
#
if [[ -d ~/.oh-my-zsh ]]; then
    echo Oh-My-Zsh already installed, ignoring...
else
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
fi
