#!/bin/bash
if ! [[ -f ~/.zshrc_local ]]; then
    touch ~/.zshrc_local
fi

pushd ~/.oh-my-zsh
git pull
popd
