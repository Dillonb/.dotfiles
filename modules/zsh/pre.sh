#!/usr/bin/env bash
#
if [[ -d ~/.oh-my-zsh ]]; then
    echo Oh-My-Zsh already installed, ignoring...
else
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
fi

pushd ~/.oh-my-zsh

if git remote -v | grep --quiet Dillonb; then
    echo "Remote is set correctly."
else
    echo "Remote is NOT set correctly!"
    git remote rm origin
    git remote add origin git@github.com:Dillonb/oh-my-zsh.git
    git fetch
    git branch --set-upstream-to=origin/master master
    git pull
fi

popd
