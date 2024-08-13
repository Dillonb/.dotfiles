#!/usr/bin/env bash
#
if [[ -d ~/.oh-my-zsh ]]; then
    echo Oh-My-Zsh already installed, ensuring origin remote is correct...
    pushd ~/.oh-my-zsh
    echo "Origin is currently `git remote get-url origin`"
    if echo "`git remote get-url origin`" | grep -q ohmyzsh/ohmyzsh; then
        echo "Origin is correct!"
    else
        echo "Origin is incorrect, fixing..."
        git remote rm origin
        git remote add origin https://github.com/ohmyzsh/ohmyzsh
        git fetch
        git branch --set-upstream-to=origin/master
        git reset --hard origin/master
    fi
    popd
else
    git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh
fi
